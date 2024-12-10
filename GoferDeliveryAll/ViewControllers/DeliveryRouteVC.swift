/**
 * RouteVC.swift
 *
 * @package GoferDriver
 * @author Trioangle Product Team
 * @version - Stable 1.0
 * @link http://trioangle.com
 */

import UIKit
import AVFoundation
import Foundation
import GoogleMaps
import Alamofire
import CoreLocation
//MARK: - PROTOCOL
protocol passLatitudeLongitudes {
    func passLatLong(orderID: Int,tripModel:TripDataModel)
}
class DeliveryRouteVC : BaseVC, GMSMapViewDelegate {
     //MARK: - OUTLETS
    @IBOutlet weak var routeView:DeliveryRouteView!
    
    
    //MARK:- Varaibles
//    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var deliveryOrderId = 0
    var reDeliveryOrderID = 0
    var reqID = 0
    var isReScheduled : Bool = false
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var updateTripHistory : UpdateContentProtocol?
   
    var tripDetailsModel : DeliveryOrderDetail? = nil
    
    var lastDirectionAPIHitStamp : Date?
    
    
    var tripDataModel : TripDataModel!
    var endTripModel : EndTripModel!
    var pendingTrips = [TripDataModel]()
    
    var isTripStarted : Bool = false

    
//    lazy var langugage : LanguageProtocol = {return LanguageEnum.default.object}()
   
   
    var shouldPopToRootVC = Bool()
    var shouldPopToOrdersVC = Bool()

    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    lazy var tripCache = TripCache()
    var isNetworkReachable : Bool?
    var getTripID : String{
        return self.tripDataModel.order_details?.description ?? ""
    }
    var timerForETA : Timer? = nil
    let deliveryRouteVM  = DeliveryRouteVM()
    var groupID = ""
    var multipleDelivery = ""
    
    var contactless_delivery = ""
    var ispopshow = false
    var popupMsg = ""
    // MARK: - ViewController Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ispopshow{
            showSimpleAlert()
        }
    }
    
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: LangCommon.message, message: self.popupMsg, preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    override var stopSwipeExitFromThisScreen: Bool? {
        return true
    }
   
//    func fetchDeliveryHistory(){
//       
//        ConnectionHandler.shared
//            .getRequest(for: .getDeliveryHistory,
//                        params: [:], showLoader: true)
//            .responseJSON({ (response) in
//                
//                print("Driver Delivery History",response)
//                self.pendingTrips = response
//                    .array("today_delivery")
//                    .compactMap({TripDataModel(resuaruntJSON: $0)})
////                Shared.instance.pendingTrips = self.pendingTrips
//            }).responseFailure({ (error) in
//                
//            })
//    }
    //MARK:- deiniti initalized objects on exit
    deinit {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.routeView.deinitObjects()
    }
    
    //MARK:- initializers
    
    
    func initNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.driverCancelledTrip),
                                               name: .TripCancelledByDriver,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.riderCancelledTrip),
                                               name: .TripCancelled,
                                               object: nil)
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        self.timerForETA = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] (_) in
            self?.routeView.calculateETA()
        }
 
    }
    func deinitNotifications(){
        NotificationCenter.default.removeObserver(self,
                                                  name: .TripCancelledByDriver,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .TripCancelled,
                                                  object: nil)
        self.timerForETA?.invalidate()
    }
    
    
    func showAlertForThirdPartyNavigation(){
        guard let data = self.routeView.tripManager?.tripDetailModel else{return}
        guard let pickupCoordinate = self.routeView.tripManager?.lastDriverLocation?.coordinate else{return}
        let dropCoordinate = data.getDestination.coordinate
                   
        
                   
        let actionSheetController = UIAlertController(
            title: LangDeliveryAll.hereYouCanChangeYourMap,
            message: LangDeliveryAll.byClickingBelowActions,
            preferredStyle: .actionSheet)
        actionSheetController
            .addColorInTitleAndMessage(titleColor: UIColor.black,
                                       messageColor: UIColor.black,
                                       titleFontSize: 15,
                                       messageFontSize: 13)
        let googleMapAction = UIAlertAction(title: "Google Map", style: .default) { (action) in
            self.showThirdPartyNavigation(for: .google(pickup: pickupCoordinate,
                                                       drop: dropCoordinate))
        }//LangDeliveryAll.googleMap
        googleMapAction.setValue(UIColor.TertiaryColor, forKey: "TitleTextColor")
        let wazeMapAction = UIAlertAction(title: "Waze Map", style: .default) { (action) in
            self.showThirdPartyNavigation(for: .waze(pickup: pickupCoordinate,
                                                     drop: dropCoordinate))
        }//LangDeliveryAll.wazeMap
        wazeMapAction.setValue(UIColor.TertiaryColor, forKey: "TitleTextColor")
        let cancelAction: UIAlertAction = UIAlertAction(title: LangCommon.cancel, style: .cancel) { action -> Void in }
        actionSheetController.addAction(googleMapAction)
        actionSheetController.addAction(wazeMapAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: false, completion: nil)
    }
    //MARK:- showThirdPartyNavigation
    func showThirdPartyNavigation(for party : ThirdPartyNavigation){
        if party.isApplicationAvailable{
            party.openThirdPartyDirection()
        }else{
            let alert = UIAlertController(
                title: LangDeliveryAll.doYouWantToAccessDirection,
                message: party.getDownloadPermissionText,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LangDeliveryAll.ok.uppercased(), style: .default, handler: { (action) in
                party.openAppStorePage()
            }))
            alert.addAction(UIAlertAction(title: LangDeliveryAll.cancel.capitalized, style: .cancel, handler: nil))
            self.present(alert, animated: true)
        
        }
    }
  

    
    // driver callcel the trip
    @objc func driverCancelledTrip()
    {
        
        NotificationCenter.default.removeObserver(self, name:UIApplication.didEnterBackgroundNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name:UIApplication.didBecomeActiveNotification, object:nil)
        self.routeView.tripManager?.removeAllTripRelatedDataFromLocal()
    }
    // Rider cancel the trip
    @objc func riderCancelledTrip(notification: Notification)
    {
        NotificationCenter.default.removeObserver(self, name:UIApplication.didEnterBackgroundNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name:UIApplication.didBecomeActiveNotification, object:nil)
        Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        self.appDelegate.onSetRootViewController(viewCtrl: self)
        
    }
    


    
  
    //MARK:- initWithStory
    class func initWithStory(_ orderId : Int) -> DeliveryRouteVC{
        let view : DeliveryRouteVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
        view.deliveryOrderId = orderId
        return view
    }
    class func initWithStoryForModel(_ model : OrderDetailHolder) -> DeliveryRouteVC{
        let view : DeliveryRouteVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
        view.tripDetailsModel = model.orderDetails
        return view
    }
    //MARK:- ETA Calculation
    
   
    //MARK: - GOOGLE API CALL
    /*
     FOR GETTING DRAW POINTS FROM GOOGLE DIRECTION API
     */

    
    
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        loadDataAppear()
       
    }
    
    func loadDataAppear() {
        self.navigationController?.navigationBar.isHidden = true
        if let data = self.routeView.tripManager?.tripDetailModel{
            self.routeView.updateDestination(with: data)
          
        }
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Shared.instance.resumeTripHitCount = 1
       
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    
    
    

    //MARK: - Change Map Style
    /*
     Here we are changing the Map style from Json File
     */
    
    


    //MARK:- set refresh Payment node 0 as initial
    
    
}






extension UINavigationController {
    public func hasViewController(ofKind kind: AnyClass) -> UIViewController? {
        return self.viewControllers.first(where: {$0.isKind(of: kind)})
    }
}

