//
//  PushNotificationManager.swift
//  GoferDriver
//
//  Created by Apple on 08/06/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import Firebase
//import FirebaseInstanceID
import FirebaseMessaging
import UIKit
import UserNotifications
import AVFoundation
import FirebaseDatabase

enum NotificationTypeEnum: String,CaseIterable{
    case ride_request
    case ArrivedNowOrBeginTrip
    case ArrivedNowOrBeginTrips
    case cancel_trip
    case trip_payment
    case manual_booking_trip_assigned
    case manual_booking_trip_reminder
    case manual_booking_trip_canceled_info
    case manual_booking_trip_booked_info
    case chat_notification
    case custom_message
    case none
    case order_cancelled
    //handyman
    case job_request
    case ArrivedNowOrBeginJob
    case ArrivedNowOrBeginJobs
    case cancel_Job
    case job_payment
    case cancel_schedule_job
    case schedule_job_request
    case schedule_job_booked
    case invoice_update
    case cancel_request
    case custom
    case delivery_request
    case order_request
    case order_assigned
    // Delivery manual Booking
    case manual_booking_job_assigned
    case order_delivery_started
    case accept_request
    case immediate_end_trip
    case update_stops

    
    init?(fromKeys keys: [String]){
        let cases = NotificationTypeEnum.allCases.compactMap({$0.rawValue})
        guard let key = Array(Set(cases).intersection(Set(keys))).first,
              let enumValue = NotificationTypeEnum(rawValue: key) else{
            return nil
        }
        self = enumValue
        
    }
}
enum notificationRequestType : String,Codable{
    case job_request
    case ride_request
}

class PushNotificationManager: NSObject,MessagingDelegate{
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
//    @objc(applicationReceivedRemoteMessage:) func application(received remoteMessage: MessagingRemoteMessage) {
//        print("dfg")
//        print(remoteMessage.appData)
//    }
    var requestArray:Array<NotificationRequest> = []
    var application:UIApplication
    let messaging : Messaging
    static var shared : PushNotificationManager?
    var notificationType:NotificationTypeEnum = .none
    var receivedNotificationIDs = [Int]()
    var receivedLocalNotificationIDs = [Int]()
    var receivedRequestIDs = [Int]()
    var receivedRequestMsgs = [Int]()
    var window: UIWindow?{
        let appDelegate = AppDelegate.shared
        return appDelegate.window
    }
    let userDefaults = UserDefaults.standard
    var present_data = ""
    var player: AVAudioPlayer?
    let AUDIO_PLAY_SPEED = 0.7
    let myThread = DispatchQueue.init(label: "MyThread")
    var continuePlaying = true
    func loopAndPlay(){
        //guard CallManager.instance.callState == .none else{return}
        self.myThread.async {
            while self.continuePlaying{
                self.playSound("ub__reminder")
                sleep(1)
            }
        }
    }
    func playSound(_ fileName: String) {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    fileprivate var firebaseReference : DatabaseReference? = nil
    init(_ application:UIApplication) {
        self.application = application
        
        self.messaging = Messaging.messaging()
        
        super.init()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            
        }
        else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Self.shared = self
    }
    
    // MARK: Register Push notification Class Methods
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound]) { (granted, error) in
                if error == nil{
                    AppUtilities().updateMainQueue {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken ?? "")
        let refreshedToken = fcmToken
        print("Remote instance ID token: \(refreshedToken ?? "")")
        print("InstanceID token: \(String(describing: refreshedToken))")
        Constants().STOREVALUE(value: refreshedToken ?? "", keyname: USER_DEVICE_TOKEN)
        let userStatus = self.userDefaults.value(forKey: USER_ACCESS_TOKEN) as? String
        if  !(refreshedToken?.isEmpty ?? true) {
            AppDelegate.shared.sendDeviceTokenToServer(strToken: refreshedToken ?? "")   // UPDATING DEVICE TOKEN FOR LOGGED IN USER
        } else {
            self.tokenRefreshNotification()
        }
    }
    // get refersh the token
    func tokenRefreshNotification() {
    }
    // Cannect the FCM
    func connectToFcm() {
        

    }
}
extension PushNotificationManager : UNUserNotificationCenterDelegate {
    
    // MARK: UNUserNotificationCenter Delegate // >= iOS 10
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let dict = notification.request.content.userInfo as NSDictionary
        //local notificaition
//        if let uniqId = dict.value(forKey: "UUID") as? String,uniqId == CURRENT_TRIP_ID{
            
//        if notification.request.identifier == "Chat Notification" {
//
//            if Shared.instance.chatVcisActive {
//                completionHandler([])
//            }else{
//                completionHandler([.alert,.sound])
//            }
//
//            return
//        }
        if notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
            completionHandler([.alert,.sound])
            return
        }
        //sinch
        if dict["sin"] != nil{
            completionHandler([])
            return
        }
        let custom = dict[NotificationTypeEnum.custom.rawValue] as Any
        let data = convertStringToDictionary(text: custom as? String ?? String())
        let keys = data?.compactMap({$0.key}) ?? []
        if (
            [NotificationTypeEnum.ride_request.rawValue,
             NotificationTypeEnum.manual_booking_trip_booked_info.rawValue,
             NotificationTypeEnum.schedule_job_request.rawValue,
             NotificationTypeEnum.job_request.rawValue,
             NotificationTypeEnum.delivery_request.rawValue,
             NotificationTypeEnum.invoice_update.rawValue]
        ).anySatisfy({keys.contains($0)}) {
            completionHandler([])//
        }else if keys.contains(NotificationTypeEnum.chat_notification.rawValue) {
            //chat notification
            let subJSON = data?[NotificationTypeEnum.chat_notification.rawValue] as? JSON ?? JSON()
//            if Shared.instance.chatVcisActive{
                
                if Shared.instance.chatVcisActive {
                    if subJSON.string("job_id") == ChatVC.currentTripID{
                        completionHandler([])
                    }else{
                        //completionHandler([.alert,.sound])
                       completionHandler([])
                    }
                }else{
                    completionHandler([.alert,.sound])
//                    completionHandler([])
                }
//            }else{
//                completionHandler([.alert,.sound])
//            }
            return
            //Admin custom_message
        }else if keys.contains(NotificationTypeEnum.order_assigned.rawValue) {
            completionHandler([.alert,.sound])
            return
        }
        else if keys.contains(NotificationTypeEnum.custom_message.rawValue) {
            completionHandler([.alert,.sound])
            return
        }
        
        
        else if keys.contains(NotificationTypeEnum.immediate_end_trip.rawValue) //Admin custom_message
        {
            NotificationCenter.default.post(name: .immediate_end_trip, object: self, userInfo: nil)
            completionHandler([.alert,.sound])
        }
        
        else if keys.contains(NotificationTypeEnum.update_stops.rawValue) //Admin custom_message
        {
            NotificationCenter.default.post(name: .update_stops, object: self, userInfo: nil)
            completionHandler([.alert,.sound])
        }
        

        else if keys.contains("reference_completed"){
            completionHandler([.sound])
        }else{
            completionHandler([.alert,.sound])
        }
        guard let dictionary = data as NSDictionary? else{
            print("Returneddddd")
            return
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Handy Splitup Start
            if AppWebConstants.businessType == .Services || AppWebConstants.businessType == .Delivery {
                // Handy Splitup End
                self.handleHandyPushNotificaiton(userInfo: dictionary as! JSON)
                // Handy Splitup Start
            }
            else{
                //self.handlePushNotificaiton(userInfo: dictionary)
            }
            // Handy Splitup End
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let dict = response.notification.request.content.userInfo as NSDictionary
        
        if dict["sin"] != nil{
           // CallManager.instance.didReceivePush(notification: response.notification.request.content.userInfo)
            return
        }
//        if response.notification.request.identifier == "Local Notification" {
//            NotificationCenter.default.post(name: NSNotification.Name.JobHistory, object: self, userInfo: nil)
//            return
//        }
//        if let uniqId = dict.value(forKey: "UUID") as? String,uniqId == CURRENT_TRIP_ID{
            //Click action handling
        
            if response.notification.request.identifier == "Chat Notification" {

                // Handy Splitup Start
            let isGofer = AppWebConstants.businessType == BusinessType.Ride
            let tripId : Int = (isGofer
                ? UserDefaults.value(for: .current_trip_id)
                : UserDefaults.value(for: .current_job_id)) ?? 0
                // Handy Splitup End
            let json = dict[NotificationTypeEnum.chat_notification.rawValue] as? JSON
            let riderID : Int = json?.int("user_id") ?? UserDefaults.value(for: .rider_user_id) ?? 0
            let riderRating : Double? = json?.double("rating")
            let typeOfConversation = json?.string("type_of_conversation") ?? "user_to_driver"
            
                let chatVC = ChatVC.initWithStory(withTripId: json?.string(isGofer ? "trip_id" : "job_id" // Handy Splitup Start
                                                                          ) ?? tripId.description, ridereID: riderID,
                                                  riderRating: riderRating,
                                              imageURL: json?.string("user_image"),
                                              name: json?.string("user_name"), typeCon: ConversationType(rawValue: typeOfConversation) ?? .u2d)
                if let nav = self.window?.rootViewController as? UINavigationController{
                    nav.pushViewController(chatVC, animated: true)
                }else if let root = self.window?.rootViewController{
                    root.navigationController?.pushViewController(chatVC, animated: true)
                }
            return
        }
        let custom = dict[NotificationTypeEnum.custom.rawValue] as Any
        let data = convertStringToDictionary(text: custom as? String ?? String())
        let dictionary = data! as NSDictionary
        
        self.handleCommonPushNotification(userInfo: dictionary,
                                          generateLocalNotification: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Handy Splitup Start
            if AppWebConstants.businessType == .Services || AppWebConstants.businessType == .Delivery{
                // Handy Splitup End
                self.handleHandyPushNotificaiton(userInfo: dictionary as! JSON)
                // Handy Splitup Start
            }
            else{
                //self.handlePushNotificaiton(userInfo: dictionary)
            }
            // Handy Splitup End
        }
        completionHandler()
    }
    
    
    // Convert the string to Dictinory formate
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    //MARK: HANDLE PUSH NOTIFICATION
    func canIHandleThisLocalNotification(userInfo : JSON)-> Bool{
        print("ð Last Notification ID : \(String(describing: self.receivedLocalNotificationIDs))")
        let notificationID = userInfo.int("id")
        print("ð New Notification ID : \(notificationID)")
        guard !self.receivedLocalNotificationIDs.contains(notificationID) else{
            print("Notification \(notificationID) already handled")
            return false
        }
        self.receivedLocalNotificationIDs.append(notificationID)
        return true
    }
    func canIHandleThisRequest(userInfo : JSON)-> Bool{
        print("ð Last Notification ID : \(String(describing: self.receivedRequestIDs))")
        let notificationID = userInfo.int("id")
        print("ð New Notification ID : \(notificationID)")
        guard !self.receivedRequestIDs.contains(notificationID) else{
            print("Notification \(notificationID) already handled")
            return false
        }
        self.receivedRequestIDs.append(notificationID)
        return true
    }
    func canIHandleThisMessage(userInfo : JSON)-> Bool{
        print("ð Last Notification ID : \(String(describing: self.receivedRequestMsgs))")
        let notificationID = userInfo.int("id")
        print("ð New Notification ID : \(notificationID)")
        guard !self.receivedRequestMsgs.contains(notificationID) else{
            print("Notification \(notificationID) already handled")
            return false
        }
        self.receivedRequestMsgs.append(notificationID)
        return true
    }
    func canIHandleThisNotification(userInfo : JSON)-> Bool{
        print("ð Last Notification ID : \(String(describing: self.receivedNotificationIDs))")
        let notificationID = userInfo.int("id")
        print("ð New Notification ID : \(notificationID)")
        guard !self.receivedNotificationIDs.contains(notificationID) else{
            print("Notification \(notificationID) already handled")
            return false
        }
        self.receivedNotificationIDs.append(notificationID)
        return true
    }
    //MARK: HANDLE PUSH NOTIFICATION
    
    
    /**
     handles only chat notifcaition
     - warning: Dont use this method inside firebase listener
     */
    func handleCommonPushNotification(userInfo: NSDictionary,
                                      generateLocalNotification: Bool){
        
        if userInfo["type"] as? String  == "order_assigned"
        {
            
            let dictTemp = userInfo//[NotificationTypeEnum.order_assigned.rawValue] as! NSDictionary
            let info: [String: Any] = [
                "order_id" : UberSupport().checkParamTypes(params:dictTemp, keys:"order_id"),
                "title" : UberSupport().checkParamTypes(params:dictTemp, keys:"title"),
            ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.order_assigned.rawValue), object: self, userInfo: info)
            
//            guard self.canIHandleThisNotification(userInfo: userInfo as! JSON) else {return}
//            guard self.canIHandleThisLocalNotification(userInfo: userInfo as! JSON) else{return}
//            NotificationCenter.default
//                .post(name: NSNotification.Name.storeassign,
//                      object: self,
//                      userInfo: userInfo as! [String : Any])
//            let sender_name = userInfo["title"] as! String
//            let content = UNMutableNotificationContent()
//
//                    content.title = sender_name
//                    content.body = userInfo["restaurent_name"] as! String
//                    content.sound = UNNotificationSound.default
//                    content.badge = 1
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//                    let identifier = "Local Notification"
//            //        let identifier = ["UUID": "CURRENT_CHAT_TRIP_ID" ]
//
//                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//                    let center  = UNUserNotificationCenter.current()
//                    center.add(request) { (error) in
//                        if let error = error {
//                            print("Error \(error.localizedDescription)")
//                        }
//                    }
//             return
        }
        

        guard userInfo[NotificationTypeEnum.chat_notification.rawValue] != nil else{return}
        let valueJSON = userInfo[NotificationTypeEnum.chat_notification.rawValue]
        // Handy Splitup Start
        let isGofer : Bool = AppWebConstants.businessType == .Ride
        var tripID : Int = (isGofer ? UserDefaults.value(for: .current_trip_id) : UserDefaults.value(for: .current_job_id)) ?? 0
        if  let jobID = (valueJSON as? JSON)?.int("job_id") {
            tripID = jobID 
        }else {
            tripID = (isGofer ? UserDefaults.value(for: .current_trip_id) : UserDefaults.value(for: .current_job_id)) ?? 0
        }
        // Handy Splitup End
        
        if  tripID.description != ChatVC.currentTripID {
            if generateLocalNotification {
                guard self.canIHandleThisNotification(userInfo: userInfo as! JSON) else {return}
                guard self.canIHandleThisLocalNotification(userInfo: userInfo as! JSON) else{return}
                let message = UberSupport().checkParamTypes(params:valueJSON as! NSDictionary, keys:"message_data")
                let title =  UberSupport().checkParamTypes(params:valueJSON as! NSDictionary, keys:"user_name")
                appDelegate.scheduleNotification(title: title as String, message: message as String)
            } else {
                // Handy Splitup Start
                let isGofer = AppWebConstants.businessType == .Ride
                let tripID : Int = (isGofer
                                        ? UserDefaults.value(for: .current_trip_id)
                                        : UserDefaults.value(for: .current_job_id)) ?? 0
                // Handy Splitup End
                let json = userInfo[NotificationTypeEnum.chat_notification.rawValue] as? JSON
                print(json)
                let riderRating : Double? = json?.double("rating")
                let riderID : Int = json?.int("sender_id") ?? UserDefaults.value(for: .rider_user_id) ?? 0 //user_id --> Commented for gofer81.trioggle.com user id
                let typeOfConversation = json?.string("type_of_conversation") ?? "user_to_driver"
                
                let chatVC = ChatVC.initWithStory(withTripId: json?.string(!isGofer ? "job_id" : "trip_id") ?? tripID.description,
                                                  ridereID: riderID,
                                                  riderRating: riderRating,
                                                  imageURL: json?.string("user_image"),   
                                                  name: json?.string("user_name"),
                                                  typeCon: ConversationType(rawValue: typeOfConversation) ?? .u2d)
                
                if let nav = self.window?.rootViewController as? UINavigationController{
                    nav.pushViewController(chatVC, animated: true)
                } else if let root = self.window?.rootViewController{
                    root.navigationController?.pushViewController(chatVC, animated: true)
                }
            }
            
            // For Some reason The Presenting both call and chat screens are not appearing
            // also it's not added in the root viewcontroller so
            // we push the chat view controller and present the call view controller
//            self.forcePresent(theController: chatVC)
        }
        else if userInfo["type"] as? String  == "order_assigned"
        {
            let dictTemp = userInfo[NotificationTypeEnum.order_assigned.rawValue] as! NSDictionary
            let info: [AnyHashable: Any] = [
                "order_id" : UberSupport().checkParamTypes(params:dictTemp, keys:"order_id"),
                "user_name" : UberSupport().checkParamTypes(params:dictTemp, keys:"user_name"),
            ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.order_assigned.rawValue), object: self, userInfo: info)
            
//            let sender_name = userInfo["title"] as! String
//            let content = UNMutableNotificationContent()
//
//                    content.title = sender_name
//                    content.body = userInfo["message"] as! String
//                    content.sound = UNNotificationSound.default
//                    content.badge = 1
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//                    let identifier = "Local Notification"
//            //        let identifier = ["UUID": "CURRENT_CHAT_TRIP_ID" ]
//
//                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//                    let center  = UNUserNotificationCenter.current()
//                    center.add(request) { (error) in
//                        if let error = error {
//                            print("Error \(error.localizedDescription)")
//                        }
//                    }

        }
        else if userInfo[NotificationTypeEnum.custom_message.rawValue] != nil{
            print("custom_message",userInfo)
        }
        
        
    }
    //MARK: HANDLE PUSH NOTIFICATION
    func handleHandyPushNotificaiton(userInfo: JSON) {
        guard let notification = NotificationTypeEnum(fromKeys: userInfo.compactMap({$0.key})) else{return}
        if notification != .invoice_update { guard self.canIHandleThisNotification(userInfo: userInfo) else{ return } }
        let valueJSON = userInfo.json(notification.rawValue)
        let notificationTitle = userInfo.string("title")
        print("notificationTitle=================",notification)
        let preference = UserDefaults.standard
        _ =  userDefaults.object(forKey: "getmainpage")  as? NSString
        switch notification{
        case .order_delivery_started:
            NotificationEnum.TripStartedRefresh.postNotification()
        case .order_assigned:
            let dictTemp = userInfo[NotificationTypeEnum.order_assigned.rawValue] as! NSDictionary
            let info: [String: Any] = [
                "order_id" : UberSupport().checkParamTypes(params:dictTemp, keys:"order_id"),
                "user_name" : UberSupport().checkParamTypes(params:dictTemp, keys:"user_name"),
            ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationTypeEnum.order_assigned.rawValue), object: self, userInfo: info)
//            let sender_name = userInfo["title"] as! String
//            let content = UNMutableNotificationContent()
//
//                    content.title = sender_name
//                    content.body = userInfo["message"] as! String
//                    content.sound = UNNotificationSound.default
//                    content.badge = 1
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//                    let identifier = "Local Notification"
//            //        let identifier = ["UUID": "CURRENT_CHAT_TRIP_ID" ]
//
//                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//                    let center  = UNUserNotificationCenter.current()
//                    center.add(request) { (error) in
//                        if let error = error {
//                            print("Error \(error.localizedDescription)")
//                        }
//                    }
//            let mes = userInfo["message"] as! String
//            let info: [AnyHashable: Any] = [
//                "message" : mes]
//            NotificationCenter.default
//                .post(name: NSNotification.Name.storeassign,
//                      object: self,
//                      userInfo: info)
        case .job_request:
            let start_time = userInfo.string("id")
            let end_time = userInfo.string("end_time")
            print("print start time : \(start_time)")
            print("print end time : \(end_time)")
            guard let epocTimeStart = TimeInterval(start_time) else { return }
            guard let epocTimeEnd = TimeInterval(end_time) else { return }

            let myStartDate = NSDate(timeIntervalSince1970: epocTimeStart)
            let myEndDate = NSDate(timeIntervalSince1970: epocTimeEnd)
            print(" print start data : \(myStartDate)")
            print("print end date : \(myEndDate)")

            let components = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: myEndDate as Date)
            print("print total seconds \(components.second?.description ?? "")")
            let currentTimeStamp = Date()
            print("print current time stamp : \(currentTimeStamp)")
            let diffcomponents = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: currentTimeStamp as Date)
            print("print diff from start request time \(diffcomponents.second?.description ?? "")")
            if (components.second ?? 0) >= diffcomponents.second ?? 0 {
                let seconds = (components.second ?? 0)  - (diffcomponents.second ?? 0)
                print("print request seconds \(seconds)")
                self.showJobRequestPage(dict: valueJSON,
                                        requestTime: seconds,
                                        startTime: start_time,
                                        endTime: end_time) //For gofer showGoferRequestPage
            }else{
                AppUtilities().customCommonAlertView(titleString: "",
                                                     messageString: "Request Expired")
            }
        case .delivery_request:
            let start_time = userInfo.string("id")
            let end_time = userInfo.string("end_time")
            print("print start time : \(start_time)")
            print("print end time : \(end_time)")
            guard let epocTimeStart = TimeInterval(start_time) else { return }
            guard let epocTimeEnd = TimeInterval(end_time) else { return }

            let myStartDate = NSDate(timeIntervalSince1970: epocTimeStart)
            let myEndDate = NSDate(timeIntervalSince1970: epocTimeEnd)
            print(" print start data : \(myStartDate)")
            print("print end date : \(myEndDate)")

            let components = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: myEndDate as Date)
            print("print total seconds \(components.second?.description ?? "")")
            let currentTimeStamp = Date()
            print("print current time stamp : \(currentTimeStamp)")
            let diffcomponents = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: currentTimeStamp as Date)
            print("print diff from start request time \(diffcomponents.second?.description ?? "")")
            if (components.second ?? 0) >= diffcomponents.second ?? 0 {
                let seconds = (components.second ?? 0)  - (diffcomponents.second ?? 0)
                print("print request seconds \(seconds)")
                self.showJobRequestPageForDelivery(dict: valueJSON)
            }else{
                AppUtilities().customCommonAlertView(titleString: "",
                                                     messageString: "Request Expired")
            }
        case .order_request:
            let businessType = BusinessType.init(rawValue: valueJSON.int("business_id"))
            switch businessType {
            case .Instacart:
                let start_time = userInfo.string("id")
                let end_time = userInfo.string("end_time")
                print("print start time : \(start_time)")
                print("print end time : \(end_time)")
                guard let epocTimeStart = TimeInterval(start_time) else { return }
                guard let epocTimeEnd = TimeInterval(end_time) else { return }
                
                let myStartDate = NSDate(timeIntervalSince1970: epocTimeStart)
                let myEndDate = NSDate(timeIntervalSince1970: epocTimeEnd)
                print(" print start data : \(myStartDate)")
                print("print end date : \(myEndDate)")
                
                let components = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: myEndDate as Date)
                print("print total seconds \(components.second?.description ?? "")")
                let currentTimeStamp = Date()
                print("print current time stamp : \(currentTimeStamp)")
                let diffcomponents = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: currentTimeStamp as Date)
                print("print diff from start request time \(diffcomponents.second?.description ?? "")")
                if (components.second ?? 0) >= diffcomponents.second ?? 0 {
                    let seconds = (components.second ?? 0)  - (diffcomponents.second ?? 0)
                    print("print request seconds \(seconds)")
                    self.showJobRequestPageForInstacart(dict: valueJSON as NSDictionary)
                }else{
                    AppUtilities().customCommonAlertView(titleString: "",
                                                         messageString: "Request Expired")
                }
            case.Laundry:
                
                let start_time = userInfo.string("id")
                let end_time = userInfo.string("end_time")
                print("print start time : \(start_time)")
                print("print end time : \(end_time)")
                guard let epocTimeStart = TimeInterval(start_time) else { return }
                guard let epocTimeEnd = TimeInterval(end_time) else { return }
                
                let myStartDate = NSDate(timeIntervalSince1970: epocTimeStart)
                let myEndDate = NSDate(timeIntervalSince1970: epocTimeEnd)
                print(" print start data : \(myStartDate)")
                print("print end date : \(myEndDate)")
                
                let components = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: myEndDate as Date)
                print("print total seconds \(components.second?.description ?? "")")
                let currentTimeStamp = Date()
                print("print current time stamp : \(currentTimeStamp)")
                let diffcomponents = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: currentTimeStamp as Date)
                print("print diff from start request time \(diffcomponents.second?.description ?? "")")
                if (components.second ?? 0) >= diffcomponents.second ?? 0 {
                    let seconds = (components.second ?? 0)  - (diffcomponents.second ?? 0)
                    print("print request seconds \(seconds)")
                    self.showJobRequestPageForLaundry(dict: valueJSON as NSDictionary)
                }else{
                    AppUtilities().customCommonAlertView(titleString: "",
                                                         messageString: "Request Expired")
                }
            default:
                
                let start_time = userInfo.string("id")
                let end_time = userInfo.string("end_time")
                print("print start time : \(start_time)")
                print("print end time : \(end_time)")
                guard let epocTimeStart = TimeInterval(start_time) else { return }
                guard let epocTimeEnd = TimeInterval(end_time) else { return }
                
                let myStartDate = NSDate(timeIntervalSince1970: epocTimeStart)
                let myEndDate = NSDate(timeIntervalSince1970: epocTimeEnd)
                print(" print start data : \(myStartDate)")
                print("print end date : \(myEndDate)")
                
                let components = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: myEndDate as Date)
                print("print total seconds \(components.second?.description ?? "")")
                let currentTimeStamp = Date()
                print("print current time stamp : \(currentTimeStamp)")
                let diffcomponents = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: currentTimeStamp as Date)
                print("print diff from start request time \(diffcomponents.second?.description ?? "")")
                if (components.second ?? 0) >= diffcomponents.second ?? 0 {
                    let seconds = (components.second ?? 0)  - (diffcomponents.second ?? 0)
                    print("print request seconds \(seconds)")
                    self.showJobRequestPageForDeliveryAll(dict: valueJSON as NSDictionary)
                }else{
                    AppUtilities().customCommonAlertView(titleString: "",
                                                         messageString: "Request Expired")
                }
                
            }
        case .order_cancelled:
            let jobID = valueJSON.int("order_id")
            NotificationCenter.default.post(name: .CancelJobByUser, object: TripStatus.scheduled,userInfo: ["order_id":jobID])
            
            NotificationCenter.default
                .post(name: .HandyShowAlertForJobStatusChange,
                      object: notificationTitle,
                      userInfo: ["job_id":jobID,"id": userInfo.string("id")])
            NotificationEnum.pendingTripHistory.postNotification()
            
            
        case .immediate_end_trip:
                    let json = userInfo[NotificationTypeEnum.immediate_end_trip.rawValue] as! JSON
                    print("success")
            NotificationCenter.default.post(name: .immediate_end_trip, object: self, userInfo: nil)
            
        case .update_stops:
                    let json = userInfo[NotificationTypeEnum.update_stops.rawValue] as! JSON
                    print("success")
            NotificationCenter.default.post(name: .update_stops, object: self, userInfo: nil)


            
        case .cancel_request:
            let requestID = valueJSON.int("request_id")
            // Handy Splitup Start
            let businessType = BusinessType.init(rawValue: valueJSON.int("business_id"))
            
            switch businessType {
            case .Services:
                // Handy Splitup End
                self.changeStatus(requestId: requestID)
                AppDelegate.personObj.requestId = requestID.description
                // Handy Splitup Start
            default:
                NotificationEnum.cancelRequest.postNotificationWithJSONObj(valueJSON as [String : AnyObject])
            }
            // Handy Splitup End
            //if requestID == HandyRequestVC.requestID{
//            NotificationCenter.default.post(name: .HandyRequestCancelledByUser, object: nil,userInfo: ["request_id":requestID.description,"title": notificationTitle,"id": userInfo.int("id")])
            //}
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                NotificationCenter.default
                    .post(name: .HandyShowAlertForJobStatusChange,
                          object: notificationTitle,
                          userInfo: ["request_id":requestID.description,
                                     "id": userInfo.int("id")])
            }

        case .invoice_update:
            let job_id = valueJSON.int("job_id")
            
            if HandyPaymentVC.currentJobID == job_id{
                NotificationCenter.default.post(name: .HandyRefreshInvoice, object: job_id)
            }
        case .cancel_Job:
            preference.removeObject(forKey: TRIP_RIDER_RATING)
            preference.removeObject(forKey: TRIP_RIDER_NAME)
            preference.removeObject(forKey: TRIP_RIDER_THUMB_URL)
            Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            //            NotificationCenter.default.post(name: NSNotification.Name.JobCancelled, object: self, userInfo: nil)
            let jobID = valueJSON.int("job_id")
            NotificationCenter.default.post(name: .CancelJobByUser, object: TripStatus.scheduled,userInfo: ["job_id":jobID])
            
            NotificationCenter.default
                .post(name: .HandyShowAlertForJobStatusChange,
                      object: notificationTitle,
                      userInfo: ["job_id":jobID,"id": userInfo.string("id")])
            NotificationEnum.pendingTripHistory.postNotification()
        case .job_payment:
            Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            let info: [AnyHashable: Any] = [
                "rider_thumb_image" : UberSupport().checkParamTypes(params:valueJSON as NSDictionary, keys:"rider_thumb_image"),
                "job_id" : UberSupport().checkParamTypes(params:valueJSON as NSDictionary, keys:"job_id"),
                "user_name" : UberSupport().checkParamTypes(params:valueJSON as NSDictionary, keys:"user_name")
            ]
//            if let json = userInfo[NotificationTypeEnum.job_payment.rawValue] as? JSON{
//                _ = PipeAdapter.fireEvent("PaymentSuccess", data: json)
//            }else{
                NotificationCenter.default.post(name: NSNotification.Name.PaymentSuccess_job, object: self, userInfo: info)
//            }
        case .cancel_schedule_job:
            let jobID = valueJSON.int("job_id")
            NotificationCenter.default.post(name: NSNotification.Name.JobHistory, object: self, userInfo: nil)
            NotificationCenter.default
                .post(name: .HandyShowAlertForJobStatusChange,
                      object: notificationTitle,
                      userInfo: ["job_id":jobID,"id": userInfo.string("id")])
            NotificationEnum.pendingTripHistory.postNotification()
        case .manual_booking_job_assigned:
            NotificationEnum.pendingTripHistory.postNotification()
        case .schedule_job_request:
            // Handy Splitup Start
            switch BusinessType(rawValue: valueJSON.int("business_id")) {
            case .Delivery:
                let userinfo = userInfo.json("schedule_job_request")
                let reqModel = ManualRequestJobModel(userinfo)
                let vc = ManualJobBookedVC.initWithStory(forRequest: reqModel,
                                                         businessType: .Delivery)
                vc.modalPresentationStyle = .overCurrentContext
                    self.forcePresent(theController: vc)

            case .Services:
                // Handy Splitup End
                let userinfo = userInfo.json("schedule_job_request")
                let reqModel = ManualRequestJobModel(userinfo)
                let vc = ManualJobBookedVC.initWithStory(forRequest: reqModel,businessType :.Services)
                vc.modalPresentationStyle = .overCurrentContext
                    self.forcePresent(theController: vc)
                // Handy Splitup Start
            case .Ride:
                let userinfo = userInfo.json("schedule_job_request")
                let reqModel = ManualRequestJobModel(userinfo)
                let vc = ManualJobBookedVC.initWithStory(forRequest: reqModel,businessType :.Ride)
                vc.modalPresentationStyle = .overCurrentContext
                    self.forcePresent(theController: vc)
            default:
                let userinfo = userInfo.json("schedule_job_request")
                let reqModel = ManualRequestJobModel(userinfo)
                let vc = ManualJobBookedVC.initWithStory(forRequest: reqModel,
                                                         businessType: .Services)
                vc.modalPresentationStyle = .overCurrentContext
                    self.forcePresent(theController: vc)
            }
            // Handy Splitup End
        case .ride_request: //Gofer
            let start_time = userInfo.string("id")
            let end_time = userInfo.string("end_time")
            let business_id = userInfo["ride_request"]
            print(business_id)
            print("print start time : \(start_time)")
            print("print end time : \(end_time)")
            guard let epocTimeStart = TimeInterval(start_time) else { return }
            guard let epocTimeEnd = TimeInterval(end_time) else { return }

            let myStartDate = NSDate(timeIntervalSince1970: epocTimeStart)
            let myEndDate = NSDate(timeIntervalSince1970: epocTimeEnd)
            print(" print start data : \(myStartDate)")
            print("print end date : \(myEndDate)")
            let no_of_stops = userInfo.string("no_of_stops")
            Shared.instance.no_of_stops = no_of_stops
            print("print no_of_stops : \(no_of_stops)")
            

            let components = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: myEndDate as Date)
            print("print total seconds \(components.second?.description ?? "")")
            let currentTimeStamp = Date()
            print("print current time stamp : \(currentTimeStamp)")
            let diffcomponents = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: currentTimeStamp as Date)
            print("print diff from start request time \(diffcomponents.second?.description ?? "")")
            if (components.second ?? 0) >= diffcomponents.second ?? 0 {
                let seconds = (components.second ?? 0)  - (diffcomponents.second ?? 0)
                print("print request seconds \(seconds)")
                
                
                self.showGoferRequestPage(dict: valueJSON,
                                        requestTime: seconds,
                                        startTime: start_time,
                                        endTime: end_time)
            }else{
                AppUtilities().customCommonAlertView(titleString: "",
                                                     messageString: "Request Expired")
            }
            
            
        case .cancel_trip:
            preference.removeObject(forKey: TRIP_RIDER_RATING)
            preference.removeObject(forKey: TRIP_RIDER_NAME)
            preference.removeObject(forKey: TRIP_RIDER_THUMB_URL)
            Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            NotificationCenter.default.post(name: NSNotification.Name.TripCancelled, object: self, userInfo: nil)
            
        case .trip_payment:
            Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            let info: [AnyHashable: Any] = [
                "rider_thumb_image" : UberSupport().checkParamTypes(params:valueJSON as NSDictionary, keys:"rider_thumb_image"),
                "trip_id" : UberSupport().checkParamTypes(params:valueJSON as NSDictionary, keys:"job_id"),
                ]
            if let json = userInfo[NotificationTypeEnum.trip_payment.rawValue] as? JSON{
               _ = PipeAdapter.fireEvent("PaymentSuccess", data: json)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name.PaymentSuccess, object: self, userInfo: info)
            }
        case .manual_booking_trip_assigned, .manual_booking_trip_reminder, .manual_booking_trip_canceled_info, .manual_booking_trip_booked_info:
            
//            let userinfo = userInfo.json("schedule_job_request")
//            let reqModel = ManualRequestJobModel(userinfo)
//            let vc = ManualJobBookedVC.initWithStory(forRequest: reqModel,
//                                                     businessType: .Ride)
//            vc.modalPresentationStyle = .overCurrentContext
//                self.forcePresent(theController: vc)
            NotificationEnum.pendingTripHistory.postNotification()
        case .accept_request:
            Shared.instance.resumeTripHitCount = 0
            NotificationEnum.getEssentialsApiCallForPush.postNotification()
            
             default:
            print("Not handled \(notification) With value \(valueJSON)")
            
            //Mark:- Gofer Checking
//            let vc = ManualJobBookedVC.initWithStory(forRequest: ManualRequestJobModel(userInfo),
//                                                     businessType: .Services)
//            vc.modalPresentationStyle = .overCurrentContext
//            self.forcePresent(theController: vc)
        }
        
    }
    
    
    // CHECKING TRIP STATUS
    
    //New_Delivery_splitup_Start
    // Laundry Splitup Start
    // Instacart Splitup Start
    //Deliveryall splitup start
    func gotoToRouteView(withDetail tripDetail: JobDetailModel){
        //Handy_NewSplitup_Start
        //Deliveryall_Newsplitup_start
        //Deliveryall_Newsplitup_end
        //Handy_NewSplitup_End
    }
    //New_Delivery_splitup_End
    // Laundry Splitup End
    // Instacart Splitup End
    //Deliveryall splitup End
    func getMultipleRequests(requestId: Int,completionHandler : @escaping (Result<Bool,Error>) -> Void)
    {
        let handler = LocalCacheHandler()
        handler.getAllData(entity: "Request") { (result) in
            self.requestArray.removeAll()
            for element in result {
                let json = element?.json ?? JSON()
                print(json)
                let model = NotificationRequest.init(json)
                let start_time = model.startTime
                let end_time = model.endTime
                let epocTimeStart = TimeInterval(start_time) ?? Double()
                let epocTimeEnd = TimeInterval(end_time) ?? Double()
                let myStartDate = NSDate(timeIntervalSince1970: epocTimeStart)
                let myEndDate = NSDate(timeIntervalSince1970: epocTimeEnd)
                let components = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: myEndDate as Date)
                print(components.second ?? "")
                let currentTimeStamp = Date()
                print(currentTimeStamp)
                let diffcomponents = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: currentTimeStamp as Date)
                print(diffcomponents.second ?? "")
                if model.requestId == requestId.description{
                    model.isCompleted = true
                }
                if (components.second ?? 0) >= diffcomponents.second ?? 0 {
                    let seconds = (components.second ?? 0)  - (diffcomponents.second ?? 0)
                    if seconds != 0 && seconds > 1 {
                        self.requestArray.append(model)
                    }
                }
            }
            completionHandler(.success(true))
        }
    }
    func changeStatus(requestId: Int){
        let handler = LocalCacheHandler()
        self.getMultipleRequests(requestId: requestId){(result) in
            
            switch result{
            case .success( _):
                handler.removeAll(entity: "Request")
                    for element in self.requestArray{
                        var dicts = JSON()
                        dicts["request_id"] = element.requestId
                        dicts["user_name"] = element.userName
                        dicts["address"] = element.address
                        dicts["rating"] = element.rating
                        dicts["requestTime"] = element.requestTime
                        dicts["startTime"] = element.startTime
                        dicts["endTime"] = element.endTime
                        dicts["serviceName"] = element.serviceName
                        if !element.isCompleted {
//                            handler.store(data: Data() ,apiName: "multipleRequests", json: dicts,entity: "Request")
                            handler.store(data: Data() ,apiName: element.requestId, json: dicts,entity: "Request")
                        }
                    }
            case .failure( _):
                print("error")
            }
        }
        

    }
    func forcePresent(theController vc : UIViewController){
        if let nav = self.window?.rootViewController as? UITabBarController {
            nav.present(vc, animated: true, completion: nil)
        }else if let nav = self.window?.rootViewController as? UINavigationController{
            nav.presentingViewController?.dismiss(animated: true, completion: nil)
            nav.viewControllers.last?.dismiss(animated: true, completion: nil)
            nav.present(vc, animated: true, completion: nil)
        }else if let root = self.window?.rootViewController{
            root.present(vc, animated: true, completion: nil)
        }
    }
    func getAvailableViewController() -> UIViewController?{
        
        if let root = self.window?.rootViewController as? UITabBarController{
            return root.viewControllers?.first ?? root
        }else if let nav = self.window?.rootViewController as? UINavigationController{
            return nav
        }
        return nil
    }
    //MARK: ShowRequestPage
    
    func showRequestPage(dict : NSDictionary){
        let info: [AnyHashable: Any] = [
            "pickup_latitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_latitude"),
            "pickup_longitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_longitude"),
            "request_id" : UberSupport().checkParamTypes(params:dict, keys:"request_id"),
            "pickup_location" : UberSupport().checkParamTypes(params:dict, keys:"pickup_location"),
            "min_time" : UberSupport().checkParamTypes(params:dict, keys:"min_time"),
            "drop_location" : UberSupport().checkParamTypes(params:dict, keys:"drop_location") ,
            "just_launched" : false,
            "is_pool" : dict["is_pool"] as? Int ?? 0,
            "seat_count" : UberSupport().checkParamTypes(params:dict, keys:"seat_count")
        ]
        NotificationCenter.default.post(name: NSNotification.Name.ResquestRide, object: self, userInfo: info)
    }
    
    func showJobRequestPage(dict : JSON,requestTime : Int,startTime : String, endTime: String){
        dump(dict)
        let info: [AnyHashable: Any] = [
            "request_id" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"request_id"),
            "user_name" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"user_name"),
            "address" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"address"),
            "rating" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"rating"),
            "requestTime" : requestTime,
            "startTime" : startTime,
            "endTime" : endTime,
            "serviceName" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"service_name"),
            "bid_amount": UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"bid_amount"),
            "price_modal": UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"price_modal"),
            "min_bid": dict.int("min_bid"),
            "date": dict.string("date"),
            "time": dict.string("time")
            
        ]
        dump(info)
        NotificationCenter.default.post(name: NSNotification.Name.ResquestJob, object: self, userInfo: info)
    }
    func showJobRequestPageForDelivery(dict : JSON){
        let info: [AnyHashable: Any] = [
            "request_id" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"request_id"),
            "user_name" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"user_name"),
            "address" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"address"),
            "rating" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"rating"),
        ]
        NotificationCenter.default.post(name: NSNotification.Name.DeliveryResquestJob, object: self, userInfo: info)
    }
    func showJobRequestPageForDeliveryAll(dict : NSDictionary){
        let info: [AnyHashable: Any] = [
            "pickup_latitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_latitude"),
            "pickup_longitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_longitude"),
            "request_id" : UberSupport().checkParamTypes(params:dict, keys:"request_id"),
            "pickup_location" : UberSupport().checkParamTypes(params:dict, keys:"pickup_location"),
            "min_time" : UberSupport().checkParamTypes(params:dict, keys:"min_time"),
            "order_id": UberSupport().checkParamTypes(params:dict, keys:"order_id"),
            "restaurant": UberSupport().checkParamTypes(params:dict, keys:"store"),
            "business_id": UberSupport().checkParamTypes(params:dict, keys:"business_id"),
            "store": UberSupport().checkParamTypes(params:dict, keys:"store"),
            "total_orders": UberSupport().checkParamTypes(params:dict, keys:"total_orders"),
            "multiple_delivery": UberSupport().checkParamTypes(params: dict, keys: "multiple_delivery"),
            "group_id": UberSupport().checkParamTypes(params:dict, keys:"group_id"),
            "just_launched" : false,
            ]
        NotificationCenter.default.post(name: NSNotification.Name.DeliveryAllRequest, object: self, userInfo: info)
    }
    
    func showJobRequestPageForLaundry(dict : NSDictionary){
        let info: [AnyHashable: Any] = [
            "pickup_latitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_latitude"),
            "pickup_longitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_longitude"),
            "request_id" : UberSupport().checkParamTypes(params:dict, keys:"request_id"),
            "pickup_location" : UberSupport().checkParamTypes(params:dict, keys:"pickup_location"),
            "min_time" : UberSupport().checkParamTypes(params:dict, keys:"min_time"),
            "order_id": UberSupport().checkParamTypes(params:dict, keys:"order_id"),
            "restaurant": UberSupport().checkParamTypes(params:dict, keys:"store"),
            "business_id": UberSupport().checkParamTypes(params:dict, keys:"business_id"),
            "store": UberSupport().checkParamTypes(params:dict, keys:"store"),
            "total_orders": UberSupport().checkParamTypes(params:dict, keys:"total_orders"),
            "multiple_delivery": UberSupport().checkParamTypes(params: dict, keys: "multiple_delivery"),
            "group_id": UberSupport().checkParamTypes(params:dict, keys:"group_id"),
            "just_launched" : false,
            ]
        NotificationCenter.default.post(name: NSNotification.Name.LaundryRequest, object: self, userInfo: info)
    }
    
    func showJobRequestPageForInstacart(dict : NSDictionary){
        let info: [AnyHashable: Any] = [
            "pickup_latitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_latitude"),
            "pickup_longitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_longitude"),
            "request_id" : UberSupport().checkParamTypes(params:dict, keys:"request_id"),
            "pickup_location" : UberSupport().checkParamTypes(params:dict, keys:"pickup_location"),
            "min_time" : UberSupport().checkParamTypes(params:dict, keys:"min_time"),
            "order_id": UberSupport().checkParamTypes(params:dict, keys:"order_id"),
            "restaurant": UberSupport().checkParamTypes(params:dict, keys:"store"),
            "business_id": UberSupport().checkParamTypes(params:dict, keys:"business_id"),
            "store": UberSupport().checkParamTypes(params:dict, keys:"store"),
            "total_orders": UberSupport().checkParamTypes(params:dict, keys:"total_orders"),
            "multiple_delivery": UberSupport().checkParamTypes(params: dict, keys: "multiple_delivery"),
            "group_id": UberSupport().checkParamTypes(params:dict, keys:"group_id"),
            "just_launched" : false,
            ]
        NotificationCenter.default.post(name: NSNotification.Name.InstacartRequest, object: self, userInfo: info)
    }
    
    //Mark:- GoferRequest Page
    func showGoferRequestPage(dict : JSON,requestTime : Int,startTime : String, endTime: String){
        
        var wayPoints = [WayPoint]()
        if let json = dict as? JSON{
            print("∂ requestJSON ",json)
            if let wayPointEncodedStringArray = json["waypoints"] as? [String]{
                wayPoints = wayPointEncodedStringArray.compactMap({$0.decode2JSON}).compactMap({WayPoint($0)})
            }
            dump(wayPoints)
        }


        
        let info: [AnyHashable: Any] = [
            "pickup_latitude" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"pickup_latitude"),
            "pickup_longitude" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"pickup_longitude"),
            "request_id" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"request_id"),
            "business_id" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"business_id"),
            "pickup_location" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"pickup_location"),
            "min_time" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"min_time"),
            "drop_location" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"drop_location") ,
            "just_launched" : false,
            "is_pool" : dict["is_pool"] as? Int ?? 0,
            "seat_count" : UberSupport().checkParamTypes(params:dict as NSDictionary, keys:"seat_count"),
            "requestTime" : requestTime,
            "startTime" : startTime,
            "endTime" : endTime,
            "waypoints" : wayPoints,
            "no_of_stops": UberSupport().checkParamTypes(params: dict as NSDictionary, keys: "no_of_stops")

        ]
        NotificationCenter.default.post(name: NSNotification.Name.GoferRequest, object: self, userInfo: info)
    }
    
    
    func showJobHistory()
    {
        NotificationCenter.default.post(name: NSNotification.Name.JobHistory, object: self, userInfo: nil)
    }
    
    
    

    
    
}
class Person: NSObject {
    @objc dynamic var requestId: String = ""
}
class cancelObserver {
    var kvoToken: NSKeyValueObservation?
    
    func observe(person: Person) {
        kvoToken = person.observe(\.requestId, options: .new) { (person, change) in
            guard let age = change.newValue else { return }
            print("Ø New requestId is: \(age)")
        }
    }
    
    deinit {
        kvoToken?.invalidate()
    }
}
let taylor = Person()
extension PushNotificationManager {
    func startObservingProvider(){
        self.stopObservingProvider()
        guard let userID : String = UserDefaults.value(for: .user_id) else{
            print("userId is missing")
            return
        }
        if let fireListeningKey = self.firebaseReference?.key,
           fireListeningKey == userID{
            print("Already listeneing to \(fireListeningKey)")
            return
        }
        print("Listening to firebase user id \(userID)")
        self.firebaseReference = Database.database().reference()
            .child(firebaseEnvironment.rawValue)
            .child("Provider")
            .child("\(userID)")
            .child("Notification")
        dump(Env.isLive())
        self.firebaseReference?.observe(.value, with: { (snapShot) in
            
            guard snapShot.exists() else{return}
            Shared.instance.permissionDenied = false

            //Reomve from firebase after reading the data
            self.firebaseReference?.removeValue()
            let dataStr = snapShot.value as? String
            let dict = self.convertStringToDictionary(text: dataStr  ?? String())
            let custom = dict?[NotificationTypeEnum.custom.rawValue] as Any
            let dictionary = custom as! NSDictionary
            // Handy Splitup Start
            switch AppWebConstants.businessType{
            default :
                // Handy Splitup End
                self.handleHandyPushNotificaiton(userInfo: dictionary as! JSON)
                // Handy Splitup Start
            }
            // Handy Splitup End
            self.handleCommonPushNotification(userInfo: dictionary as NSDictionary,
                                              generateLocalNotification: true)
        }, withCancel: { (Error:Any) in
            Shared.instance.permissionDenied = true
            print("Error is \(Error)") //prints Error is Error Domain=com.firebase Code=1 "Permission Denied"
        })
        
    }
    func stopObservingProvider(){
        self.firebaseReference?.removeAllObservers()
        self.firebaseReference = nil
    }
}
