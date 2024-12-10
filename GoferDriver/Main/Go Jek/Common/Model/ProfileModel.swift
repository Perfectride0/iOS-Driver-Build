/**
* ProfileModel.swift
*
* @package UberDiver
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/


import Foundation
import UIKit

// MARK: - ProfileModel


class ProfileModel : Codable {
    
    //MARK Properties
    var status_message : String = ""
    var status_code : String = ""
    var driverStatus : Int = 0
    var is_minimum_balance: Bool = false
    var home_alert : String = ""
    var address_line1 : String = ""
    var address_line2 : String = ""
    var city : String = ""
    var country_code : String = ""
    var email_id : String = ""
    var car_id : String = ""
    var first_name : String = ""
    var insurance : String = ""
    var last_name : String = ""
    var license_back : String = ""
    var license_front : String = ""
    var mobile_number : String = ""
    var is_km : Bool = false
    var permit : String = ""
    var postal_code : String = ""
    var user_thumb_image : String = ""
    var rc : String = ""
    var state : String = ""
    var user_name : String = ""
    var vehicle_no : String = ""
    var isstoreDriver : String = ""
    var vehicle_name : String = ""
    var car_type :String = ""
    var currency_code : String = ""
    var currency_symbol : String = ""
//    var customer_support : String = ""
    var car_image : String = ""
    var car_active_image : String = ""
    var driverDocuments : [DynamicDocumentModel]
    var vehicles  : [DynamicVehicleModel]
    var company_id : String
    var company_name : String
    var bankDetails: BankDetails?
//    var owe_amount: String = ""
    var gender : String = ""
    var providerStatus:String
    var provider_status: DriverTripStatus = .Offline
    var pending_jobs_count: Int = 0
    var completed_jobs_count: Int = 0
    var serviceDesc : String = ""
    var providerLocation: ProviderLocationModel?
    var checkedAvailability : Bool = false
    var isProviderApproved : Bool = false
    var checkedServices : Bool = false
    var services : [GojekService] = []
    var vehicleID:String
    var getUserName:String
    var userLocaitonIsAvailable: Bool = false
    var isCompanyDriver:Bool
    var activeVehicle:DynamicVehicleModel?
    var current_rate: Double
    
    enum CodingKeys: String, CodingKey {
        case car_active_image = "car_active_image"
        case company_name = "company_name"
//        case owe_amount = "owe_amount"
        case gender = "gender"
        case serviceDesc = "service_description"
        case driverDocuments = "documents"
        case vehicles = "vehicles_details"
        case providerLocation = "location"
        case bankDetails = "bank_details"
        case company_id = "company_id"
        case pending_jobs_count = "pending_jobs_count"
        case completed_jobs_count = "completed_jobs_count"
        case providerStatus = "provider_status"
        case checkedAvailability = "checked_availability"
        case checkedServices = "checked_service"
        case services = "service"
        case vehicle_no = "vehicle_number"
        case isstoreDriver = "store_driver"
        case vehicle_name = "vehicle_name"
        case car_type = "car_type"
        case currency_code = "currency_code"
        case currency_symbol = "currency_symbol"
//        case customer_support = "customer_support"
        case car_image = "car_image"
        case license_front = "license_front"
        case mobile_number = "mobile_number"
        case is_km = "is_km"
        case permit = "permit"
        case postal_code = "postal_code"
        case user_thumb_image = "profile_image"
        case rc = "rc"
        case state = "state"
        case status_message = "status_message"
        case status_code = "status_code"
        case address_line1 = "address_line1"
        case address_line2 = "address_line2"
        case city = "city"
        case country_code = "country_code"
        case email_id = "email_id"
        case car_id = "car_id"
        case first_name = "first_name"
        case insurance = "insurance"
        case last_name = "last_name"
        case license_back = "license_back"
        case driverStatus = "status"
        case is_minimum_balance = "is_minimum_balance"
        case home_alert = "home_alert"
        case isProviderApproved
        case user_name
        case getUserName
        case activeVehicle
        case vehicleID = "vehicle_id"
        case current_rate = "currency_rate"

    }

    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.driverStatus = container.safeDecodeValue(forKey: .driverStatus)
        self.is_minimum_balance = container.safeDecodeValue(forKey: .is_minimum_balance)
        self.home_alert = container.safeDecodeValue(forKey: .home_alert)
        self.first_name = container.safeDecodeValue(forKey: .first_name)
        self.last_name = container.safeDecodeValue(forKey: .last_name)
        self.user_name =  String(format:"%@ %@",self.first_name,self.last_name)
        self.user_thumb_image = container.safeDecodeValue(forKey: .user_thumb_image)
        self.email_id =  container.safeDecodeValue(forKey: .email_id)
        self.car_id =  container.safeDecodeValue(forKey: .car_id)
        self.currency_code =  container.safeDecodeValue(forKey: .currency_code)
        self.currency_symbol =  container.safeDecodeValue(forKey: .currency_symbol)
        self.mobile_number =  container.safeDecodeValue(forKey: .mobile_number)
        self.is_km =  container.safeDecodeValue(forKey: .is_km)
        self.address_line1 = container.safeDecodeValue(forKey: .address_line1)
        self.address_line2 = container.safeDecodeValue(forKey: .address_line2)
        self.city = container.safeDecodeValue(forKey: .city)
        self.state = container.safeDecodeValue(forKey: .state)
        self.serviceDesc = container.safeDecodeValue(forKey: .serviceDesc)
        self.postal_code = container.safeDecodeValue(forKey: .postal_code)
        self.vehicle_no = container.safeDecodeValue(forKey: .vehicle_no)
        Shared.instance.isStoreDriver = container.safeDecodeValue(forKey: .isstoreDriver)
        self.car_type = container.safeDecodeValue(forKey: .car_type)
        self.vehicle_name = container.safeDecodeValue(forKey: .vehicle_name)
        self.insurance = container.safeDecodeValue(forKey: .insurance)
        self.license_back = container.safeDecodeValue(forKey: .license_back)
        self.license_front = container.safeDecodeValue(forKey: .license_front)
        self.permit = container.safeDecodeValue(forKey: .permit)
        self.car_image = container.safeDecodeValue(forKey: .car_image)
        self.car_active_image = container.safeDecodeValue(forKey: .car_active_image)
        self.rc = container.safeDecodeValue(forKey: .rc)
        self.vehicleID = container.safeDecodeValue(forKey: .vehicleID)
        self.checkedAvailability = container.safeDecodeValue(forKey: .checkedAvailability)
        self.checkedServices = container.safeDecodeValue(forKey: .checkedServices)
        self.isProviderApproved = self.driverStatus == 1 ? true : false
        UserDefaults.set(self.vehicleID, for: .vehicle_id)
        self.bankDetails = try? container.decodeIfPresent(BankDetails.self, forKey: .bankDetails)
        self.company_name = container.safeDecodeValue(forKey: .company_name)
        self.company_id = container.safeDecodeValue(forKey: .company_id)
        self.country_code = container.safeDecodeValue(forKey: .country_code)
        self.gender = container.safeDecodeValue(forKey: .gender)
        self.providerStatus = container.safeDecodeValue(forKey: .providerStatus)
        
        
        
        let userDefaults = UserDefaults.standard
        if self.company_id != "0" && self.company_id != "1" {
            userDefaults.set(true, forKey: IS_COMPANY_DRIVER)
        }else {
            userDefaults.set(false, forKey: IS_COMPANY_DRIVER)
        }
        
        let veh_Doc = try? container.decodeIfPresent([DynamicVehicleModel].self, forKey: .vehicles)
        self.vehicles = veh_Doc ?? [DynamicVehicleModel]()
        
        let driver_Doc = try? container.decodeIfPresent([DynamicDocumentModel].self, forKey: .driverDocuments)
        self.driverDocuments = driver_Doc ?? [DynamicDocumentModel]()
        
        
        // handy
        self.provider_status = DriverTripStatus.init(rawValue: self.providerStatus) ?? .Offline
        self.pending_jobs_count = container.safeDecodeValue(forKey: .pending_jobs_count)
        self.completed_jobs_count = container.safeDecodeValue(forKey: .completed_jobs_count)
        //
        self.providerLocation = try? container.decodeIfPresent(ProviderLocationModel.self, forKey: .providerLocation)
        let services = try? container.decodeIfPresent([GojekService].self, forKey: .services)
        self.services = services ?? [GojekService]()
        
        if !self.user_name.isEmpty {
            self.getUserName = self.user_name
        } else {
            self.getUserName =  self.first_name + " " + self.last_name
        }
        self.userLocaitonIsAvailable = !(self.providerLocation?.address.isEmpty ?? false)
        self.activeVehicle = self.vehicles.filter({$0.isCurrentOrDefault}).first //?? self.vehicles.first
        self.isCompanyDriver = (self.company_id == "1" || self.company_id == "0") ? false : true
        self.current_rate = try container.safeDecodeValue(forKey: .current_rate)
        
    }
    
    func makeCurrencySymbols(encodedString : String) -> String{
        let encodedData = encodedString.stringByDecodingHTMLEntities
        return encodedData
    }
}


class ProviderLocationModel : Codable
{
   let providerLocLatitude, providerLocLongitude, spec_providerLocLatitude, spec_providerLocLongitude:Double
   let work_radius, service_at_mylocation, is_specified:Int
     let address, flat_no, nick_name, land_mark, spec_address:String

    enum CodingKeys: String, CodingKey {
        case providerLocLatitude = "latitude"
        case providerLocLongitude = "longitude"
        case spec_providerLocLatitude = "spec_latitude"
        case spec_providerLocLongitude = "spec_longitude"
        case spec_address = "spec_address"
        case work_radius = "work_radius"
        case service_at_mylocation = "service_at_mylocation"
        case is_specified = "is_specified"
        case address = "address"
        case flat_no = "flat_no"
        case nick_name = "nick_name"
        case land_mark = "land_mark"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.providerLocLatitude = container.safeDecodeValue(forKey: .providerLocLatitude)
        self.providerLocLongitude = container.safeDecodeValue(forKey: .providerLocLongitude)
        self.spec_providerLocLatitude = container.safeDecodeValue(forKey: .spec_providerLocLatitude)
        self.spec_providerLocLongitude = container.safeDecodeValue(forKey: .spec_providerLocLongitude)
        self.spec_address = container.safeDecodeValue(forKey: .spec_address)
        self.work_radius = container.safeDecodeValue(forKey: .work_radius)
        self.service_at_mylocation = container.safeDecodeValue(forKey: .service_at_mylocation)
        self.is_specified = container.safeDecodeValue(forKey: .is_specified)
        self.address = container.safeDecodeValue(forKey: .address)
        self.flat_no = container.safeDecodeValue(forKey: .flat_no)
        self.nick_name = container.safeDecodeValue(forKey: .nick_name)
        self.land_mark = container.safeDecodeValue(forKey: .land_mark)
    }
}


//class BankDetails {
//    var id = Int()
//    var user_id = Int()
//    var holder_name = String()
//    var account_number = String()
//    var bank_name = String()
//    var bank_location = String()
//    var code = String()
//    var created_at = String()
//    var updated_at = String()
//    init() {
//    }
//    init(json:JSON) {
//        self.id = json.int("id")
//        self.user_id = json.int("user_id")
//        self.holder_name = json.string("holder_name")
//        self.account_number = json.string("account_number")
//        self.bank_name = json.string("bank_name")
//        self.bank_location = json.string("bank_location")
//        self.code = json.string("code")
//        self.created_at = json.string("created_at")
//        self.updated_at = json.string("updated_at")
//
//    }
//    init(from payout: PayoutItemModel){
//        self.id = payout.id
//        self.user_id = payout.id
//        self.holder_name = payout.payoutData?.holderName ?? ""
//        self.account_number = payout.payoutData?.accountNumber ?? ""
//        self.bank_name = payout.payoutData?.bankName ?? ""
//        self.bank_location = payout.payoutData?.bankLocation ?? ""
//        self.code = payout.payoutData?.branchCode ?? ""
//        self.created_at = ""
//        self.updated_at = ""
//    }
//}

class BankDetails : Codable
{
     let id, user_id:Int
     let holder_name, account_number, bank_name, bank_location, code, created_at, updated_at:String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user_id = "user_id"
        case holder_name = "holder_name"
        case account_number = "account_number"
        case bank_name = "bank_name"
        case bank_location = "bank_location"
        case code = "code"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.user_id = container.safeDecodeValue(forKey: .user_id)
        self.holder_name = container.safeDecodeValue(forKey: .holder_name)
        self.account_number = container.safeDecodeValue(forKey: .account_number)
        self.bank_name = container.safeDecodeValue(forKey: .bank_name)
        self.bank_location = container.safeDecodeValue(forKey: .bank_location)
        self.code = container.safeDecodeValue(forKey: .code)
        self.created_at = container.safeDecodeValue(forKey: .created_at)
        self.updated_at = container.safeDecodeValue(forKey: .updated_at)
    }
    
    init(from payout: PayoutItemModel){
           self.id = payout.id
           self.user_id = payout.id
           self.holder_name = payout.payoutData?.holderName ?? ""
           self.account_number = payout.payoutData?.accountNumber ?? ""
           self.bank_name = payout.payoutData?.bankName ?? ""
           self.bank_location = payout.payoutData?.bankLocation ?? ""
           self.code = payout.payoutData?.branchCode ?? ""
           self.created_at = ""
           self.updated_at = ""
       }
}
