
//
//  NotificationEnum.swift
//  PassUp
//
//  Created by trioangle on 26/02/20.
//  Copyright © 2020 Trioangle Technology. All rights reserved.
//
import UIKit


enum NotificationEnum :String {
    case completedTripHistory
    case pendingTripHistory
    case addressRefresh
    case cancelRequest
    case photoAddedRefresh
    case TripStartedRefresh
    case getEssentialsApiCallForPush
    func addObserver(_ observer:Any, selector: Selector){
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func removeObserver(_ observer:Any){
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func postNotification(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func postNotificatinWithData(userInfo:JSON){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: nil, userInfo: userInfo)
    }
    
    func postNotificationWithJSONObj(_ userInfo:[String:AnyObject]) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: nil, userInfo: userInfo)
    }
    func postNotificationWithObject(_ object:AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: object, userInfo: nil)
    }
    
   
}
