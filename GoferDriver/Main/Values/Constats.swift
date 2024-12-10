/**
* Constants.swift
*
* @package GoferDriver
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

typealias GifLoaderValue = (loader:UIView,count : Int)

protocol TimerDelegate { func TimeUpdate(time: String) }

class Shared{
    static let instance = Shared()
    private init(){}
    var isdarkmode = Bool()
//    var language : LanguageContentModel!
    //Laundry splitup start
    var isForCash = Bool()

    //Deliveryall splitup start
    var is_company = Bool()

    //New Delivery splitup Start
    //Handy_NewSplitup_Start

    //New_Delivery_splitup_Start
    // Laundry_NewSplitup_start
    // Laundry_NewSplitup_end
    //New_Delivery_splitup_End

    //Handy_NewSplitup_End
    //Deliveryall splitup End
    //Laundry splitup end
    var isStoreDriver = false
    var currencyConversionRate = 0.0
    var resumeTripHitCount = 0
    var chatVcisActive = false
    var needToShowChatVC = false
    var enabledPayouts = [Payouts]()
    var userProfile : ProfileModel?
    var timerDelegate : TimerDelegate?
    var timerUpdate : String = "" { didSet { timerDelegate?.TimeUpdate(time: self.timerUpdate) } }
    var deliveryTimer : Timer!
    var selectedRequest : Int = 0
    var currButtChar = ""
    var completedWayPoints = [WayPoint]()
    var no_of_stops = ""
    var isMultiTrip = Bool()

//    var AppLanaguage: LanguageContentModel!
    var permissionDenied = false
    var isGovidEnabled : Bool = false
    var isWebPayment : Bool = false
    var singleRequest : Bool = true
    var isCompletedRequest : Bool = false
    var isAcceptedRequest : Bool = false
    var storeName = String()
    var heatMapOn = Bool()
    var is_driver_wallet  = Bool()
    var heatMapBusinessTypes = String()
    var heatMapServiceTypes = String()
    var countryList =  [CountryCodeList]()
    //Referral
    private var enableReferral = Bool()
    var defaultCountryCode :String!
    var phoneCode :String!
    var defaultFlag :String!
    var otpEnabled = false
    var supportArray : [Support]? = nil
    func supportOtpEnabled(otpEnabled: Bool,supportArr : [Support]){
        self.otpEnabled = otpEnabled
        self.supportArray = supportArr
    }
    func enableReferral(_ on : Bool){
        self.enableReferral = on
    }
    func isReferralEnabled() -> Bool{
        return self.enableReferral
    }
    //Extra Fare
    private var enableExtraFare = Bool()
    func enableExtraFare(_ on : Bool){
        self.enableExtraFare = on
    }
    func isExtraFareEnabled() -> Bool{
        return self.enableExtraFare
    }
    //Heat Map
    private var enableHeatMap = Bool()
    func enableHeatMap(_ on : Bool){
        self.enableHeatMap = on
    }
    func isHeatMapEnabled() -> Bool{
        return self.enableHeatMap
    }
    
    fileprivate var gifLoaders : [UIView:GifLoaderValue] = [:]
    func isLoading(in view : UIView? = nil) -> Bool{
        if let _view = view,
            let _ = self.gifLoaders[_view]{
            return true
        }
        if let window = AppDelegate.shared.window,
            let _ = self.gifLoaders[window]{
            return true
        }
        return false
    }
    func getDeviceToken() -> String {
        return isSimulator ? "94c8a93426e12a874c8e9355da737a15db2f4a1da0d9c38de7340e8f66812b34" : Constants().GETVALUE(keyname :USER_DEVICE_TOKEN)
    }
}

class Constants : NSObject
{
    //MARK: When store user dates
    func STOREVALUE(value : String , keyname : String)
    {
        UserDefaults.standard.setValue(value , forKey: keyname as String)
        UserDefaults.standard.synchronize()
    }
    //MARK: Get user dates
    func GETVALUE(keyname : String) -> String
    {
        let value = UserDefaults.standard.value(forKey: keyname)
        if value == nil
        {
            return ""
        }
        return value as? String ?? String()
    }
    
    func jsonToNSData(json: JSON) -> Data?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as Data
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    
    
    static let userDefaults = UserDefaults.standard
    
}
enum PipeLineKey : String{
    case check_splash
    case app_entered_foreground
}



extension UserDefaults {
    
    enum Key : String{
        
        case access_token
        case default_language_option
        
        case first_name
        case last_name
        case user_email_id
        case phonenumber
        case trip_status
        case user_online_status
        case selected_business
        case selected_services
        //casce google_api_key
        
        case user_id
        case vehicle_id
        case sinch_key
        case sinch_secret_key
        
        case trip_travelled_distance
        case trip_offline_distance
        case cache_location_trip_id
        
        case rider_user_id
        case user_enabled_heat_map
        
        case user_currency_symbol_org = "user_currency_symbol_org_splash"
        
        case payment_gateway_type
     
        case payment_method
        case payment_method_icon
        case stripe_publish_key
        case paypal_mode
        case paypal_client_key
        case card_brand_name
        case card_last_4
        case brain_tree_display_name
        case stripe_card
        case direction_hit_count
        
        case current_trip_id
        case current_job_id
        
        case requestID
        // handy
        case provider_online_status
        case provider_trip_status
        case requestTime
        case is_provider_approved

        case PrimaryColor
        case SecondaryColor
        case TertiaryColor
        case IndicatorColor
        case SecondaryTextColor
        case PrimaryTextColor
        case ThemeTextColor
        case InactiveTextColor
        case PromoColor
        case ErrorColor
        case CompletedStatusColor
        case CancelledStatusColor
        case PendingStatusColor
        case PayStatementColor
        case RatingColor
        case DarkBackground
        case DarkTextColor
        
        case InitiatedTheme
        
        // delivery
        
        case eater_user_id
        case eater_user_name
        case eater_image
        case store_user_id
        case store_user_name
        case store_image
    }
    internal static var prefernce : UserDefaults{ return UserDefaults.standard}
 
   
   static func isNull(for key : Key) -> Bool{
        return self.prefernce.value(forKey: key.rawValue) == nil
    }
    /**
     get value?<T> for unique Key from UserDefaults
     - Author: Abishek Robin
     - Parameters:
     - key: unique key for storedValue
     - Returns: optional value for key
     - Note: Generic hander
     */
    static func value<T>(for key : Key) -> T? {
        return self.prefernce.value(forKey: key.rawValue) as? T
    }
    /**
     set value?<T> for unique Key in UserDefaults
     - Author: Abishek Robin
     - Parameters:
     - value: <T> value to be stored
     - key: unique key for storedValue
     - Returns: optional value for key
     - Note: Generic hander
     */
    static func set<T>(_ value : T,for key : Key){
        self.prefernce.set(value, forKey: key.rawValue)
    }
    static func removeValue(for key : Key){
        self.prefernce.removeObject(forKey: key.rawValue)
    }
    static func clearAllKeyValues() {
        
        self.removeValue(for: .access_token)
        self.removeValue(for: .first_name)
        self.removeValue(for: .last_name)
        
        self.removeValue(for: .user_id)
        self.removeValue(for: .sinch_key)
        self.removeValue(for: .sinch_secret_key)
        self.removeValue(for: .brain_tree_display_name)
        self.removeValue(for: .card_last_4)
        self.removeValue(for: .card_brand_name)
        
        self.removeValue(for: .trip_travelled_distance)
        self.removeValue(for: .trip_offline_distance)
        self.removeValue(for: .cache_location_trip_id)
        
        self.removeValue(for: .rider_user_id)
        self.removeValue(for: .user_enabled_heat_map)
        self.removeValue(for: .requestTime)
        self.removeValue(for: .user_currency_symbol_org)
        self.removeValue(for: .default_language_option)
        
    }
}

func debug(print msg: String,file : String = #file,fun : String = #function){
    print("∂:/\(fun)->\(msg) ")
}

extension UIViewController {
    func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            viewController.modalPresentationStyle = .overFullScreen
        } else {
            // Fallback on earlier versions
        }
        
        //    viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: animated, completion: completion)
    }
}
//MARK:- alert
extension Shared{
    func showLoader(in view : UIView){
        guard Shared.instance.gifLoaders[view] == nil else{return}
        let gifValue : GifLoaderValue
        if let existingLoader = self.gifLoaders[view]{
            gifValue = (loader: existingLoader.loader,count: existingLoader.count + 1)
        }else{

            let gif = self.getLoaderGif(forFrame: view.bounds)
            view.addSubview(gif)
            gif.frame = view.frame
            gif.center = view.center
            gifValue = (loader: gif,count: 1)
        }
        Shared.instance.gifLoaders[view] = gifValue
    }
    func removeLoader(in view : UIView){
        
        guard let existingLoader = self.gifLoaders[view] else{
            return
        }
        let newCount = existingLoader.count - 1
        if newCount == 0{
            Shared.instance.gifLoaders[view]?.loader.removeFromSuperview()
            Shared.instance.gifLoaders.removeValue(forKey: view)
        }else{
            Shared.instance.gifLoaders[view] = (loader: existingLoader.loader,
                                                count: newCount)
        }
    }
    func getLoaderGif(forFrame parentFrame: CGRect) -> UIView{
        let jeremyGif = UIImage.gifImageWithName("loader")
        let view = UIView()
        view.backgroundColor = UIColor.PrimaryColor.withAlphaComponent(0.05)
        view.frame = parentFrame
        let imageView = UIImageView(image: jeremyGif)
        imageView.tintColor = .PrimaryColor
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.center = view.center
        
        view.addSubview(imageView)
        view.tag = 2596
        return view
    }
    func showLoaderInWindow(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelegate.window{
            self.showLoader(in: window)
        }
    }
    func removeLoaderInWindow(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelegate.window{
            self.removeLoader(in: window)
        }
    }
}
