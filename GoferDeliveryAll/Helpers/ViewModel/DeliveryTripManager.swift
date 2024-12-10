//
//  TripManager.swift
//  GoferDriver
//
//  Created by trioangle on 06/12/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
import Alamofire
import ARCarMovement
import UIKit
import GoogleMaps
import GooglePlaces
protocol DeliveryTripManagerDelegate {
    var shouldFocusPolyline : Bool {get set}
    var gMapView : GMSMapView {get}
    var viewController : UIViewController {get}
    var progressBtn : ProgressButton {get}
    func updateDestination(with detail : DeliveryOrderDetail)
    func createPolyLine(start : CLLocation,
                           end : CLLocation,
                           skipValidation : Bool,
                           getDistance : DistanceClosure?)
    func onSuccessfullTripCompletion()
    func checkForRemainingTrip()
    
}
class DeliveryTripManager : NSObject{
    //MARK:- APIViewProtocol
    
    lazy var connetionHandler = ConnectionHandler()
    var locationVariableForDistanceCalculation : CLLocation?
    
    var isnavigated  = false
    
    
    
    //MARK:- TripData
    let orderID : Int
    var tripDetailModel : DeliveryOrderDetail?
    //MARK:- private vaiables
    
    var localTimeZoneName: String { return TimeZone.current.identifier }
    var tripView : DeliveryTripManagerDelegate
    var currentSpeed :  Double = 30
    /**
     google marker for destination pin
     
     - Warning: Can cause inconsistency in trip flow, if mishandled.
     */
    fileprivate var focusedDriver = false
    fileprivate let wayPointMarker : GMSMarker
    fileprivate let appDelegate : AppDelegate
    fileprivate let cameraDefaultZoom : Float = 16.5
    
    fileprivate var pipelineForeGroundId : Int? = nil
    fileprivate let arCarMovemnet: ARCarMovement!
    /**
     object for singleton location handler
     
     */
    fileprivate let locationHandler : LocationHandlerProtocol
    lazy var tripCache = TripCache()
    
    var lastDriverLocation : CLLocation?{
        didSet{
            guard oldValue == nil,
                let location = self.lastDriverLocation else{
                    return
            }
            
            self.tripView
                .gMapView
                .animate(with: GMSCameraUpdate
                    .setTarget(location.coordinate,
                               zoom: cameraDefaultZoom))
        }
    }
    var serverLocationUpdateTimer : Timer?
    var extraFareOption : ExtraFareOption?
    fileprivate var jpeg_map_snap_shot_light : Data?
    fileprivate var jpeg_map_snap_shot_dark : Data?
    //MARK:- Lazy & GET SET
    
    lazy var driverMarker : GMSMarker = {
       let marker = GMSMarker()
        marker.icon = UIImage(named: "gf_moto_bike.png")
        
        marker.isFlat = true
        marker.map = self.tripView.gMapView
        if let lastKnow = self.lastDriverLocation{
            marker.position = lastKnow.coordinate
        }
        return marker
    }()
    /**
    common getter setter for tripStatus
     
     - Note: state received and setter are maintained for entire flow
     */
    var currentTripStatus : TripStatus {
          get{
              if let detail = self.tripDetailModel{
                  return detail.getStatus()
              }else{
                return .accepetedOrderDel
              }
          }
          set{
              self.tripDetailModel?.setStatus(newValue)
           
            self.updateMarker()
            if let newLocation = self.lastDriverLocation,
                let detail = self.tripDetailModel{
                self.tripView.createPolyLine(start: newLocation,
                                             end: detail.getDestination,
                                             skipValidation: true,
                                             getDistance: nil)
       
            }
          }
      }
    
    //MARK:- background thread handler
    var backGroundThread : UIBackgroundTaskIdentifier = .invalid
    
    //MARK:- init and deinit
    init(using delegate : DeliveryTripManagerDelegate,forOrder orderId : Int){
        self.orderID = orderId
        ///DELEGATE
        self.tripView = delegate
        ///DEFAULT VALUES
        self.wayPointMarker = GMSMarker()
        
        ///HANDLERS
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locationHandler = LocationHandler.shared()
        self.arCarMovemnet = ARCarMovement()
     
        super.init()
        ///DELEGATE CONNECTION
        self.arCarMovemnet.delegate = self
        
        
        if let lastKnow = self.locationHandler.lastKnownLocation{
            self.lastDriverLocation = lastKnow
            self.driverMarker.position = lastKnow.coordinate
            self.didReceiveLocation(lastKnow)
        }
        
        ///START SERVICES
        self.locationHandler.removeObserver(in: self)
        self.serverLocationUpdateTimer?.invalidate()
        if let pipeID = self.pipelineForeGroundId{
            PipeLine.deleteEvent(withID: pipeID)
        }
        self.serverLocationUpdateTimer = Timer.scheduledTimer(timeInterval: 10.00, target: self, selector: #selector(self.updateCurrentLocationToServer), userInfo: nil, repeats: true)
        self.backGroundThread = UIApplication
            .shared
            .beginBackgroundTask(expirationHandler: {
                [weak self] in
                self?.terminateBackgroundThread()
            })
        self.startLocationObserver()
        self.locationHandler.startListening(toLocationChanges: true)
        self.fetchTripDetails()
        self.pipelineForeGroundId = PipeLine
                      .createEvent(key: .app_entered_foreground,
                                   action:
                          { [weak self] in
                            self?.handleOnAppForeGroundActions()
                      })
     
    }
    init(using delegate : DeliveryTripManagerDelegate,forOrderModel order : DeliveryOrderDetail?){
        self.orderID = order?.orderID ?? 0
        ///DELEGATE
        self.tripView = delegate
        ///DEFAULT VALUES
        self.wayPointMarker = GMSMarker()
        
        ///HANDLERS
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locationHandler = LocationHandler.shared()
        self.arCarMovemnet = ARCarMovement()
     
        super.init()
        ///DELEGATE CONNECTION
        self.arCarMovemnet.delegate = self
        
        
        if let lastKnow = self.locationHandler.lastKnownLocation{
            self.lastDriverLocation = lastKnow
            self.driverMarker.position = lastKnow.coordinate
            self.didReceiveLocation(lastKnow)
        }
        
        ///START SERVICES
        self.locationHandler.removeObserver(in: self)
        self.serverLocationUpdateTimer?.invalidate()
        if let pipeID = self.pipelineForeGroundId{
            PipeLine.deleteEvent(withID: pipeID)
        }
        self.serverLocationUpdateTimer = Timer.scheduledTimer(timeInterval: 10.00, target: self, selector: #selector(self.updateCurrentLocationToServer), userInfo: nil, repeats: true)
        self.backGroundThread = UIApplication
            .shared
            .beginBackgroundTask(expirationHandler: {
                [weak self] in
                self?.terminateBackgroundThread()
            })
        self.startLocationObserver()
        self.locationHandler.startListening(toLocationChanges: true)
//        self.fetchTripDetails()
        if let orderdetail = order {
            
        self.tripDetailModel = nil
        self.tripDetailModel = orderdetail
        self.updateMarker()
        if let detail = self.tripDetailModel{
            self.tripView.updateDestination(with: detail)
        }
        self.updateMarker()
        if let loc = self.lastDriverLocation{
            self.didReceiveLocation(loc)
        }
        
        }
        self.pipelineForeGroundId = PipeLine
                      .createEvent(key: .app_entered_foreground,
                                   action:
                          { [weak self] in
                            self?.handleOnAppForeGroundActions()
                      })
     
    }
    deinit{
        self.locationHandler.removeObserver(in: self)
        self.serverLocationUpdateTimer?.invalidate()
        if let pipeID = self.pipelineForeGroundId{
            PipeLine.deleteEvent(withID: pipeID)
        }
    }
    func handleOnAppForeGroundActions(){
        guard self.currentTripStatus.isDelOrderStarted else{return}
        self.locationHandler.startListening(toLocationChanges: true)

    }
    
    func startLocationObserver(){
        self.locationHandler.addObserver(in: self) { (location) in
            self.didReceiveLocation(location)
        }
    }
}
//MARK:- Location Updates
extension DeliveryTripManager{
    /**
     filters received loaction and update carMarker and poyline
   
     - Parameters:
        - newLocation:- current CLLocation
     */
    func didReceiveLocation(_ newLocation : CLLocation){
        
        let newSpeed = newLocation.kilometerPerHours < 18 ? 18 : newLocation.kilometerPerHours
        self.currentSpeed = (self.currentSpeed + newSpeed) / 2
        guard let detail = tripDetailModel else{
            self.lastDriverLocation = newLocation
            self.fetchTripDetails()
            return
        }
        self.updateDriveLocToFirebase(location: newLocation)
        guard let lastLoc = self.lastDriverLocation?.coordinate else{
            self.lastDriverLocation = newLocation
            return
            
        }
        //MARK: location is valid
        DispatchQueue.performAsync(on: .main) { [weak self] in
            guard let welf = self else{return}
           
            welf.arCarMovemnet.arCarMovement(marker: welf.driverMarker, oldCoordinate: lastLoc, newCoordinate: newLocation.coordinate, mapView: welf.tripView.gMapView, bearing: 0.0)

        }
        self.lastDriverLocation = newLocation
        self.tripView.createPolyLine(start: newLocation,
                                     end: detail.getDestination,
                                     skipValidation: false,
                                     getDistance: nil)
       
    }
   
}
//MARK:- MARKER UPDATES
extension DeliveryTripManager{
    /**
     update wayPoint market according to trip Status
     
     */
    func updateMarker(){
        guard let detail = self.tripDetailModel else{
            self.fetchTripDetails()
            return
        }
            
        self.wayPointMarker.map = nil
        self.wayPointMarker.icon = UIImage(named: detail.getDestinationMarkerImage)
        self.wayPointMarker.map = self.tripView.gMapView
        self.wayPointMarker.position = detail.getDestination.coordinate
    }
}
//MARK:- ARCarMovementDelegate
extension DeliveryTripManager : ARCarMovementDelegate{
    
    func arCarMovementMoved(_ marker: GMSMarker) {
        
    }
    
    /**
     ARCarmovement delegate for marker location changes
     
     - NOTE: this delegate is user to focus camera to drivers vehicle
     */
    func arCarMovement(_ movedMarker: GMSMarker) {
        driverMarker.position = movedMarker.position
        let updatedCamera = GMSCameraUpdate.setTarget(movedMarker.position)
        self.tripView.gMapView.animate(with: updatedCamera)
        if !self.focusedDriver{
            self.tripView.gMapView.animate(toZoom: self.cameraDefaultZoom)
            self.focusedDriver = true
        }
        self.tripView.gMapView.animate(toBearing:  movedMarker.rotation)
    }
}

//MARK:- ProgressButtonDelegates
extension DeliveryTripManager : ProgressButtonDelegates{
    func didActivateProgress() {

        switch currentTripStatus {
        case .confirmedOrderDel:
            self.connetionHandler.getRequest(for: .startDelivery,
                                                params: ["order_id":self.orderID.description, "business_id": AppWebConstants.currentBusinessType.rawValue],
                                                showLoader: true)
                .responseJSON({ (json) in
                    if json.isSuccess {
                        self.tripView.progressBtn.setState(ProgressState.normal)
                        self.focusedDriver = false
                        self.currentTripStatus = .startedTripDel
                        self.tripView.progressBtn.set2Trip(state: self.currentTripStatus)
                        self.tripView.progressBtn.setState(.normal)
                        self.tripView.shouldFocusPolyline = true
                        if let lastLoc = self.locationHandler.lastKnownLocation{
                            self.didReceiveLocation(lastLoc)
                        }
                        
                        self.fetchTripDetails()
                        
                    } else {
                        
                    }
                }).responseFailure({ (error) in
                    
                })
        case .startedTripDel:
            if let data = self.tripDetailModel{
                self.tripView.progressBtn.setState(.normal)
                let view = EndDeliveryOptionVC.initWithStory(forOrder: data)

                 let delivery = data.contactless_delivery

                print("comes here",delivery)
                if delivery == "true"
                {
                    view.currentScreen = .contactless
                    view.iscontactlessdelivery = true
                }
//                self.fetchTripDetails()
                self.tripView.viewController.navigationController?
                    .pushViewController(view, animated: true)
                return
            }
        case .deliverdOrderDel:
            guard let lastLoc = LocationHandler.shared().lastKnownLocation else{
                self.tripView.progressBtn.setState(.normal)
                LocationHandler.shared().startListening(toLocationChanges: true)
                self.appDelegate.createToastMessage(LangCommon.gettingLocationTryAgain)
                return
            }
            self.didReceiveLocation(lastLoc)
            self.lastDriverLocation = lastLoc
            self.updateCurrentLocationToServer()

            self.calculateOptimalRoute()
       
        default:
            print(currentTripStatus.getDisplayText)
        }
    }
    
}


//MARK:- TripOTPDelegate
extension DeliveryTripManager : TripOTPDelegate{
    
    var actualOTP: String? {
        let otp = "1234"//self.tripDetailModel != nil ? self.tripDetailModel!.otp : ""
        print("∂OTP : \(otp)")
        return otp
    }
    func otpValidatedSuccesfully() {
        guard let location = self.lastDriverLocation else{
            self.tripView.progressBtn.setState(ProgressState.normal)
            return
        }
        //calling beign trip with driver current after otp validation
        self.connetionHandler.getRequest(for: .beginingTripNow, params: ["trip_id":self.orderID.description,
            "begin_latitude":location.coordinate.latitude,
            "begin_longitude":location.coordinate.longitude],
            showLoader: true).responseJSON({ (json) in
            if json.isSuccess {
                
            } else {
                self.tripView.progressBtn.setState(.normal)
                self.appDelegate.createToastMessage(json.status_message)
            }
        }).responseFailure({ (error) in
            
        })
    }
    func otpValidationCancelled() {
        self.tripView.progressBtn.setState(ProgressState.normal)
    }
    
}
//MARK:- ExtraTripFareDelegate
extension DeliveryTripManager : ExtraTripFareDelegate{

    func extraTripFareApplied(_ option: ExtraFareOption) {
        self.extraFareOption = option
        self.calculateOptimalRoute()
    }
    
    func extraTripFareCancelled() {
        self.extraFareOption = nil
        self.calculateOptimalRoute()
    }
}
//MARK:- calculateOptimalRoute
extension DeliveryTripManager {
    
    /**
     function to calculate optimal distance and path for the trip
     
     */
    func calculateOptimalRoute(){
        self.tripCache.getTravelledLocations(forTrip: self.orderID.description) { (locations) in
            var calculatingLocations  = locations
            let firstLoc : CLLocation
            let lastLoc : CLLocation
            if let first = calculatingLocations.first?.location,
                let last = calculatingLocations.last?.location{
                firstLoc = first
                lastLoc = last
            }else{
                let alternativeLocation = self.lastDriverLocation ??
                    LocationHandler.shared().lastKnownLocation ??
                    CLLocation()
               let addedLocation = CacheLocation(location: alternativeLocation,
                                                 isOffline: false,
                                                 timeStamp: Date())
                self.tripCache.addTravelledLocation(forTrip: self.orderID.description,addedLocation)
                calculatingLocations.append(addedLocation)
                firstLoc = alternativeLocation
                lastLoc = alternativeLocation
            }
            self.tripView.createPolyLine(start: firstLoc,
                                end: lastLoc,
                                skipValidation: true,
                                getDistance: { (distanceFromGoogle,googlePath) in
                                    
                                    debug(print: distanceFromGoogle.description)
                                    
                                    self.getBestPath(localDistance: self.tripCache.tripTravllerDistance,
                                                     localLocations: calculatingLocations,
                                                     googeDistance: distanceFromGoogle,
                                                     googlePath: googlePath)
            })
        }
        
    }
    /**
     validate weather google or local distance is optimal
     
     - NOTE: trip distance if calculated
     */
    func getBestPath(localDistance : Double,localLocations : [CacheLocation],
                     googeDistance : Double,googlePath : String){
        debug(print: "Local D : \(localDistance),Google D : \(googeDistance)")
        guard let firstLoc = localLocations.first,
            let lastLoc = localLocations.last else{
                let alternativeLocation = self.lastDriverLocation ??
                    LocationHandler.shared().lastKnownLocation ??
                CLLocation()
                self.tripCache.addTravelledLocation(forTrip: self.orderID.description,
                                                    CacheLocation(location: alternativeLocation,
                                                                  isOffline: false,
                                                                  timeStamp: Date()))
              
                self.tripView.progressBtn.setState(.normal)
                self.tripView.progressBtn.set2Trip(state: .deliverdOrderDel)
                return
                
        }
        if localDistance >= googeDistance{
            var locationStringArray = localLocations.compactMap({$0.description})
            if locationStringArray.count > 100{
                let filter_range = locationStringArray.count / 100
                locationStringArray = locationStringArray
                    .enumerated()
                    .filter({$0.offset % filter_range == 0})
                    .compactMap({$0.element})
            }
            let localTravelledPath = locationStringArray
                .joined(separator: "|")
            self.callStaticMap(withPath: localTravelledPath,
                               from: firstLoc.description,
                               to: lastLoc.description,
                               distance: localDistance)
        }else{
            self.callStaticMap(withPath: "enc:"+googlePath,
                               from: firstLoc.description,
                               to: lastLoc.description,
                               distance: googeDistance)
        }
    }
    /**
     remove all trip related data from cache
     
     - Warning:- Call only when trip is ended(After api confirmation for end trip)
     */
    func removeAllTripRelatedDataFromLocal(){
        
        self.currentTripStatus = .completed
        if self.serverLocationUpdateTimer != nil
        {
            self.serverLocationUpdateTimer?.invalidate()
        }
        Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        locationHandler.removeObserver(in: self)
        ChatInteractor.instance.deleteChats()
        self.tripDetailModel?.storeUserInfo(false)
        self.tripCache.removeTripDataFromLocale(self.orderID.description)
    }
    
}

//MARK:- ServerUpdates
extension DeliveryTripManager{
    /**
     update current driver location to firebase
     
     */
    func updateDriveLocToFirebase(location : CLLocation) {
        let tracking = FireBaseNodeKey.trip.ref()
        var locationInfo = [AnyHashable: Any]()
        locationInfo["lat"] = location.coordinate.latitude.description
        locationInfo["lng"] = location.coordinate.longitude.description
        tracking.child(self.orderID.description).child("Provider").setValue(locationInfo)
        
        
    }
    /**
     update current driver locaiton to server for every 10sec
     
     */
    @objc func updateCurrentLocationToServer(){
        guard let driverLocation = self.lastDriverLocation,
        self.currentTripStatus != TripStatus.completed else{return}
        var distance : Double
        if let oldLoc = self.locationVariableForDistanceCalculation {
            distance = oldLoc.distance(from: driverLocation) / 1000
        }else{
            distance = 0
        }
        self.locationVariableForDistanceCalculation = driverLocation
        let networkAvailable = NetworkManager.instance.isNetworkReachable
        var dicts = [String: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["latitude"] = driverLocation.coordinate.latitude.description
        dicts["longitude"] = driverLocation.coordinate.longitude.description
//        dicts["car_id"] = Constants().GETVALUE(keyname: USER_CAR_ID)
        dicts["timezone"] = self.localTimeZoneName
        dicts["status"] = Constants().GETVALUE(keyname: TRIP_STATUS)
        if dicts["status"] as! String == "Trip"{
            dicts["status"] = "Job"
        }
//        if !status.isEmpty{
//            switch status.lowercased() {
//            case let x where x.contains("trip"):
//                dicts["status"] = 2
//            case let x where x.contains("online"):
//                dicts["status"] = 1
//            default:
//                dicts["status"] = 0
//            }
//        }

        dicts["type"] = "2"
        if self.currentTripStatus.isDelOrderStarted{

           // dicts["status"] = 2
            dicts["total_km"] = distance.description
            dicts["order_id"] =  self.orderID.description
            tripCache.addTravelledLocation(forTrip: self.orderID.description,
                                           CacheLocation(location : driverLocation,
                                                         isOffline: !networkAvailable,
                                                         timeStamp: Date()))
        }
        self.connetionHandler.getRequest(for: .updateDriverLocation, params:dicts, showLoader: false).responseJSON({ (json) in
            if json.isSuccess {
                
            } else {
                self.tripView.progressBtn.setState(.normal)
                self.appDelegate.createToastMessage(json.status_message)
            }
        }).responseFailure({ (error) in
            
        })
    }
    func fetchTripDetails(){

        let support = UberSupport()
        support.showProgressInWindow(showAnimation:  true)
        
        print("Called here")
        self.connetionHandler
            .getRequest(for: .getDeliveryDetail,
                        params: ["order_id": self.orderID.description], showLoader: true)
            .responseDecode(to: OrderDetailHolder.self, { (response) in
               
                support.removeProgressInWindow()
                
                if response.statusCode != "0" {
                    
                self.tripDetailModel = nil
                self.tripDetailModel = response.orderDetails
                self.updateMarker()
                if let detail = self.tripDetailModel{
                    self.tripView.updateDestination(with: detail)
                }
                self.updateMarker()
                if let loc = self.lastDriverLocation{
                    self.didReceiveLocation(loc)
                }
                
                }
                
                else
                {
                
                    if !self.isnavigated
                    {
                        self.topMostViewController().navigationController?.popViewController(animated: true)
                        self.appDelegate.createToastMessage(response.statusMessage)

                    }
                    self.isnavigated = true
                    
                }
            })
            .responseFailure({ (error) in
                debug(print: error)
                support.removeProgressInWindow()
            })
     }
    func callStaticMap(withPath path: String,
                       from strPickup : String,
                       to strDrop : String,
                       distance : Double) {
            debug(print: "path"+path)
            debug(print: "strPickup"+strPickup)
            debug(print: "strDrop"+strDrop)
            UserDefaults.standard.array(forKey: "Locations")
            DispatchQueue.main.async {
                self.tripView.progressBtn.isUserInteractionEnabled = false//btnArriveNow
            }
        let pickupImgUrl = APIBaseUrl ?? "https://goferjek.trioangledemo.com/" + "/images/pickup.png?1"
        let dropImgUrl = APIBaseUrl ?? "https://goferjek.trioangledemo.com/" + "/images/drop.png?1"
        let staticImageUrl = "https://maps.googleapis.com/maps/api/staticmap?top=\(strPickup)&bottom=\(strDrop)&size=1350x400&markers=size:mid|icon:\(pickupImgUrl)|\(strPickup)&markers=size:mid|icon:\(dropImgUrl)|\(strDrop)&key=\(GooglePlacesApiKey)&path=color:0x2bcb7b|weight:4|\(path)"
        
        
       
    
        let darkStyle = staticImageUrl + "&style=element:geometry|invert_lightness:false&style=feature:landscape.natural.terrain|element:geometry|visibility:on&style=feature:landscape|element:geometry.fill|color:0x303030&style=feature:poi|element:geometry.fill|color:0x404040&style=feature:poi.park|element:geometry.fill|color:0x222222&style=feature:water|element:geometry|color:0x333333&style=feature:transit|element:geometry|visibility:on|color:0x333333&style=feature:road|element:geometry.stroke|visibility:on&style=feature:road.local|element:geometry.fill|color:0x606060&style=feature:road.arterial|element:geometry.fill|color:0x888888feature:road.local|element:geometry.fill|color:0x606060feature:road|color:0x606060|visibility:simplified&style=element:labels.text.fill|color:0x757575&style=element:labels.text.stroke|color:0x212121"
        print("DarkStyleImage==============>>>>>",darkStyle)
        

        if let LightUrlStr = staticImageUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed),
           let darkUrlStr = darkStyle.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed){
                        
                let lightImageurl = URL(string:"\(LightUrlStr)")
                let darkModeImageUrl = URL(string:"\(darkUrlStr)")
                if LightUrlStr != ""  && darkUrlStr != ""{
                    // UberSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
                    self.tripView.viewController.view.isUserInteractionEnabled = false
                    if let lightdata = try? Data(contentsOf: lightImageurl!),
                       let darkData = try? Data(contentsOf: darkModeImageUrl!)
                       
                    {
                        let mapLightImage:UIImage = UIImage(data: lightdata)!
                        let mapDarkImage:UIImage = UIImage(data: darkData)!
                        self.jpeg_map_snap_shot_light = mapLightImage.jpegData(compressionQuality: 1.0)//UIImageJPEGRepresentation(mapimage,1)
                        self.jpeg_map_snap_shot_dark = mapDarkImage.jpegData(compressionQuality: 1.0)
                        self.tripView.viewController.view.isUserInteractionEnabled = true
                        self.tripView.progressBtn.isUserInteractionEnabled = false//btnArriveNow
                        self.callEndTripAPI(with: distance)
                        
                    } else {
                        self.tripView.progressBtn.setState(.normal)
                        self.tripView.progressBtn.set2Trip(state: .deliverdOrderDel)
                        self.tripView.progressBtn.isUserInteractionEnabled = true//btnArriveNow
                        self.tripView.viewController.view.isUserInteractionEnabled = true
                    }
                } else{
                    self.tripView.progressBtn.setState(.normal)
                    self.tripView.progressBtn.set2Trip(state: .deliverdOrderDel)
                    self.tripView.viewController.view.isUserInteractionEnabled = true
                    self.tripView.progressBtn.isUserInteractionEnabled = true//btnArriveNow
                }
        }
                
            
    //        self.tripView.progressBtn.isUserInteractionEnabled = true//btnArriveNow
            
        }
    //MARK: - API CALL -> END TRIP
    /*
     AFTER API DONE, NAVIGATING TO RATING PAGE
     */
    func callEndTripAPI(with distance : Double)
    {
        var params = [String:Any]()
        params["order_id"] = self.orderID.description
        params["end_latitude"] = self.lastDriverLocation?.coordinate.latitude.description ?? ""
        params["end_longitude"] = self.lastDriverLocation?.coordinate.longitude.description ?? ""
        params["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        
        let distanceInKM = distance/1000
        params["total_km"] = distanceInKM.description
        
        if let option = self.extraFareOption{
            params["toll_reason_id"] = option.id
            params["toll_fee"] = option.amount
            if option.commentable , let comment = option.comment{
                params["toll_reason"] = comment
            }
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let dataLight = self.jpeg_map_snap_shot_light {
                multipartFormData.append(dataLight, withName: "map_image", fileName: "image.png", mimeType: "image/png")
            }
            if let dataDark = self.jpeg_map_snap_shot_dark {
                multipartFormData.append(dataDark, withName: "map_image_dark", fileName: "image_dark.png", mimeType: "image/png")
            }
        }, to: APIUrl+APIEnums.endDelivery.rawValue) .response { resp in
            switch resp.result {
            case .success(let data):
                do {
                    if let responseJson = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers) as? [String:Any] {
                        if responseJson["status_code"] as? String ?? String() == "1" {
                            self.currentTripStatus = .completed
                            let res : JSON = responseJson
                            self.removeAllTripRelatedDataFromLocal()
                            if res.bool("is_job_pending") {
                                self.tripView.checkForRemainingTrip()
                            } else {
                                Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
                                Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
                                UberSupport().removeProgressInWindow(viewCtrl: self.tripView.viewController)
                                self.currentTripStatus = .completed//.rating
                                self.tripView.onSuccessfullTripCompletion()
                            }
                        } else {
                            self.tripView.progressBtn.setState(.normal)
                            self.tripView.progressBtn.set2Trip(state: .deliverdOrderDel)
                            self.tripView.progressBtn.isUserInteractionEnabled = true
                            UberSupport().removeProgressInWindow(viewCtrl: self.tripView.viewController)
                            self.appDelegate.createToastMessageForAlamofire(responseJson.status_message,
                                                                            bgColor: UIColor.black,
                                                                            textColor: UIColor.white,
                                                                            forView: self.self.tripView.viewController.view)

                        }
                    }
                    

                } catch {
                    self.appDelegate.createToastMessage(error.localizedDescription)
                    self.tripView.progressBtn.setState(.normal)
                    self.tripView.progressBtn.set2Trip(state: .deliverdOrderDel)
                    self.tripView.progressBtn.isUserInteractionEnabled = true
                    print("Error in upload: \(error.localizedDescription)")
                }
                break

            case .failure(let error):
                self.appDelegate.createToastMessage(error.localizedDescription)
                self.tripView.progressBtn.setState(.normal)
                self.tripView.progressBtn.set2Trip(state: .deliverdOrderDel)
                self.tripView.progressBtn.isUserInteractionEnabled = true
                print("Error in upload: \(error.localizedDescription)")


            }
            
        }
        
    }
}
//MARK:- Background task termination
extension DeliveryTripManager {
    fileprivate func terminateBackgroundThread() {
        debug(print: "\(UIApplication.shared.backgroundTimeRemaining)")
      guard backGroundThread != .invalid else{return}
      guard UIApplication.shared.backgroundTimeRemaining < 1 else {return}
      UIApplication.shared.endBackgroundTask(backGroundThread)
      self.backGroundThread = .invalid
    }
    func stop(){
        self.serverLocationUpdateTimer?.invalidate()
    }
}


