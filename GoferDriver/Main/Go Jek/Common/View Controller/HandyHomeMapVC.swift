//
//  HandyHomeMapVC.swift
//  GoferHandyProvider
//
//  Created by trioangle on 28/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//
import UIKit
import Foundation
import FirebaseDatabase
import Firebase
import GeoFire
import ARCarMovement
import GoogleMaps
import SwiftUI

class HandyHomeMapVC: BaseVC,ARCarMovementDelegate {
    func arCarMovementMoved(_ marker: GMSMarker) {
        
    }
    
    //--------------------------
    //MARK: - Outlets
    //--------------------------
    @IBOutlet var handyHomeMapView: HandyHomeMapView!
    
    @IBOutlet weak var homealert: UILabel!
    @IBOutlet var alertview: UIView!
    //--------------------------
    //MARK: - Local Variables
    //--------------------------
    
    var homeViewModel : HandyHomeViewModel!
    var menuPresenter : MenuPresenter!
    var ref: DatabaseReference!
    var currentRequestID : String? = nil
    var userID = String()
    var gojekhomeVM : GojekHomeVM!
    var is_company = ""
    var is_company_check = Bool()
    var isStatusChecked = Bool()
    var checkstatuss = Int()
    var driverMarker: GMSMarker!
    var moveMent: ARCarMovement!
    var oldCoordinate: CLLocationCoordinate2D!
    //Gofer splitup start
    var selectedServiceListArray:Array<ServiceTypes> = []
    //Gofer splitup end

    fileprivate var locationHandler : LocationHandlerProtocol?
    //---------------------------------------
    //MARK: - life Cycle or Overide Function
    //---------------------------------------
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?

    override
    func viewDidLoad() {
        super.viewDidLoad()
      
        self.userID = UserDefaults.value(for: .user_id) ?? ""
        self.ref = Database.database().reference().child(firebaseEnvironment.rawValue)
        AppDelegate.shared.pushManager.registerForRemoteNotification()
        self.removeNotification()
        self.initNotificationObservers()
        moveMent = ARCarMovement()
        moveMent.delegate = self
        self.getUserData(showloader: false)

        geoFireRef = Database.database().reference().child(firebaseEnvironment.rawValue).child("GeoFire")
            geoFire = GeoFire(firebaseRef: geoFireRef!)
        
        deinitNotification()
        //Handy_NewSplitup_Start
        initNotification()
        if self.checkstatuss == 1 {
            self.handyHomeMapView.customSwitchHolder.isHidden = false
        } else {
            self.handyHomeMapView.customSwitchHolder.isHidden = true
        }
        //Handy_NewSplitup_End
    
    }
    
    func updateEnablePermissionPopup() {
        self.locationHandler?.startListening(toLocationChanges: true)
    }
    // MARK: - ARCarMovementDelegate
    func arCarMovement(_ movedMarker: GMSMarker) {
        
        driverMarker = movedMarker
        driverMarker.map = self.handyHomeMapView.map

    }
    
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCountryList()
        self.handyHomeMapView.BottomViewPrepartion()
        self.navigationController?.navigationBar.isHidden = true
        self.updateEnablePermissionPopup()
        self.getUserData(showloader: true)
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        self.getUserData(showloader: true)
    }
    func setAlertView(isShow:Bool){
        if isShow{
            alertview.isHidden = false
           // if self.isStatusChecked == true {
                self.handyHomeMapView.customSwitchHolder.isHidden = true
          //  } else {
              //  self.handyHomeMapView.customSwitchHolder.isHidden = false
           // }
            self.handyHomeMapView.map?.addSubview(alertview)
            self.alertview.bringSubviewToFront(handyHomeMapView.map!)
            alertview.frame = CGRect(x: self.handyHomeMapView.frame.width / 2 - 150 , y: self.handyHomeMapView.frame.height / 5 - 75 , width: 300, height: 150)
        }else{
            self.alertview.removeFromSuperview()
            self.alertview.isHidden = true
            if self.checkstatuss == 1 {
                self.handyHomeMapView.customSwitchHolder.isHidden = false
            } else {
                self.handyHomeMapView.customSwitchHolder.isHidden = true
            }
        }
        
    }
    func updateGeofire()
    {
        //self.oldCoordinate = self.homeViewModel.locationHandler?.lastKnownLocation?.coordinate
        self.homeViewModel.getCurrentLocation { (location) in
            self.handyHomeMapView.lat = location.coordinate.latitude
            self.handyHomeMapView.long = location.coordinate.longitude
        
            self.moveMent.arCarMovement(marker: self.driverMarker, oldCoordinate: self.oldCoordinate, newCoordinate: location.coordinate, mapView: self.handyHomeMapView.map ?? GMSMapView(), bearing: 0.0)
            
            
            self.oldCoordinate = location.coordinate
    //        let newStatus = Constants().GETVALUE(keyname: USER_ONLINE_STATUS)
    //        let vehiclId : String = UserDefaults.value(for: .vehicle_id) ?? ""
            let userId = Constants().GETVALUE(keyname: USER_ID)
            guard !userId.isEmpty else{return}
            if DriverTripStatus.default == .Online{
                let location:CLLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.geoFire?.setLocation(location, forKey: userId)// vehiclId + "_" +
            }else{
                self.geoFire?.removeKey( userId)//vehiclId + "_" +
            }
        }
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    //---------------------------------------
    //MARK: - init with Story Board
    //---------------------------------------
    class func initWithStory() -> HandyHomeMapVC {
        let vc : HandyHomeMapVC = UIStoryboard.gojekCommon.instantiateViewController()
        vc.homeViewModel = HandyHomeViewModel()
        vc.menuPresenter = MenuPresenter()
        vc.gojekhomeVM = GojekHomeVM()
        return vc
    }
    func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    @objc func getEssentialsApiCallforpush() {
        Shared.instance.resumeTripHitCount = 0
        self.homeViewModel.getEssentials(){ (json) in
            switch json{
            case .success(let profile):
                dump(profile)
                if profile.status_code == 1{
                    //Gofer splitup start
                    //Laundry splitup start
                    //Instacart splitup start
                    //Deliveryall splitup start
                    //Handy_NewSplitup_Start
                    if profile["order_details"] != nil {
                        //New_Delivery_splitup_Start
                        // Laundry_NewSplitup_start

                        do {
                            // Laundry_NewSplitup_start
                            

                        } catch {
                            print("error")
                        }
                        //Deliveryall_Newsplitup_start
                        // Laundry_NewSplitup_start
                            
                            let model = JobDetailModel(profile)
                            if model.statusCode != "0" {
                                if model.getCurrentTrip()?.jobStatus == .payment {
                                    self.route2Payment(forTrip: model)
                                }else{
                                    self.routeInCompleteTrips(model)
                                }
                            }
                            
                        }
                      
                            // Handy Splitup Start
                            //New_Delivery_splitup_Start
                            // Laundry_NewSplitup_start
                        // Laundry_NewSplitup_end
                        //New_Delivery_splitup_End
                        //New Delivery splitup End
                     //Handy_NewSplitup_End
                        // Handy Splitup End

                    //delivery splitup end
                    //Gofer splitup end
                    //Laundry splitup End
                    //Instacart splitup End
                    self.handyHomeMapView.setHeatMap()
                        //Handy_NewSplitup_Start
                    //Deliveryall_Newsplitup_start
                }

                //Deliveryall_Newsplitup_end
                    //Delivery Splitup End
                    //Handy_NewSplitup_End
                let model = JobDetailModel(profile)
                if model.statusCode != "0" {
                    if model.getCurrentTrip()?.jobStatus == .payment {
                        self.route2Payment(forTrip: model)
                    }else{
                        self.routeInCompleteTrips(model)
                    }
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    func getEssentialsApiCall() {
        self.homeViewModel.getEssentials(){ (json) in
            switch json{
            case .success(let profile):
                if profile.status_code == 1{
                    //Gofer splitup start
                    //Laundry splitup start
                    //Instacart splitup start
                    //Deliveryall splitup start
                    //Handy_NewSplitup_Start
                    if profile["order_details"] != nil {
                        //New_Delivery_splitup_Start
                        // Laundry_NewSplitup_start
                        
                        do {
                            // Laundry_NewSplitup_start
                            
                            
                        } catch {
                            print("error")
                        }
                        //Deliveryall_Newsplitup_start
                        // Laundry_NewSplitup_start
                            let model = JobDetailModel(profile)
                            Shared.instance.isMultiTrip = ((model.getCurrentTrip()?.isMultiTrip) != nil)
                            if model.statusCode != "0" {
                                if model.getCurrentTrip()?.jobStatus == .payment {
                                    self.route2Payment(forTrip: model)
                                }else{
                                    self.routeInCompleteTrips(model)
                                }
                            }
                            
                            
                            //Deliveryall_Newsplitup_end
                            //Handy_NewSplitup_Start
                            //New Delivery splitup Start

                           

                        
                    
                            // InstaCart_NewSplitup_end
                        
                    }
                    else{
                        //New_Delivery_splitup_Start
                        // Laundry_NewSplitup_start
                        
                        do {
                            // Laundry_NewSplitup_start
                            
                            
                        } catch {
                            print("error")
                        }
                        //Deliveryall_Newsplitup_start
                        // Laundry_NewSplitup_start
                            let model = JobDetailModel(profile)
                            Shared.instance.isMultiTrip = ((model.getCurrentTrip()?.isMultiTrip) != nil)
                            if model.statusCode != "0" {
                                if model.getCurrentTrip()?.jobStatus == .payment {
                                    self.route2Payment(forTrip: model)
                                }else{
                                    self.routeInCompleteTrips(model)
                                }
                            }
                            
                            
                            //Deliveryall_Newsplitup_end
                            //Handy_NewSplitup_Start
                            //New Delivery splitup Start

                           

                        
                    
                            // InstaCart_NewSplitup_end
                        //Deliveryall_Newsplitup_start
                    }
                    //Deliveryall_Newsplitup_end
                        // Gofer_NewSplitup_end
                        // Laundry_NewSplitup_end
                        //New_Delivery_splitup_End
                        //New Delivery splitup End
                     //Handy_NewSplitup_End
                        // Handy Splitup End

                    //delivery splitup end
                    //Gofer splitup end
                    //Laundry splitup End
                    //Instacart splitup End
                    self.handyHomeMapView.setHeatMap()
                        //Handy_NewSplitup_Start
                    //Deliveryall_Newsplitup_start
                }
                //Deliveryall_Newsplitup_end
                    //Delivery Splitup End
                    //Handy_NewSplitup_End
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //Gofer splitup start
    //New_Delivery_splitup_Start
    //Laundry splitup Start
    //Instacart splitup start
    //Deliveryall splitup start
    //Deliveryall_Newsplitup_start
    func getMyServicesAPI() {
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    //Deliveryall_Newsplitup_end
    //Deliveryall splitup end
    //Gofer splitup end
    //New_Delivery_splitup_End
    //Laundry splitup End
    //Instacart splitup End
    //----------------------------
    //MARK: - remove Notification
    //----------------------------
    
    func removeNotification() {
        NotificationEnum.addressRefresh.removeObserver(self)
        NotificationCenter.default.removeObserver(
            self,
            name: .ResquestJob,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .JobHistory,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .ShowHomePage_job,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .PaymentSuccess_job,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .JobCancelled,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .JobCancelledByDriver,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .HandyShowAlertForJobStatusChange,
            object: nil
        )
        
        
        NotificationCenter.default.removeObserver(
            self,
            name: .GoferRequest,
            object: nil
        )
            
    }
    
    //---------------------------
    //MARK: - init Notification
    //--------------------------
    func initNotificationObservers(){
        NotificationEnum.addressRefresh.addObserver(
            self,
            selector: #selector(self.ProfileAddressRefresh(_:))
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.themeRefresh(_:)),
            name: .ThemeRefresher,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.goToJobHistory),
            name: NSNotification.Name.JobHistory,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.showThisPage),
            name: NSNotification.Name.ShowHomePage_job,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.getPaymentSuccess),
            name: NSNotification.Name.PaymentSuccess_job,
            object: nil
        )
        _ = PipeAdapter.createEvent(withName: "PaymentSuccess", dataAction: { (data) in
            if let json = data as? JSON{
                self.onPaymentSucces(json)
            }
        })
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.riderCancelledTrip),
            name: NSNotification.Name.JobCancelled,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.driverCancelledTrip),
            name: NSNotification.Name.JobCancelledByDriver,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.showAlertFrom(_:)),
            name: .HandyShowAlertForJobStatusChange,
            object: nil
        )
        //Gofer splitup start
        //Laundry splitup start
        //Instacart splitup start
        //Handy_NewSplitup_Start
        NotificationCenter.default.addObserver(self, selector: #selector(self.getProviderDetailsDelivery), name: NSNotification.Name.DeliveryResquestJob, object: nil)

        //Handy_NewSplitup_End
        //New Delivery splitup Start

        // Handy Splitup End
        //New_Delivery_splitup_Start

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.getProviderDetails),
            name: NSNotification.Name.ResquestJob,
            object: nil
        )
        //Handy_NewSplitup_Start
        NotificationCenter.default.addObserver(self, selector: #selector(self.getOrderDetails), name: NSNotification.Name.DeliveryAllRequest, object: nil)
        //Gofer splitup end
        //Mark:- Gofer observer
        //Deliveryall_Newsplitup_start
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.getDriverDetails),
            name: NSNotification.Name.GoferRequest,
            object: nil
        )

        //Instacart splitup end
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.instacartGetOrderDetails),
            name: NSNotification.Name.InstacartRequest,
            object: nil
        )
        //Laundry splitup end
        //Instacart splitup start
        NotificationCenter.default.addObserver(self, selector: #selector(self.laundryGetOrderDetails), name: NSNotification.Name.LaundryRequest, object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.driverassignfunc),
//                                               name: .storeassign,
//                                               object: nil)
        //Instacart splitup end

        //Handy_NewSplitup_End
        //New Delivery splitup End
        //Deliveryall_Newsplitup_end
        // Handy Splitup End
        //New_Delivery_splitup_End

    }
    //Laundry splitup start
    //Instacart splitup start
    
    func deinitNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name("order_assigned"),
                                                  object: nil)
    }
    //Handy_NewSplitup_Start
    func initNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.driverassignfunc(_:)),
                                               name: Notification.Name("order_assigned"),
                                               object: nil)
        NotificationEnum.getEssentialsApiCallForPush.addObserver(self, selector: #selector(self.getEssentialsApiCallforpush))
    }
    
    
    @objc func driverassignfunc(_ notification: Notification)
    {
        //New_Delivery_splitup_Start
        let str2 = notification.userInfo
        print(str2)
        
//        let story = UIStoryboard(name: "Trip", bundle: nil)
        let tripID = str2?["order_id"] as? String ?? String()
        if tripID != ""{
            // Laundry_NewSplitup_start
            // Laundry_NewSplitup_end
        }
        //New_Delivery_splitup_End
    }
    
    @objc
    func getProviderDetailsDelivery(notification: Notification) {
        //Deliveryall_Newsplitup_start
            let str2 = notification.userInfo
            if currentRequestID == str2?["request_id"] as? String {
                return
            }
            currentRequestID = str2?["request_id"] as? String
            self.navigationToDeliveryRequestVC(notification: notification)
        //Deliveryall_Newsplitup_end
        }

    //Handy_NewSplitup_End
   //New Delivery splitup Start

    // Handy Splitup End
   //New_Delivery_splitup_Start

    //Gofer splitup start
    //Handy_NewSplitup_Start
    @objc
    func  getOrderDetails(notification: Notification) {
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    //Instacart splitup end
    //Deliveryall splitup start
    //Deliveryall_Newsplitup_start
    @objc
    func  instacartGetOrderDetails(notification: Notification) {
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    //Laundry splitup end
    //Instacart splitup start
    @objc
    func  laundryGetOrderDetails(notification: Notification) {
    }

    //Handy_NewSplitup_End
    //Deliveryall_Newsplitup_end
    //Deliveryall splitup end

    //Laundry splitup start
    @objc
    func getProviderDetails(notification: Notification) {
        //Deliveryall_Newsplitup_start
        let str2 = notification.userInfo
        if currentRequestID == str2?["request_id"] as? String {
            return
        }
        currentRequestID = str2?["request_id"] as? String
        self.navigationToRequestVC(notification: notification)
        //Deliveryall_Newsplitup_end
    }
    //New_Delivery_splitup_End

    //Handy_NewSplitup_Start

    //Deliveryall splitup start
    //Deliveryall_Newsplitup_start
    func navigationToDeliveryRequestVC(notification: Notification) {
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }

    //Handy_NewSplitup_End
    //Deliveryall_Newsplitup_end
    //Deliveryall splitup end

    //Gofer splitup end
    //Laundry splitup end
    //Instacart splitup end
    //---------------------------
    //MARK: - payment Completion
    //---------------------------
    func onPaymentSucces(_ json : JSON){
        Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        self.commonAlert.setupAlert(alert: LangCommon.success,
                                    alertDescription: LangHandy.providerPaidSuccess,
                                    okAction: LangCommon.ok.capitalized)
        self.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            AppDelegate.shared.onSetRootViewController(viewCtrl: self)
        }
    }
    //New_Delivery_splitup_Start
    //---------------------------
    //MARK: - Navigate To Request
    //---------------------------
    //Gofer splitup start
    //Laundry splitup start
    //Instacart splitup start
    //Deliveryall splitup start
    //Deliveryall_Newsplitup_start
    func navigationToRequestVC(notification: Notification) {
        let handler = LocalCacheHandler()
        var dicts = JSON()
        let str2 = notification.userInfo
        dump(str2)
        dicts["request_id"] = str2?["request_id"] as? String ?? String()
        dicts["user_name"] = str2?["user_name"] as? String ?? String()
        dicts["address"] = str2?["address"] as? String ?? String()
        dicts["rating"] = str2?["rating"] as? String ?? String()
        dicts["requestTime"] = str2?["requestTime"] as? Int ?? Int()
        dicts["startTime"] = str2?["startTime"] as? String ?? String()
        dicts["endTime"] = str2?["endTime"] as? String ?? String()
        dicts["serviceName"] = str2?["serviceName"] as? String ?? String()
        dicts["bid_amount"] = str2?["bid_amount"] as? String ?? String()
        dicts["price_modal"] = str2?["price_modal"] as? String ?? String()
        dicts["min_bid"] = str2?["min_bid"] as? Int ?? Int()
        dicts["date"] = str2?["date"] as? String ?? String()
        dicts["time"] = str2?["time"] as? String ?? String()
        
        dump(dicts)
        handler.store(data: Data(),
                      apiName: str2?["request_id"] as? String ?? String(),
                      json: dicts,
                      entity: "Request")
        // Laundry_NewSplitup_start
        let topmostController = self.navigationController?.topViewController
        // Laundry_NewSplitup_end
    }
    //Handy_NewSplitup_Start
    //Gofer splitup end
    /*
     WHEN RIDER REQUEST TO RIDE
     */
    @objc func getDriverDetails(notification: Notification){
        // Laundry_NewSplitup_start
        let str2 = notification.userInfo
        let business_id = str2?["business_id"] as? String ?? String()
        print(business_id)
            
      
        // InstaCart_NewSplitup_start
        guard !RequestAcceptVC.ScreenIsActive,
              currentRequestID != str2?["request_id"] as? String else {
            return
        }
        if self.tabBarController?.selectedIndex != 0{
            self.tabBarController?.selectedIndex = 0
        }
        currentRequestID = str2?["request_id"] as? String
        
        self.ref.child("trip_request").child(self.userID).removeValue()
        
        let viewRequest = RequestAcceptVC.initWithStory()
      
        viewRequest.strRequestID = str2?["request_id"] as? String ?? String()
        viewRequest.strPickupLocation = str2?["pickup_location"] as? String ?? String()
        viewRequest.strPickupTime = str2?["min_time"] as? String ?? String()
        viewRequest.strPickUpLatitude = str2?["pickup_latitude"] as? String ?? String()
        viewRequest.strPickUpLongitude = str2?["pickup_longitude"] as? String ?? String()
        viewRequest.strDropLocation = str2?["drop_location"] as? String ?? String()
        viewRequest.isPoolRequest = (str2?["is_pool"] as? Int ?? 0) == 1
        viewRequest.startTime = str2?["startTime"] as? String ?? String()
        viewRequest.endTime = str2?["endTime"] as? String ?? String()
        viewRequest.requestTime = str2?["requestTime"] as? Int ?? Int()
        viewRequest.numberOfSeats = Int(str2?["seat_count"] as? String ?? "") ?? 0
        viewRequest.no_of_stops = Int(str2?["no_of_stops"] as? String ?? "") ?? 0

        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.viewControllers.last?.dismiss(animated: true, completion: nil)
        self.navigationController?.pushViewController(viewRequest, animated: true)
        // Laundry_NewSplitup_end
        // InstaCart_NewSplitup_end
        
    }
    @objc func TowgetDriverDetails(notification: Notification){
    }
    //Handy_NewSplitup_End
    //Laundry splitup end
    //Instacart splitup end
    //Deliveryall splitup end
    //Deliveryall_Newsplitup_end
    
    //New_Delivery_splitup_End
    
    func routeInCompleteTrips(_ trip : JobDetailModel){
        guard  let current = trip.getCurrentTrip() else{ return }
        switch current.jobStatus  {
           case .rating:
               self.route2Rating(forTrip: trip)
           case .cancelled,.completed:
               self.route2TripDetailsInfo(forTrip: trip)
           case .payment:
             self.route2Payment(forTrip: trip)
           case .scheduled,.beginTrip,.endTrip:
               self.route2TripScreen(forTrip: trip)
           default:
               print("")
           }
       }
    
    func route2TripScreen(forTrip tripDetail: JobDetailModel) {
        guard let trip = tripDetail.getCurrentTrip() else{  return }
        if !trip.pickupLat.isZero,
           !trip.pickupLng.isZero{
            let preference = UserDefaults.standard
            preference.set("\(trip.pickupLat),\(trip.pickupLng)", forKey: PICKUP_COORDINATES)
            ///preference.set(rider.pickup_latitude)
        }
        //Gofer splitup start
      
        //Laundry splitup start
        //Instacart splitup start
        //Deliveryall splitup start
        //New_Delivery_splitup_Start

        //Deliveryall_Newsplitup_start

        // Laundry_NewSplitup_start

            let tripView = ShareRouteVC.initWithStory(tripDataModel: nil,
                                                      tripId: (tripDetail.isPoolTrip && trip.jobStatus < .payment) ? 0 : trip.jobID,
                                                      tripStatus: trip.jobStatus)
            self.navigationController?.pushViewController(tripView, animated: true)
            //Gofer splitup start
            //Handy_NewSplitup_End
        // Laundry_NewSplitup_end
        //Gofer splitup end
        //New_Delivery_splitup_End
        //Laundry splitup end
        //Instacart splitup end
        //Deliveryall splitup end
        //Deliveryall_Newsplitup_end
    }
       
    func route2Payment(forTrip trip : JobDetailModel) {
        guard let currentTrip = trip.getCurrentTrip() else { return }
        let tripView = HandyPaymentVC.initWithStory(model: trip,
                                                    jobID: currentTrip.jobID,
                                                    jobStatus: currentTrip.jobStatus)
        tripView.isFromTripPage = false
        self.navigationController?.pushViewController(tripView,
                                                      animated: true)
    }
    func route2Rating(forTrip trip : JobDetailModel) {
        let propertyView = RateYourRideVC.initWithStory(trip: trip)
        propertyView.isFromTripPage = true
        self.navigationController?.pushViewController(propertyView,
                                                      animated: true)
    }
    
    func route2TripDetailsInfo(forTrip trip : JobDetailModel) {
    }
    
    func openChangeFontSheet() {
        let actionSheet = UIAlertController(title: "\(LangCommon.changeFont)", message: "", preferredStyle: .actionSheet)
        let ClanProFont = UIAlertAction(title: "Clan Pro \(LangCommon.font)", style: .default) { (_) in
            G_RegularFont = "ClanPro-Book"
            G_BoldFont = "ClanPro-Medium"
            G_MediumFont = "ClanPro-News"
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let GoogleSans = UIAlertAction(title: "Default \(LangCommon.font)", style: .default) { (_) in
            G_RegularFont = "GoogleSans-Regular"
            G_BoldFont = "GoogleSans-Bold"
            G_MediumFont = "GoogleSans-Medium"
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let cancelThemesAction = UIAlertAction(title: "\(LangCommon.cancel)", style: .destructive) { (_) in
            print("Font Selection Canceled")
        }
        actionSheet.addAction(ClanProFont)
        actionSheet.addAction(GoogleSans)
        actionSheet.addAction(cancelThemesAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openThemeSheet() {
        let actionSheet = UIAlertController(title: "\(LangCommon.changeTheme)", message: "", preferredStyle: .actionSheet)
        let brownThemeAction = UIAlertAction(title: "Brown \(LangCommon.theme)", style: .default) { (_) in
            UIColor.PrimaryColor = UIColor.init(hex: "964B00")
            UIColor.ThemeTextColor = UIColor.init(hex: "964B00")
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let yellowThemeAction = UIAlertAction(title: "Orange \(LangCommon.theme)", style: .default) { (_) in
            UIColor.PrimaryColor = UIColor.init(hex: "ff8308")
            UIColor.ThemeTextColor = UIColor.init(hex: "ff8308")
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let pinkThemeAction = UIAlertAction(title: "Violat \(LangCommon.theme)", style: .default) { (_) in
            UIColor.PrimaryColor = UIColor.init(hex: "9909b3")
            UIColor.ThemeTextColor = UIColor.init(hex: "9909b3")
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let makeDefault = UIAlertAction(title: "Default \(LangCommon.theme)", style: .default) { (_) in
            UIColor.PrimaryColor = UIColor.init(hex: ThemeColors?.string("PrimaryColor"))
            UIColor.ThemeTextColor = UIColor.init(hex: ThemeColors?.string("ThemeTextColor"))
            NotificationCenter.default.post(name: .ThemeRefresher, object: nil)
        }
        let cancelThemesAction = UIAlertAction(title: "\(LangCommon.cancel)", style: .destructive) { (_) in
            print("Theme Canceled")
        }
        actionSheet.addAction(brownThemeAction)
        actionSheet.addAction(yellowThemeAction)
        actionSheet.addAction(pinkThemeAction)
        actionSheet.addAction(makeDefault)
        actionSheet.addAction(cancelThemesAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //-------------------------
    //MARK: - Address Refresh
    //------------------------
    @objc
    func ProfileAddressRefresh(_ notification : Notification) {
        print("¯¯¯¯¯¯Profile  Refresh")
        DispatchQueue.main.async(group: .none,
                                 qos: .background,
                                 flags: .inheritQoS) {
            self.getUserData(showloader: false)
        }
    }
    
    @objc
    func themeRefresh(_ notification : Notification) {
        self.handyHomeMapView.darkModeChange()
    }
    

    
    @objc
    func goToJobHistory(notification: Notification) {
        /*
         comment: Find The Current Viewcontroller is a HandyTripVC or Not
         */
        
        if let isFromSamePlace = self.navigationController?.topViewController?.isKind(of: HandyTripHistoryVC.self) {
            if isFromSamePlace {
                NotificationEnum.pendingTripHistory.postNotification()
                print("å: It Placed in a Same place so I reloaded the pending Table")
            } else {
                let viewRequest = HandyTripHistoryVC.initWithStory()
                self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
                self.navigationController?.viewControllers.last?.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(viewRequest, animated: true)
            }
        } else {
            let viewRequest = HandyTripHistoryVC.initWithStory()
            self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
            self.navigationController?.viewControllers.last?.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(viewRequest, animated: true)
        }
    }
    
    @objc
    func showThisPage(notification: Notification) {
        AppDelegate.shared.onSetRootViewController(viewCtrl: self)
        return
    }
    
    @objc
    func getPaymentSuccess(_ notificaiton : Notification) {
        Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        let topmostController = self.navigationController?.topViewController
        if topmostController?.isKind(of: HandyHomeMapVC.self) ?? false{
            self.commonAlert.setupAlert(alert: LangCommon.success,
                                        alertDescription: LangHandy.providerPaidSuccess,
                                        okAction: LangCommon.ok.capitalized)
            
            
        }
    }
    
    @objc
    func riderCancelledTrip(notification: Notification) {
        self.commonAlert.setupAlert(alert: LangCommon.message+"!!!",
                                    alertDescription: LangGofer.tripCancelledByRider,
                                    okAction: LangCommon.ok.capitalized)
        self.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        }
    }
    
    @objc
    func driverCancelledTrip(notification: Notification) {
        Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        NotificationCenter.default.post(name: NSNotification.Name.JobCancelDriver,
                                        object: self,
                                        userInfo: nil)
    }
    
    @objc
    func showAlertFrom(_ notification : Notification){
        guard let status = notification.object as? String else { return }
        guard let json = notification.userInfo as? JSON else { return }
        guard appDelegate.pushManager.canIHandleThisMessage(userInfo: json) else{return}
        self.commonAlert.setupAlert(alert: appName,
                                    alertDescription: LangCommon.jobCancelledUSer, okAction: LangCommon.ok.capitalized,
                                    cancelAction: nil,
                                    userImage: nil)
        self.commonAlert.addAdditionalOkAction(isForSingleOption: true) { }
    }
    
    
    //-------------------------
    //MARK: - ws Functions
    //------------------------
    func getUserData(showloader: Bool){
        if showloader {
            Shared.instance.showLoader(in: self.view)
        }
        self.homeViewModel?.getProviderProfileApi(showloader: showloader){(result) in
            switch result{
            case .success(let profile):
                dump(profile)
                self.handyHomeMapView.userLocationCheck(from: profile)
                Shared.instance.userProfile = profile
                Shared.instance.currencyConversionRate = profile.current_rate
                self.handyHomeMapView.set(userDetails: profile)
                //Gofer splitup start
                self.selectedServiceListArray = self.homeViewModel.serviceListArray
                //Gofer splitup end

                AppWebConstants.availableBusinessType = profile.services
                AppWebConstants.selectedBusinessType = profile.services.filter({$0.selectedBusinessId})
                self.updateGeofire()
                // @karuppasamy
                self.handyHomeMapView.updateButtonTittles()
                self.handyHomeMapView.setUpTheAvailabiltyAndServicesStatus()
                self.handyHomeMapView.setUpBottomView(toActive: profile.driverStatus == 1)
                self.checkstatuss = profile.driverStatus
                print(self.checkstatuss)
                if self.checkstatuss == 1 {
                    self.handyHomeMapView.customSwitchHolder.isHidden = false
                } else {
                    self.handyHomeMapView.customSwitchHolder.isHidden = true
                }
                self.is_company = profile.company_id
                if self.is_company != "1" {
                    self.is_company_check = true
                    Shared.instance.is_company = self.is_company_check
                } else {
                    self.is_company_check = false
                    Shared.instance.is_company = self.is_company_check
                    self.setAlertView(isShow: profile.is_minimum_balance)
                }
                self.homealert.text = profile.home_alert
                if AppWebConstants.selectedBusinessType.compactMap({$0.id}).contains(BusinessType.Ride.rawValue) && Shared.instance.userProfile?.gender == "" {
                    self.handyHomeMapView.genderSelection()
                }
                if !isSingleApplication {
                    if profile.driverStatus != 1 && AppWebConstants.selectedBusinessType.isEmpty {
                        self.handyHomeMapView.openBottomSheetForTypeSelection()
                    }
                }
                Shared.instance.removeLoader(in: self.view)
            case .failure(let error):
                print(error.localizedDescription)
                Shared.instance.removeLoader(in: self.view)
            }
        }
    }
    
    func wsToUpdateService(param: JSON) {
        self.gojekhomeVM.updateDriverService(param: param) { result in
            switch result {
            case .success(let json):
                if json.statusCode == "1" {
                    print("Updated Success Fully")
                    let service = json.service
                    AppWebConstants.availableBusinessType.removeAll()
                    AppWebConstants.selectedBusinessType.removeAll()
                    AppWebConstants.availableBusinessType = service
                    AppWebConstants.selectedBusinessType = service.filter({$0.selectedBusinessId})
                    if !AppWebConstants.selectedBusinessType.compactMap({$0.id}).contains(AppWebConstants.currentBusinessType.rawValue) {
                        if let value = AppWebConstants.selectedBusinessType.first {
                            AppWebConstants.currentBusinessType = BusinessType.init(rawValue: value.id) ?? .Gojek
                        }
                    }
                    self.getUserData(showloader: true)
                    self.handyHomeMapView.setHome()
                } else {
                    AppDelegate.shared.createToastMessage(json.statusMessage)
                }
                if AppWebConstants.selectedBusinessType.compactMap({$0.id}).contains(BusinessType.Ride.rawValue) && Shared.instance.userProfile?.gender == "" {
                    self.handyHomeMapView.genderSelection()
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        }
        
    }
    
    func updateCurrentLocationToServer(status: DriverTripStatus){
        var dicts = JSON()
        dicts["status"] = status.rawValue
        self.homeViewModel?.updateProviderStatusApi(parms: dicts){(result) in
            switch result {
            case .success(let result):
                let _status = DriverTripStatus.init(rawValue: result.string("status"))
                if result.isSuccess {
                    status.store()
                    self.handyHomeMapView.setSwitchStatus()
                } else {
                    if (_status == .Trip || _status == .Job) {
                        self.commonAlert.setupAlert(alert: LangCommon.message+"!!!",
                                                    alertDescription: result.status_message,
                                                    okAction: LangCommon.ok.capitalized)
                        AppDelegate.shared.createToastMessage(result.status_message)
                    } else {
                        AppDelegate.shared.createToastMessage(result.status_message)
                    }
                    _status?.store()
                    self.handyHomeMapView.setSwitchStatus()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateWorkLoc(params: [AnyHashable:Any]){
    self.homeViewModel.updateWorkLocationApi(parms: params){(result) in
              switch result {
              case .success( _):
                 print("success") // @karuppasamy
              case .failure(let error):
                print("\(error.localizedDescription)")

              }
              
          }
      }
    
    func getCurrentLocation() {
        let providerLocation = self.homeViewModel.profileModel?.providerLocation
        self.homeViewModel.getCurrentLocation { (location) in
            self.handyHomeMapView.lat = location.coordinate.latitude
            self.handyHomeMapView.long = location.coordinate.longitude
            location.getAddress { (address) in
                print("Address:\(String(describing: address))")
                self.handyHomeMapView.address = address ?? ""
                self.homeViewModel.stopListening()
                var dicts = JSON()
                dicts["latitude"] = self.handyHomeMapView.lat
                dicts["longitude"] = self.handyHomeMapView.long
                dicts["work_radius"] = providerLocation?.work_radius
                dicts["is_specified"] = 0
                dicts["service_at_mylocation"] = 0
                dicts["address"] = self.handyHomeMapView.address
                self.handyHomeMapView.workLocationAddressLbl.text = address ?? ""
//                dicts["flat_no"] = self.flat_no
//                dicts["land_mark"] = self.land_mark
//                dicts["nick_name"] = self.nick_name
                self.updateWorkLoc(params: dicts)
                if (providerLocation?.address != "" && providerLocation?.address != nil){
                    self.handyHomeMapView.updateWorkLoc = true
                    //
                }
            }
        }
    }
    
    func checkProviderStatus() {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared.getRequest(for: .checkDriverStatus, params: [:], showLoader: true)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.isSuccess{
                    if json.int("provider_status") == 1 {
                        self.getUserData(showloader: true)
                    }else{
                        self.presentProjectError(message: json.string("provider_status_message"))
                    }
                }else{
                    self.presentProjectError(message: json.status_message)
                }
            })
            .responseFailure({ (error) in
            UberSupport.shared.removeProgressInWindow()
                self.presentProjectError(message: error)
            })
    }
    
    func getCountryList(){
        self.homeViewModel.getCountryList(){ result in
            switch result{
            case .success(let countries):
                Shared.instance.countryList.removeAll()
                Shared.instance.countryList = countries.country_list
            case .failure(let error):
                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
            
        }
    }
}
