//
//  DeliveryRouteView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 15/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import GoogleMaps
import CoreLocation

class DeliveryRouteView: BaseView,DeliveryTripManagerDelegate, passLatitudeLongitude {
    
    //Outlets
//MARK:- Outlets
    
    @IBOutlet var btnViewRiderProfile: UIButton!
    @IBOutlet var viewDetailHoder: TopCurvedView!
    @IBOutlet var viewAddressHoder: SecondaryView!
    @IBOutlet var lblLocationName: SecondaryTextFieldTypeLabel!
    @IBOutlet var lblRiderName: SecondaryHeaderLabel!
    @IBOutlet var googleMap: GMSMapView!
    @IBOutlet var btnRiderProfileHolder: UIButton!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var navigateLabel : SecondaryExtraNavigateLabel!
    @IBOutlet weak var navigationView : SecondaryView!
    @IBOutlet weak var navigationImage : CommonColorImageView!
    
    @IBOutlet weak var navview: HeaderView!
    @IBOutlet weak var tripProgressBtn : ProgressButton!
    @IBOutlet weak var enRouteLbl: SecondaryHeaderLabel!
    @IBOutlet weak var cashTripLbl : SecondaryHeaderLabel!
    @IBOutlet weak var etaLbl : SecondaryTextFieldTypeLabel!
    @IBOutlet weak var lblRiderName2: SecondaryHeaderLabel!
    @IBOutlet weak var what2Lbl: SecondaryHeaderLabel!
    @IBOutlet weak var orderLbl: SecondaryHeaderLabel!
    @IBOutlet weak var orderView :UIView!
    @IBOutlet weak var cartStatusIV : UIImageView!
    @IBOutlet weak var cartStatusView : UIView!
    @IBOutlet weak var orderListBtn: UIButton!
    
    
    //variables
    //MARK: - LOCAL VARIABLES
    var polyline = GMSPolyline()
    var googlePath = GMSPath(){
        didSet{
            guard !self.googlePath.encodedPath().isEmpty,
                oldValue != self.googlePath else{return}
            self.updateFirebase(withNewPath: self.googlePath.encodedPath())
        }
    }
    var driversPositiionAtPath : UInt = 0
    var knownETASecFromGoogle : Int = 60
    var currenRouteData : Route? = nil
    var tripManager : DeliveryTripManager?
    fileprivate let cameraDefaultZoom : Float = 16.5
    var delVC:DeliveryRouteVC!
    var dropVC:DropOrderVC!
    var ref: DatabaseReference!
    var shouldFocusPolyline = true
    var reqID = 0
    var shouldPopToOrdersVC = Bool()
//MARK: - NECESSARY CLASS FUNCTIONS
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        delVC = baseVC as? DeliveryRouteVC
        initialize()
        loadDataView()
        darkModeChange()
    }
    
    override func darkModeChange() {
        super.darkModeChange()
        self.viewDetailHoder.customColorsUpdate()
        self.viewAddressHoder.customColorsUpdate()
        self.lblLocationName.customColorsUpdate()
        self.lblRiderName.customColorsUpdate()
        self.navigationImage.customColorsUpdate()
        self.navigationImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryColor
        self.navview.customColorsUpdate()
        self.enRouteLbl.customColorsUpdate()
        self.cashTripLbl.customColorsUpdate()
        self.etaLbl.customColorsUpdate()
        self.etaLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryColor
        self.lblRiderName2.customColorsUpdate()
        self.what2Lbl.customColorsUpdate()
        self.orderLbl.customColorsUpdate()
        if orderLbl.text == LangDeliveryAll.confirmOrder.capitalized {
            self.orderLbl.textColor = .PrimaryColor
        } else {
            self.orderLbl.textColor = .TertiaryColor
        }
        self.navigateLabel.customColorsUpdate()
        self.navigateLabel.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryColor
        self.onChangeMapStyle(map: googleMap)
    }
    
    
    
    func initialize() {
        self.viewAddressHoder.layer.cornerRadius = 15
        self.viewAddressHoder.elevate(2.5)
    }
    func loadDataView()  {
        self.googleMap.clipsToBounds = true
        self.googleMap.cornerRadius = 50
        self.googleMap.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        if let lastLocation = LocationHandler.shared().lastKnownLocation {
            self.delVC.currentLocation = lastLocation
            self.setMap()
        } else {
            self.delVC.deliveryRouteVM.getCurrentLocation { model in
                self.delVC.currentLocation = model
                self.setMap()
            }
        }        
        if self.delVC.tripDetailsModel != nil {
            self.tripManager = DeliveryTripManager(using: self,
                                                   forOrderModel: self.delVC.tripDetailsModel)

        }else{
            self.tripManager = DeliveryTripManager(using: self,
                                                   forOrder: self.delVC.deliveryOrderId)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.tripProgressBtn.initialize(self.tripManager!)
            self.tripProgressBtn.secodaryThemeCorner()
            self.tripProgressBtn.backgroundColor = .PrimaryColor
            self.tripProgressBtn.setTitleColor(.PrimaryTextColor,
                                               for: .normal)
            self.tripProgressBtn.titleLabel?.font = .MediumFont(size: 15)
            self.initView()
            self.initGesture()
            self.initLangugage()
            self.delVC.initNotification()
            self.createInitialTripFireBaseNode()
        }
        //UIApplication.shared.statusBarStyle = .lightContent
        var preferredStatusBarStyle: UIStatusBarStyle {
              return .lightContent
        }
    }
    func initGesture(){
        self.navigationView.addAction(for: .tap) { [weak self] in
            self?.delVC.showAlertForThirdPartyNavigation()
        }
        self.orderView.addAction(for: .tap) { [weak self ] in
            self?.goToOrderList(nil)
        }
    }
    func setMap(){
//        let camera: GMSCameraPosition = GMSCameraPosition
//            . camera(withLatitude: self.delVC.currentLocation.coordinate.latitude,
//                     longitude: self.delVC.currentLocation.coordinate.longitude,
//                     zoom: self.cameraDefaultZoom)
//        googleMap.camera = camera
    }
    func initView() {
        if !ChatInteractor.instance.isInitialized {
            if self.delVC.tripDataModel != nil {
                ChatInteractor.instance.initialize(withTrip: self.delVC.tripDataModel.order_details?.description ?? "",
                                                   type: .u2d)
            } else {
                ChatInteractor.instance.initialize(withTrip: 10028.description,
                                                   type: .u2d)
            }
            
        }
        //   onChangeMapStyle()
        self.onChangeMapStyle(map: googleMap)
        ref = Database.database().reference()
        let cash = Constants().GETVALUE(keyname: CASH_PAYMENT)
        cashView.layer.cornerRadius = 5
        cashView.isHidden = !cash.lowercased().contains("cash")
        
        //googleMap.addSubview(cashView)
        
        //self.tripProgressBtn.isUserInteractionEnabled = true
        self.orderListBtn.isHidden = true
        
        switch self.tripManager?.currentTripStatus ?? .accepetedOrderDel {
        case .accepetedOrderDel:
            self.tripProgressBtn.set2Trip(state: .confirmedOrderDel)
            Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
            self.tripProgressBtn.backgroundColor = .PrimaryColor
            self.tripProgressBtn.isUserInteractionEnabled = false
        case .confirmedOrderDel:
            self.tripProgressBtn.isUserInteractionEnabled = false
            self.orderListBtn.isHidden = true
            self.tripProgressBtn.backgroundColor = .PrimaryColor
            self.tripProgressBtn.set2Trip(state: .accepetedOrderDel)
        case .startedTripDel:
//            self.tripProgressBtn.set2Trip(state: .startedTripDel)
            self.tripProgressBtn.backgroundColor = .PrimaryColor
        case .deliverdOrderDel:
            self.tripProgressBtn.backgroundColor = .PrimaryColor
        case .completed:
            self.tripProgressBtn.set2Trip(state: .endTrip)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
        default:
            break
        }
        
        self.tripManager?.updateCurrentLocationToServer()
        btnViewRiderProfile.layer.shadowColor = UIColor.gray.cgColor;
        btnViewRiderProfile.layer.shadowOffset = CGSize(width:0, height:1.0);
        btnViewRiderProfile.layer.shadowOpacity = 0.5;
        btnViewRiderProfile.layer.shadowRadius = 2.0;
        
        let nav_comapass = UIImage(named: "compass.png")?.withRenderingMode(.alwaysTemplate)
        self.navigationImage.image = nav_comapass
        self.navigationView.backgroundColor = UIColor(hex: "#303841")
        self.navigationView.cornerRadius = 20.0
        self.navigationView.elevate(2.5)
    }
    
    func initLangugage(){
        self.enRouteLbl.text = LangDeliveryAll.enRoute
        self.cashTripLbl.text = LangCommon.cashTrip.uppercased()
        self.navigateLabel.text = LangDeliveryAll.navigate.capitalized
        
    }
//    func onChangeMapStyle()
//    {
//        do {
//            if let styleURL = Bundle.main.url(forResource: "ub__map_style", withExtension: "json") {
//                googleMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
//            } else {
//            }
//        } catch {
//        }
//    }
    func onChangeMapStyle(map: GMSMapView) {
            // Create a GMSCameraPosition that tells the map to display the
            // coordinate at zoom level 6.
            // googleMapView.setMinZoom(15.0, maxZoom: 55.0)
            let camera = GMSCameraPosition.camera(withLatitude: 9.917703, longitude: 78.138299, zoom: 4.0)
            GMSMapView.map(withFrame: map.frame, camera: camera)
            do {
                // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
                if let styleURL = Bundle.main.url(forResource: self.isDarkStyle ?  "map_style_dark" : "mapStyleChanged", withExtension: "json") {
                    map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                }
            } catch {
            }
        }

//MARK: - BUTTON ACTIONS
    //Actions
    @IBAction func onRiderViewProfileTapped() {
        guard let data = self.tripManager?.tripDetailModel else{
            self.tripManager?.fetchTripDetails() ; return }
        let tripView = RiderProfileVC.initWithStory()
        tripView.tripDetailDataModel = data
        tripView.isTripStarted = self.tripManager?.currentTripStatus.isDelOrderStarted ?? true
        self.delVC.navigationController?.pushViewController(tripView, animated: true)
    }

    @IBAction func onDriverListIconTapped(_ sender: Any) {
        //@karthik
        print("onDriverListIconTapped")
        guard let data = self.tripManager?.tripDetailModel  else{return}
        let pickView = DriverOrderListVC.initWithStory(storeName: data.storeName)
        pickView.grpID_recived = data.groupId
        pickView.delegate = self
        self.delVC.navigationController?.pushViewController(pickView, animated: true)
      
    }
    @IBAction
    func goToOrderList(_ sender : Any?){
        guard let data = self.tripManager?.tripDetailModel,
            ![TripStatus.deliverdOrderDel,TripStatus.confirmedOrderDel].contains(data.getStatus())  else{return}
        
        if data.getStatus().isDelOrderStarted{
            let view = DropOrderVC.initWithStory(forOrder: data)
            view.modalPresentationStyle = .overCurrentContext
            self.viewController.present(view, animated: true, completion: nil)
           
            
        }else{
            print("")
            
            let pickView = PickUpVC.initWithStory()
            pickView.reqID = reqID
            pickView.group_ID = data.groupId
            pickView.PopToRootVC = shouldPopToOrdersVC
            self.delVC.navigationController?.pushViewController(pickView, animated: true)
        }
    }
    
    @IBAction func onBackTapped() {
        self.deinitObjects()
        Shared.instance.resumeTripHitCount = 1
       // self.delVC.exitScreen(animated: true)
        if let vc = self.delVC.findLastBeforeVC(),
           vc.isKind(of: HandyTripHistoryVC.self) {
            self.delVC.updateTripHistory?.updateContent()
            self.delVC.exitScreen(animated: true)
        } else {
            self.delVC.navigationController?.popToRootViewController(animated: false)
        }
        
        
//        if shouldPopToRootVC {
        
//        if shouldPopToOrdersVC
//        {
//           self.navigationController?.popToRootViewController(animated: false)
//            return
//        }
        
   //@karthik
//        if ((self.navigationController?.hasViewController(ofKind: TripHistoryVC.self)) != nil)
//        {
//            print("Present In Navigation Controller")
//
//            self.updateTripHistory?.updateContent()
//            navigationController?.popToViewController(ofClass: TripHistoryVC.self)
//
//        }
//
//        else
//        {
//            print("Not in Navigation Controller")
//            self.navigationController?.popToRootViewController(animated: false)
//        }
        
        
        

        
        
        //self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TripManagerDelegate
extension DeliveryRouteView{
    
    
    var gMapView: GMSMapView {
        return self.googleMap
    }
    
    var viewController: UIViewController {
        return self.delVC
    }
    
    var progressBtn: ProgressButton {
        return self.tripProgressBtn
    }
    
    func updateDestination(with detail: DeliveryOrderDetail) {
        
        
        //        if Shared.instance.needToShowChatVC{
        //                   self.goToChatVC("")
        //        }
        detail.storeUserInfo(true)
//        lblRiderName.text = detail.getTargetUser.name
//        lblRiderName2.text = detail.getTargetUser.name
        let pickUP : CLLocation = LocationHandler.shared().lastKnownLocation ?? CLLocation()
        self.tripProgressBtn.isUserInteractionEnabled = true
        self.orderListBtn.isHidden = false
        self.tripProgressBtn.alpha = 1
        switch detail.getStatus() {
        case .accepetedOrderDel:
            self.delVC.isTripStarted = false
            self.orderListBtn.isHidden = true
            
//            if multipleDelivery == "Yes"{
//                what2Lbl.text = LangDeliveryAll.dropOff.uppercased()
//                lblLocationName.text = detail.dropLocation
//               // orderLbl.text = LangDeliveryAll.orderDetails.uppercased()
//            }
//
//            else{
//                what2Lbl.text = LangDeliveryAll.pickUp.uppercased()
//               // orderLbl.text = LangDeliveryAll.confirmOrder.uppercased()
//                lblLocationName.text = detail.pickupLocation
//
//            }
            
            lblRiderName.text = detail.storeName
            lblRiderName2.text = detail.storeName
            lblLocationName.text = detail.pickupLocation
            what2Lbl.text = LangDeliveryAll.pickUp.capitalized
            orderLbl.text = LangDeliveryAll.confirmOrder.capitalized
            orderLbl.textColor = .PrimaryColor
            self.cartStatusIV.image = UIImage(named: "pencil")?.withRenderingMode(.alwaysTemplate)
            self.cartStatusIV.tintColor = .TertiaryColor
            self.cartStatusIV.isHidden = false
            self.cartStatusView.isHidden = false
            
            
            //############################
            self.tripProgressBtn.set2Trip(state: .accepetedOrderDel)
            self.tripProgressBtn.isUserInteractionEnabled = false
            self.tripProgressBtn.backgroundColor = .TertiaryColor
            self.tripProgressBtn.alpha = 0.4
            
            self.delVC.contactless_delivery = detail.contactless_delivery
            print("self.contactless_delivery",self.delVC.contactless_delivery)
        case .confirmedOrderDel:
            self.delVC.isTripStarted = false
             self.orderListBtn.isHidden = false
//            if multipleDelivery == "Yes"{
//                what2Lbl.text = LangDeliveryAll.dropOff.uppercased()
//                lblLocationName.text = detail.dropLocation
//
//            }else{
//                what2Lbl.text = LangDeliveryAll.pickUp.uppercased()
//                lblLocationName.text = detail.pickupLocation
//
//            }
            
            lblRiderName.text = detail.storeName
            lblRiderName2.text = detail.storeName
            what2Lbl.text = LangDeliveryAll.pickUp.capitalized
            lblLocationName.text = detail.pickupLocation
            
            cartStatusIV.tintColor = .PrimaryColor
              
            orderLbl.text = LangDeliveryAll.orderConfirmed.capitalized
            orderLbl.textColor = .TertiaryColor
            self.cartStatusIV.image = UIImage(named: "orderAccept")?.withRenderingMode(.alwaysTemplate)
            self.cartStatusIV.tintColor = .PrimaryColor
            self.cartStatusIV.isHidden = false
            self.cartStatusView.isHidden = false
            //############################
            self.tripProgressBtn.set2Trip(state: .confirmedOrderDel)
            Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
            
            
            self.delVC.contactless_delivery = detail.contactless_delivery
            print("self.contactless_delivery",self.delVC.contactless_delivery)
            
        case .startedTripDel:
            lblRiderName.text = detail.getTargetUser.name
            lblRiderName2.text = detail.getTargetUser.name
            self.delVC.isTripStarted = true
            self.orderListBtn.isHidden = false
            what2Lbl.text = LangDeliveryAll.dropOff.capitalized
            lblLocationName.text = detail.dropLocation
            orderLbl.text = LangDeliveryAll.orderDetails.capitalized
            orderLbl.textColor = .TertiaryColor
            self.cartStatusIV.isHidden = true
            self.cartStatusView.isHidden = true
            //############################
            self.tripProgressBtn.set2Trip(state: .startedTripDel)
            
            
            self.delVC.contactless_delivery = detail.contactless_delivery
            print("self.contactless_delivery",self.delVC.contactless_delivery)
            
            if detail.collectCash.isEmpty || detail.collectCash == "" {
//                Shared.instance.isForCash = false
                self.tripProgressBtn.setTitle(LangDeliveryAll.dropOff)
            }else{
                
                if self.delVC.contactless_delivery == "true"
                {
//                    Shared.instance.isForCash = false
                    self.tripProgressBtn.setTitle(LangDeliveryAll.dropOff)
                }
                else
                {
//                    Shared.instance.isForCash = true
                    self.tripProgressBtn.setTitle(LangDeliveryAll.collectCash+"(\(UserDefaults.value(for: .user_currency_symbol_org) ?? "$")\(detail.collectCash))")
                }
                
            }
        case .deliverdOrderDel:
            lblRiderName.text = detail.getTargetUser.name
            lblRiderName2.text = detail.getTargetUser.name
            self.delVC.isTripStarted = true
              self.orderListBtn.isHidden = false
            what2Lbl.text = LangDeliveryAll.dropOff.capitalized
            lblLocationName.text = detail.dropLocation
            orderLbl.text = LangDeliveryAll.dropOff.capitalized + " " + LangDeliveryAll.confirmed
            orderLbl.textColor = .TertiaryColor
            self.cartStatusIV.image = UIImage(named: "pencil")?.withRenderingMode(.alwaysTemplate)
            self.cartStatusIV.tintColor = .PrimaryColor
            self.cartStatusIV.isHidden = false
            self.cartStatusView.isHidden = false
            //############################
            self.tripProgressBtn.set2Trip(state: .deliverdOrderDel)
            self.tripProgressBtn.backgroundColor = .PrimaryColor
            
            
            self.delVC.contactless_delivery = detail.contactless_delivery
            print("self.contactless_delivery",self.delVC.contactless_delivery)
            
        case .completed:
            
            self.delVC.isTripStarted = true
            self.orderListBtn.isHidden = false
            self.tripProgressBtn.set2Trip(state: .endTrip)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
            
            self.delVC.contactless_delivery = detail.contactless_delivery
            print("self.contactless_delivery",self.delVC.contactless_delivery)
            
        default:
            break
        }
        
        
        self.createPolyLine(start: pickUP,
                            end: detail.getDestination,
                            skipValidation: false,
                            getDistance: nil)
        //        btnViewRiderProfile.sd_setImage(with: NSURL(string: detail.getTargetUser.image)! as URL, for: .normal)
      //  lblLocationName.text = detail.getTargetUser.address
        
    }
    func deinitObjects(){
        self.delVC.deinitNotifications()
        self.tripManager?.stop()
    }
    func onSuccessfullTripCompletion() {
        self.delVC.presentAlertWithTitle(title: LangCommon.orderCompleted,
                                    message: "",
                                    options: LangCommon.ok) { (_) in
                                        
            appDelegate.onSetRootViewController(viewCtrl: self.delVC)
                                        
        }
    }
    
    func checkForRemainingTrip() {
        self.delVC.deliveryRouteVM.getJobApi(parms: [:]) { result in
            switch result {
            case .success(let res):
                if res.statusCode != "0" {
                    self.tripManager = nil
                    self.delVC.tripDetailsModel = res.orderDetails
                    self.googleMap.clear()
                    self.initialize()
                    self.loadDataView()
                } else {
                    self.onSuccessfullTripCompletion()
                    print("Something Went Wrong")
                }
            case .failure(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func isPathChanged(byDriver coordinate : CLLocation) -> Bool{
  
        guard self.googlePath.count() != 0 else{return true}
        
        for range in 0..<googlePath.count(){
            let point = googlePath.coordinate(at: range).location
            
            if point.distance(from: coordinate) < 75{
                self.driversPositiionAtPath = range
                self.drawRoute(for: self.googlePath)
                return false
            }
        }
//        self.driversPositiionAtPath = 0
        return true
    }
    func createPolyLine(start : CLLocation,
                        end: CLLocation,
                        skipValidation : Bool,
                        getDistance : DistanceClosure? = nil )
    {
        DispatchQueue.performAsync(on: .main) { [weak self] in
            guard let welf = self else{return}
            debug(print: getDistance == nil ? "empty" : "full")
            
            if welf.shouldFocusPolyline {
                
                let bounds = GMSCoordinateBounds(coordinate: start.coordinate,
                                                 coordinate: end.coordinate)
                let camera1 = welf.googleMap.camera(for: bounds,
                                                       insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
                welf.googleMap.camera = camera1!
                welf.shouldFocusPolyline = false
            }
            //Apply validation for trip not for end trip
            if getDistance == nil && !skipValidation{
                if welf.polyline.path != nil {
                    guard welf.isPathChanged(byDriver: start) else{return}
                    
                }
                let timeDifference = Date().timeIntervalSince(self?.delVC.lastDirectionAPIHitStamp ?? Date())
                guard self?.delVC.lastDirectionAPIHitStamp == nil || timeDifference > 15 else{return}
            }
            self?.delVC.lastDirectionAPIHitStamp = Date()
            let count = UserDefaults.value(for: .direction_hit_count) ?? 0
            UserDefaults.set(count + 1, for: .direction_hit_count)
//            welf.appDelegate.createToastMessage("\(skipValidation):Direction:\(count + 1)")
        
//            var debugArray : [JSON] = UserDefaults.value(for: .debug_trip_path_changes) ?? [JSON]()
//            let json : JSON = [
//                "trip_id" : self?.tripDataModel.description ?? "no_trip",
//                "count" : count,
//                "didSkip" : skipValidation,
//                "driver_position" : start.description,
//                "drop_position" : end.description,
//                "gmsPath" : self?.googlePath.encodedPath() ?? "no_path"
//            ]
//            debugArray.append(json)
//            UserDefaults.set(debugArray, for: .debug_trip_path_changes)
            ConnectionHandler.shared
                .getRequest(forAPI: "https://maps.googleapis.com/maps/api/directions/json",
                            params: [
                                "origin" : "\(start.coordinate.latitude),\(start.coordinate.longitude)",
                                "destination" :"\(end.coordinate.latitude),\(end.coordinate.longitude)",
                                "mode" : "driving",
                                "units" : "metric",
                                "sensor" : "true",
                                "key" : GooglePlacesApiKey
                            ],showLoader: true, cacheAttribute: .none)
                .responseDecode(to: GoogleGeocode.self, { (googleGecode) in
                    self?.handleDirectionResponse(googleGecode,getDistance: getDistance)

                })
                .responseFailure({ (error) in
                    debugPrint(error)
                    if let distanceFromGoogle = getDistance{
                        distanceFromGoogle(0.0,"")
                        return
                    }
                })
        
            
        }
    }
    func handleDirectionResponse(_ gecode : GoogleGeocode,
                                 getDistance : DistanceClosure? = nil ){
        if let distanceFromGoogle = getDistance{
            //(getDistance != nil)this method is called for getting distance alone
            if let route = gecode.routes.first{
                let distance = route.legs.first?.distance.value ?? 0
                let path = route.overviewPolyline.points
                distanceFromGoogle(Double(distance),path)
                self.calculateETA()
            }else{
                distanceFromGoogle(0.0,"")
            }
         
            return
        }
        if let route = gecode.routes.first{
            self.drawRoute(forRoute: route)
            self.knownETASecFromGoogle = route.legs.first?.duration.value ?? 60
            self.calculateETA()
        }
    
    }
    func calculateETA(){
        guard let route = self.currenRouteData,
              let driverLocation = LocationHandler.shared().lastKnownLocation,
            let leg = route.legs.first else{return}
       
        let steps = leg.steps
        var remainingSecETA : Int? = nil
        
        for step in steps{
            if let availableETA = remainingSecETA {
                remainingSecETA = availableETA + (step.duration.value )
            }else if (step.startLocation.distance(from: driverLocation) ) < 100{
                remainingSecETA = step.duration.value
            }
        }
        
        let secondsETA = remainingSecETA ?? self.knownETASecFromGoogle
        self.knownETASecFromGoogle = secondsETA
        var minutesETA = secondsETA / 60
        if minutesETA < 1{
            minutesETA = 1
        }
        debug(print: minutesETA.description)
        var _ = String()
        let _ = minutesETA / 60
        let _ = minutesETA % 60
        self.calculateSpeed(googleETAMin: Double(minutesETA), from: googlePath)
       
    }
    // drow the route in map
    func drawRoute(forRoute route: Route)
    {
        self.currenRouteData = route
        let points = route.overviewPolyline.points
        
        if let newPath = GMSPath(fromEncodedPath: points){
            self.googlePath = newPath
            self.driversPositiionAtPath = 0
            self.drawRoute(for: googlePath)
        }
   
    }
    func drawRoute(for path : GMSPath){
        let drawingPath = GMSMutablePath()
        for i in self.driversPositiionAtPath..<path.count(){
            drawingPath.add(path.coordinate(at: i))
        }
        
        self.polyline.path = drawingPath
        self.polyline.strokeColor = .ThemeTextColor
        self.polyline.strokeWidth = 3.0
        self.polyline.map = googleMap
        self.calculateETA()
    }
    func calculateSpeed(googleETAMin : Double,from path : GMSPath){
        var oldLoc = path.coordinate(at: self.driversPositiionAtPath).location
        var distance : Double = 0
        for index in self.driversPositiionAtPath..<path.count() where index % 5 == 0 {
            let newLocation = path.coordinate(at: index).location
            distance += newLocation.distance(from: oldLoc)
            oldLoc = newLocation
        }
        
        
        let lastLocation = path.coordinate(at: path.count() - 1).location
        distance += lastLocation.distance(from: oldLoc)
      
        let distanceInKM = distance / 1000
        var currentSpeed = self.tripManager?.currentSpeed ?? 18
        if currentSpeed < 18{
            currentSpeed = 18
        }
        if currentSpeed > 40{
            currentSpeed = 40
        }
        let calculatedETAHrs = distanceInKM / currentSpeed
       var averageETAmins = ((calculatedETAHrs * 60) + googleETAMin) / 2
        averageETAmins = averageETAmins <= 1 ? 1 : averageETAmins
//        self.lblRiderName.text = "Speed : \(self.tripManager?.currentSpeed  ?? 0)"
//        self.navigateLabel
//            .text = "\(Int(averageETAmins)) min"

        self.updateFirebase(withNewETA: Int(averageETAmins))
        var etaString = String()
        let minutesETA = Int(averageETAmins)
        let hrs = minutesETA / 60
        let mins = minutesETA % 60
        if hrs > 0{
            etaString.append("\(hrs) \(hrs == 1 ? LangDeliveryAll.hr.lowercased() : LangDeliveryAll.hrs.lowercased()) ")
        }
        if mins > 1 {
            etaString.append("\(mins) \(LangDeliveryAll.mins.lowercased())")
        }else{
            etaString.append("1 \(LangDeliveryAll.min.lowercased())")
        }
          self.etaLbl.text = etaString
        
    }
}

//MARK: - EXTENSIONS
extension DeliveryRouteView : passLatitudeLongitudes {
    func passLatLong(orderID: Int, tripModel: TripDataModel) {
        self.delVC.deliveryOrderId = orderID
         self.deinitObjects()
        self.delVC.tripDataModel = tripModel
        self.tripManager = DeliveryTripManager(using: self,forOrder: self.delVC.deliveryOrderId)
       
         self.initView()
        self.delVC.initNotification()
        self.createInitialTripFireBaseNode()
    }
    func createInitialTripFireBaseNode(){
        
        //self.ref = Database.database().reference().child(iApp.firebaseEnvironment.rawValue)
        let tracking = self.ref.child(FireBaseNodeKey.trip.rawValue)
        tracking.observeSingleEvent(of: .value) { (snapShot) in
            if !snapShot.hasChild(self.delVC.reqID.description){//node not available
                var node = [String:Any]()
                node[FireBaseNodeKey._refresh_payment.rawValue] = "0"
                node[FireBaseNodeKey._polyline_path.rawValue] = "0"
                node[FireBaseNodeKey._eta_min.rawValue] = "0"
                tracking.child(self.delVC.reqID.description).setValue(node)
            }else if self.googlePath.encodedPath().isEmpty{// no local path right now
//                if let tripNode = snapShot.value(forKey: self.tripDataModel.description) as? JSON,
//                    let fire_gPathString = tripNode[FireBaseNodeKey._polyline_path.rawValue] as? String,
//                    !fire_gPathString.isEmpty,
//                    let fire_gPath = GMSPath(fromEncodedPath: fire_gPathString){
//                    self.path = fire_gPath
//
//                }
            }
        }
        
    }
    func updateFirebase(withNewPath path : String){
        let tracking = FireBaseNodeKey.trip.ref()
        tracking.child(self.delVC.deliveryOrderId.description).updateChildValues([FireBaseNodeKey._polyline_path.rawValue : path])
//        let tracking = self.ref.child(FireBaseNodeKey.trip.rawValue).child(delVC.deliveryOrderId.description)
//        tracking.updateChildValues([FireBaseNodeKey._polyline_path.rawValue : path])
    }
    
    func updateFirebase(withNewETA eta : Int){
        let tracking = FireBaseNodeKey.trip.ref()
        tracking.child(self.delVC.deliveryOrderId.description).updateChildValues([FireBaseNodeKey._eta_min.rawValue : eta.description])
//        let tracking = self.ref
//            .child(FireBaseNodeKey.trip.rawValue)
//            .child(delVC.deliveryOrderId.description)
//        tracking.updateChildValues([FireBaseNodeKey._eta_min.rawValue : eta.description])
    }

}
