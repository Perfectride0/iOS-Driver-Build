//
//  Global Variables.swift
//  Goferjek Driver
//
//  Created by Trioangle on 13/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Dynamic Language
/**
 Global_Language is a Global Variable.
 - note : Global_Language is our project's whole Language Model Value
 */
private var Global_Language : LanguageContentModel?
/**
 LangCommon is a Global Variable.
 - note : LangCommon is sub model get from the LanguageContentModel. It's holds the value of of Common Model
 */
var LangCommon: Common { get { return Global_Language?.common ?? Common() } }

var LangLaundry: Laundry { get { return Global_Language?.laundry ?? Laundry() } }

/**
 LangHandy is a Global Variable.
 - note : LangHandy is sub model get from the LanguageContentModel. It's holds the value of of Handy Model
 */
var LangHandy : Handyman { get { return Global_Language?.handyman ?? Handyman() } }
/**
 LangDelivery is a Global Variable.
 - note : LangDelivery is sub model get from the LanguageContentModel. It's holds the value of of Delivery Model
 */
var LangDelivery : DeliveryLang { get { return Global_Language?.delivery ?? DeliveryLang() } }
/**
 LangDeliveryAll is a Global Variable.
 - note : LangDeliveryAll is sub model get from the LanguageContentModel. It's holds the value of of GoferDeliveryAll Model
 */
var LangDeliveryAll : goferdeliveryall { get { return Global_Language?.goferDeliveryAll ?? goferdeliveryall() } }
/**
 LangGofer is a Global Variable.
 - note : LangGofer is sub model get from the LanguageContentModel. It's holds the value of of Gofer Model
 */
var LangGofer : Gofer { get { return Global_Language?.gofer ?? Gofer() } }
/**
 isRTLLanguage is a Global Variable.
 - note : isRTLLanguage is used to identify the current language direction (eg: RTL (Right to Left) or LTR(Left to Right) )
 */
var isRTLLanguage : Bool { get { return Global_Language?.isRTLLanguage() ?? false } }
/**
 availableLanguages is a Global Variable.
 - note : availableLanguages is our project's available Languages, It can be modified by Admin
 */
var availableLanguages : [Language] { get { return Global_Language?.language ?? [] } }
/**
 currentLanguage is a Global Variable.
 - note : currentLanguage is our currently loaded language from API, Can change by User
 */
var currentLanguage : Language { get { return Global_Language?.currentLangage() ?? Language() } }
/**
 defaultLanugage is a Global Variable. defaultLanugage is used to identify default loading lanugage after logout
 - note : It can be set from admin panel site setting
 */
var defaultLanugage : String { get { return Global_Language?.defaultLanguage ?? "en" } }
/**
 appName is a Global Variable.
 - note : appName is our project's name, Can change from web (Dynamically Set from the Language Model)
 */
var appName : String { get { return LangCommon.appName } }
/**
 locale is a Global Variable.
 - note : locale is used to  identify the locale of our project, based on Language
 */
var locale : Locale { get { return Global_Language?.locale ?? Locale(identifier: "en") } }

/**
 isLanguageLoaded is a Global Variable.isLanguageLoaded used to identfy the current Language is Fully Loaded from web
 - note : Used in Splash screen to wait for language
 */
var isLanguageLoaded = Global_Language != nil


// MARK: - Application Details
/**
 isSimulator is a Global Variable.isSimulator used to identfy the current running mechine
 - note : Used in segregate Simulator and device to do appropriate action
 */
var isSimulator : Bool { return TARGET_OS_SIMULATOR != 0 }
/**
 AppVersion is a Global Variable.AppVersion used to get the current app version from info plist
 - note : Used in Force update functionality to get newer version update
 */
var AppVersion : String? = { return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String }()


// MARK: - UserDefaults Easy Access
/**
 userDefaults is a Global Variable.
 - note : userDefaults used to store and retrive details from Local Storage (Short Access)
 */
let userDefaults = UserDefaults.standard

let Images = ImageConstants()

// MARK: - URLS and API Keys
/**
 infoPlist is a Global Variable.
 - note : infoPlist used to read all the details inside info plist
 */
let infoPlist = PlistReader<InfoPlistKeys>()
/**
 APIBaseUrl is a Global Variable. Get from info Plist, Change in Configuration File
 - note : used in project's All source files (eg: images)
 - warning : Don't Forget to Add Your URL here
 */
let APIBaseUrl : String = (infoPlist?.value(for: .App_URL) ?? "").replacingOccurrences(of: "\\", with: "")
/**
 Global_UserType is a Global Variable. Get from info Plist, Change in Configuration File
 - note : used in project's All source files (eg: images)
 - warning : Don't Forget to Add Your URL here
 */
let Global_UserType : String = (infoPlist?.value(for: .UserType) ?? "")
/**
 APIUrl is a Global Variable. Get from info Plist, Change in Configuration File
 - note : used in project's All APIs
 - warning : Don't Forget to Add Your URL here
 */
let APIUrl : String = APIBaseUrl + "api/"
/**
 GoogleAPIKey is a Global Variable. Get from info Plist, Change in Configuration File
 - note : used in maps and geodecode from Google Api
 - warning : Don't Forget to Add Your Key before AppCheck
 */
let GoogleAPIKey : String = infoPlist?.value(for: .Google_API_keys) ?? ""
/**
 GooglePlacesApiKey is a Global Variable. Get from info Plist, Change in Configuration File
 - note : used in Places name and direction from Google Api
 - warning : Don't Forget to Add Your Key before AppCheck
 */
let GooglePlacesApiKey : String = infoPlist?.value(for: .Google_Places_keys) ?? ""
/**
 appLogo is a Global Variable.appLogo Holds the image name of the applogo in our Project
 - warning : appLogo name must preset in image assets
 */
let appLogo = "goferjek"
/**
 forceUpdateVersion is a Global Variable.forceUpdateVersion Holds the value for next update check from forceupdate
 - warning : don't for get to change the value for config before any build
 */
var forceUpdateVersion : String? = infoPlist?.value(for: .ReleaseVersion)

// MARK: - Custom Font Names
/**
 RegularFont is a Global Variable.RegularFont Holds the Regular Font Name used in our Project
 - note : RegularFont used in All Lables and Button
 */
var G_RegularFont : String = "GoogleSans-Regular"
/**
 MediumFont is a Global Variable.MediumFont Holds the Medium Font Name used in our Project
 - note : MediumFont used in All Lables and Button
 */
var G_MediumFont : String = "GoogleSans-Medium"
/**
 BoldFont is a Global Variable.BoldFont Holds the Bold Font Name used in our Project
 - note : BoldFont used in All Lables and Button
 */
var G_BoldFont : String = "GoogleSans-Bold"
/**
 ImageFont is a Global Variable.ImageFont Holds the Images  used in our Project
 - note : ImageFont used in All Lable image setting
 */
let ImageFont : String = "uber-clone-mobile"


// MARK: - Firebase Environment Setup
/**
 firebaseEnvironment is a Global Variable.firebaseEnvironment used to control the Environment in Firebase Node Access
 - note : select live for production demo for debug (Env.isLive() is used to identify debug or production in run time)
 - warning : don't forget to set live when appstore publish
 */
let firebaseEnvironment : FireBaseEnvironment = Env.isLive() ? .live : .demo
//let firebaseEnvironment : FireBaseEnvironment = .live



// MARK: - Call Manager Environment Setup
/**
 callEnvironment is a Global Variable.callEnvironment used to control the Environment in Sinch Call
 - note : select live for production demo for debug
 - warning : don't forget to set live when appstore publish
 */
//let callEnvironment : CallManager.Environment = .live


// MARK: - User , Provider Appstore Details
/**
 userDetails is a private Variable.userDetails Holds the Details of the Rider Appstore Details from Info plist
 - note :Local use only ( private value)
 */
private let userDetails : JSON? = infoPlist?.value(for: .iTunesData_user)
/**
 providerDetails is a private Variable.providerDetails Holds the Details of the Driver Appstore Details from Info plist
 - note :Local use only ( private value)
 */
private let providerDetails : JSON? = infoPlist?.value(for: .iTunesData_provider)
/**
 RideriTunes is a global User defined Struct. RideriTunes Holds the Details of the Rider Appstore Details
 - note : Get  Rider Details Form Appstore (Used in Rider App redirection)
 */
struct RideriTunes : iTunesData{
    var appName = userDetails?.string("appName") ?? ""
    var appStoreDisplayName = userDetails?.string("appStoreDisplayName") ?? ""
    var appID = userDetails?.string("appID") ?? ""
}
/**
 DriveriTunes is a global User defined Struct. DriveriTunes Holds the Details of the Driver Appstore Details
 - note : Get  Driver Details Form Appstore (Used  in Driver App redirection)
 */
struct DriveriTunes : iTunesData {
    var appName = providerDetails?.string("appName") ?? ""
    var appStoreDisplayName = providerDetails?.string("appStoreDisplayName") ?? ""
    var appID = providerDetails?.string("appID") ?? ""
}
/**
 Redirection Link is a Global Variable. Redirection Link is Useful For Redirecting the One Application to Other Application in Appstore
 - note: Used in User to driver Redirection
 */
let redirectionLink : String = infoPlist?.value(for: .RedirectionLink_provider) ?? ""

// MARK: - Common Errors
/**
 Redirection Link is a Global Enum .CommonError Used For Error passing or Predefined Error Through
 - note : Used in Connection Handlers or Completion Handlers
 */
enum CommonError : Error,
                   LocalizedError {
    case server
    case connection
    case failure(_ reason : String)
    
    /**
     return the errorDescription of the appropriate application
     */
    var errorDescription: String?{
        switch self {
        case .failure(let error):
            return error
        default:
            return self.localizedDescription
        }
    }
    /**
     return the localizedDescription of the appropriate application
     */
    var localizedDescription: String {
        guard Global_Language == nil else { return "No internet connection.".localizedCapitalized}
        switch self {
        case .server:
            return LangCommon.internalServerError
        case .connection:
            return LangCommon.noInternetConnection
        case .failure(let reason):
            return reason
        }
    }
}

// MARK: - Application Features Variables

/**
 isSingleApplication is a Global Variable.To initiate Single Application Feature in Application
 - Warning: make sure you set 'false' to get Multiple Application
 */
var isSingleApplication : Bool { get { return AppWebConstants.availableBusinessType.count == 1 } } // return true  // Handy Splitup Start
/**
 CanRequestSinchNotification is a Global Variable. To initiate Sinch Call  set 'true'
 - Warning: make sure you set 'true' to get Sinch Call
 */
let CanRequestSinchNotification = true
/**
 crashApplicationOnSplash is a Global Variable.To initiate firebase crash analytics set 'true'
 - Warning: make sure you set 'false' before launching
 */
let crashApplicationOnSplash = false


// MARK: - Theme Colors
/**
 ThemeColors is a Global Variable.ThemeColors holds the Values of the all colors listed from the info plist
 - note : ThemeColors used to get all the details about colors from  info plist
 - warning : Don't make it private some time useful to access default keys
 */
let ThemeColors : JSON? = infoPlist?.value(for: .ThemeColors)

extension UIColor {
    /**
     _Colors is used to store the get set Varaibles Helper
     - note: it's Used for 'PrimaryColor' and 'ThemeTextColor'
     */
    private static var _Colors = [String : UIColor]()
    /**
     PrimaryColor is a Theme Color of the Project
     - note: used in Navigation, images and Button Active
     */
//    open class var PrimaryColor         : UIColor {
//        get { UserDefaults.standard.setValue(ThemeColors?.string("PrimaryColor"), forKey: "PrimaryColor")
//            return UIColor._Colors["PrimaryColor"] ?? UIColor(hex: ThemeColors?.string("PrimaryColor")) }
//        set { UserDefaults.standard.setValue(newValue, forKey: "PrimaryColor")
//            UIColor._Colors["PrimaryColor"] = newValue } }
    open class var PrimaryColor         : UIColor {
            get { return UIColor._Colors["PrimaryColor"] ?? UIColor(hex: ThemeColors?.string("PrimaryColor")) }
            set { UIColor._Colors["PrimaryColor"] = newValue } }
    /**
     ThemeTextColor is same as Primary Color
     - note: used in Text Color (Same as ThemeColor)
     */
    open class var ThemeTextColor       : UIColor {
        get { return UIColor._Colors["ThemeTextColor"] ?? UIColor(hex: ThemeColors?.string("ThemeTextColor")) }
        set { UIColor._Colors["ThemeTextColor"] = newValue } }
    /**
     PrimaryTextColor is useful For Text above the PrimaryColor
     - note: PrimaryTextColor used in Navigation or Button labels
     */
    open class var PrimaryTextColor     : UIColor { return UIColor(hex: ThemeColors?.string("PrimaryTextColor")) }
    /**
     SecondaryColor is useful in background or Primary Contrast Color
     - note: SecondaryColor used in  Label's backgroundl  and Secondary Button's background
     */
    open class var SecondaryColor       : UIColor { return UIColor(hex: ThemeColors?.string("SecondaryColor")) }
    /**
     SecondaryTextColor is useful in background or Primary Contrast Color
     - note: SecondaryTextColor used in background Label text and Secondary Button text
     */
    open class var SecondaryTextColor   : UIColor { return UIColor(hex: ThemeColors?.string("SecondaryTextColor")) }
    /**
     TertiaryColor is useful Inactive or Other State of Active
     - note: TertiaryColor used in inactive Lables and Views
     */
    open class var TertiaryColor        : UIColor { return UIColor(hex: ThemeColors?.string("TertiaryColor")) }
    /**
     InactiveTextColor is useful Inactive or Other State of Active
     - note: InactiveTextColor used in inactive Lables text and Button Text
     */
    open class var InactiveTextColor    : UIColor { return UIColor(hex: ThemeColors?.string("InactiveTextColor")) }
    /**
     IndicatorColor is useful For Indication
     - note: IndicatorColor used in Indicator View's
     */
    open class var IndicatorColor       : UIColor { return UIColor(hex: ThemeColors?.string("IndicatorColor")) }
    /**
     BoxColor is useful For Text Filed  in DarkMode Time
     - note: PrimaryTextColor used in DarkMode Textfiled and Lable Differentiate
     */
    open class var PayStatementColor             : UIColor { return UIColor(hex: ThemeColors?.string("PayStatementColor")) }
    /**
     CancelledStatusColor is useful For Canceled Status Color
     - note: CancelledStatusColor used in history cancelled state Color. eg: State  (canceled)
     */
    open class var CancelledStatusColor : UIColor { return UIColor(hex: ThemeColors?.string("CancelledStatusColor")) }
    /**
     CompletedStatusColor is useful For Completed Status Color
     - note: CompletedStatusColor used in history completed state Color. eg: State  (completed)
     */
    open class var CompletedStatusColor : UIColor { return UIColor(hex: ThemeColors?.string("CompletedStatusColor")) }
    /**
     ErrorColor is useful For Error Time
     - note: ErrorColor used in Error Labels and Error Views
     */
    open class var ErrorColor           : UIColor { return UIColor(hex: ThemeColors?.string("ErrorColor")) }
    /**
     PendingStatusColor is useful For Pending Status Color
     - note: PendingStatusColor used in history pending state Color. eg: State  (pending,Rating,scheduled)
     */
    open class var PendingStatusColor   : UIColor { return UIColor(hex: ThemeColors?.string("PendingStatusColor")) }
    /**
     RatingColor is useful For Rating Variables
     - note: RatingColor used in Rating Lables and Rating Background Views
     */
    open class var RatingColor           : UIColor { return UIColor(hex: ThemeColors?.string("RatingColor")) }
    /**
     DarkModeBackground is useful For DarkMode Time
     - note: DarkModeBackground used in DarkMode Time View's Bacground Color
     */
    open class var DarkModeBackground   : UIColor { return UIColor(hex: ThemeColors?.string("DarkModeBackground")) }
    /**
     DarkModeTextColor is useful For DarkMode Time
     - note: DarkModeTextColor used in DarkMode Time View's Label Text or Button's Text
     */
    open class var DarkModeTextColor    : UIColor { return UIColor(hex: ThemeColors?.string("DarkModeTextColor")) }
    /**
     LightModeTextColor is useful For LightMode Time
     - note: LightModeTextColor used in LightMode Time View's Label Text
     */
    open class var LightModeTextColor   : UIColor { return UIColor(hex: ThemeColors?.string("LightModeTextColor")) }
    /**
     DarkModeBorderColor is useful in Darkmode Time
     - note: DarkModeBorderColor used in View's Border During DarkMode Time
     */
    open class var DarkModeBorderColor  : UIColor { return UIColor(hex: ThemeColors?.string("DarkModeBorderColor")) }
    /**
     LightWhiteColor is useful Inactive or Other State of Active
     - note: LightWhiteColor used in inactive Views
     */
    open class var LightWhiteColor      : UIColor { return UIColor(hex: ThemeColors?.string("LightWhiteColor")) }
    /**
     ThemeYellow is useful For Rating Stars
     - note: ThemeYellow used in Rating Buttons or Views
     */
    static var ThemeYellow              : UIColor { return UIColor(named: "ThemeYellow") ?? UIColor(hex: "FFFFFF") }
}


// MARK: - Global Language Set From Web

/// Global Language Set From Web
/// - Parameters:
///   - params: Need to pass the 'Language' param to get the appropriate Language
///   - completionHandler: return the Language Content Mode or Error After the Process Execution to appropriate requesting function
func wsToGetLanguage(params: JSON,
                     completionHandler : @escaping ((Result<LanguageContentModel,Error>) -> Void)) {
    ConnectionHandler.shared
        .getRequest(for: APIEnums.language_content,
                       params: params,
                       showLoader: true)
        .responseDecode(to: LanguageContentModel.self) { (languageContent) in
            Global_Language = languageContent
            completionHandler(.success(languageContent))
        }.responseFailure { (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                completionHandler(.failure(CommonError.failure(error)))
            }
        }
}
