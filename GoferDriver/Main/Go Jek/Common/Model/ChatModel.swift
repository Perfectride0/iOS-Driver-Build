//
//  ChatModel.swift
//  GoferDriver
//
//  Created by Trioangle Technologies on 12/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UserNotifications

//MARK: chat protocols
protocol ChatInteractorProtocol {
    var trip_id : String{get set}
    var chatRef : DatabaseReference{get}
    func getAllChats(ForView view : ChatViewProtocol?,AndObserve observe: Bool)
    func observeTripChat(_ val : Bool,view : ChatViewProtocol?)
    func append(message : ChatModel)
}
protocol ChatViewProtocol {
    var chatInteractor : ChatInteractorProtocol?{get set}
    var messages : [ChatModel]{get set}
    func setChats(_ message : [ChatModel])
}


//MARK: ChatModel###########################
enum MessageSenderType : String{
    case driver = "driver"
    case rider = "rider"
    case user = "user"
    case provider  = "provider"
    case store = "store"
    
    static func typeFor(string : String) -> MessageSenderType{
        
        switch string.lowercased() {
        case "driver":
            return .driver
        case "rider":
            return .rider
        case "user":
            return .user
        case "provider":
            return .provider
        case "store":
            return .store
        default:
            return .rider
        }
    }
}
enum ConversationType : String{
    case u2d = "user_to_driver"
    case u2s = "user_to_store"
    case s2d  = "store_to_driver"
    
    static func conversType(string : String) -> ConversationType{
        
        switch string.lowercased() {
        case "user_to_driver":
            return .u2d
        case "user_to_store":
            return .u2s
        case "store_to_driver":
            return .s2d
        default:
            return .u2d
        }
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


class ChatModel: Equatable{
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        return lhs.message == rhs.message
            && lhs.type == rhs.type
            && lhs.key == rhs.key
    }
    
    var message : String
    var type : MessageSenderType
    var key : String
    init(message : String , type : MessageSenderType){
        self.message = message
        self.type =  type
        self.key = ""
    }
    init(snapShot : DataSnapshot){
        self.message = ""
        self.type = .rider
        self.key = ""
        guard let dict = snapShot.value as? NSDictionary else{return}
        if let message = dict.value(forKey: "message") as? String,
            let sender = dict.value(forKey: "type") as? String{
            self.message = message
            self.type = MessageSenderType.typeFor(string: sender)
            self.key = snapShot.key
        }
        
    
        
    }
    var getDict : [String:String]{
        return ["message":self.message,
                "type":type.rawValue]
    }
    
}

//MARK: #################ChatInteractor#########################################################
class ChatInteractor : ChatInteractorProtocol{
    
    static var instance = ChatInteractor()
    
    var trip_id: String
    internal var chatRef: DatabaseReference
    internal var contype: ConversationType
    var isInitialized = false
    
    //Messages that should not send notifications
    var noNotificaitonMessages : [ChatModel]?
    var timer : Timer?
    private init(){
        self.trip_id = String()
        self.chatRef = FireBaseNodeKey.trip_chat.ref()
        self.contype = .u2d
    }
    
    //intializing to firebase node with trip id
    func initialize(withTrip tripId : String,type:ConversationType){
        guard !tripId.isEmpty else {return}
        self.isInitialized = true
        self.trip_id = tripId
        self.contype = type
        
        UserDefaults.standard.set(tripId, forKey: CURRENT_TRIP_ID)
        self.chatRef = FireBaseNodeKey.trip_chat.ref(forID: self.trip_id, type: self.contype)
        
    }
    //Delete all chats
    func deleteChats(){
        guard !self.trip_id.isEmpty else{return}
        if !self.isInitialized{
            self.chatRef = FireBaseNodeKey.trip_chat.ref(forID: self.trip_id, type: self.contype)
        }
        if self.chatRef == Database.database().reference().child(firebaseEnvironment.rawValue){
            self.chatRef = FireBaseNodeKey.trip_chat.ref(forID: self.trip_id, type: self.contype)
        }
        self.chatRef.removeValue()
        UserDefaults.standard.removeObject(forKey: CURRENT_TRIP_ID)
    }
    //Stop listening to chat and clear all instance
    func deinitialize(){
        if self.isInitialized{
            self.chatRef.removeAllObservers()
            self.chatRef = FireBaseNodeKey.trip_chat.ref()
            self.isInitialized = false
            UserDefaults.standard.removeObject(forKey: CURRENT_TRIP_ID)
        }
    }
    
    //Remove all listeners to the chat
    func resetListener(){
        self.chatRef.removeAllObservers()
        self.chatRef = FireBaseNodeKey.trip_chat.ref(forID: self.trip_id, type: self.contype)
        self.isInitialized = true
    }
    
    //Gettign all converstaion in firebase
    func getAllChats(ForView view: ChatViewProtocol?, AndObserve observe: Bool) {
        guard self.isInitialized else {return}
        guard observe else{//If u want to just observe remove this guard !!!!
            self.observeTripChat(false, view: view)//to stop listeing to chat
            return
        }
        self.chatRef.observeSingleEvent(of: .value, with: { (SnapShot) in
            if !SnapShot.exists(){return}
            var messages = [ChatModel]()
            let enumerator = SnapShot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                messages.append(ChatModel.init(snapShot: rest))
            }
            //These are past message so not notification for them
            self.noNotificaitonMessages = messages
            if let chatView = view{
                chatView.setChats(messages)
            }
            self.observeTripChat(true, view: view)
            
            
        })
    }
    
    //Listeninig to firebase converastaions
    
    internal func observeTripChat(_ val : Bool, view: ChatViewProtocol?) {
        guard isInitialized else{return}
        guard val else{//to stop listening the firebase chat and exit
       
            self.chatRef.removeAllObservers()
            self.trip_id = String()
            self.chatRef = FireBaseNodeKey.trip_chat.ref()
            return
        }
        self.resetListener()//Reset so other listener will not work
        
        var messages = view?.messages ?? [ChatModel]()
        self.chatRef.observe(.childAdded, with: { (Snapshot) in
            
            if !Snapshot.exists(){return}
            
            let message = ChatModel.init(snapShot: Snapshot)
            
            guard !messages.contains(message) else{return}//If message is already obtained do nothing
            messages.append(message)
            if let listeningView = view{//has view so send message to view
                self.noNotificaitonMessages?.append(message)
                listeningView.setChats(messages)
            }else{//No view connected so send push notification
                self.postLocalNotification(WithChat: message)
            }
        })
        
    }
    
    //Appending users message to firebase node
    func append(message: ChatModel) {
        guard self.isInitialized else{return}
        self.chatRef.observeSingleEvent(of: .value, with: { (ss) in
            let autoId = self.chatRef.childByAutoId()
            //            self.chatRef.updateChildValues([autoId.key:message.getDict])
            self.chatRef
                .child(autoId.key ?? "key")
                .setValue(message.getDict,
                          withCompletionBlock: { (error, ref) in
                            print("\(String(describing: error))")
                                
            })
        })
    }
    
    func postLocalNotification(WithChat chat: ChatModel){
        guard !(self.noNotificaitonMessages?.contains(chat) ?? false) else {return}
        self.noNotificaitonMessages?.append(chat)
        guard chat.type == .rider else{return}
        
        let sender_name = UserDefaults.standard.string(forKey: TRIP_RIDER_NAME) ?? LangCommon.rider
        self.timer?.invalidate()
        self.timer = nil
        
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 0)
        notification.timeZone = NSTimeZone.default
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.alertBody = "\(sender_name) :\(chat.message)"
        notification.alertAction = "open"
        notification.hasAction = true
        notification.applicationIconBadgeNumber = 1
        notification.userInfo = ["UUID": CURRENT_TRIP_ID ]
        UIApplication.shared.scheduleLocalNotification(notification)
        return
    }
    
    @objc func triggerFirebase() {
        guard self.noNotificaitonMessages?.isEmpty ?? true else{return}
        guard (!self.trip_id.isEmpty) else{return}
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        guard let root = keyWindow?.rootViewController else{
           // self.getAllChats(ForView: nil, AndObserve: true)
            return
        }
        
        if !(root.children.last is ChatVC) {
          //  self.getAllChats(ForView: nil, AndObserve: true)
        }
        
        
    }
   
}
