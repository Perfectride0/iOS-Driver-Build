/**
 * SplashVC.swift
 *
 * @package GoferDriver
 * @author Trioangle Product Team
 *  
 * @link http://trioangle.com
 */

import UIKit
import Alamofire
import FirebaseCrashlytics
enum ForceUpdate : String {
  case skipUpdate = "skip_update"
  case noUpdate = "no_update"
  case forceUpdate = "force_update"
}
class SplashVC: BaseVC {
  
  @IBOutlet weak var splashView: splashView!
  
  var hasLaunchedAlready : Bool = false
  var window = UIWindow()
  var appDelegate  = UIApplication.shared.delegate as! AppDelegate
  var isFirstTimeLaunch : Bool = false
  
  var transitionDelegate: UIViewControllerTransitioningDelegate?
  // MARK: - Variable for Language Protocol
  var timer : Timer?
  var languageLoaded : Bool{
    //languages
    guard let lang : String = UserDefaults.value(for: .default_language_option),
          isLanguageLoaded else{
      return false
    }
    return lang == currentLanguage.key
  }
  
  // MARK: - ViewController Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    if self.languageLoaded{//language is ready
      self.onLanguageAvailableStartFunctionalities()
    }else{ //fetch lanugage
      self.wsToFetchLanguage()
    }
    if crashApplicationOnSplash{
      Crashlytics.crashlytics()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  //MARK:- Language update flow
  
  
  func onLanguageAvailableStartFunctionalities(){
    
    if !isSimulator {
      if !(UIApplication.shared.isRegisteredForRemoteNotifications) {
        //TRVicky
        self.commonAlert.setupAlert(alert:LangCommon.message.capitalized,
                                    alertDescription: LangCommon.pleaseEnablePushNotification,
                                    okAction: LangCommon.ok.uppercased())
      }
    }
    self.timer = Timer.scheduledTimer(timeInterval:1.0,
                                      target: self,
                                      selector: #selector(self.onSetRootViewController),
                                      userInfo: nil,
                                      repeats: true)
    
    _ = PipeLine.createEvent(key: PipeLineKey.app_entered_foreground) {
      self.onStart()
    }
  }
  func wsToFetchLanguage() {
    var param = JSON()
    if let lang : String = UserDefaults.value(for: .default_language_option){
      param["language"] = lang
    }
    wsToGetLanguage(params: param) { result in
      switch result {
      case .success(_):
        DispatchQueue.main.async {
          self.onLanguageAvailableStartFunctionalities()
        }
      case .failure(let error):
        debug(print: error.localizedDescription)
        AppDelegate.shared.createToastMessage(error.localizedDescription)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
          self.wsToFetchLanguage()
        }
      }
    }
  }
  
  // showing root viewcontroller after splash page shown
  @objc func onSetRootViewController()  {
    if !isSimulator {
      guard let _ = UserDefaults.standard.value(forKey: USER_DEVICE_TOKEN) else {
        self.appDelegate.pushManager.registerForRemoteNotification()
        return
      }
    }
    self.timer?.invalidate()
    self.onStart()
  }
  
  //MARK: - init with storyBoard
  class func initWithStory() -> SplashVC{
    let view : SplashVC = UIStoryboard.gojekCommon.instantiateViewController()
    return view
  }
  
  //Onapplicaiton start
  func onStart() {
    guard let _forceUpdateVersion = forceUpdateVersion else {return}
    var params = JSON()
    params["version"] = _forceUpdateVersion
    ConnectionHandler.shared.getRequest(for: .force_update,
                                        params: params,
                                        showLoader: false)
      
//      .responseJSON { (json) in
//      let shouldForceUpdate = json.string("force_update")
//      let should = ForceUpdate(rawValue: shouldForceUpdate) ?? .noUpdate
//      let enableReferral = json.bool("enable_referral")
//      let currency_code = json.string("default_curreny_code")
//      let curreny_symbol = json.string("default_curreny_symbol")
//      let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
//      let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
//      if userCurrencyCode == "" || userCurrencySym == "" {
//        Constants().STOREVALUE(value: curreny_symbol, keyname: USER_CURRENCY_SYMBOL_ORG_splash)
//        Constants().STOREVALUE(value: currency_code, keyname: USER_CURRENCY_ORG_splash)
//      }
//      let otpEnabled = json.bool("otp_enabled")
//      let supportArray = json.array("support")
//      let support = supportArray.compactMap({Support.init($0)})
//      Shared.instance.supportOtpEnabled(otpEnabled: otpEnabled,
//                                        supportArr: support)
//      Shared.instance.enableReferral(enableReferral)
//      self.shouldForceUpdate(should)
//    }
    
      .responseDecode(to: checkVersionModel.self) { (json) in
        let shouldForceUpdate = json.force_update
        let should = ForceUpdate(rawValue: shouldForceUpdate) ?? .noUpdate
        let enableReferral = json.enable_referral
        let currency_code = json.default_curreny_code
        let curreny_symbol = json.default_curreny_symbol
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        if userCurrencyCode == "" || userCurrencySym == "" {
          Constants().STOREVALUE(value: curreny_symbol, keyname: USER_CURRENCY_SYMBOL_ORG_splash)
          Constants().STOREVALUE(value: currency_code, keyname: USER_CURRENCY_ORG_splash)
        }
        let otpEnabled = json.otp_enabled
        Shared.instance.is_driver_wallet = json.is_driver_wallet
        print(Shared.instance.is_driver_wallet)
        let support = json.support
        Shared.instance.defaultCountryCode = json.default_country_code
        Shared.instance.phoneCode = json.default_phone_code
        Shared.instance.defaultFlag = json.default_country_flag
        Shared.instance.supportOtpEnabled(otpEnabled: otpEnabled,
                                          supportArr: support)
        Shared.instance.enableReferral(enableReferral)
        self.shouldForceUpdate(should)
      }
      
      .responseFailure { (error) in
      print(error)
    }
  }
  
  func shouldForceUpdate(_ should : ForceUpdate){
    switch should {
    case .forceUpdate:
      self.presentAlertWithTitle(title: LangCommon.newVersionAvail,
                                 message: LangCommon.updateApp,
                                 options: LangCommon.visitAppStore) { (option) in
        self.goToAppStore()}
    case .noUpdate:
      self.moveOn()
    case .skipUpdate:
      self.commonAlert.setupAlert(alert: LangCommon.newVersionAvail,
                                  alertDescription: LangCommon.forceUpdate ,
                                  okAction: LangCommon.update ,
                                  cancelAction: LangCommon.skip,
                                  userImage: nil)
      self.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
        self.goToAppStore()
      }
      self.commonAlert.addAdditionalCancelAction {
        self.moveOn()
      }
    }
  }
  
  // Continue Without Update
  func moveOn() {
    guard !self.hasLaunchedAlready else {return}
    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
    appDelegate.onSetRootViewController(viewCtrl:self)
    self.hasLaunchedAlready = true
  }
  
  //Redirect to App Store
  func goToAppStore(){
    
    if let url = DriveriTunes().appStoreLink{
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url)
      } else {
        UIApplication.shared.openURL(url)
        // Fallback on earlier versions
      }
    }
  }
}
