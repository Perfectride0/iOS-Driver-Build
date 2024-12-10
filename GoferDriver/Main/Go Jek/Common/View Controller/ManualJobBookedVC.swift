//
//  ManualJobBookedVC.swift
//  GoferHandyProvider
//
//  Created by trioangle on 05/05/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class ManualJobBookedVC: BaseVC {
    
    // Outlets
    @IBOutlet var manualJobBookedView: ManualJobBookedView!
    // Handy Splitup Start
    var businessType : BusinessType = .Services
    // Handy Splitup End
    // Local Variales
    var requestJob : ManualRequestJobModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    class func initWithStory(forRequest req : ManualRequestJobModel,
                             businessType : BusinessType // Handy Splitup Start
    ) -> ManualJobBookedVC {
        
        let vc : ManualJobBookedVC = UIStoryboard.gojekCommon.instantiateViewController()
        // Handy Splitup Start
        vc.businessType = businessType
        // Handy Splitup End
        vc.modalPresentationStyle = .overCurrentContext
        vc.requestJob = req
        return vc
    }
    
}
//class ManualRequestJobModel {
//    var tripStatus : TripStatus = .manuallyBooked
//    var jobID = Int()
//    var requestID = Int()
//    var date = String()
//    var time = String()
//    var message = String()
//    var pickUpAddress = String()
//    var userName = String()
//    var userCountryCode = String()
//    var userPhoneNo = String()
//    var serviceName = String()
//    var serviceIcon = String()
//    var isManualBooking = Bool()
//
//    init(_ json : JSON){
//        self.serviceName = json.string("service_name")
//        self.serviceIcon = json.string("service_icon")
//        self.date = json.string("date")
//        self.time = json.string("time")
//        self.message = json.string("mesage")
//        self.userPhoneNo = json.string("user_mobile_number")
//        self.userCountryCode = json.string("user_country_code")
//        self.pickUpAddress = json.string("pickup_location")
//        self.userName = json.string("user_name")
//        self.jobID = json.int("job_id")
//        self.requestID = json.int("request_id")
//        self.isManualBooking = json.string("booking_type") == "manual_booking"
//    }
//
//    lazy var displayTime : String = {
//        return self.date + " - " + self.time
//    }()
//    lazy var displayNumber : String = {
//        return self.userCountryCode + " - " + self.userPhoneNo
//    }()
//}

class ManualRequestJobModel : Codable {
    var tripStatus : TripStatus = .manuallyBooked
    let serviceName: String
    let serviceIcon: String
    var date, time, message,pickUpAddress, userName, userCountryCode, userPhoneNo : String
    let requestID, jobID:Int
    var displayTime, displayNumber, booking_type: String
    var isManualBooking : Bool
    
    
    enum CodingKeys: String, CodingKey {
        case serviceName = "service_name"
        case serviceIcon = "serviceIcon"
        case date = "date"
        case time = "time"
        case message = "message"
        case pickUpAddress = "pickup_location"
        case userName = "user_name"
        case userCountryCode = "user_country_code"
        case userPhoneNo = "user_mobile_number"
        case requestID = "request_id"
        case jobID = "job_id"
        case booking_type = "booking_type"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.serviceName = container.safeDecodeValue(forKey: .serviceName)
        self.serviceIcon = container.safeDecodeValue(forKey: .serviceIcon)
        self.date = container.safeDecodeValue(forKey: .date)
        self.time = container.safeDecodeValue(forKey: .time)
        self.message = container.safeDecodeValue(forKey: .message)
        self.pickUpAddress = container.safeDecodeValue(forKey: .pickUpAddress)
        self.userName = container.safeDecodeValue(forKey: .userName)
        self.userCountryCode = container.safeDecodeValue(forKey: .userCountryCode)
        self.userPhoneNo = container.safeDecodeValue(forKey: .userPhoneNo)
        self.requestID = container.safeDecodeValue(forKey: .requestID)
        self.jobID = container.safeDecodeValue(forKey: .jobID)
        self.displayTime = self.date + " - " + self.time
        self.displayNumber = self.userCountryCode + " - " + self.userPhoneNo
        self.booking_type = container.safeDecodeValue(forKey: .booking_type)
        self.isManualBooking = (self.booking_type == "manual_booking") ? true : false
    }
    
        init(_ json : JSON){
            self.serviceName = json.string("service_name")
            self.serviceIcon = json.string("service_icon")
            self.date = json.string("date")
            self.time = json.string("time")
            self.message = json.string("mesage")
            self.pickUpAddress = json.string("pickup_location")
            self.userName = json.string("user_name")
            self.userPhoneNo = json.string("user_mobile_number")
            self.userCountryCode = json.string("user_country_code")
            self.jobID = json.int("job_id")
            self.requestID = json.int("request_id")
            self.booking_type = json.string("booking_type")
            self.isManualBooking = self.booking_type == "manual_booking" ? true : false
            self.userCountryCode = json.string("user_country_code")
            self.displayTime = self.date + " - " + self.time
            self.displayNumber = self.userCountryCode + " - " + self.userPhoneNo
        }
}


