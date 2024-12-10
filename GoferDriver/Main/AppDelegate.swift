/**
 * AppDelegate.swift
 *
 * @package GoferDriver
 * @author Trioangle Product Team
 *
 * @link http://trioangle.com
 */

import UIKit
import UserNotifications
import GoogleMaps
import CoreLocation
import PaymentHelper
//import APScheduledLocationManager
import GeoFire
import Firebase
//import FirebaseInstanceID
import FirebaseMessaging
import AVFoundation

import CoreData
import UserNotifications
import OSLog
import SinchRTC
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate:UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate
{
    static var oberserver : cancelObserver?
    static var personObj:Person = Person()

    
    var notificationJSOS:JSON?
    var window: UIWindow?
    var navigationController: UINavigationController!
    var isFirstTime : Bool = false
    var isDriverOnline : Bool = false
    var strDriverStatus = ""
    var timerDriverLocation : Timer? = Timer()
    var isTripStarted : Bool = false
    var strLatitude = ""
    var strLongitude = ""
    var strOldLatitude = ""
    var strOldLongitude = ""
    var strTripID = ""
    var present_data = ""
    var nSelectedIndex : Int = 0
    let locationHandler : LocationHandlerProtocol? = LocationHandler.default()
    let userDefaults = UserDefaults.standard
    var lastLocation:CLLocation?
    var locationManager = CLLocationManager()
    let windowKey = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    
    //MARK: - PushNotification Manager Declaration
    var pushManager : PushNotificationManager!
    var IsTimerCalled = false
    let center = UNUserNotificationCenter.current()
    fileprivate var backGroundThread : UIBackgroundTaskIdentifier = .invalid
    var push: SinchManagedPush!
       var callKitMediator: SinchClientMediator!
       let customLog = OSLog(subsystem: "com.sinch.sdk.app", category: "AppDelegate")

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CacheData_")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                /*var tripCache = TripCache()
                tripCache.removeTripDataFromLocale(UserDefaults.value(for: .cache_location_trip_id) ?? "")*/
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    lazy var persistentContainerDB: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cache")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                /*var tripCache = TripCache()
                tripCache.removeTripDataFromLocale(UserDefaults.value(for: .cache_location_trip_id) ?? "")*/
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    var supportsVideo: Bool {
                     get {
                     let video = Bundle.main.object(forInfoDictionaryKey: "SINAppSupportsVideo") as? NSNumber
                     return video != nil && video?.boolValue ?? false
                     }
                     set {
                         self.supportsVideo = newValue
                     }
             }
    //MARK:- App life cycle
    //release commit yamini
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        var locationInfo = [AnyHashable: Any]()
//        locationInfo["lat"] = location.coordinate.latitude.description
//        locationInfo["lng"] = location.coordinate.longitude.description
        DispatchQueue.main.async {
            self.pushManager = PushNotificationManager(application)
            self.initPushNotification()
            SinchRTC.setLogCallback { (severity: SinchRTC.LogSeverity, area: String, msg: String, _: Date) in
                                                 os_log("%{public}@", log: OSLog(subsystem: "com.sinch.sdk.app", category: area), type: severity.osLogType(), msg)
                                               }

                                               self.push = SinchRTC.managedPush(forAPSEnvironment: SinchRTC.APSEnvironment.development)
                                               self.push.delegate = self
                                               self.push.setDesiredPushType(SinchManagedPush.TypeVoIP)

                                               self.callKitMediator = SinchClientMediator.init(delegate: self,supportsVideo: self.supportsVideo)
        }
        if (launchOptions?[.location]) != nil {
            self.locationHandler?.startListening(toLocationChanges: true)
            let context = self.persistentContainerDB.viewContext
            
            if let entityObj = NSEntityDescription.entity(forEntityName: "BackgroundLocation",
                                                          in: context) {
                let object = NSManagedObject(entity: entityObj,
                                             insertInto: context)
                object.setValue("lat: \(self.locationHandler?.lastKnownLocation?.coordinate.latitude ?? 0), long: \(self.locationHandler?.lastKnownLocation?.coordinate.longitude ?? 0)",
                                forKey: "location")
                object.setValue(Date(), forKey: "time")
            }
        }
        return true
    }
    // Launch the app
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        UIApplication.shared.registerForRemoteNotifications(matching: ([.alert, .badge, .sound]))
        let pre = Locale.preferredLanguages[0]
        _ = pre.components(separatedBy: "-")
        //        language = lag[0]
        //UITextField.appearance().
        //PUSHNOTIFICATION Manager
        if self.timerDriverLocation != nil {
            self.timerDriverLocation?.invalidate()
        }
        
        if IsTimerCalled == false {
            timerDriverLocation = Timer.scheduledTimer(timeInterval: TimeInterval(floatLiteral: 10.00) ,
                                                       target: self,
                                                       selector: #selector(self.updateCurrentLocationToServer),
                                                       userInfo: nil,
                                                       repeats: true)
            IsTimerCalled = true
        }
        

        self.window = UIWindow(frame:UIScreen.main.bounds)
        UIApplication.shared.applicationIconBadgeNumber = 0;
        GMSServices.provideAPIKey(GoogleAPIKey)
        IQKeyboardManager.shared.enable = true
        if let options = launchOptions,
           let jsons = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            self.notificationJSOS = jsons
            self.perform(#selector(self.didReceiveNotificationHandler),
                         with: nil,
                         afterDelay: 1)
        }
        
        // Registering For Push Notification
        // registerForRemoteNotification()
        self.initModules()
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        self.makeSplashView(isFirstTime: true)
        
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
                print("not allowed")
            }
        }
        UITextField.appearance().tintColor = .PrimaryColor
        UITextView.appearance().tintColor = .PrimaryColor
        AppDelegate.oberserver = cancelObserver()
        AppDelegate.oberserver?.observe(person: AppDelegate.personObj)
        AppDelegate.personObj.requestId = ""
        print("")
        return true
    }
    
    // MARK: for killed state pushnotification Handler
    @objc
    func didReceiveNotificationHandler() {
        if let  dict = self.notificationJSOS {
            self.pushManager.handleHandyPushNotificaiton(userInfo: dict)
            self.pushManager.handleCommonPushNotification(userInfo: dict as NSDictionary, generateLocalNotification: false)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.didReceiveNotificationHandler()
            }
        }
    }
    
    
    // update the location if app isin will enter the foreground mode
    
    
    //MARK: extension
    func webServiceUnderMaintenance() {
        print("WEB UNDER MAINTENANCEEEEEEEEEEEEEEEEEEEE::::::::::::::")
        let webMainVC = WebUnderMaintenanceVC.initWithStory()
        webMainVC.hidesBottomBarWhenPushed = true
        webMainVC.modalPresentationStyle = .fullScreen
        
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            if topController != WebUnderMaintenanceVC(){
                print("TopController==================================",topController)
                topController.present(webMainVC, animated: true, completion: nil)
            }
        }
            
       // self.navigationController.present(webMainVC, animated: true, completion: nil)
        
      //  self.topMostViewController().present(webMainVC, animated: true, completion: nil)
//        self.topMostViewController().navigationController?.pushViewController(webMainVC,animated: false)
    }
    
    func scheduleNotification(title: String,message: String) {
        let sender_name = UserDefaults.standard.string(forKey: TRIP_RIDER_NAME) ?? "driver"
        let content = UNMutableNotificationContent()
        
        content.title = sender_name
        content.body = message
        content.sound = UNNotificationSound.default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "Chat Notification"
//        let identifier = ["UUID": "CURRENT_CHAT_TRIP_ID" ]

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }

    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: .AppEnteredForeground,
                                        object: nil)
        if self.timerDriverLocation != nil {
            self.timerDriverLocation?.invalidate()
        }
        
        _ = PipeLine.fireEvent(withKey : PipeLineKey.app_entered_foreground)
          
        // Force Location Handling When User try to stop when in the trip And setting work location
        
        let topmostController = application.topViewController()
        //Delivery splitup start
        //remove handyenroutevc from below line
        //Gofer splitup start
        //remove DeliveryEnrouteVC & HandyEnRouteVC from below line
        //Laundry splitup start
        //Instacart splitup start
        if
        //Deliveryall_Newsplitup_start
            topmostController?.isKind(of: HandySetLocationVC.self) ?? false || topmostController?.isKind(of: HandyHomeMapVC.self) ?? false
                //Deliveryall_Newsplitup_start
                //Handy_NewSplitup_Start
        //Handy_NewSplitup_End
        {
            locationHandler?.startListening(toLocationChanges: true)
            // Delivery splitup end
            //Laundry splitup end
            //Instacart splitup end
        }else{
            print("Nothing To Show")
        }
       // self.pushManager.startObservingProvider()
      
        if let call = self.callKitMediator.currentCall() {
                         self.transitionToCallView(call)
                       }
                   }
                   func handlePushNotification(withInfo info: [AnyHashable: Any]) {
                     os_log("handlePushNotification -> createClientIfNeeded()", log: self.customLog)

                     self.callKitMediator.createClientIfNeeded()

                     precondition(self.callKitMediator.client != nil, "Client at this point must always exist")

                     if let client = self.callKitMediator.sinchClient {
                       client.relayPushNotification(withUserInfo: info)
                     }
                   }

                   private func transitionToCallView(_ call: SinchCall) {
                     // Find MainViewController and present CallViewController from it.

                     var top = self.window!.rootViewController!
                     while top.presentedViewController != nil {
                       top = top.presentedViewController!
                     }

                     // TODO: Check top is not call already

//                     let sBoard = UIStoryboard(name: "GoJek_Common", bundle: nil)
//                     guard let callVC = sBoard.instantiateViewController(withIdentifier: "AudioCall") as? AudioCall else {
//                       preconditionFailure("Error AudioCall is expected")
//                     }
                       let callView = AudioCall(nibName: "CallViewController", bundle: nil)
                     callView.callKitMediator = self.callKitMediator
                     callView.call = call

                     os_log("transitionToCallView -> preset call controller", log: self.customLog)
                       callView.attach(with: .fullScreen)
                   }
    
    // update the location if app isin background mode
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.isIdleTimerDisabled = true
        NotificationCenter.default.post(name: .AppEnteredBackground, object: nil)
        
        self.locationManager.startMonitoringSignificantLocationChanges()
        
        let userTripStatus = userDefaults.value(forKey: TRIP_STATUS) as? String
   
        print("backgroundprocess \(String(describing: userTripStatus))")
        if(userTripStatus == "Offline"){
            //Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            if self.timerDriverLocation != nil {
                self.timerDriverLocation?.invalidate()
            }
            timerDriverLocation = Timer.scheduledTimer(timeInterval: 10.00,
                                                       target: self,
                                                       selector: #selector(self.updateCurrentLocationToServer),
                                                       userInfo: nil,
                                                       repeats: true)
        } else {
            
            if self.timerDriverLocation != nil {
                self.timerDriverLocation?.invalidate()
            }
            updateCurrentLocationToServer()
            
        }
//        self.pushManager.stopObservingProvider()
        
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.isIdleTimerDisabled = true
        let pre = Locale.preferredLanguages[0]
        _ = pre.components(separatedBy: "-")
//        language = lag[0]
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications() // To remove all delivered notifications
        center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
        self.updateLanguage()
        NotificationCenter.default.post(name: .ChatRefresh, object: nil)

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground
        self.pushManager.stopObservingProvider()
        //Crashing sometimes
        //CallManager.instance.deinitialize()
        self.backGroundThread = UIApplication.shared.beginBackgroundTask { [weak self] in
            debug(print: "\(String(describing: self?.backGroundThread.rawValue))")
            
           // CallManager.instance.deinitialize()
            DispatchQueue.main.asyncAfter(deadline: .now()+5) { [weak self] in
                self?.terminateBackgroundThread()
            }
        }
        assert(backGroundThread != .invalid)
     
        let userTripStatus = userDefaults.value(forKey: TRIP_STATUS) as? String
        if (userTripStatus != "Trip") {
            
            updateCurrentLocationToServer()
            LocationHandler.shared().startListening(toLocationChanges: false)
            
        } else {
            
            if self.timerDriverLocation != nil {
                self.timerDriverLocation?.invalidate()
            }
            DispatchQueue.global(qos: .background).async {
                self.timerDriverLocation = Timer.scheduledTimer(timeInterval: 10.00,
                                                                target: self,
                                                                selector: #selector(self.updateCurrentLocationToServer),
                                                                userInfo: nil,
                                                                repeats: true)
                self.timerDriverLocation?.fire()
            }
        }
    }
    //MARK:-

    func initModules(){
        NetworkManager.instance.observeReachability(true)
//        Constants().STOREVALUE(value: "Offline", keyname: TRIP_STATUS)
        
//        if UserDefaults.isNull(for: .default_language_option){
//            LangCommon.default.saveLanguage()
//        }666
        let userTripStatus = userDefaults.value(forKey: TRIP_STATUS) as? String
        if (userTripStatus == nil || userTripStatus == "")
        {
            userDefaults.set("", forKey: TRIP_STATUS)
        }
        else if (userTripStatus == "Trip")
        {
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        }
        else if (userTripStatus == "Online" || userTripStatus == "Offline")
        {
            let sts = (userTripStatus == "Offline") ? "Offline": "Online"
            Constants().STOREVALUE(value: sts, keyname: TRIP_STATUS)
        }
        
        let userStatus = userDefaults.value(forKey: USER_STATUS) as? String
        if (userStatus == nil || userStatus == "")
        {
            userDefaults.set("", forKey: USER_STATUS)
        }
        
        let userCurrency = userDefaults.value(forKey: USER_CURRENCY_SYMBOL_ORG_splash) as? String
        if (userCurrency == nil || userCurrency == "")
        {
            userDefaults.set("", forKey: USER_CURRENCY_SYMBOL_ORG_splash)
        }
        
        let userdialcode = userDefaults.value(forKey: USER_DIAL_CODE) as? String
        if (userdialcode == nil || userdialcode == "")
        {
            userDefaults.set("", forKey: USER_DIAL_CODE)
        }
        
        let userOnlineStatus = userDefaults.value(forKey: USER_ONLINE_STATUS) as? String
        if (userOnlineStatus == nil || userOnlineStatus == "")
        {
            userDefaults.set("", forKey: USER_ONLINE_STATUS)
        }
        
        let userCountryCode = userDefaults.value(forKey: USER_COUNTRY_CODE) as? String
        if (userCountryCode == nil || userCountryCode == "")
        {
            userDefaults.set("", forKey: USER_COUNTRY_CODE)
        }
        
        let userDeviceToken = userDefaults.value(forKey: USER_DEVICE_TOKEN) as? String
        if (userDeviceToken == nil || userDeviceToken == "")
        {
            userDefaults.set("", forKey: USER_DEVICE_TOKEN)
        }
        userDefaults.synchronize()
   
        
    }
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    
//    @objc(applicationReceivedRemoteMessage:) func application(received remoteMessage: MessagingRemoteMessage) {
//        print("dfg")
//        print(remoteMessage.appData)
//    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String){
        
        print("didRefreshRegistrationToken")
       // registerForRemoteNotification()
    }
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage){
//
//        print("recive msg")
//    }
    // MARK: Getting Main Storyboard Name
    func makeSplashView(isFirstTime:Bool)
    {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var getStoryBoardName : String = ""
        switch (deviceIdiom)
        {
        case .pad:
            getStoryBoardName = "Main_iPad"
        case .phone:
            getStoryBoardName = "Main"
        default:
            break
        }
        
        //let _ : UIStoryboard = UIStoryboard(name: getStoryBoardName, bundle: nil)
//        let splashView = storyBoardMenu.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
//        let splashView = UIStoryboard.main.instantiateViewController() as SplashVC
        let splashView = SplashVC.initWithStory()
        splashView.isFirstTimeLaunch = isFirstTime
        window!.rootViewController = splashView
        window!.makeKeyAndVisible()
    }
    
    // MARK: Getting Main Storyboard Name
    func getMainStoryboardName() -> String
    {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var getStoryBoardName : String = ""
        switch (deviceIdiom)
        {
        case .pad:
            getStoryBoardName = "Main_iPad"
        case .phone:
            getStoryBoardName = "Main"
        default:
            break
        }
        
        return getStoryBoardName
    }
    // MARK: Set the Root View Controller
    //
    func onSetRootViewController(viewCtrl:UIViewController) {
//        viewCtrl.view.removeFromSuperview()
        self.updateCurrentLocationToServer()
        
        let getMainPage =  userDefaults.object(forKey: "getmainpage")  as? NSString
        
        if isRTLLanguage{
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        if getMainPage == "driver"
        {
            switch AppWebConstants.businessType {
            default:
                let vc = HandyHomeMapVC.initWithStory()
                let nav = UINavigationController(rootViewController: vc)
                window?.rootViewController = nav//MainTabBarController()
                window?.makeKeyAndVisible()
            }
            PushNotificationManager.shared?.startObservingProvider()
             
        }
        else
        {
            LocationHandler.shared().startListening(toLocationChanges: false)
            let userStatus = userDefaults.value(forKey: USER_STATUS) as? String
            if userStatus == "Car_details"
            {
                //self.gotoVehicleDetailPage()
            }
            else if userStatus == "Document_details"
            {
               // self.gotoDocumentPage()
            }
            else
            {
                self.showLoginView()
            }
        }
    }
    
    

    
    
    // MARK: Set App Root View controller
    func showLoginView()
    {
        
        let tripView = WelcomeVC.initWithStory()
        navigationController = UINavigationController(rootViewController: tripView)
        
        //        self.navigationController?.pushViewController(tripView, animated: true)
        navigationController?.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController;
        window?.makeKeyAndVisible()
        
        
        
    }
    
    // PUSH Notification
    
    func initPushNotification() {
           
           DispatchQueue.main.async {
               self.pushManager.registerForRemoteNotification()
           }
       }


    func logOutDidFinish()
    {
        let cacheHandler = LocalCacheHandler()
        let accessToken : String = UserDefaults.value(for: .access_token) ?? ""
        LocationHandler.shared().startListening(toLocationChanges: false)
        
        PushNotificationManager.shared?.stopObservingProvider()
        let userId = Constants().GETVALUE(keyname: USER_ID)
        if !userId.isEmpty{
            let geoFireRef = Database.database().reference().child(firebaseEnvironment.rawValue).child("GeoFire")
            let geoFire = GeoFire(firebaseRef: geoFireRef)
            geoFire.removeKey( userId)
        }
        cacheHandler.removeAll()
        cacheHandler.removeAll(entity: "Request")
        Shared.instance.resumeTripHitCount = 0
        userDefaults.set("", forKey: USER_CARD_LAST4)
        userDefaults.set("", forKey: USER_CARD_BRAND)
        userDefaults.set("", forKey: "CardDetails")
        userDefaults.set("", forKey: "CARD_DETAILS_GIVEN")
        Constants().STOREVALUE(value: "", keyname: USER_ACCESS_TOKEN)
        Constants().STOREVALUE(value: "", keyname: LICENSE_BACK)
        Constants().STOREVALUE(value: "", keyname: LICENSE_FRONT)
        Constants().STOREVALUE(value: "", keyname: LICENSE_INSURANCE)
        Constants().STOREVALUE(value: "", keyname: LICENSE_RC)
        Constants().STOREVALUE(value: "", keyname: LICENSE_PERMIT)
        Constants().STOREVALUE(value: "", keyname: USER_PAYPAL_EMAIL_ID)
        Constants().STOREVALUE(value: "Offline", keyname: USER_ONLINE_STATUS)
        Constants().STOREVALUE(value: "Offline", keyname: TRIP_STATUS)
        userDefaults.set(false, forKey: IS_COMPANY_DRIVER)
        userDefaults.set("", forKey:"getmainpage")
        userDefaults.set("", forKey:USER_STATUS)
        DriverStatus.removerFromPreference()
        UserDefaults.clearAllKeyValues()
        userDefaults.synchronize()
        
//        guard self.window?.rootViewController is UITabBarController else {
//            return
//        }
//        do{
//            try CallManager.instance.should(waitForCall: false)
//            CallManager.instance.wipeUserData()
//            CallManager.instance.deinitialize()
//        }catch{
//
//        }
        if isRTLLanguage {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        if !accessToken.isEmpty{
            self.showLoginView()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        
    }
    
    // MARK: Application Life cycle delegate methods
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        application.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications() // To remove all delivered notifications
        center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
    }
    
    
    func updateLanguage () {
        guard let token : String = UserDefaults.value(for: .access_token),
              let lang : String = UserDefaults.value(for: .default_language_option) else{return}
        var dicts = JSON()
          dicts["token"] =  token
          dicts["language"] = lang
        ConnectionHandler.shared.getRequest(
                  for: APIEnums.updateLanguage,
                  params: dicts,showLoader: false).responseJSON({ (json) in
              UberSupport.shared.removeProgressInWindow()
              if json.isSuccess{
              }else{
              }
          }).responseFailure({ (error) in
          })
    
    }
    
//MARK: - API CALL -> UPDATE DRIVER CURRENT LOCATION TO SERVER
    @objc
    func updateCurrentLocationToServer() {
        var dicts = JSON()
        let token = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        if token.isEmpty { return }
        dicts["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["latitude"] = Constants().GETVALUE(keyname: USER_LATITUDE)
        dicts["longitude"] = Constants().GETVALUE(keyname: USER_LONGITUDE)
        dicts["car_id"] = Constants().GETVALUE(keyname: USER_CAR_ID)
        dicts["status"] = Constants().GETVALUE(keyname: TRIP_STATUS)
        if dicts["status"] as! String == "Trip"{
            dicts["status"] = "Job"
        }
        if isTripStarted {
            dicts["total_km"] = self.getDistanceFromPreviousLocation(latitude: strLatitude, longitude: strLongitude)
            dicts["trip_id"] = strTripID
            
        }
        guard let lat = dicts["latitude"] as? String else {return}
        guard let lang = dicts["longitude"] as? String else {return}
        print("lat",lat)
        print("lang",lang)
        guard !lat.isEmpty && !lang.isEmpty else{return}
        
        let homeVm = HandyHomeViewModel()
        homeVm.getCurrentLocation { (location) in
            location.getAddress { (address) in
                if let address = address {
                    dicts["address"] = address
                    ConnectionHandler.shared.getRequest(for: .updateDriverLocation,
                                                           params: dicts,
                                                           showLoader: false)
                        .responseJSON({ (json) in
                            debug(print: "lat : \(lat) , long: \(lang)")
                            guard !json.isSuccess else{
                                if json.int("status_code") == 2 {
                                    NotificationEnum.addressRefresh.postNotification()
                                }
                                return
                            }
                            print("Error Here")
                        }).responseFailure({ (error) in
                            
                        })
                }
            }
        }
        
    }
    
    func createRegion(location:CLLocation?) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let coordinate = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            let regionRadius = 50.0
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude),
                                          radius: regionRadius,
                                          identifier: "aabb")
            
            region.notifyOnExit = true
            region.notifyOnEntry = true
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startMonitoring(for: region)
        }
        else {
            print("System can't track regions")
        }
    }
    
    // update the location
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited Region")
        locationManager.stopMonitoring(for: region)
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        debug(print: locations.last?.coordinate.location.description ?? "")
        if UIApplication.shared.applicationState == .active {
            updateCurrentLocationToServer()
        } else {
            //App is in BG/ Killed or suspended state
            //send location to server
            // create a New Region with current fetched location
            let location = locations.last
            lastLocation = location
            updateCurrentLocationToServer()
            //Make region and again the same cycle continues.
            self.createRegion(location: lastLocation)
        }
    }
    func getDistanceFromPreviousLocation(latitude: String, longitude: String) -> String {
        
        if strOldLatitude == "" && strOldLongitude == "" {
            strOldLatitude = strLatitude
            strOldLongitude = strLongitude
        }
        let userLocation = CLLocation(latitude: Double(strOldLatitude)!, longitude: Double(strOldLongitude)!)
        let priceLocation = CLLocation(latitude: Double(strLatitude)!, longitude: Double(strLongitude)!)
        
        
        if latitude == "" && longitude == "" {
            strOldLatitude = strLatitude
            strOldLongitude = strLongitude
        } else{
            
            strOldLatitude = latitude
            strOldLongitude = longitude
        }
        
        let distanceInKm = String(format: "%.2f", userLocation.distance(from: priceLocation)/1000)
        print("Distance is KM is:: \(distanceInKm)")
        return distanceInKm
        
    }
    
    
    //FCM Get tocken methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
      
        //CallManager.instance.registerForPushNotificaiton(token: deviceToken, forApplicaiton: application)
        Messaging.messaging().apnsToken = deviceToken
        //InstanceID.instanceID().token()
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                let refreshedToken = result.token
//                print("Remote instance ID token: \(refreshedToken)")
//                print("InstanceID token: \(refreshedToken))")
//                Constants().STOREVALUE(value: refreshedToken, keyname: USER_DEVICE_TOKEN)
//                let userStatus = self.userDefaults.value(forKey: USER_ACCESS_TOKEN) as? String
//                if (userStatus != nil && userStatus != "")
//                {
//                    self.sendDeviceTokenToServer(strToken: refreshedToken)   // UPDATING DEVICE TOKEN FOR LOGGED IN USER
//                }
//                else{
//                    self.tokenRefreshNotification()
//                }
//            }
//        }
//        if let refreshedToken = InstanceID.instanceID() {
//            print("InstanceID token: \(refreshedToken)")
//
//            Constants().STOREVALUE(value: refreshedToken, keyname: USER_DEVICE_TOKEN)
//
//            //IF LOGGED IN USER ONLY
//            let userStatus = userDefaults.value(forKey: USER_ACCESS_TOKEN) as? String
//            if (userStatus != nil && userStatus != "")
//            {
//                self.sendDeviceTokenToServer(strToken: refreshedToken)   // UPDATING DEVICE TOKEN FOR LOGGED IN USER
//            }
//            else{
//                tokenRefreshNotification()
//            }
//        }
        
    }
    
    // get refersh the token
    func tokenRefreshNotification() {
//       InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                 let refreshedToken = result.token
//                print("Remote instance ID token: \(refreshedToken)")
//                print("InstanceID token: \(String(describing: refreshedToken))")
//                Constants().STOREVALUE(value: refreshedToken, keyname: USER_DEVICE_TOKEN)
//                self.connectToFcm()
//            }
//        }
        
        
    }
    // Cannect the FCM
//    func connectToFcm() {
//
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//                return
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//            }
//        }
//
////        guard InstanceID.instanceID().token() != nil else {
////            // Won't connect since there is no token
////            return
////        }
//        // Disconnect previous FCM connection if it exists.
//        if Messaging.messaging().isDirectChannelEstablished{
//            print("Connected to FCM.")
//        } else {
//            print("Disconnected from FCM.")
//        }
//
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
            //CallManager.instance.didReceivePush(notification: userInfo)
       
    }
    
    // }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Error = ",error.localizedDescription)
    }
    
    func forcePresent(theController vc : UIViewController){
        if let nav = self.window?.rootViewController as? UITabBarController{
            nav.present(vc, animated: true, completion: nil)
        }else if let nav = self.window?.rootViewController as? UINavigationController{
            nav.present(vc, animated: true, completion: nil)
        }else if let root = self.window?.rootViewController{
            root.present(vc, animated: true, completion: nil)
        }

    }
    func getAvailableViewController() -> UIViewController?{
       
        if let root = self.window?.rootViewController as? UITabBarController{
            return root.viewControllers?.first ?? root
        }else if let nav = self.window?.rootViewController as? UINavigationController{
            return nav
        }
        return nil
    }
    

    var player: AVAudioPlayer?
    let AUDIO_PLAY_SPEED = 0.7
    let myThread = DispatchQueue.init(label: "MyThread")
    var continuePlaying = true
    func loopAndPlay(){
        
        //guard CallManager.instance.callState == .none else{return}
        self.myThread.async {
            while self.continuePlaying{
                self.playSound("ub__reminder")
                sleep(1)
            }
        }
        
    }
    func playSound(_ fileName: String) {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    //MARK: ShowRequestPage
    
    func showRequestPage(dict : NSDictionary){
        let info: [AnyHashable: Any] = [
            "pickup_latitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_latitude"),
            "pickup_longitude" : UberSupport().checkParamTypes(params:dict, keys:"pickup_longitude"),
            "request_id" : UberSupport().checkParamTypes(params:dict, keys:"request_id"),
            "pickup_location" : UberSupport().checkParamTypes(params:dict, keys:"pickup_location"),
            "min_time" : UberSupport().checkParamTypes(params:dict, keys:"min_time"),
            "drop_location" : UberSupport().checkParamTypes(params:dict, keys:"drop_location") ,
            "just_launched" : false,
            "is_pool" : dict["is_pool"] as? Int ?? 0,
            "seat_count" : UberSupport().checkParamTypes(params:dict, keys:"seat_count")
            ]
//        if let root = self.rootTabBar{
//            root.selectedIndex = 0
            NotificationCenter.default.post(name: NSNotification.Name.ResquestRide, object: self, userInfo: info)
//        }else{
//            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                //info["just_launched"] = true
//                NotificationCenter.default.post(name: NSNotification.Name.ResquestRide, object: self, userInfo: info)
//            }
//        }
    }
    
    
    //MARK: ----- UPDATING DEVICE TO SERVER -----
    func sendDeviceTokenToServer(strToken: String)
    {
        var devicetoken = strToken
        if devicetoken.isEmpty {
            devicetoken = UserDefaults.standard.string(forKey: USER_ACCESS_TOKEN) ?? ""
        }
        Constants().STOREVALUE(value: strToken, keyname: USER_DEVICE_TOKEN)
        //        guard (self.userDefaults.value(forKey: USER_ACCESS_TOKEN) as? String) != nil else { return }
        guard !devicetoken.isEmpty else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.tokenRefreshNotification()
            }
            return
        }
        if !Constants().GETVALUE(keyname: USER_ACCESS_TOKEN).isEmpty {
            var dicts = JSON()
            dicts["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
           // dicts["device_id"] = String(format:"%@",strToken)
            dicts["device_id"] = Constants().GETVALUE(keyname: USER_DEVICE_TOKEN)//strDeviceToken
    //        guard !strToken.isEmpty,!token.isEmpty else {
    //            return
    //        }
            ConnectionHandler.shared.getRequest(for: .updateDeviceToken, params: dicts, showLoader: false).responseJSON { (json) in
                if !json.isSuccess{
                  
                    debug(print: json.status_message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                          self.sendDeviceTokenToServer(strToken: Constants().GETVALUE(keyname :USER_DEVICE_TOKEN))
                    }
                  
                }
            }.responseFailure({ (error) in
                debug(print: error)
            })
        }
       
      
    }
    
    // MARK: - Display Toast Message
    // MARK: - Display Toast Message
      func createToastMessage(_ strMessage:String,
                              bgColor: UIColor = .PrimaryColor,
                              textColor: UIColor = .PrimaryTextColor) {
          if #available(iOS 13.0, *) {
              guard let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive || $0.activationState == .background || $0.activationState == .foregroundInactive})
                        .compactMap({$0 as? UIWindowScene})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first else { return }
              let lblMessage=UILabel(frame: CGRect(x: 0,
                                                   y: keyWindow.frame.height + 70,
                                                   width: keyWindow.frame.size.width,
                                                   height: 70))
              lblMessage.tag = 500
              lblMessage.text = NetworkManager.instance.isNetworkReachable ? strMessage : CommonError.connection.localizedDescription
              lblMessage.textColor = .PrimaryTextColor
              lblMessage.backgroundColor = .PrimaryColor
              lblMessage.font = .MediumFont(size: 15)
              lblMessage.textAlignment = NSTextAlignment.center
              lblMessage.numberOfLines = 0
              lblMessage.layer.shadowColor = UIColor.PrimaryColor.cgColor;
              lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
              lblMessage.layer.shadowOpacity = 0.5;
              lblMessage.layer.shadowRadius = 1.0;
              moveLabelToYposition(lblMessage,
                                   win: keyWindow)
              keyWindow.addSubview(lblMessage)
          } else {
              guard let window = windowKey else{return}
              let lblMessage=UILabel(frame: CGRect(x: 0,
                                                   y: window.frame.size.height + 70,
                                                   width: window.frame.size.width,
                                                   height: 70))
              lblMessage.tag = 500
              lblMessage.text = NetworkManager.instance.isNetworkReachable ? strMessage : CommonError.connection.localizedDescription
              lblMessage.textColor = .PrimaryTextColor
              //        lblMessage.backgroundColor = .ThemeMain//bgColor
              lblMessage.backgroundColor = .PrimaryColor
              //        lblMessage.font = UIFont(name: G_MediumFont, size: CGFloat(15))
              lblMessage.font = .MediumFont(size: 15)
              lblMessage.textAlignment = NSTextAlignment.center
              lblMessage.numberOfLines = 0
              //        lblMessage.layer.shadowColor = UIColor.ThemeMain.cgColor;
              lblMessage.layer.shadowColor = UIColor.PrimaryColor.cgColor;
              lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
              lblMessage.layer.shadowOpacity = 0.5;
              lblMessage.layer.shadowRadius = 1.0;
              
              moveLabelToYposition(lblMessage,
                                   win: window)
              windowKey?.addSubview(lblMessage)
          }
      }
    
    func downTheToast(lblView:UILabel,
                      forView:UIView) {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut ,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (forView.frame.size.height)-70,
                                   width: (forView.frame.size.width),
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            self.closeTheToast(lblView,
                               forView: forView)
        })
    }
    
    func closeTheToast(_ lblView:UILabel,
                       forView:UIView) {
        UIView.animate(withDuration: 0.3,
                       delay: 3.5,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (forView.frame.size.height)+70,
                                   width: (forView.frame.size.width),
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            lblView.removeFromSuperview()
        })
    }
    
    func moveLabelToYposition(_ lblView:UILabel,
                              win: UIWindow) {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (win.frame.size.height)-70,
                                   width: win.frame.size.width,
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            self.onCloseAnimation(lblView,
                                  win: win)
        })
    }
    
    // Remove toast message
    func onCloseAnimation(_ lblView:UILabel,
                          win: UIWindow) {
        UIView.animate(withDuration: 0.3,
                       delay: 3.5,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            lblView.frame = CGRect(x: 0,
                                   y: (win.frame.size.height)+70,
                                   width: (win.frame.size.width),
                                   height: 70)
        }, completion: { (finished: Bool) -> Void in
            lblView.removeFromSuperview()
        })
    }
    
    
    func createToastMessageForAlamofire(_ strMessage:String, bgColor: UIColor, textColor: UIColor, forView:UIView)
    {
        let lblMessage=UILabel(frame: CGRect(x: 0, y: (forView.frame.size.height)+70, width: (forView.frame.size.width), height: 70))
        lblMessage.tag = 500
        lblMessage.text = NetworkManager.instance.isNetworkReachable ? NSLocalizedString(strMessage, comment: "") : CommonError.connection.localizedDescription
        lblMessage.textColor = .PrimaryTextColor
        lblMessage.backgroundColor = .PrimaryColor
//        lblMessage.font = UIFont(name: G_MediumFont, size: CGFloat(15))
        lblMessage.font = .MediumFont(size: 15)
        lblMessage.textAlignment = NSTextAlignment.center
        lblMessage.numberOfLines = 0
//        lblMessage.layer.shadowColor = UIColor.ThemeMain.cgColor;
        lblMessage.layer.shadowColor = UIColor.PrimaryColor.cgColor;
        lblMessage.layer.shadowOffset = CGSize(width:0, height:1.0);
        lblMessage.layer.shadowOpacity = 0.5;
        lblMessage.layer.shadowRadius = 1.0;
        
        downTheToast(lblView: lblMessage, forView: forView)
        self.windowKey?.addSubview(lblMessage)
    }
    
//    func downTheToast(lblView:UILabel, forView:UIView) {
//
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
//            lblView.frame = CGRect(x: 0, y: (forView.frame.size.height)-70, width: (forView.frame.size.width), height: 70)
//        }, completion: { (finished: Bool) -> Void in
//            self.closeTheToast(lblView, forView: forView)
//        })
//    }
//
//    func closeTheToast(_ lblView:UILabel, forView:UIView)
//    {
//        UIView.animate(withDuration: 0.3, delay: 3.5, options: UIView.AnimationOptions(), animations: { () -> Void in
//            lblView.frame = CGRect(x: 0, y: (forView.frame.size.height)+70, width: (forView.frame.size.width), height: 70)
//        }, completion: { (finished: Bool) -> Void in
//            lblView.removeFromSuperview()
//        })
//    }
}

//MARK:- Background task
extension AppDelegate{
    
    fileprivate func terminateBackgroundThread() {
        print("Background task ended.")
        guard backGroundThread != .invalid else{return}
        UIApplication.shared.endBackgroundTask(backGroundThread)
        self.backGroundThread = .invalid
    }
}

extension AppDelegate{
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if let scheme = url.scheme,
            scheme.localizedCaseInsensitiveCompare(DriveriTunes().appName) == .orderedSame{
            return true
        }
        if BrainTreeHandler.isBrainTreeHandleURL(url,
                                                 options: options) {
            return true
        }else if StripeHandler.isStripeHandleURL(url) {
            return true
        }
        return true
    }

    func testStamp(){
        let hanlder = CoreDataHandler<TestDate>()
        hanlder.store(data: TestDate(stamp: Date()))
        hanlder.getData { (dates) in
            debug(print: dates.count.description)
        }
    }
    static var shared : AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
}
extension UIApplication {
    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            } else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        return topViewController
    }
}

extension AppDelegate: SinchManagedPushDelegate {
  func managedPush(_ managedPush: SinchManagedPush,
                   didReceiveIncomingPushWithPayload payload: [AnyHashable: Any], for type: String) {
    os_log("didReceiveIncomingPushWithPayload: %{public}@", log: self.customLog, payload.description)

    // Since iOS 13 the application must report an incoming call to CallKit if a VoIP push notification was used, and
    // this must be done within the same run loop as the push is received (i.e. GCD async dispatch must not be used). See
    // https://developer.apple.com/documentation/pushkit/pkpushregistrydelegate/2875784-pushregistry for details.
    self.callKitMediator.reportIncomingCall(withPushPayload: payload, withCompletion: { err in

      // It has to be the same GCD queue as PKPushKit deliver notification on
      // (as we must report to CallKit within the same runloop, see above),
      // so this dispatch to main queue is here because we also want customer to only interact with SinchClient
      // on a single thread (we make no guarantees that SinchClient is thread safe).
      DispatchQueue.main.async {
        self.handlePushNotification(withInfo: payload)
      }

      if err != nil {
        os_log("Error when reportintg call to CallKit: %{public}@",
               log: self.customLog, type: .error, err!.localizedDescription)
      }
    })
  }
}

// MARK: CallKitMediatorDelegate

extension AppDelegate: SinchClientMediatorDelegate {
  func handleIncomingCall(_ call: SinchCall) {
    self.transitionToCallView(call)
  }
}

extension LogSeverity {
  func osLogType() -> OSLogType {
    switch self {
    case .info: return .default
    case .critical: return .fault
    case .warning: return .default
    case .trace: return .debug
    default: return .default
    }
  }
}
