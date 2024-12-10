/**
 * LoginModel.swift
 *
 * @package UberDiver
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 *  
 * @link http://trioangle.com
 */



import Foundation
import UIKit

class LoginModel : Codable {
    let status_message,status_code,access_token,first_name,last_name,mobile_number , email_id, user_status,user_thumb_image,user_id , insurance, license_back, license_front, permit, rc, vehicle_id, vehicle_type, paypal_email_id, company_name, company_id, provider_status, country_code,status, gender,selected_business_id,profile_image,address_line1, address_line2,city, state, postal_code, currency_code, currency_symbol, owe_amount, provider_referral_earning, service_description, pending_jobs_count, completed_jobs_count, vehicle_number: String
    var user_name:String
    let car_details:[CarDetailModel]
    var carType,carId:String

    enum CodingKeys: String, CodingKey {
        case status_message = "status_message"
        case status_code = "status_code"
        case access_token = "access_token"
        case first_name = "first_name"
        case last_name = "last_name"
        case mobile_number = "mobile_number"
        case provider_status = "provider_status"
        case country_code = "country_code"
        case email_id = "email_id"
        case status = "status"
        case gender = "gender"
        case selected_business_id = "selected_business_id"
        case profile_image = "profile_image"
        case address_line1 = "address_line1"
        case address_line2 = "address_line2"
        case city = "city"
        case state = "state"
        case postal_code = "postal_code"
        case currency_code = "currency_code"
        case currency_symbol = "currency_symbol"
        case company_id = "company_id"
        case company_name = "company_name"
        case owe_amount = "owe_amount"
        case provider_referral_earning = "provider_referral_earning"
        case service_description = "service_description"
        case pending_jobs_count = "pending_jobs_count"
        case completed_jobs_count = "completed_jobs_count"
        case vehicle_number = "vehicle_number"
        case user_status = "user_status"
        case user_thumb_image = "user_thumb_image"
        case user_id = "user_id"
        case insurance = "insurance"
        case license_back = "license_back"
        case license_front = "license_front"
        case permit = "permit"
        case rc = "rc"
        case vehicle_id = "vehicle_id"
        case vehicle_type = "vehicle_type"
        case paypal_email_id = "payout_id"
        case car_details = "car_details"
        case carType = "carType"
        case carId = "carId"

    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.access_token = container.safeDecodeValue(forKey: .access_token)
        self.first_name = container.safeDecodeValue(forKey: .first_name)
        self.last_name = container.safeDecodeValue(forKey: .last_name)
        self.mobile_number = container.safeDecodeValue(forKey: .mobile_number)
        self.provider_status = container.safeDecodeValue(forKey: .provider_status)
        self.country_code = container.safeDecodeValue(forKey: .country_code)
        self.email_id = container.safeDecodeValue(forKey: .email_id)
        self.status = container.safeDecodeValue(forKey: .status)
        self.gender = container.safeDecodeValue(forKey: .gender)
        self.selected_business_id = container.safeDecodeValue(forKey: .selected_business_id)
        self.profile_image = container.safeDecodeValue(forKey: .profile_image)
        self.address_line1 = container.safeDecodeValue(forKey: .address_line1)
        self.address_line2 = container.safeDecodeValue(forKey: .address_line2)
        self.city = container.safeDecodeValue(forKey: .city)
        self.state = container.safeDecodeValue(forKey: .state)
        self.postal_code = container.safeDecodeValue(forKey: .postal_code)
        self.currency_code = container.safeDecodeValue(forKey: .currency_code)
        self.currency_symbol = container.safeDecodeValue(forKey: .currency_symbol)
        self.company_name = container.safeDecodeValue(forKey: .company_name)
        self.owe_amount = container.safeDecodeValue(forKey: .owe_amount)
        self.provider_referral_earning = container.safeDecodeValue(forKey: .provider_referral_earning)
        self.service_description = container.safeDecodeValue(forKey: .service_description)
        self.pending_jobs_count = container.safeDecodeValue(forKey: .pending_jobs_count)
        self.completed_jobs_count = container.safeDecodeValue(forKey: .completed_jobs_count)
        self.vehicle_number = container.safeDecodeValue(forKey: .vehicle_number)
        self.user_status = container.safeDecodeValue(forKey: .user_status)
        self.user_thumb_image = container.safeDecodeValue(forKey: .user_thumb_image)
        self.user_id = container.safeDecodeValue(forKey: .user_id)
        self.insurance = container.safeDecodeValue(forKey: .insurance)
        self.license_back = container.safeDecodeValue(forKey: .license_back)
        self.license_front = container.safeDecodeValue(forKey: .license_front)
        self.permit = container.safeDecodeValue(forKey: .permit)
        self.rc = container.safeDecodeValue(forKey: .rc)
        self.vehicle_id = container.safeDecodeValue(forKey: .vehicle_id)
        self.vehicle_type = container.safeDecodeValue(forKey: .vehicle_type)
        self.paypal_email_id = container.safeDecodeValue(forKey: .paypal_email_id)
        self.company_id = container.safeDecodeValue(forKey: .company_id)
        self.carType = container.safeDecodeValue(forKey: .carType)
        self.carId = container.safeDecodeValue(forKey: .carId)
        let cardetails = try? container.decodeIfPresent([CarDetailModel].self, forKey: .car_details)
        self.car_details = cardetails ?? [CarDetailModel]()
        
        self.user_name = String(format:"%@ %@",self.first_name , self.last_name)
        Constants().STOREVALUE(value: "Offline", keyname: USER_ONLINE_STATUS) // its used for driver online/offline switch
        Constants().STOREVALUE(value: "Offline", keyname: TRIP_STATUS)
        
        let userDefaults = UserDefaults.standard
        for i in 0 ..< self.car_details.count
        {
            let model = self.car_details[i] as! CarDetailModel
            if i == 0
            {
                carType = model.car_name
                carId = model.car_id
            }
            else if i == self.car_details.count-1
            {
                carType = String(format: "%@,%@",carType ,model.car_name)
                carId = String(format: "%@,%@",carId ,model.car_id)
            }
            else
            {
                carType = String(format: "%@,%@",carType, model.car_name)
                carId = String(format: "%@,%@",carId, model.car_id)
            }
        }
        
        
        
        
        
        userDefaults.set(carType, forKey: USER_CAR_TYPE)
        userDefaults.set(carId, forKey: USER_CAR_IDS)
        
        Constants().STOREVALUE(value: self.user_status, keyname: USER_STATUS)
        Constants().STOREVALUE(value: self.access_token, keyname: USER_ACCESS_TOKEN)
        Constants().STOREVALUE(value: self.user_name, keyname: USER_FULL_NAME)
        Constants().STOREVALUE(value: self.first_name, keyname: USER_FIRST_NAME)
        Constants().STOREVALUE(value: self.last_name, keyname: USER_LAST_NAME)
        Constants().STOREVALUE(value: self.user_thumb_image, keyname: USER_IMAGE_THUMB)
        Constants().STOREVALUE(value: self.user_id, keyname: USER_ID)
        Constants().STOREVALUE(value: self.email_id, keyname: USER_EMAIL_ID)
        Constants().STOREVALUE(value: self.vehicle_id, keyname: USER_CAR_ID)
        if company_id != "0" && company_id != "1" || company_id == ""{
            userDefaults.set(true, forKey: IS_COMPANY_DRIVER)
        }else {
            userDefaults.set(false, forKey: IS_COMPANY_DRIVER)
        }
    }
}






//class LoginModel : NSObject {
//
//    //MARK Properties
//    var status_message : String = ""
//    var status_code : String = ""
//    var access_token : String = ""
//    var first_name : String = ""
//    var last_name : String = ""
//    var mobile_number : String = ""
//    var Payment_method : String = ""
//    var email_id : String = ""
//    var home_location_name : String = ""
//    var work_location_name : String = ""
//    var user_status : String = ""
//    var user_thumb_image : String = ""
//    var user_id : String = ""
//    var user_name : String = ""
//
//    var insurance : String = ""
//    var license_back : String = ""
//    var license_front : String = ""
//    var permit : String = ""
//    var rc : String = ""
//    var vehicle_id : String = ""
//    var vehicle_number : String = ""
//    var vehicle_type : String = ""
//    var paypal_email_id : String = ""
//
//    var car_details : NSMutableArray = NSMutableArray()
//    var company_name = String()
//    var company_id = String()
//    override init(){
//        super.init()
//    }
//    init(_ json : JSON){
//        super.init()
//        self.status_message = json.status_message
//        self.status_code = json["status_code"] as? String ?? String()
//        var carType = ""
//        var carId = ""
//
//
//
//                self.car_details = NSMutableArray()
//        let carDataArray = json.array("car_details")
//        for carData in carDataArray{
//             self.car_details.addObjects(from: (
//                [
//                    CarDetailModel()
//                        .initCarDetails(responseDict: carData as NSDictionary)
//                ]
//                )
//            )
//        }
//
//
//            self.access_token = json["access_token"] as? String ?? String()
//            self.first_name = json.string("first_name")
//            self.last_name = json.string("last_name")
//            self.mobile_number = json.string("mobile_number")
//            self.email_id = json.string("email_id")
//            self.home_location_name = json.string("home_location_name")
//            self.work_location_name = json.string("work_location_name")
//            self.user_status = json.string("user_status")
//            DriverStatus.getStatus(forString: self.user_status).storeInPreference()
//            self.user_name = String(format:"%@ %@",self.first_name , self.last_name)
//
//            self.user_thumb_image = json.string("user_thumb_image")
//            self.email_id = json.string("email_id")
//            self.user_id = json.string("user_id")
//            self.vehicle_id = json.string("vehicle_id")
//
//            self.insurance = json.string("insurance")
//            self.license_back = json.string("license_back")
//            self.license_front = json.string("license_front")
//            self.permit = json.string("permit")
//            self.rc = json.string("rc")
//            self.vehicle_id = json.string("vehicle_id")
//            self.vehicle_number = json.string("vehicle_number")
//            self.vehicle_type = json.string("vehicle_type")
//            self.paypal_email_id = json.string("payout_id")
//            self.company_id = json.string("company_id")
//            self.company_name = json.string("company_name")
//
//
//
//            Constants().STOREVALUE(value: "Offline", keyname: USER_ONLINE_STATUS) // its used for driver online/offline switch
//            Constants().STOREVALUE(value: "Offline", keyname: TRIP_STATUS)
//
//            let userDefaults = UserDefaults.standard
//            for i in 0 ..< self.car_details.count
//            {
//                let model = self.car_details[i] as! CarDetailModel
//                if i == 0
//                {
//                    carType = model.car_name
//                    carId = model.car_id
//                }
//                else if i == self.car_details.count-1
//                {
//                    carType = String(format: "%@,%@",carType ,model.car_name)
//                    carId = String(format: "%@,%@",carId ,model.car_id)
//                }
//                else
//                {
//                    carType = String(format: "%@,%@",carType, model.car_name)
//                    carId = String(format: "%@,%@",carId, model.car_id)
//                }
//            }
//
//            userDefaults.set(carType, forKey: USER_CAR_TYPE)
//            userDefaults.set(carId, forKey: USER_CAR_IDS)
//
//            Constants().STOREVALUE(value: self.user_status, keyname: USER_STATUS)
//            Constants().STOREVALUE(value: self.access_token, keyname: USER_ACCESS_TOKEN)
//            Constants().STOREVALUE(value: self.user_name, keyname: USER_FULL_NAME)
//            Constants().STOREVALUE(value: self.first_name, keyname: USER_FIRST_NAME)
//            Constants().STOREVALUE(value: self.last_name, keyname: USER_LAST_NAME)
//            Constants().STOREVALUE(value: self.user_thumb_image, keyname: USER_IMAGE_THUMB)
//            Constants().STOREVALUE(value: self.user_id, keyname: USER_ID)
//            Constants().STOREVALUE(value: self.email_id, keyname: USER_EMAIL_ID)
//            Constants().STOREVALUE(value: self.vehicle_id, keyname: USER_CAR_ID)
//        if company_id != "0" && company_id != "1" || company_id == ""{
//                userDefaults.set(true, forKey: IS_COMPANY_DRIVER)
//            }else {
//                userDefaults.set(false, forKey: IS_COMPANY_DRIVER)
//            }
//
//    }
//    func makeCurrencySymbols(encodedString : String) -> String
//    {
//        let encodedData = encodedString.stringByDecodingHTMLEntities
//        return encodedData
//    }
//}
//
class CarDetailModel : Codable
{
    let base_fare, capacity, car_name, car_description, car_id, min_fare, per_km, per_min, status : String

    enum CodingKeys: String, CodingKey {
        case base_fare = "base_fare"
        case capacity = "capacity"
        case car_name = "car_name"
        case car_description = "description"
        case car_id = "id"
        case min_fare = "min_fare"
        case per_km = "per_km"
        case per_min = "per_min"
        case status = "status"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.base_fare = container.safeDecodeValue(forKey: .base_fare)
        self.capacity = container.safeDecodeValue(forKey: .capacity)
        self.car_name = container.safeDecodeValue(forKey: .car_name)
        self.car_description = container.safeDecodeValue(forKey: .car_description)
        self.car_id = container.safeDecodeValue(forKey: .car_id)
        self.min_fare = container.safeDecodeValue(forKey: .min_fare)
        self.per_km = container.safeDecodeValue(forKey: .per_km)
        self.per_min = container.safeDecodeValue(forKey: .per_min)
        self.status = container.safeDecodeValue(forKey: .status)
    }
    
    
    //MARK Properties
//    var base_fare : String = ""
//    var capacity : String = ""
//    var car_name : String = ""
//    var car_description : String = ""
//    var car_id : String = ""
//    var min_fare : String = ""
//    var per_km : String = ""
//    var per_min : String = ""
//    var status : String = ""
//
//    //MARK: Inits
//    func initCarDetails(responseDict: NSDictionary) -> Any
//    {
//        let json = responseDict as! JSON
//
//        base_fare = json.string("base_fare")
//        capacity = json.string("capacity")
//        car_name = json.string("car_name")
//        car_description = json.string("description")
//        car_id = json.string("id")
//        min_fare = json.string("min_fare")
//        per_km = json.string("per_km")
//        per_min = json.string("per_min")
//        status = json.string("status")
//        return self
//    }

}
