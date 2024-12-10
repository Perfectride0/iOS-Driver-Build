//
//  JobDetailModel.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 14/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class JobDetailModel: Codable , Equatable {
    
    
    // Adding This Model To Speed Up the reloading State
    static func == (lhs: JobDetailModel, rhs: JobDetailModel) -> Bool {
        lhs.statusCode == rhs.statusCode &&
        lhs.statusMessage == rhs.statusCode &&
        lhs.users == rhs.users &&
        lhs.providerID == rhs.providerID &&
        lhs.providerName == rhs.providerName &&
        lhs.mobileNumber == rhs.mobileNumber &&
        lhs.providerImage == rhs.providerImage &&
        lhs.providerRating == rhs.providerRating &&
        lhs.providerAddress == rhs.providerAddress &&
        lhs.promoDetails == rhs.promoDetails
    }
    func getCurrentTrip() -> Users?{
        var rider : Users?
        if let id = currentDriverPrefered {
            rider = self.users.filter({$0.id == id}).first
        }else{
            rider = self.users.first
        }
        rider?.storeRiderInfo(true)
        return rider
    }
    var isFromHistoryPage : Bool {
        return false
    }
    
    var isPoolTrip: Bool
    var currentDriverPrefered: Int?
    var currentReceipientPrefered: Int?{
        get{return self.getCurrentTrip()?.delivery?.id}
        set{print("Ignored Id \(String(describing: newValue))")}
    }
    var id: Int{return self.getCurrentTrip()?.jobID ?? 0}
    var status: TripStatus{return getCurrentTrip()?.jobStatus ?? .pending}
    let statusCode, statusMessage : String
    var users: [Users]
    let providerID: Int
    let providerName, mobileNumber: String
    let providerImage: String
    let providerRating: Int
    let providerAddress: String
    let promoDetails: [PromoDetail]
    let totalFare, vehicleName: String
    var orderId : Int
    var orderStatus: String
    var mapImage,map_image_dark,isConfirmed,groupId:String
    var pickuploc,droploc:String
    var additionalfee:Bool
    var amITheTravellerDelivery : Bool{
        if getCurrentTrip()?.priceType == .Distance && getCurrentTrip()?.jobStatus.isDeliveryTripStarted ?? false{
            return true
        }else{
            return self.getCurrentTrip()?.jobAtUser ?? false
        }
    }
    var amITheTraveller : Bool{
        if getCurrentTrip()?.priceType == .Distance && (getCurrentTrip()?.jobStatus.isTripStarted ?? false) {
            return true
        }else{
            return self.getCurrentTrip()?.jobAtUser ?? false
        }
    }
    var isOTPShow : Bool{
        if getCurrentTrip()?.isRequiredOtp ?? false {
            return true
        }else{
            return false
        }
    }
    var targetJobLocation : CLLocation{
        return .init(latitude: self.getCurrentTrip()?.pickupLat ?? 0.00,
                     longitude: self.getCurrentTrip()?.pickupLng ?? 0.00)
      }
    
    //Gofer splitup start
    //Laundry splitup start
    //Instacart splitup start
    //Deliveryall splitup start

    //Deliveryall_Newsplitup_start

    // Laundry_NewSplitup_start
    // Laundry_NewSplitup_end

    //Gofer splitup end
    //Laundry splitup end
    //Instacart splitup end
    //Deliveryall splitup end
    var canShowLiveTrackingMapDelivery : Bool{
        
        if getCurrentTrip()?.priceType == .Distance {
            if self.getCurrentTrip()?.jobAtUser ?? false {
                return true
            }else{
                return self.getCurrentTrip()?.jobStatus.isDeliveryTripStarted ?? false
            }
        }else if !(self.getCurrentTrip()?.jobAtUser ?? false)  { //job is at providers location
            return false
        }else{
            return !(self.getCurrentTrip()?.jobStatus.isDeliveryTripStarted ?? false)
        }
    }
    var canShowPolylineDelivery : Bool{
        ////////////////////////////////////////////////////////
        guard canShowLiveTrackingMapDelivery else{ // first map should be showing
            return false
        }
        
        //////////////////////////////////////////////////////////
        if self.getCurrentTrip()?.priceType == .Distance{
            if self.getCurrentTrip()?.jobStatus.isDeliveryTripStarted ?? false{
                return false
            }else{
                return true
            }
        }
        
        if self.getCurrentTrip()?.jobStatus.isDeliveryTripStarted ?? false{
            return false
        }
        if !(self.getCurrentTrip()?.jobAtUser ?? false) { //job is at providers location
            return false
        }
       
        return true
    }
    var canShowLiveTrackingMap : Bool{
        
        if getCurrentTrip()?.priceType == .Distance {
            if self.getCurrentTrip()?.jobAtUser ?? false{
                return true
            }else{
                return self.getCurrentTrip()?.jobStatus.isTripStarted ?? false
            }
        }else if !(self.getCurrentTrip()?.jobAtUser ?? false){ //job is at providers location
            return false
        }else{
            return !(self.getCurrentTrip()?.jobStatus.isTripStarted ?? false)
        }
    }
    var canShowPolyline : Bool{
        ////////////////////////////////////////////////////////
        guard canShowLiveTrackingMap else{ // first map should be showing
            return false
        }
        
        //////////////////////////////////////////////////////////
        if self.getCurrentTrip()?.priceType == .Distance{
            if self.getCurrentTrip()?.jobStatus.isTripStarted ?? false{
                return false
            }else{
                return true
            }
        }
        
        if self.getCurrentTrip()?.jobStatus.isTripStarted ?? false{
            return false
        }
        if !(self.getCurrentTrip()?.jobAtUser ?? false)  { //job is at providers location
            return false
        }
       
        return true
    }

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case isPoolTrip = "is_pool"
        case users
        case providerID = "provider_id"
        case providerName = "provider_name"
        case mobileNumber = "mobile_number"
        case providerImage = "provider_image"
        case providerRating = "provider_rating"
        case providerAddress = "provider_address"
        case promoDetails = "promo_details"
        case totalFare = "total_fare"
        case vehicleName = "vehicle_name"
        case orderId = "id"
        case orderStatus = "status"
        case mapImage = "map_image"
        case isConfirmed = "is_confirmed"
        case groupId = "group_id"
        case map_image_dark = "map_image_dark"
        case pickuploc = "pickup_location"
        case droploc = "drop_location"
        case additionalfee = "additional_fee"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.providerID = container.safeDecodeValue(forKey: .providerID)
        self.providerName = container.safeDecodeValue(forKey: .providerName)
        self.mobileNumber = container.safeDecodeValue(forKey: .mobileNumber)
        self.providerImage = container.safeDecodeValue(forKey: .providerImage)
        self.providerRating = container.safeDecodeValue(forKey: .providerRating)
        self.providerAddress = container.safeDecodeValue(forKey: .providerAddress)
        let promo = try? container.decodeIfPresent([PromoDetail].self, forKey: .promoDetails)
        self.promoDetails = promo ?? [PromoDetail]()
        self.users = try container.decodeIfPresent([Users].self, forKey: .users) ?? []
        //        self.users = try container.decodeIfPresent(Users.self, forKey: .users)
        //        self.users = usersss ?? [Users(JSON())]
        self.totalFare = container.safeDecodeValue(forKey: .totalFare)
        self.vehicleName = container.safeDecodeValue(forKey: .vehicleName)
        self.orderId = container.safeDecodeValue(forKey: .orderId)
        self.orderStatus = container.safeDecodeValue(forKey: .orderStatus)
        self.mapImage = container.safeDecodeValue(forKey: .mapImage)
        self.isConfirmed = container.safeDecodeValue(forKey: .isConfirmed)
        self.groupId = container.safeDecodeValue(forKey: .groupId)
        self.map_image_dark = container.safeDecodeValue(forKey: .map_image_dark)
        self.pickuploc = container.safeDecodeValue(forKey: .pickuploc)
        self.droploc = container.safeDecodeValue(forKey: .droploc)
        self.isPoolTrip = container.safeDecodeValue(forKey: .isPoolTrip)
        self.additionalfee = container.safeDecodeValue(forKey: .additionalfee)
        
    }
    init(_ json : JSON) {
        self.statusCode = json.string("status_code")
        self.statusMessage = json.string("status_message")
        self.providerID = json.int("provider_id")
        self.providerName = json.string("provider_name")
        self.mobileNumber = json.string("mobile_number")
        self.providerImage = json.string("provider_image")
        self.providerRating = json.int("provider_rating")
        self.providerAddress = json.string("provider_address")
        self.promoDetails = json.array("promo_details").compactMap({PromoDetail($0)})
//        self.users = Users(json["users"] as? JSON ?? JSON())
        self.users = json.array("users").compactMap({Users($0)})
        self.totalFare = json.string("total_fare")
        self.vehicleName = json.string("vehicle_name")
        self.orderId = json.int("id")
        self.orderStatus = json.string("status").capitalized
        self.mapImage = json.string("map_image")
        self.isConfirmed = json.string("is_confirmed")
        self.groupId = json.string("group_id")
        self.map_image_dark = json.string("map_image_dark")
        self.pickuploc = json.string("pickup_location")
        self.droploc = json.string("drop_location")
        self.isPoolTrip = json.bool("is_pool")
        self.additionalfee = json.bool("additional_fee")
    }
    //Laundry splitup start
    //Gofer splitup start
    //Instacart splitup start

    //Handy_NewSplitup_Start

    //Deliveryall splitup start

    //Deliveryall_Newsplitup_start

    // Laundry_NewSplitup_start

    // Laundry_NewSplitup_end
    // Handy Splitup End

    //Handy_NewSplitup_End

    //Gofer splitup end
    //Laundry splitup end
    //Instacart splitup end
    //Deliveryall splitup End
    //Deliveryall_Newsplitup_end
}
// MARK: - Delivery
class Delivery: Codable {
    let id, otp: Int
    let recipientName, latitude, longitude, address: String
    let deliverySubStatus: String

    enum CodingKeys: String, CodingKey {
        case id, otp
        case recipientName = "recipient_name"
        case latitude, longitude, address
        case deliverySubStatus = "delivery_sub_status"
    }

    init(id: Int, otp: Int, recipientName: String, latitude: String, longitude: String, address: String, deliverySubStatus: String) {
        self.id = id
        self.otp = otp
        self.recipientName = recipientName
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.deliverySubStatus = deliverySubStatus
    }
    required init(from decoder : Decoder) throws{
       let container = try decoder.container(keyedBy: CodingKeys.self)
          
        self.id = container.safeDecodeValue(forKey: .id)
        self.otp = container.safeDecodeValue(forKey: .otp)
        self.recipientName = container.safeDecodeValue(forKey: .recipientName)
        self.latitude = container.safeDecodeValue(forKey: .latitude)
        self.longitude = container.safeDecodeValue(forKey: .longitude)
        self.address = container.safeDecodeValue(forKey: .address)
        self.deliverySubStatus = container.safeDecodeValue(forKey: .deliverySubStatus)

   }
   init(_ json : JSON) {
        self.id = json.int("id")
        self.otp = json.int("otp")
        self.recipientName = json.string("recipient_name")
        self.latitude = json.string("latitude")
        self.longitude = json.string("longitude")
        self.address = json.string("address")
        self.deliverySubStatus = json.string("delivery_sub_status")

   }
}
// MARK: - PromoDetail
class PromoDetail: Codable, Equatable {
    
    static func == (lhs: PromoDetail, rhs: PromoDetail) -> Bool {
        lhs.amount == rhs.amount &&
        lhs.code == rhs.code &&
        lhs.id  == rhs.id &&
        lhs.expireDate == rhs.expireDate
    }
    
    let id: Int
    let code, amount, expireDate: String

    enum CodingKeys: String, CodingKey {
        case id, code, amount
        case expireDate = "expire_date"
    }

     required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
           
           self.id = container.safeDecodeValue(forKey: .id)
           self.code = container.safeDecodeValue(forKey: .code)
           self.amount = container.safeDecodeValue(forKey: .amount)
           self.expireDate = container.safeDecodeValue(forKey: .expireDate)
    }
    init(_ json : JSON) {
        self.id = json.int("status_code")
        self.code = json.string("status_code")
        self.amount = json.string("status_code")
        self.expireDate = json.string("status_code")
        
    }
}
// MARK: - Users
class Users: Codable , Equatable {
    
    static func == (lhs: Users, rhs: Users) -> Bool {
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.image == rhs.image &&
            lhs.mobileNumber == rhs.mobileNumber &&
            lhs.isRequiredOtp == rhs.isRequiredOtp &&
            lhs.jobAtUser == rhs.jobAtUser &&
            lhs.jobID == rhs.jobID &&
            lhs.pickup == rhs.pickup &&
            lhs.drop == rhs.drop &&
            lhs.pickupLat == rhs.pickupLat &&
            lhs.pickupLng == rhs.pickupLng &&
            lhs.dropLat == rhs.dropLat &&
            lhs.dropLng == rhs.dropLng &&
            lhs.requestID == rhs.requestID &&
            lhs.currencyCode == rhs.currencyCode &&
            lhs.currencySymbol == rhs.currencySymbol &&
            lhs.totalTime == rhs.totalTime &&
            lhs.totalkm == rhs.totalkm &&
            lhs.providerPaypalID == rhs.providerPaypalID &&
            lhs.paypalAppID == rhs.paypalAppID &&
            lhs.paypalMode == rhs.paypalMode &&
            lhs.bookingType == rhs.bookingType &&
            lhs.rating == rhs.rating &&
            lhs.paymentMode == rhs.paymentMode &&
            lhs.firstDriver == rhs.firstDriver &&
            lhs.paymentStatus == rhs.paymentStatus &&
            lhs.totalFare == rhs.totalFare &&
            lhs.scheduleDisplayDate == rhs.scheduleDisplayDate &&
            lhs.requestedServices == rhs.requestedServices &&
            lhs.priceType == rhs.priceType &&
            lhs.jobProgress == rhs.jobProgress &&
            lhs.invoice == rhs.invoice &&
            lhs.jobStatus == rhs.jobStatus &&
            lhs.jobImage == rhs.jobImage &&
        lhs.jobRating == rhs.jobRating &&
        lhs.wayPoints == rhs.wayPoints &&
        lhs.isMultiTrip == rhs.isMultiTrip &&
        lhs.no_of_droppoints == rhs.no_of_droppoints &&
        lhs.requestedToEndTrip == rhs.requestedToEndTrip &&
        lhs.cancel_warning == rhs.cancel_warning




    }
    var requestedToEndTrip : Bool
    var wayPoints = [WayPoint]()
    var isMultiTrip : Bool
    var no_of_droppoints: Int
    
    var cancel_warning: String

    var imageUpload, imageRequired : Bool
    var id: Int
    var is_KM: Bool
    var name: String
    var image: String
    var mobileNumber, otp: String
    var jobID: Int
    var pickup, drop : String
    var dropLat, dropLng, pickupLat, pickupLng: Double
    var requestID,beginImageCount,endImageCount: Int
    var currencyCode, currencySymbol: String
    var totalTime: String
    var totalkm:String
    var providerPaypalID, paypalMode,paypalAppID : String
    var bookingType: BookingEnum
    var isCurrentJob, isRequiredOtp: Bool
    var rating: Int
    var paymentMode, firstDriver, totalFare,providerEarnings: String
    let promoAdded : Bool
    let walletSelected : Bool
    var scheduleDisplayDate: String
    var requestedServices: [RequestedServiceModel]
    var priceType: PriceType
    var jobProgress: [JobProgress]
    var invoice: [Invoice]
    var showInvoice : Bool = false
    var seats : String
    var mapImage : String
    var vehicleName : String
    var paymentModeKey : String
    var biddingFlow : String
    var modifiedInvoice : [Invoice] {
        if showInvoice {
            var invoice = self.invoice
            invoice.insert(Invoice.init(customWithName: LangHandy.fareDetails,
                                        value: "",
                                        bar: 0,
                                        colour: "",
                                        comment: ""),
                           at: 0)
            return invoice
        } else {
            return [Invoice.init(customWithName: LangHandy.fareDetails,
                                 value: "",
                                 bar: 0,
                                 colour: "",
                                 comment: "")]
        }
    }
    let jobImage: JobImage?
    let jobRating: JobRating
    var jobStatus,paymentStatus: TripStatus
    var jobAtUser : Bool
    var yaminiStatus : String
    var payer: PaymentResponsible
    //Handy_NewSplitup_Start
    // Laundry Splitup Start
    //Instacart splitup start
    //Deliveryall splitup start
    // Laundry_NewSplitup_start
    // Laundry_NewSplitup_end
    //Deliveryall_Newsplitup_end
    //Deliveryall splitup start
    //Handy_NewSplitup_End
    // Laundry Splitup End
    //Instacart splitup end
    var businessId : BusinessType

    var getDestination : CLLocation{
           if jobStatus.isTripStarted{
               return CLLocation(latitude: self.dropLat, longitude: self.dropLng)
           }else{
               return CLLocation(latitude: self.pickupLat, longitude: self.pickupLng)
           }
       }
    
    var getDestinationMarkerImage : String{
        if jobStatus.isTripStarted == true{
            return  "box"
        }else{
            return "circle"
        }
    }
    var currentReceipientPrefered: Int?{
        get{return self.delivery?.id}
        set{print("Ignored Id \(String(describing: newValue))")}
    }
    //Gofer splitup start
    // Laundry Splitup Start
    //Handy_NewSplitup_Start
    //Instacart splitup start
    //Deliveryall splitup start

    //Deliveryall_Newsplitup_start

    // Laundry_NewSplitup_start
    // Laundry_NewSplitup_end

    //Gofer splitup end
    // Laundry Splitup End
    //Handy_NewSplitup_End
    //Instacart splitup End
    //Deliveryall splitup End
    var delivery : Delivery?

    var paymentResult : String {
        get {
            var str = paymentMode
            if walletSelected { str += (promoAdded ? " , " : " & ") + LangCommon.wallet }
            if promoAdded { str +=  " & "  + (LangCommon.promo.isEmpty ? "Promo" : LangCommon.promo) }
            return str
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case cancel_warning = "cancel_warning"

        case id, name, image
        case mobileNumber = "mobile_number"
        case isRequiredOtp = "is_required_otp"
        case otp
        case wayPoints = "waypoints"
        case no_of_droppoints = "no_of_droppoints"
        case requestedToEndTrip = "request_end_trip"
        case isMultiTrip = "is_multitrip"

        case is_KM = "is_km"
        case jobID = "job_id"
        case pickup, drop
        case pickupLat = "pickup_lat"
        case pickupLng = "pickup_lng"
        case dropLat = "drop_lat"
        case dropLng = "drop_lng"
        case requestID = "request_id"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case totalTime = "total_time"
        case totalkm = "total_km"
        case providerPaypalID = "provider_paypal_id"
        case paypalAppID = "paypal_app_id"
        case paypalMode = "paypal_mode"
        case bookingType = "booking_type"
        case isCurrentJob = "is_current_job"
        case rating
        case jobStatus = "job_status"
        case paymentMode = "payment_mode"
        case firstDriver = "first_driver"
        case paymentStatus = "payment_status"
        case totalFare = "total_fare"
        case providerEarnings = "provider_earnings"
        case scheduleDisplayDate = "schedule_display_date"
        case requestedServices = "requested_services"
        case priceType = "price_type"
        case jobProgress = "job_progress"
        case invoice
        case jobImage = "job_image"
        case jobRating = "job_rating"
        case jobAtUser = "job_at_user"
        case imageUpload = "image_upload"
        case imageRequired = "image_required"
        case beginImageCount = "begin_image_count"
        case endImageCount = "end_image_count"
        case payer
        case paymentModeKey = "payment_mode_key"
        case biddingFlow = "bidding_flow"
        //Gofer splitup start
        // Laundry Splitup Start

        //Handy_NewSplitup_Start


        //Deliveryall_Newsplitup_start


        //Deliveryall splitup start
        // Laundry_NewSplitup_start

        // Laundry_NewSplitup_end
        // Handy Splitup End

        //Handy_NewSplitup_End

        //Gofer splitup end
        // Laundry Splitup End
        //Deliveryall_Newsplitup_end
        case delivery
        case businessId = "business_id"
        case seats = "seats"
        case mapImage = "map_image"
        case vehicleName = "vehicle_name"
        case promoAdded = "promo_added"
        case walletSelected = "wallet_selected"
        case yaminiStatus = "yamini_status"
    }
    init(_ json : JSON) {
        self.cancel_warning = json.string("cancel_warning")
        self.imageRequired = json.bool("image_required")
        self.imageUpload = json.bool("image_upload")
        self.id = json.int("id")
        self.is_KM = json.bool("is_km")
        self.name = json.string("name")
        self.image = json.string("image")
        self.jobAtUser = json.bool("job_at_user")
        self.mobileNumber = json.string("mobile_number")
        self.isRequiredOtp = json.bool("is_required_otp")
        self.otp = json.string("otp")
        self.jobID = json.int("job_id")
        self.beginImageCount = json.int("begin_image_count")
        self.endImageCount = json.int("end_image_count")
        self.pickup = json.string("pickup")
        self.drop = json.string("drop")
        self.pickupLat = json.double("pickup_lat")
        self.pickupLng = json.double("pickup_lng")
        self.dropLat = json.double("drop_lat")
        self.dropLng = json.double("drop_lng")
        self.currencyCode = json.string("currency_code")
        self.currencySymbol = json.string("currency_symbol")
        self.totalTime = json.string("total_time")
        self.totalkm = json.string("total_km")
        self.providerPaypalID = json.string("provider_paypal_id")
        self.paypalAppID = json.string("paypal_app_id")
        self.paypalMode = json.string("paypal_mode")
        self.requestID = json.int("request_id")
        self.paymentMode = json.string("payment_mode")
        self.firstDriver = json.string("first_driver")
        let _paymentStatus = json.string("payment_status")
        self.paymentStatus =  TripStatus(rawValue: _paymentStatus) ?? .pending
        self.totalFare = json.string("total_fare")
        self.providerEarnings = json.string("provider_earnings")
        let _bookingtype = json.string("booking_type")
        self.bookingType =  BookingEnum(rawValue: _bookingtype) ?? .auto
        self.isCurrentJob = json.bool("is_current_job")
        self.rating = json.int("rating")
        self.scheduleDisplayDate = json.string("schedule_display_date")
        self.requestedServices = json.array("requested_services").compactMap({RequestedServiceModel($0)})
        self.jobProgress = json.array("job_progress").compactMap({JobProgress($0)})
        self.invoice = json.array("invoice").compactMap({Invoice($0)})
        let _pricetype = json.string("price_type")
        self.priceType =  PriceType(rawValue: _pricetype) ?? .Distance
        let _jobStatus = json.string("job_status")
        self.jobStatus =  TripStatus(rawValue: _jobStatus) ?? .scheduled
        self.jobRating = JobRating(json["job_rating"] as? JSON ?? JSON())
        self.jobImage = JobImage(json["job_image"] as? JSON ?? JSON())
        let _payer = json.string("payer")
        self.payer =  PaymentResponsible(rawValue: _payer) ?? .receiver
        //Gofer splitup start
        // Laundry Splitup Start
        //Instacart splitup start

        //Deliveryall_Newsplitup_start

        //Deliveryall splitup start

        // Handy Splitup Start
        // Laundry_NewSplitup_start

        //Handy_NewSplitup_Start
        // Laundry_NewSplitup_end
        //Handy_NewSplitup_End

        //Deliveryall_Newsplitup_end

        // Handy Splitup End

        
       
        

        //Deliveryall splitup End

        //Gofer splitup end
        // Laundry Splitup End
        //Instacart splitup end
        self.delivery = Delivery(json["delivery"] as? JSON ?? JSON())
        let _type = json.int("business_id")
        self.businessId =  BusinessType(rawValue: _type) ?? .Services
        self.seats = json.string("seats")
        self.mapImage = json.string("map_image")
        self.vehicleName = json.string("vehicle_name")
        self.walletSelected = json.bool("wallet_selected")
        self.promoAdded = json.bool("promo_added")
        self.yaminiStatus = json.string("job_status")
        self.no_of_droppoints = json.int("no_of_droppoints")
        self.wayPoints = json.array("waypoints").compactMap({WayPoint($0)})
        self.requestedToEndTrip = json.bool("request_end_trip")
        self.isMultiTrip = json.bool("is_multitrip")
        self.paymentModeKey = json.string("payment_mode_key")
        self.biddingFlow = json.string("bidding_flow")

    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.cancel_warning = container.safeDecodeValue(forKey: .cancel_warning)
        self.is_KM = container.safeDecodeValue(forKey: .is_KM)
        self.imageUpload = container.safeDecodeValue(forKey: .imageUpload)
        self.imageRequired = container.safeDecodeValue(forKey: .imageRequired)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.image = container.safeDecodeValue(forKey: .image)
        self.mobileNumber = container.safeDecodeValue(forKey: .mobileNumber)
        self.isRequiredOtp = container.safeDecodeValue(forKey: .isRequiredOtp)
        self.otp = container.safeDecodeValue(forKey: .otp)
        self.jobID = container.safeDecodeValue(forKey: .jobID)
        self.beginImageCount = container.safeDecodeValue(forKey: .beginImageCount)
        self.endImageCount = container.safeDecodeValue(forKey: .endImageCount)
        self.pickup = container.safeDecodeValue(forKey: .pickup)
        self.drop = container.safeDecodeValue(forKey: .drop)
        self.pickupLat = container.safeDecodeValue(forKey: .pickupLat)
        self.pickupLng = container.safeDecodeValue(forKey: .pickupLng)
        self.dropLat = container.safeDecodeValue(forKey: .dropLat)
        self.dropLng = container.safeDecodeValue(forKey: .dropLng)
        self.currencyCode = container.safeDecodeValue(forKey: .currencyCode)
        self.currencySymbol = container.safeDecodeValue(forKey: .currencySymbol)
        self.totalTime = container.safeDecodeValue(forKey: .totalTime)
        self.totalkm = container.safeDecodeValue(forKey: .totalkm)
        self.providerPaypalID = container.safeDecodeValue(forKey: .providerPaypalID)
        self.paypalAppID = container.safeDecodeValue(forKey: .paypalAppID)
        self.paypalMode = container.safeDecodeValue(forKey: .paypalMode)
        self.requestID = container.safeDecodeValue(forKey: .requestID)
        self.paymentMode = container.safeDecodeValue(forKey: .paymentMode)
        self.firstDriver = container.safeDecodeValue(forKey: .firstDriver)
        let paymentStatus = try? container.decodeIfPresent(TripStatus.self, forKey: .paymentStatus)
        self.paymentStatus = paymentStatus ?? TripStatus.pending
        self.totalFare = container.safeDecodeValue(forKey: .totalFare)
        self.providerEarnings = container.safeDecodeValue(forKey: .providerEarnings)
        let bookingType = try? container.decodeIfPresent(BookingEnum.self, forKey: .bookingType)
        self.bookingType = bookingType ?? BookingEnum.schedule
        self.isCurrentJob = container.safeDecodeValue(forKey: .isCurrentJob)
        self.rating = container.safeDecodeValue(forKey: .rating)
        self.scheduleDisplayDate = container.safeDecodeValue(forKey: .scheduleDisplayDate)
        let requestedServices = try? container.decodeIfPresent([RequestedServiceModel].self, forKey: .requestedServices)
        self.requestedServices = requestedServices ?? [RequestedServiceModel]()
        let jobProgress = try? container.decodeIfPresent([JobProgress].self, forKey: .jobProgress)
        self.jobProgress = jobProgress ?? [JobProgress]()
        let invoice = try? container.decodeIfPresent([Invoice].self, forKey: .invoice)
        self.invoice = invoice ?? [Invoice]()
        let priceTypee = try? container.decodeIfPresent(PriceType.self, forKey: .priceType)
        self.priceType = priceTypee ?? PriceType.Distance
        let jobStatus = try? container.decodeIfPresent(TripStatus.self, forKey: .jobStatus)
        self.jobStatus = jobStatus ?? TripStatus.scheduled
        let val = try? container.decode(TripStatus.self, forKey: .jobStatus)
              self.jobStatus = val ?? .endTrip
        let jobRating = try container.decodeIfPresent(JobRating.self, forKey: .jobRating)
        self.jobRating = jobRating ?? JobRating(JSON())
        self.jobImage = try container.decodeIfPresent(JobImage.self, forKey: .jobImage)
        let payer = try? container.decode(PaymentResponsible.self, forKey: .payer)
        self.payer = payer ?? PaymentResponsible.receiver
        //Gofer splitup start
        // Laundry Splitup Start
        //Instacart splitup start
        //Deliveryall splitup start

        // Handy Splitup Start
        // Laundry_NewSplitup_start
        //Handy_NewSplitup_Start
         //Handy_NewSplitup_End
        // Laundry_NewSplitup_end
        // Handy Splitup End
        //Deliveryall_Newsplitup_end
       

        //Gofer splitup end
        // Laundry Splitup End
        //Instacart splitup End
        //Deliveryall splitup End
        self.delivery = try container.decodeIfPresent(Delivery.self, forKey: .delivery)
        let businesstype = try? container.decode(BusinessType.self, forKey: .businessId)
        self.businessId = businesstype ?? .Services
        self.jobAtUser = self.businessId == .Delivery ? true : container.safeDecodeValue(forKey: .jobAtUser)
        self.seats = container.safeDecodeValue(forKey: .seats)
        self.mapImage = container.safeDecodeValue(forKey: .mapImage)
        self.vehicleName = container.safeDecodeValue(forKey: .vehicleName)
        self.walletSelected = container.safeDecodeValue(forKey: .walletSelected)
        self.promoAdded = container.safeDecodeValue(forKey: .promoAdded)
        self.yaminiStatus = container.safeDecodeValue(forKey: .jobStatus)
        let points = try? container.decodeIfPresent([WayPoint].self, forKey: .wayPoints)
        self.wayPoints = points ?? [WayPoint]()
        self.requestedToEndTrip = container.safeDecodeValue(forKey: .requestedToEndTrip)
        self.isMultiTrip = container.safeDecodeValue(forKey: .isMultiTrip)
        self.no_of_droppoints = container.safeDecodeValue(forKey: .no_of_droppoints)
        self.paymentModeKey = container.safeDecodeValue(forKey: .paymentModeKey)
        self.biddingFlow = container.safeDecodeValue(forKey: .biddingFlow)

        
    }
    func storeRiderInfo(_ val : Bool){
        let preference = UserDefaults.standard
        if val{
            UserDefaults.set(self.id, for: .rider_user_id)
            preference.set(self.image, forKey: TRIP_RIDER_THUMB_URL)
            preference.set(self.name, forKey: TRIP_RIDER_NAME)
            preference.set(self.rating, forKey: TRIP_RIDER_RATING)
        }else{
            UserDefaults.removeValue(for: .rider_user_id)
            preference.removeObject(forKey: TRIP_RIDER_THUMB_URL)
            preference.removeObject(forKey: TRIP_RIDER_NAME)
            preference.removeObject(forKey: TRIP_RIDER_RATING)
        }
    }
}

// MARK: - JobProgress
class JobProgress: Codable , Equatable {
    static func == (lhs: JobProgress, rhs: JobProgress) -> Bool {
        lhs.jobStatusMsg == rhs.jobStatusMsg &&
        lhs.time == rhs.time &&
        lhs.status == rhs.status
    }
    
    let jobStatusMsg, time: String
    let status: Bool
    enum CodingKeys: String, CodingKey {
        case jobStatusMsg = "job_status_msg"
        case time
        case status
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
       self.jobStatusMsg = container.safeDecodeValue(forKey: .jobStatusMsg)
       self.time = container.safeDecodeValue(forKey: .time)
        self.status = container.safeDecodeValue(forKey: .status)
    }
    init(_ json : JSON){
        self.jobStatusMsg = json.string("job_status_msg")
        self.time = json.string("time")
        self.status = json.bool("status")
    }
}
// MARK: - Invoice
class Invoice: Codable, Equatable{
    
    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        lhs.key == rhs.key &&
        lhs.value == rhs.value &&
        lhs.bar == rhs.bar &&
        lhs.colour == rhs.colour &&
        lhs.comment == rhs.comment
    }
    
    let key, value: String
    let bar: Int
    let colour, comment: String
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
       self.key = container.safeDecodeValue(forKey: .key)
       self.value = container.safeDecodeValue(forKey: .value)
        self.bar = container.safeDecodeValue(forKey: .bar)
        self.colour = container.safeDecodeValue(forKey: .colour)
        self.comment = container.safeDecodeValue(forKey: .comment)
    }
    init(_ json : JSON){
            self.key = json.string("key")
            self.value = json.string("value")
            self.bar = json.int("bar")
            self.colour = json.string("colour")
            self.comment = json.string("comment")
    }
    init(customWithName key : String,value : String, bar : Int, colour : String, comment : String){
        self.key = key
        self.value = value
        self.bar = bar
        self.colour = colour
        self.comment = comment
    }
}

// MARK: - RequestedService
class RequestedServiceModel: Codable , Equatable {
    
    static func == (lhs: RequestedServiceModel, rhs: RequestedServiceModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.quantity == rhs.quantity &&
        lhs.instruction == rhs.instruction &&
        lhs.service_name == rhs.service_name &&
        lhs.category_name == rhs.category_name
    }
    
    let name: String
    let id, quantity: Int
    let instruction,service_name,category_name: String
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
       self.name = container.safeDecodeValue(forKey: .name)
       self.id = container.safeDecodeValue(forKey: .id)
        self.quantity = container.safeDecodeValue(forKey: .quantity)
        self.instruction = container.safeDecodeValue(forKey: .instruction)
        self.service_name = container.safeDecodeValue(forKey: .service_name)
        self.category_name = container.safeDecodeValue(forKey: .category_name)
    }
    init(_ json : JSON){
        self.name = json.string("name")
        self.id = json.int("id")
        self.quantity = json.int("quantity")
        self.instruction = json.string("instruction")
        self.service_name = json.string("service_name")
        self.category_name = json.string("category_name")

       }
}
// MARK: - JobImage
class JobImage: Codable , Equatable {
    static func == (lhs: JobImage, rhs: JobImage) -> Bool {
        lhs.afterImages == rhs.afterImages &&
        lhs.beforeImages == rhs.beforeImages
    }

    
    let beforeImages: [ImageModel]
    let afterImages: [ImageModel]

    enum CodingKeys: String, CodingKey {
        case beforeImages = "before_images"
        case afterImages = "after_images"
    }

    init(_ json : JSON){
        self.beforeImages = json.array("before_images").compactMap({ImageModel($0)})
        self.afterImages = json.array("after_images").compactMap({ImageModel($0)})
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let beforeImg = try? container.decodeIfPresent([ImageModel].self, forKey: .beforeImages)
        self.beforeImages = beforeImg ?? [ImageModel]()
        let afterImg = try? container.decodeIfPresent([ImageModel].self, forKey: .afterImages)
        self.afterImages = afterImg ?? [ImageModel]()    }
}

// MARK: - BeforeImage
class ImageModel: Codable , Equatable {
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.image == rhs.image
    }
    let image: String
    required init(from decoder : Decoder) throws{
          let container = try decoder.container(keyedBy: CodingKeys.self)
         self.image = container.safeDecodeValue(forKey: .image)
      }
    init(_ json : JSON){
                  self.image = json.string("image")
    }
}


// MARK: - JobRating
class JobRating: Codable , Equatable {
    
    static func == (lhs: JobRating, rhs: JobRating) -> Bool {
        lhs.userRating == rhs.userRating &&
        lhs.userComments == rhs.userComments &&
        lhs.providerRating == rhs.providerRating &&
        lhs.providerComments == rhs.providerComments
    }
    
    
    let userRating: Int
    let userComments: String
    let providerRating: Int
    let providerComments: String

    enum CodingKeys: String, CodingKey {
        case userRating = "user_rating"
        case userComments = "user_comments"
        case providerRating = "provider_rating"
        case providerComments = "provider_comments"
    }
    init(_ json : JSON){
        self.userRating = json.int("user_rating")
        self.userComments = json.string("user_comments")
        self.providerRating = json.int("provider_rating")
        self.providerComments = json.string("provider_comments")

    }
   
    required init(from decoder : Decoder) throws{
           let container = try decoder.container(keyedBy: CodingKeys.self)
          self.userRating = container.safeDecodeValue(forKey: .userRating)
          self.userComments = container.safeDecodeValue(forKey: .userComments)
           self.providerRating = container.safeDecodeValue(forKey: .providerRating)
           self.providerComments = container.safeDecodeValue(forKey: .providerComments)
       }
}
//class Support: NSObject {
//    let id : Int
//    let name : String
//    var link : String
//    var image : String
//    override init(){
//        id = 0
//        name = ""
//        link = ""
//        image = ""
//    }
//    init(_ json : JSON){
//        self.id = json.int("id")
//        self.name = json.string("name")
//        self.link = json.string("link")
//        self.image = json.string("image")
//    }
//}

class Support: Codable {
        let id : Int
        let name : String
        var link : String
        var image : String
        var is_numeric : Bool
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case link = "link"
        case image = "image"
        case is_numeric = "is_numeric"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.link = container.safeDecodeValue(forKey: .link)
        self.image = container.safeDecodeValue(forKey: .image)
        self.is_numeric = container.safeDecodeValue(forKey: .is_numeric)
    }
}


class checkVersionModel: Codable {
        let status_code : String
        let status_message : String
        var force_update : String
        var client_id,default_language, default_language_code, default_curreny_code, default_curreny_symbol, default_country_code, default_phone_code, default_country_flag : String
        var apple_login, facebook_login, google_login,is_driver_wallet,otp_enabled, enable_referral:Bool
        var support:[Support]
    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case status_message = "status_message"
        case force_update = "force_update"
        case client_id = "client_id"
        case default_language = "default_language"
        case default_language_code = "default_language_code"
        case default_curreny_code = "default_curreny_code"
        case default_curreny_symbol = "default_curreny_symbol"
        case default_country_code = "default_country_code"
        case default_phone_code = "default_phone_code"
        case default_country_flag = "default_country_flag_url"
        case apple_login = "apple_login"
        case facebook_login = "facebook_login"
        case google_login = "google_login"
        case otp_enabled = "otp_enabled"
        case is_driver_wallet = "is_driver_wallet"
        case support = "support"
        case enable_referral = "enable_referral"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.force_update = container.safeDecodeValue(forKey: .force_update)
        self.client_id = container.safeDecodeValue(forKey: .client_id)
        self.default_language = container.safeDecodeValue(forKey: .default_language)
        self.default_language_code = container.safeDecodeValue(forKey: .default_language_code)
        self.default_curreny_code = container.safeDecodeValue(forKey: .default_curreny_code)
        self.default_curreny_symbol = container.safeDecodeValue(forKey: .default_curreny_symbol)
        self.default_country_code = container.safeDecodeValue(forKey: .default_country_code)
        self.default_phone_code = container.safeDecodeValue(forKey: .default_phone_code)
        self.default_country_flag = container.safeDecodeValue(forKey: .default_country_flag)
        self.apple_login = container.safeDecodeValue(forKey: .apple_login)
        self.facebook_login = container.safeDecodeValue(forKey: .facebook_login)
        self.google_login = container.safeDecodeValue(forKey: .google_login)
        self.otp_enabled = container.safeDecodeValue(forKey: .otp_enabled)
        self.is_driver_wallet = container.safeDecodeValue(forKey: .is_driver_wallet)
        let support_data = try? container.decodeIfPresent([Support].self, forKey: .support)
        self.support = support_data ?? [Support]()
        self.enable_referral = container.safeDecodeValue(forKey: .enable_referral)
    }
}


