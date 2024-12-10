//
//  TripDetailDataModel.swift
//  GoferDriver
//
//  Created by trioangle on 15/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

//class TripDetailDataModel  {
//    var id: Int{return self.getCurrentTrip()?.id ?? 0}
//
//    var status: TripStatus{return self.getCurrentTrip()?.status ?? .scheduled}
//
//    //MARK Properties
//    let userID: Int
//    let mainTripID : Int
//    let driverID: Int
//    let vehicleName, driverName : String
//    let driverThumbImage: String
//    let carActiveImage: String
//
//    var riders : [RiderDataModel]
//
//    var isPoolTrip : Bool
//
//    let requestID : Int
//
//    let walletAmount : Double
//
//    let scheduleTime : String
//
//
//    let updatedAt : String
//    let createdAt : String
//
//    let rating : Double
//    let shouldApplyExtraFare : Bool
//
//
//    var statusMessage : String
//    let statusCode : String
//    var isDetialData = false
//    var currentDriverPrefered : Int?
//    let riderID : Int
//    let riderThumbImage : String
//    let ratingValue : String
//    let riderName: String
//
//    init(_ json : JSON){
//        self.statusCode = json.status_code.description
//        self.statusMessage = json.status_message
//        self.mainTripID = json.int("pool_id")
//        self.carActiveImage = json.string("car_active_image")
//
//        self.createdAt = json.string("created_at")
//        self.updatedAt = json.string("updated_at")
//        self.vehicleName = json.string("vehicle_name")
//        self.shouldApplyExtraFare = json.bool("apply_job_additional_fee")
//
//
//        self.scheduleTime = json.string("schedule_time")
//        self.userID =  json.int("user_id")
//        self.driverID = json.int("driver_id")
//        self.driverName = json.string("driver_name")
//        self.driverThumbImage = json.string("driver_thumb_image")
//        self.requestID = json.int("request_id")
//        self.walletAmount = json.double("wallet_amount")
//        self.rating = json.double("rating")
//        self.isDetialData = true
//        self.riders = json.array("riders").compactMap({RiderDataModel($0)})
//        self.isPoolTrip = json.bool("is_pool")
//
//        self.riderThumbImage = json.string("rider_thumb_image")
//        self.riderName = json.string("rider_name")
//        self.ratingValue = json.string("rating_value")
//        self.riderID = json.int("rider_id")
//
//    }
//    convenience init(tripID id: Int){
//        var json = JSON()
//        json["job_id"] = id
//        self.init(json)
//    }
//    //MARK:- fucnitonalities
//    func storeRiderInfo(_ val : Bool){
//        let preference = UserDefaults.standard
//        if val{
//            UserDefaults.set(self.riderID, for: .rider_user_id)
//            preference.set(self.riderThumbImage, forKey: TRIP_RIDER_THUMB_URL)
//            preference.set(self.riderName, forKey: TRIP_RIDER_NAME)
//            preference.set(self.ratingValue, forKey: TRIP_RIDER_RATING)
//        }else{
//            UserDefaults.removeValue(for: .rider_user_id)
//            preference.removeObject(forKey: TRIP_RIDER_THUMB_URL)
//            preference.removeObject(forKey: TRIP_RIDER_NAME)
//            preference.removeObject(forKey: TRIP_RIDER_RATING)
//        }
//    }
//
//    func getCurrentTrip() -> RiderDataModel?{
//        var rider : RiderDataModel?
//        if let id = currentDriverPrefered {
//            rider = self.riders.filter({$0.id == id}).first
//        }else{
//            rider = self.riders.first
//        }
//        rider?.storeRiderInfo(true)
//        return self.riders.first
//    }
//
//}
//extension TripDetailDataModel : CustomStringConvertible{
//    var description: String{
//        return self.getCurrentTrip()?.getTripID.description ?? ""
//    }
//}
