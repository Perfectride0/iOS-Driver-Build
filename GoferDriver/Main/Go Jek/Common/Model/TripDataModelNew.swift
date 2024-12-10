//
//  TripDataModel.swift
//  GoferDriver
//
//  Created by trioangle on 15/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
//class TripDataModel {
//    let id : Int
//    let tripStatus : Int
//    var carID : Int = 0
//    var tripPath : String = ""
//    let totalFare : Double
//    let carName : String
//    let isConfirm : String
//    let mapImage :String
//    var pickupLatitude : Double = 0
//    var pickupLongitude : Double = 0
//    var dropLatitude : Double = 0
//    var dropLongitude: Double = 0
//    var pickupLocation : String = ""
//    var dropLocation: String = ""
//    var currency_symbol : String = ""
//    var sheduleTime : String = ""
//    var scheduleDate : String = ""
//    var driverPayout: Double = 0
//    var subTotalFare: Double = 0
//    var driverEarnings: String = ""
//
//    var statusMessage : String = ""
//    var statusCode : String = ""
//    var deliveryStatusCode : String = ""
//    var group_id : String = ""
//
//
//    var status : TripStatus = .scheduled
//    var bookingType : BookingEnum = .auto
//    init(_ json : JSON) {
//        self.id =  json.int("trip_id")
//        self.tripStatus = json.int("status")
//        self.carID =  json.int("car_id")
//        self.tripPath =  json.string("trip_path")
//        self.totalFare =  json.double("total_fare")
//        self.carName =  json.string("car_name")
//        self.isConfirm = json.string("is_confirmed")
//        self.mapImage =  json.string("map_image")
//        self.pickupLatitude =  json.double("pickup_latitude")
//        self.pickupLongitude =  json.double("pickup_longitude")
//        self.pickupLocation = json.string("pickup_location")
//        self.dropLatitude =  json.double("drop_latitude")
//        self.dropLongitude =  json.double("drop_longitude")
//        self.dropLocation = json.string("drop_location")
//        self.currency_symbol =  json.string("currency_symbol")
//        self.sheduleTime = json.string("schedule_time")
//        self.scheduleDate = json.string("schedule_date")
//        self.driverPayout = json.double("driver_payout")
//        self.subTotalFare = json.double("subtotal_fare")
//        let _status = json.string("status")
//        let _tripsStatus = json.json("payment_details").string("trips_status")
//        self.status =  TripStatus(rawValue: _status.isEmpty ? _tripsStatus : _status) ?? .request
//        self.bookingType = BookingEnum(rawValue: json.string("booking_type")) ?? .auto
//        self.statusCode = json.status_code.description
//        self.statusMessage = json.status_message
//        self.driverEarnings = json.string("driver_earnings")
//        self.group_id = json.string("group_id")
//
//    }
//    convenience init(tripID id: Int){
//        var json = JSON()
//        json["trip_id"] = id
//        self.init(json)
//    }
//    init(resuaruntJSON json: JSON){
//
//        self.id = json.int("id")
//        self.totalFare = json.double("total_fare")
//        self.carName = json.string("vehicle_name")
//        self.deliveryStatusCode = json.string("status")
//        self.mapImage = json.string("map_image")
//        self.isConfirm = json.string("is_confirmed")
//        self.tripStatus = json.int("status")
//        self.group_id = json.string("group_id")
//        self.status = TripStatus(fromDeliveryCode: self.deliveryStatusCode)
//    }
//    init(tripJSON json: JSON){
//
//        self.id = json.int("order_id")
//        self.carName = json.string("vehicle_type")
//        self.deliveryStatusCode = json.string("status")
//        self.tripStatus = json.int("status")
//        self.group_id = json.string("group_id")
//        self.status = TripStatus(fromDeliveryCode: self.deliveryStatusCode)
//        self.mapImage = json.string("map_image")
//        self.totalFare = json.double("total_fare")
//        self.isConfirm = json.string("is_confirmed")
//    }
//}
//extension TripDataModel : Equatable,Hashable{
//    static func == (lhs: TripDataModel, rhs: TripDataModel) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(self.id)
//    }
//
//}
//extension TripDataModel : CustomStringConvertible{
//    var description: String{
//        return self.id.description
//    }
//}
//MARK:- UDF
//extension TripDataModel{
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
//        let pickupImgUrl = APIBaseUrl ?? "https://goferjek.trioangledemo.com/" + "/images/pickup.png?1|"
//        let dropImgUrl = APIBaseUrl ?? "https://goferjek.trioangledemo.com/" + "/images/drop.png?1|"
//        let positionOnMap = "&markers=size:mid|icon:" + pickupImgUrl + startlatlong
//        let positionOnMap1 = "&markers=size:mid|icon:"  + dropImgUrl + droplatlong
//        let staticImageUrl = mapUrl + positionOnMap + size + "&zoom=12" + "&maptype=roadmap&format=png&visual_refresh=true" + positionOnMap1 + enc + key
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


//class DeliveryAllModel : TripDataModel {
//    //MARK Properties
//    let userID: Int
//    let driverID: Int
//    let totalTime, totalKM, waitingCharge: Double
//    let beginTrip, endTrip, paymentMode: String
//    let paymentStatus, currencyCode, otp: String
//    let vehicleName, driverName, riderName: String
//    let riderProfilePicture: String
//    let driverThumbImage: String
//    let carActiveImage: String
//    let group_Id: String
//    //let driverEarnings: String
//    let invoice: [InvoiceModel]
//
//
//
//    let riderID : Int
//    let riderThumbImage : String
//    let requestID : Int
//    let ratingValue : String
//    let carType : String
//
//    let mobileNumber : String
//    let appliedOweAmount : Double
//    let walletAmount : Double
//
//    let scheduleTime : String
//    // let scheduleDate : String
//
//
//    let createdAt : String
//    let updatedAt : String
//
//
//    let rating : Double
//    let shouldApplyExtraFare : Bool
//
//    var getTripID : String{
//        return self.id.description
//    }
//    var getPayableAmount : String {
//        return self.totalFare.isZero
//            ? self.payment_detail.total_fare
//            : self.totalFare.description
//    }
//    var getPaymentMethod : String{
//        return self.paymentMode
//    }
//    var getRating : Double{
//        return Double(self.ratingValue) ?? 0.0
//    }
//    var payment_detail = EndTripModel()
//    var isDetialData = false
//    override init(_ json : JSON){
//
//        self.otp = json.string("otp")
//        self.riderThumbImage = json.string("rider_thumb_image")
//        self.riderName = json.string("rider_name")
//        self.ratingValue = json.string("rating_value")
//        self.carType = json.string("car_type")
//
//        self.mobileNumber = json.string("mobile_number")
//        self.paymentMode = json.string("payment_mode")
//        self.carActiveImage = json.string("car_active_image")
//
//
//        self.totalTime = json.double("total_time")
//        self.beginTrip = json.string("begin_trip")
//        self.endTrip = json.string("end_trip")
//        self.createdAt = json.string("created_at")
//        self.updatedAt = json.string("updated_at")
//        //self.driverEarnings = json.string("driver_earnings")
//        //self.driverPayout = json.string("driver_payout")
//        self.totalKM = json.double("total_km")
//        self.vehicleName = json.string("vehicle_name")
//        //self.subTotalFare = json.double("sub_total_fare")
//        self.shouldApplyExtraFare = json.bool("apply_trip_additional_fee")
//
//        let paymentDetails = json.json("payment_details")
//
//        self.payment_detail = EndTripModel(paymentDetails) //UberSeparateParam.init().separateParamForGiveRating(params: paymentDetails as NSDictionary, isFromPayment: true) as! EndTripModel
//        let invoiceArr = json.array("invoice")
//        self.invoice = invoiceArr.compactMap({InvoiceModel.init($0)})
//
//        //self.scheduleDate = json.string("schedule_date")
//        self.scheduleTime = json.string("schedule_time")
//
//        self.riderID = json.int("rider_id")
//        UserDefaults.set(self.riderID, for: .rider_user_id)
//        self.userID =  json.int("user_id")
//        self.driverID = json.int("driver_id")
//        self.waitingCharge = json.double("waiting_charge")
//        self.paymentStatus = json.string("payment_status")
//        self.currencyCode = json.string("currency_code")
//        self.driverName = json.string("driver_name")
//        self.riderProfilePicture = json.string("driver_profile_picture")
//        self.driverThumbImage = json.string("driver_thumb_image")
//        self.requestID = json.int("request_id")
//        self.appliedOweAmount = json.double("applied_owe_amount")
//        self.walletAmount = json.double("wallet_amount")
//        self.rating = json.double("rating")
//        self.group_Id = json.string("group_id")
//        super.init(json)
//        self.isDetialData = true
//        if !self.getRating.isZero{
//            UserDefaults.standard.set(self.getRating.description, forKey: TRIP_RIDER_RATING)
//        }
//        self.storeRiderInfo(true)
//    }
//
//    //MARK:- fucnitonalities
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
//    /**
//     destination to which driver should travel
//     - Author: Abishek Robin
//     - NOTE: return drop location if trip is started else pickup
//     */
//    var getDestination : CLLocation{
//        if status.isDelOrderStarted{
//            return CLLocation(latitude: self.dropLatitude, longitude: self.dropLongitude)
//        }else{
//            return CLLocation(latitude: self.pickupLatitude, longitude: self.pickupLongitude)
//        }
//    }
//    var getDestinationMarkerImage : String{
//        if status.isDelOrderStarted{
//            return "dropoff_icon_pin.png"
//        }else{
//            return "pickup_icon.png"
//        }
//    }
//}



class TripDataModel: Codable {
    let status_message, status_code : String
    let order_details:DeliveryAllCommonData?
    enum CodingKeys: String, CodingKey {
        case status_message = "status_message"
        case status_code = "status_code"
        case order_details = "order_details"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.order_details = try? container.decodeIfPresent(DeliveryAllCommonData.self, forKey: .order_details)
    }
}

class DeliveryAllCommonData: Codable {
    let id , riderID, requestID: Int
    let total_Fare, isConfirm, mapImage, pickup_latitude, pickup_longitude, pickupLocation, drop_latitude , drop_longitude, dropLocation, group_id, carName, deliveryStatusCode, tripStatus, tripPath, paymentMode, firstDriver: String
    let totalFare, pickupLatitude, pickupLongitude, dropLatitude, dropLongitude:Double
    var status : TripStatus = .scheduled

    enum CodingKeys: String, CodingKey {
        case tripStatus = "status"
        case total_Fare = "total_fare"
        case isConfirm = "is_confirmed"
        case mapImage = "map_image"
        case pickup_latitude = "pickup_latitude"
        case pickup_longitude = "pickup_longitude"
        case pickupLocation = "pickup_location"
        case drop_latitude = "drop_latitude"
        case drop_longitude = "drop_longitude"
        case dropLocation = "drop_location"
        case group_id = "group_id"
        case id = "order_id"
        case carName = "vehicle_type"
        case riderID = "rider_id"
        case tripPath = "trip_path"
        case paymentMode = "payment_mode"
        case firstDriver = "first_driver"
        case requestID = "request_id"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.riderID = container.safeDecodeValue(forKey: .riderID)

        self.tripStatus = container.safeDecodeValue(forKey: .tripStatus)
        self.carName = container.safeDecodeValue(forKey: .carName)

        self.total_Fare = container.safeDecodeValue(forKey: .total_Fare)
        self.isConfirm = container.safeDecodeValue(forKey: .isConfirm)
        self.mapImage = container.safeDecodeValue(forKey: .mapImage)
        self.pickup_latitude = container.safeDecodeValue(forKey: .pickup_latitude)
        self.pickup_longitude = container.safeDecodeValue(forKey: .pickup_longitude)
        self.pickupLocation = container.safeDecodeValue(forKey: .pickupLocation)
        self.drop_latitude = container.safeDecodeValue(forKey: .drop_latitude)
        self.drop_longitude = container.safeDecodeValue(forKey: .drop_longitude)
        self.dropLocation = container.safeDecodeValue(forKey: .dropLocation)
        self.group_id = container.safeDecodeValue(forKey: .group_id)
        self.tripPath = container.safeDecodeValue(forKey: .tripPath)
        self.paymentMode = container.safeDecodeValue(forKey: .paymentMode)
        self.firstDriver = container.safeDecodeValue(forKey: .firstDriver)
        self.requestID = container.safeDecodeValue(forKey: .requestID)




        self.totalFare = Double(self.total_Fare) ?? 0.0
        self.pickupLatitude = Double(self.pickup_latitude) ?? 0.0
        self.pickupLongitude = Double(self.pickup_longitude) ?? 0.0
        self.dropLatitude = Double(self.drop_latitude) ?? 0.0
        self.dropLongitude = Double(self.drop_longitude) ?? 0.0

        self.deliveryStatusCode = self.tripStatus

    }
}
extension DeliveryAllCommonData : Equatable,Hashable{
    static func == (lhs: DeliveryAllCommonData, rhs: DeliveryAllCommonData) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}
extension DeliveryAllCommonData : CustomStringConvertible{
    var description: String{
        return self.id.description
    }
}
//MARK:- UDF
extension DeliveryAllCommonData{
    private var getGooglStaticMap : URL?{
        let startlatlong = "\(self.pickupLatitude),\(self.pickupLongitude)"
        
        let droplatlong = "\(self.dropLatitude),\(self.dropLongitude)"
        
        let tripPath = self.tripPath
        let mapmainUrl = "https://maps.googleapis.com/maps/api/staticmap?"
        let mapUrl  = mapmainUrl + startlatlong
        let size = "&size=" +  "\(Int(640))" + "x" +  "\(Int(350))"
        let enc = "&path=color:0x000000ff|weight:4|enc:" + tripPath
        let key = "&key=" + GooglePlacesApiKey
        let pickupImgUrl = APIBaseUrl ?? "https://goferjek.trioangledemo.com/" + "/images/pickup.png?1|"
        let dropImgUrl = APIBaseUrl ?? "https://goferjek.trioangledemo.com/" + "/images/drop.png?1|"
        let positionOnMap = "&markers=size:mid|icon:" + pickupImgUrl + startlatlong
        let positionOnMap1 = "&markers=size:mid|icon:"  + dropImgUrl + droplatlong
        let staticImageUrl = mapUrl + positionOnMap + size + "&zoom=12" + "&maptype=roadmap&format=png&visual_refresh=true" + positionOnMap1 + enc + key
        let urlStr = staticImageUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! as String
        let url = URL(string: urlStr)
        return url
    }
    func getWorkingMapURL() -> URL?{
        if self.mapImage.isEmpty{
            return self.getGooglStaticMap
        }else{
            return URL(string: self.mapImage)
        }
    }
}
