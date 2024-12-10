//
//  ChatVC.swift
//  GoferDriver
//
//  Created by Trioangle Technologies on 12/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatVC: BaseVC ,ChatViewProtocol{
    
    //MARK: Protocol implementation
    
    @IBOutlet var chatView: chatView!
    
    var chatInteractor: ChatInteractorProtocol?
    var typeCon:ConversationType = .u2d
    var messages: [ChatModel] = [ChatModel]()
    var firstTime : Bool = true
    var riderID : Int!
    var trip_id = ""
    static var currentTripID : String? = nil
    let preference = UserDefaults.standard
    var riderImage : String? = nil
    lazy var riderName : String  = {
        return LangCommon.rider.capitalized
    }()
    var rating = 0.0
    
    
    func setChats(_ message: [ChatModel]) {
        self.messages = message
        if self.firstTime{
            self.chatView.chatTableView.springReloadData()
            self.firstTime = false
        }else{
            self.chatView.chatTableView.reloadData()
        }
        let count = self.messages.count - 1
        if count >= 0{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.chatView.chatTableView.scrollToRow(at: IndexPath(row: count, section: 0),
                                               at: .bottom,
                                               animated: true)
//            }
        }
        
    }

    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPipeLines()
        NotificationCenter.default.removeObserver(self,
                                                  name: .ChatRefresh,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshChat),
                                               name: .ChatRefresh,
                                               object: nil)
    }
    @objc func refreshChat(){
        ChatInteractor.instance.getAllChats(ForView : self,
                                            AndObserve: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        if shouldCloseOnWillAppear{
            self.shouldCloseOnWillAppear = false
            return
        }
        ChatInteractor.instance.getAllChats(ForView : self,
                                            AndObserve: true)

//       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Shared.instance.needToShowChatVC = false
        Shared.instance.chatVcisActive = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Shared.instance.chatVcisActive = false
    }
    //MARK: initailalizer
    
    func initPipeLines(){
        _ = PipeLine.createEvent(withName: "CHAT_OBSERVER") { [weak self] in
            ChatInteractor.instance.getAllChats(ForView : self,
                                                AndObserve: true)
        }
    }
    var isKeyboardOpen = false
 
    private var shouldCloseOnWillAppear = false
    func riderCancelledTrip(notification: Notification)
    {
        self.shouldCloseOnWillAppear = true
    }
    
    func sendButtonTapped(){
        guard let msg = self.chatView.messageTextField.text,!msg.isEmpty else{return}
        
        var param = ["receiver_id": self.riderID.description,
                     "message":msg]
        // Handy Splitup Start
        let isGofer = AppWebConstants.businessType == BusinessType.Ride
        if let tripId : Int = UserDefaults.value(for: isGofer ? .current_trip_id : .current_job_id){
            param[isGofer ? "trip_id" : "job_id"] = tripId.description
        }
        param[isGofer ? "trip_id" : "job_id"] = self.trip_id
        // Handy Splitup End
        param["type_of_conversation"] = self.typeCon.rawValue
        param["business_id"] = AppWebConstants.currentBusinessType.rawValue.description
       
        ConnectionHandler.shared.getRequest(for: APIEnums.sendMessage, params: param, showLoader: false).responseJSON({ (json) in
               if json.isSuccess{
               }else{
               }
           }).responseFailure({ (error) in
           })
        
        //to fire base
        let chat = ChatModel(message: msg, type: .driver)
        ChatInteractor.instance.append(message: chat)
        if self.messages.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                ChatInteractor.instance.getAllChats(ForView : self,
                                                    AndObserve: true)
            }
        }
        
        self.chatView.messageTextField.text = String()
    }
    
    //MARK: init with story
    class func initWithStory(withTripId trip_id:String,
                             ridereID : Int,
                             riderRating : Double?,
                             imageURL : String?,
                             name : String?,typeCon:ConversationType) -> ChatVC{
        ChatVC.currentTripID = trip_id
       
        let view : ChatVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.modalPresentationStyle = .overFullScreen
        if let _rating = riderRating{
            view.rating = _rating
        }
        view.trip_id = trip_id
        view.typeCon = typeCon
        view.riderID = ridereID
        ChatInteractor.instance.initialize(withTrip: trip_id, type:typeCon)
        if let _name = name{
            view.riderName = _name
        }
        view.riderImage = imageURL
        
        view.modalPresentationStyle = .fullScreen
        return view
    }
    
    
}
