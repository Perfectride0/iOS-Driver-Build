//
//  NotificationNames+extension.swift
//  GoferDriver
//
//  Created by trioangle on 27/02/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation


extension Notification.Name{
    static let AppEnteredBackground = Notification.Name(rawValue: "app_entered_background")
    static let AppEnteredForeground = Notification.Name(rawValue: "app_entered_foreground")
    static let PaymentSuccess = Notification.Name(rawValue: "PaymentSuccess")
    static let ResquestRide = Notification.Name(rawValue: "ResquestRide")
    static let phonenochanged = Notification.Name(rawValue: "phonenochanged")
    static let ShowHomePage = Notification.Name(rawValue: "ShowHomePage")
    static let HandleTimer = Notification.Name(rawValue: "handle_timer")
    static let TripCancelDriver = Notification.Name(rawValue: "cancel_trip_driver")
    static let PaymentSuccessInHomeAlert = Notification.Name(rawValue: "PaymentSuccessInHomeAlert")
    static let TripCancelledByDriver = Notification.Name(rawValue: "cancel_trip_by_driver")
    static let TripCancelled = Notification.Name(rawValue: "cancel_trip")
    //handy
    static let ResquestJob = Notification.Name(rawValue: "ResquestJob")
    static let JobCancelledByDriver = Notification.Name(rawValue: "cancel_job_by_driver")
    
    static let JobCancelled = Notification.Name(rawValue: "cancel_job")
    static let ManualJobBooked = Notification.Name(rawValue: "manual_job_booked")
    static let JobHistory = Notification.Name(rawValue: "JobHistory")
    static let PaymentSuccess_job = Notification.Name(rawValue: "PaymentSuccess_job")
    
    
    static let ThemeRefresher = Notification.Name(rawValue: "ThemeRefresher")
    static let ShowHomePage_job = Notification.Name(rawValue: "ShowHomePage_job")
    static let JobCancelDriver = Notification.Name(rawValue: "cancel_job_driver")
    static let PaymentSuccessInHomeAlert_job = Notification.Name(rawValue: "PaymentSuccessInHomeAlert_job")
    
    static let HandyRefreshInvoice = Notification.Name("HandyRefreshInvoice")
    static let ChatRefresh = Notification.Name("ChatRefresh")
    static let HandyRequestCancelledByUser = Notification.Name(rawValue: "HandyRequestCancelledByUser")
    static let HandyShowAlertForJobStatusChange = Notification.Name(rawValue: "HandyShowAlertForJobStatusChange")
    static let CancelJobByUser = Notification.Name(rawValue: "CancelJobByUser")
    static let HandyMultipleRequest = Notification.Name(rawValue: "HandyMultipleRequest")
    static let DeliveryResquestJob = Notification.Name(rawValue: "DeliveryResquestJob")
    static let DeliveryAllRequest = Notification.Name(rawValue: "DeliveryAllRequest")
    static let LaundryRequest = Notification.Name(rawValue: "LaundryRequest")
    static let InstacartRequest = Notification.Name(rawValue: "InstacartRequest")

    static let storeassign = Notification.Name(rawValue: "order_assigned")
    static let GoferRequest = Notification.Name(rawValue: "GoferRequest")
    static let TripStartedRefresh = Notification.Name(rawValue: "TripStartedRefresh")
    static let getEssentialsApiCallForPush = Notification.Name(rawValue: "getEssentialsApiCallForPush")
    static let immediate_end_trip = Notification.Name(rawValue: "immediate_end_trip")
    static let update_stops = Notification.Name(rawValue: "update_stops")
    

}
