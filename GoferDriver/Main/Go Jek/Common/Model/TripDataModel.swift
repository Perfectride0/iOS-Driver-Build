//
//  RiderDataModel.swift
//  GoferDriver
//
//  Created by trioangle on 15/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
//class RiderDataModel {
//    let id : Int
//    let carID : Int
//    let tripPath : String
//    let totalFare : Double
//    let carName : String
//    let mapImage :String
//    let pickupLatitude, pickupLongitude : Double
//    let dropLatitude, dropLongitude: Double
//    let pickupLocation, dropLocation: String
//    let riderProfilePicture: String
//    let currency_symbol : String
//    let sheduleTime : String
//    let scheduleDate : String
//    let driverPayout: Double
//    let subTotalFare: Double
//    let driverEarnings: String
//
//    var statusMessage : String
//    let statusCode : String
//    let createdAt : String
//    var isPoolTrip : Bool = Bool()
//    var seats : Int = Int()
//
//    var status : TripStatus
//    var bookingType : BookingEnum
//
//    let riderID : Int
//       let riderThumbImage : String
//    let beginTrip, endTrip, paymentMode: String
//    let ratingValue : String
//    let mobileNumber : String
//    let appliedOweAmount : Double
//    let invoice: [InvoiceModel]
//    let riderName : String
//    var payment_detail = EndTripModel()
//    let paymentStatus, currencyCode, otp: String
//
//    let totalTime, totalKM, waitingCharge: Double
//
//    let carType : String
//
//    var getTripID : String{
//        return self.id.description
//    }
////    var getPayableAmount : String {
////        return self.totalFare.isZero
////            ? self.payment_detail.total_fare
////            : self.totalFare.description
////    }
//    var getPaymentMethod : String{
//        return self.paymentMode
//    }
//    var getRating : Double{
//        return Double(self.ratingValue) ?? 0.0
//    }
//
//    /**
//     destination to which driver should travel
//     - Author: Abishek Robin
//     - NOTE: return drop location if trip is started else pickup
//     */
//    var getDestination : CLLocation{
//        if status.isTripStarted{
//            return CLLocation(latitude: self.dropLatitude, longitude: self.dropLongitude)
//        }else{
//            return CLLocation(latitude: self.pickupLatitude, longitude: self.pickupLongitude)
//        }
//    }
//    var getDestinationMarkerImage : String{
//        if status.isTripStarted{
//            return "dropoff_icon_pin"
//        }else{
//            return "pickup_icon"
//        }
//    }
//    init(_ json : JSON) {
//        self.id =  json.int("id")
//        self.paymentMode = json.string("payment_mode")
//        self.paymentStatus = json.string("payment_status")
//        self.carID =  json.int("car_id")
//        self.carType = json.string("car_type")
//        self.tripPath = json.string("job_path")
//        self.totalFare =  json.double("total_fare")
//        self.carName =  json.string("car_type")
//        self.mapImage =  json.string("map_image")
//        self.pickupLatitude =  json.double("pickup_lat")
//        self.pickupLongitude =  json.double("pickup_lng")
//        self.pickupLocation = json.string("pickup")
//        self.dropLatitude =  json.double("drop_lat")
//        self.dropLongitude =  json.double("drop_lng")
//        self.dropLocation = json.string("drop")
//        self.currency_symbol =  json.string("currency_symbol")
//        self.sheduleTime = json.string("schedule_time")
//        self.scheduleDate = json.string("schedule_date")
//        self.driverPayout = json.double("provider_payout")
//        self.subTotalFare = json.double("subtotal_fare")
////        self.carActiveImage = json.string("car_active_image")
//        let _status = json.string("status")
//        let _tripsStatus = json.json("payment_details").string("trips_status")
//        self.status =  TripStatus(rawValue: _status.isEmpty ? _tripsStatus : _status) ?? .request
//        self.bookingType = BookingEnum(rawValue: json.string("booking_type")) ?? .auto
//        self.statusCode = json.status_code.description
//        self.statusMessage = json.status_message
//        self.driverEarnings = json.string("driver_earnings")
//
//        self.riderID = json.int("id")
//        self.riderThumbImage = json.string("image")
//        self.riderName = json.string("name")
//        self.otp = json.string("otp")
//        self.currencyCode = json.string("currency_code")
//        UserDefaults.set(self.riderID, for: .rider_user_id)
//        self.beginTrip = json.string("begin_job")
//        self.endTrip = json.string("end_job")
//         self.ratingValue = json.string("rating")
//        self.mobileNumber = json.string("mobile_number")
//        self.appliedOweAmount = json.double("applied_owe_amount")
//        self.riderProfilePicture = json.string("rider_thumb_image")
//        self.invoice = json.array("invoice")
//            //.compactMap({InvoiceModel($0)})
//
//        self.totalTime = json.double("total_time")
//        self.totalKM = json.double("total_km")
//        self.waitingCharge = json.double("waiting_charge")
//        self.createdAt = json.string("created_at")
//        self.storeRiderInfo(true)
////        if self.statusCode != "0",
////            ![TripStatus.rating,.payment].contains(self.status){
////            DriverTripStatus.Trip.store()
////        }
//
//    }
//    convenience init(tripID id: Int){
//        var json = JSON()
//        json["trip_id"] = id
//        self.init(json)
//    }
//
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
//}
//extension RiderDataModel : Equatable,Hashable{
//    static func == (lhs: RiderDataModel, rhs: RiderDataModel) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(self.id)
//    }
//
//}
//extension RiderDataModel : CustomStringConvertible{
//    var description: String{
//        return self.id.description
//    }
//}
//MARK:- UDF
//extension RiderDataModel{
//    private var getGooglStaticMap : URL?{
//        let startlatlong = "\(self.pickupLatitude),\(self.pickupLongitude)"
//        
//        let droplatlong = "\(self.dropLatitude),\(self.dropLongitude)"
//        
//        let tripPath = self.tripPath
//        let mapmainUrl = "https://maps.googleapis.com/maps/api/staticmap?"
//        let mapUrl  = mapmainUrl + startlatlong
//        let size = "&size=" +  "\(Int(640))" + "x" +  "\(Int(350))"
//        let enc = "&path=color:0x000000ff|weight:4|enc:" + tripPath
//        let key = "&key=" + GooglePlacesApiKey
//        let pickupImgUrl = String(format:"%@public/images/pickup_icon|",APIBaseUrl)
//        let dropImgUrl = String(format:"%@public/images/dropoff_icon|",APIBaseUrl)
//        let positionOnMap = "&markers=size:mid|icon:" + pickupImgUrl + startlatlong
//        let positionOnMap1 = "&markers=size:mid|icon:"  + dropImgUrl + droplatlong
//        let staticImageUrl = mapUrl + positionOnMap + size + "&zoom=14" + positionOnMap1 + enc + key
//        let urlStr = staticImageUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! as String
//        let url = URL(string: urlStr)
//        return url
//    }
//    func getWorkingMapURL() -> URL?{
//        if self.mapImage.isEmpty{
//            return self.getGooglStaticMap
//        }else{
//            return URL(string: self.mapImage)
//        }
//    }
//}


