//
//  TripManager.swift
//  GoferDriver
//
//  Created by trioangle on 06/12/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Alamofire
import GoogleMaps
import CoreLocation
import ARCarMovement

enum MultiTripStatus{
    case arrivedNow
    case beginTrip
    case toDropPoint(_ point : Int?)
    case toStartPoint(_ point : Int?)
    case endTrip
}



protocol TripManagerDelegate {
    var tripDataModel : JobDetailModel! { get set }
    var shouldFocusPolyline : Bool {get set}
    var gMapView : GMSMapView {get}
    var viewController : UIViewController {get}
    var progressBtn : ProgressButton {get}
    func updateDestination(with detail : JobDetailModel,skipPolyValidation : Bool)
    func createPolyLine(start : CLLocation,
                        end : CLLocation,
                        skipValidation : Bool,
                        getDistance : DistanceClosure?)
    func onSuccessfullTripCompletion()
    func deinitObjects()
    func currentImage(currentRider : Users)
    func moveToPayment(tripID : Int,status : TripStatus)
    func currentStatus(currentRider : Users) -> CLLocation
    func handleButtonInteraction(withCurrent current : CLLocation,forDrop drop: CLLocation)


}
extension TripManagerDelegate{
    
    func updateDestination(with detail : JobDetailModel){
        self.updateDestination(with: detail, skipPolyValidation: false)
    }
}
class TripManager : NSObject {
    
    //MARK:- TripData
    var started = Int()
    var tripDetailModel : JobDetailModel!
    var modelForYamini : JobDetailModel!

    //MARK:- private vaiables
    var tripView : TripManagerDelegate
    var currentSpeed :  Double = 30
    fileprivate var currentShareTripID : Int? = nil
    /**
     google marker for destination pin
     - Author: Abishek Robin
     - Warning: Can cause inconsistency in trip flow, if mishandled.
     */
    fileprivate var focusedDriver = false
    fileprivate let wayPointMarker : GMSMarker
    fileprivate let appDelegate : AppDelegate
    fileprivate let cameraDefaultZoom : Float = 16.5
    
    fileprivate var pipelineForeGroundId : Int? = nil
    fileprivate let arCarMovemnet: ARCarMovement!
    var returnBool = false
    var staticImageURL = ""

    /**
     object for singleton location handler
     - Author: Abishek Robin
     */
    fileprivate let locationHandler : LocationHandlerProtocol
    lazy var tripCache = TripCache()
    var tripStatus = String()
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
    fileprivate var jpeg_map_snap_shot : Data?
    fileprivate var jpeg_map_snap_shot_dark : Data?
    var iscalculationCalled = false
    var IstimerCalled = false

    //MARK:- Lazy & GET SET
    
    lazy var driverMarker : GMSMarker = {
        let marker = GMSMarker()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
        imageView.image = UIImage(named: "top view")
        marker.iconView = imageView
        
        //        marker.icon = UIImage(named: "cartopview2_40.png")
        marker.isFlat = true
        marker.map = self.tripView.gMapView
        if let lastKnow = self.lastDriverLocation{
            marker.position = lastKnow.coordinate
        }
        return marker
    }()
    /**
     common getter setter for tripStatus
     - Author: Abishek Robin
     - Note: state received and setter are maintained for entire flow
     */
    var currentTripStatus : TripStatus{
        get{
            let status = self.tripDetailModel.getCurrentTrip()?.jobStatus ?? TripStatus.pending
            if ![TripStatus.rating,.payment,.completed,.cancelled].contains(status){
                //DriverTripStatus.Trip.store()
            }
            return status
        }
        set{
            self.tripDetailModel.getCurrentTrip()?.jobStatus = newValue
            if ![TripStatus.rating,.payment,.completed,.cancelled].contains(newValue){
                DriverTripStatus.Trip.store()
            }
            self.updateMarker()
            if let newLocation = self.lastDriverLocation,
               let detail = self.tripDetailModel{
                self.tripView.createPolyLine(start: newLocation,
                                             end: detail.getCurrentTrip()?.getDestination ?? CLLocation(),
                                             skipValidation: true,
                                             getDistance: nil)
                
            }
        }
    }
    
    //MARK:- background thread handler
    var backGroundThread : UIBackgroundTaskIdentifier = .invalid
    
    //MARK:- init and deinit
    init(using delegate : TripManagerDelegate,
         forTrip trip : JobDetailModel){
        self.tripDetailModel = trip
        ///DELEGATE
        self.tripView = delegate
        ///DEFAULT VALUES
        self.wayPointMarker = GMSMarker()
        
        ///HANDLERS()
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
        
        if IstimerCalled == false {
            self.serverLocationUpdateTimer = Timer.scheduledTimer(timeInterval: TimeInterval(floatLiteral: AppWebConstants.locationUpdateTimeIntervel) ,
                                                                  target: self,
                                                                  selector: #selector(self.updateCurrentLocationToServer),
                                                                  userInfo: nil,
                                                                  repeats: true)
            IstimerCalled = true
            appDelegate.timerDriverLocation?.invalidate()
            
        }
        
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removeAllTripRelatedDataFromLocal),
                                               name: .TripCancelledByDriver,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removeAllTripRelatedDataFromLocal),
                                               name: .TripCancelled,
                                               object: nil)
        
    }
    deinit{
        self.locationHandler.removeObserver(in: self)
        self.serverLocationUpdateTimer?.invalidate()
        if let pipeID = self.pipelineForeGroundId{
            PipeLine.deleteEvent(withID: pipeID)
        }
        NotificationCenter.default.removeObserver(self, name: .TripCancelDriver, object: nil)
        NotificationCenter.default.removeObserver(self, name: .TripCancelled, object: nil)
    }
    func handleOnAppForeGroundActions(){
        guard self.currentTripStatus.isTripStarted else{return}
        self.locationHandler.startListening(toLocationChanges: true)
        
    }
    /**
     handler to listen for location update from singleton
     - Author: Abishek Robin
     */
    func startLocationObserver(){
        self.locationHandler.addObserver(in: self) { (location) in
            self.didReceiveLocation(location)
        }
    }
}
//MARK:- Location Updates
extension TripManager{
    /**
     filters received loaction and update carMarker and poyline
     - Author: Abishek Robin
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
        guard let lastLoc = self.lastDriverLocation?.coordinate else{
            self.lastDriverLocation = newLocation
            return
            
        }

        //MARK: location is valid
        DispatchQueue.performAsync(on: .main) { [weak self] in
            guard let welf = self else{return}
            welf.arCarMovemnet.arCarMovement(marker: welf.driverMarker, oldCoordinate: lastLoc, newCoordinate: newLocation.coordinate, mapView: welf.tripView.gMapView, bearing: 0.0)
            welf.updateDriveLocToFirebase(location: newLocation)
        }
        self.lastDriverLocation = newLocation
        self.tripView.createPolyLine(start: newLocation,
                                     end: detail.getCurrentTrip()?.getDestination ?? CLLocation(),
                                     skipValidation: false,
                                     getDistance: nil)
    }
    
}
//MARK:- MARKER UPDATES
extension TripManager{
    /**
     update wayPoint market according to trip Status
     - Author: Abishek Robin
     */
    func updateMarker(){
        guard let detail = self.tripDetailModel,
              let currentRider = detail.getCurrentTrip() else{
                  self.fetchTripDetails()
                  return
              }
        
        self.wayPointMarker.map = nil
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
     
        //        var image = self.tripView.currentImage(currentRider: currentRider)
                imageView2.image = UIImage(named: currentRider.getDestinationMarkerImage)//currentRider.getDestinationMarkerImage)
        wayPointMarker.iconView = imageView2
        
        //        self.wayPointMarker.icon = UIImage(named: currentRider.getDestinationMarkerImage)
        self.wayPointMarker.map = self.tripView.gMapView
        if let point = currentRider.wayPoints.filter({$0.isCompleted == 0}).first {
            var drop = CLLocation()
            drop = CLLocation(latitude: point.end.latitude?.toDouble() ?? 0.000, longitude: point.end.longitude?.toDouble() ?? 0.000)
            self.wayPointMarker.position = drop.coordinate
        } else {
            self.wayPointMarker.position = currentRider.getDestination.coordinate
        }


    }
}
//MARK:- ARCarMovementDelegate
extension TripManager : ARCarMovementDelegate {
    func arCarMovementMoved(_ marker: GMSMarker) {
        driverMarker.position = marker.position
        let updatedCamera = GMSCameraUpdate.setTarget(marker.position)
        self.tripView.gMapView.animate(with: updatedCamera)
        if !self.focusedDriver{
            self.tripView.gMapView.animate(toZoom: self.cameraDefaultZoom)
            self.focusedDriver = true
        }
        self.tripView.gMapView.animate(toBearing:  marker.rotation)
    }
    
    /**
     ARCarmovement delegate for marker location changes
     - Author: Abishek Robin
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
extension TripManager : ProgressButtonDelegates{
    func didActivateProgress() {
        switch currentTripStatus {
        case .scheduled,
                .manualBookingInfo,
                .manuallyBookedReminder,
                .manuallyBooked:
            
            
            //                 self.apiInteractor?
            //                    .getResponse(forAPI: .arrivedPickupNow,
            //                                 params: ["trip_id":self.tripDetailModel.getCurrentTrip()?.id ?? 0])
            //                    .shouldLoad(true)
            self.arrivedNow()
            
        case .beginTrip:
            //Verify otp from rider before calling api
            if self.tripDetailModel.getCurrentTrip()?.isRequiredOtp ?? false {
                let tripOTPVC = TripOTPVC.initWithStory(with: self)
                self.tripView.viewController.present(tripOTPVC, animated: true, completion: nil)
                
            }else{
                self.otpValidatedSuccesfully()
            }
            
        case .endTrip,.rating:
            if self.tripDetailModel?.getCurrentTrip()?.isMultiTrip ?? false,
               !(self.tripDetailModel?.getCurrentTrip()?.requestedToEndTrip ?? false),
               let completedWaypoint = self.tripDetailModel?.getCurrentTrip()? .wayPoints
                .filter({($0.isCompleted == 0)}).first{
                if self.tripDetailModel?.getCurrentTrip()?.wayPoints.filter({($0.isCompleted == 0)}).count == 1  {
                    if Shared.instance.isExtraFareEnabled(){
                        if let trip = self.tripDetailModel.getCurrentTrip() {
                            let extrafareVC = ExtraTripFareVC.initWithStory(self, businessID: 0)
                            self.tripView.viewController.present(extrafareVC, animated: true) {}
                        }
                    } else{
                        self.wayPointCompletedAPI()
                        self.calculateOptimalRoute()
                    }
                }else if completedWaypoint.isStarted == 0 {
                    self.wayPointStartedAPI()
                } else {
                    self.wayPointCompletedAPI()
                }
            } else {
                
                guard let lastLoc = self.lastDriverLocation else{
                    self.tripView.progressBtn.setState(.normal)
                    LocationHandler.shared().startListening(toLocationChanges: true)
                    self.appDelegate.createToastMessage(LangCommon.gettingLocationTryAgain)
                    return
                }
                self.didReceiveLocation(lastLoc)
                self.lastDriverLocation = lastLoc
                self.updateCurrentLocationToServer()
                
                if let data = self.tripDetailModel{
                    self.tripView.updateDestination(with: data)
                }else{
                    self.fetchTripDetails()
                }
                //prompt for extra fare options
                if Shared.instance.isExtraFareEnabled(){
                    if let trip = self.tripDetailModel.getCurrentTrip() {
                        let extrafareVC = ExtraTripFareVC.initWithStory(self,
                                                                        businessID: 4)
                        self.tripView.viewController.present(extrafareVC, animated: true) {}
                    }
                }else{
                    self.calculateOptimalRoute()
                }
            }
        default:
            print(currentTripStatus.getDisplayText)
        }
    }
    
    
    
    func wayPointStartedAPI() {
        
        if let completedWaypoint = self.tripDetailModel?.getCurrentTrip()?.wayPoints.filter({($0.isStarted == 0)}).first {
            var params = Parameters()
            params["id"] = completedWaypoint.id
            params["trip_id"] = self.tripDetailModel.getCurrentTrip()?.jobID ?? 0
            ConnectionHandler.shared.getRequest(for: .wayPointStarted, params: params, showLoader: false)
            .responseJSON({ (json) in
                if json.isSuccess,
                   let waypoints = self.tripDetailModel?.getCurrentTrip()?.wayPoints {
                    self.handleButton(forWaypoint: waypoints)
                    self.fetchTripDetails()
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
            })
            .responseFailure({ (error) in
                AppDelegate.shared.createToastMessage(error)
            })
        }
    }
    
    func wayPointCompletedAPI() {
        if let completedWaypoint = self.tripDetailModel?.getCurrentTrip()?.wayPoints.filter({($0.isCompleted == 0)}).first {
            var params = Parameters()
            params["id"] = completedWaypoint.id
            params["trip_id"] = self.tripDetailModel.getCurrentTrip()?.jobID ?? 0
            guard let loc = self.lastDriverLocation else {return}
            let str = decodeLocation(loc)
            params["drop_latitude"] = loc.coordinate.latitude
            params["drop_longitude"] = loc.coordinate.longitude
            params["drop_location"] = str
            ConnectionHandler.shared.getRequest(for: APIEnums.wayPointCompleted, params: params,showLoader: true)
                .responseJSON({ (json) in
                    if json.isSuccess,
                       let waypoints = self.tripDetailModel?.getCurrentTrip()?.wayPoints {
                        self.handleButton(forWaypoint: waypoints)
                        let id = json.int("waypoint_id")
                        let trip = JobDetailModel(json)
                        self.hello(id: id, trip)
                        print(json.status_message)
                        if self.returnBool{
                            print("trip to be ended")
                        } else {
                            return
                        }
                    }else{
                        AppDelegate.shared.createToastMessage(json.status_message)
                    }
                })
                .responseFailure({ (error) in
                    AppDelegate.shared.createToastMessage(error)
                })
        }
    }
    
    
    private
    func getStringAddress(from placemark: CLPlacemark) -> String {
        var string = String()
        if (placemark.thoroughfare != nil) {
            string += placemark.thoroughfare!
        }else if let subLocality = placemark.subLocality{
            string += subLocality
        }
        
        if (placemark.locality != nil) {
            if (string.count ) > 0 {
                string += ", "
            }
            string += placemark.locality!
        }
        
        if (placemark.administrativeArea != nil) {
            if (string.count ) > 0 {
                string += ", "
            }
            string += placemark.administrativeArea!
        }
        
        if (placemark.country != nil) {
            if (string.count ) > 0 {
                string += ", "
            }
            string += placemark.country!
        }
        return string
    }
    
    func decodeLocation(_ location : CLLocation) -> String{
        let geocoder = CLGeocoder()
        var addr = ""
        geocoder.reverseGeocodeLocation(location) { (places, error) in
            guard error == nil,let place = places?.first else{return}
            addr = self.getStringAddress(from: place)
            
        }
        return addr
    }
    
    func handleButton(forWaypoint wayPoints : [WayPoint]){
        if self.tripDetailModel.getCurrentTrip()?.wayPoints.filter({($0.isCompleted == 0)}).count == 1 {
            self.setButtonTitle(forMultiTripStatus: .endTrip)
        }
        if let startPoint = wayPoints.filter({$0.isCompleted == 0}).first{
            let index = wayPoints.firstIndex{$0 === startPoint}
            if wayPoints.first != startPoint{
                if self.tripDetailModel.getCurrentTrip()?.wayPoints.filter({($0.isCompleted == 0)}).count == 1 {
                    self.setButtonTitle(forMultiTripStatus: .endTrip)
                }
                if !(self.tripDetailModel.getCurrentTrip()?.jobStatus.isTripStarted ?? false){
                    self.setButtonTitle(forMultiTripStatus: .arrivedNow)
                    //                } else if self.tripDetailModel.getCurrentTrip()?.wayPoints.filter({($0.isCompleted == 0)}).count == 1 {
                    //                    self.setButtonTitle(forMultiTripStatus: .endTrip)
                }else if startPoint.isStarted == 0 {
                    if self.tripDetailModel.getCurrentTrip()?.wayPoints.filter({($0.isStarted == 0)}).count == 1 {
                        self.setButtonTitle(forMultiTripStatus: .endTrip)
                    } else {
                        self.setButtonTitle(forMultiTripStatus: MultiTripStatus.toStartPoint(index))
                    }
                }else {
                    self.setButtonTitle(forMultiTripStatus: MultiTripStatus.toDropPoint(index))
                }
            }
        }
        if self.tripDetailModel.getCurrentTrip()?.wayPoints.filter({($0.isCompleted == 0 && $0.isStarted == 0)}).count == 1 {
            self.setButtonTitle(forMultiTripStatus: .endTrip)
        }
        self.updateMarker()
    }
    
    
    func setButtonTitle(forMultiTripStatus status : MultiTripStatus){
        switch status {
        case .arrivedNow:
            self.tripView.progressBtn.setTitle("ARRIVE NOW", for: .normal)
            self.tripView.progressBtn.backgroundColor = UIColor.PrimaryColor
        case .beginTrip:
            if self.currentTripStatus.isTripStarted == false {
                self.tripView.progressBtn.setTitle("BEGIN TRIP", for: .normal)
                self.tripView.progressBtn.backgroundColor = UIColor.PrimaryColor
            }
        case .toStartPoint(let value):
            let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            let lettersArr = Array(letters)
            let index = (value ?? 0)
            print("index:", index)
            let char = lettersArr.value(atSafe: index) ?? lettersArr[0]
            self.tripView.progressBtn.setCustomTitle("\(LangCommon.startedAtStop) \(char)")
            self.tripView.progressBtn.backgroundColor = UIColor.PrimaryColor
        case .toDropPoint(let value):
            let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            let lettersArr = Array(letters)
            let index = (value ?? 0)
            print("index:", index)
            let char = lettersArr.value(atSafe: index) ?? lettersArr[0]
            self.tripView.progressBtn.setCustomTitle("\(LangCommon.reachedAtStop) \(char)")
            self.tripView.progressBtn.backgroundColor = UIColor.PrimaryColor
        case .endTrip:
            if self.currentTripStatus.isTripStarted == true {
                self.tripView.progressBtn.setTitle("END TRIP", for: .normal)
                self.tripView.progressBtn.backgroundColor = UIColor.PrimaryColor
            }
            returnBool = true
        }
    }
    
    func hello(id: Int?,_ detail:JobDetailModel){
        let completedWaypoint = self.tripDetailModel?.getCurrentTrip()?.wayPoints.filter({$0.id == id}).first
        Shared.instance.completedWayPoints.append(completedWaypoint!)
        completedWaypoint?.isCompleted = 1
        self.tripView.progressBtn.setState(.normal)
        self.tripView.shouldFocusPolyline = true
        if let lastLoc = self.locationHandler.lastKnownLocation{
            self.didReceiveLocation(lastLoc)
        }
        if self.tripDetailModel?.getCurrentTrip()?.isMultiTrip ?? false,
           let waypoints = self.tripDetailModel?.getCurrentTrip()?.wayPoints{
            self.handleButton(forWaypoint: waypoints)
        }
        detail.getCurrentTrip()?.storeRiderInfo(true)
        self.tripDetailModel = detail
        if let detail = self.tripDetailModel{
            self.tripView.updateDestination(with: detail)
        }
        self.tripView.updateDestination(with: self.tripDetailModel,skipPolyValidation: true)
        self.updateMarker()
    }
    

    

    
    
    func arrivedNow() {
        //        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared.getRequest(for: APIEnums.arrivedPickupNow,
                                               params: ["job_id":self.tripDetailModel.getCurrentTrip()?.jobID ?? 0],
                                               showLoader: true)
//            .responseJSON({ (json) in
//                if json.isSuccess {
//                    //                    UberSupport.shared.removeProgressInWindow()
//                    if json.status_code == 2{
//                        let settingsActionSheet: UIAlertController = UIAlertController(title: NSLocalizedString("Message!!!", comment: ""), message: json.status_message, preferredStyle: .alert)
//                        settingsActionSheet.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: ""), style: .cancel, handler:{ action in
//                            //                            @Karuppasamy
//                            //                            let redirect = DriverHomeViewController.initWithStory()
//                            //                            self.appDelegate.onSetRootViewController(viewCtrl: redirect)
//                        }))
//                        UIApplication.shared.keyWindow?.rootViewController?.present(settingsActionSheet, animated:true, completion:nil)
//
//                    }
//
////                    let trip = TripDetailDataModel( json)
////                    if trip.isPoolTrip{
////                        Shared.instance.resumeTripHitCount = 0
////                    }else{
////                        Shared.instance.resumeTripHitCount += 1
////                    }
////                    let detail = TripDetailDataModel( json)
////                    detail.getCurrentTrip()?.storeRiderInfo(true)
////                    self.tripDetailModel = detail
////                    self.tripView.tripDataModel = detail
////                    self.tripView.updateDestination(with: detail)
////                    self.switchToCurrent(tripID: self.currentShareTripID)
////                    if let data = self.tripDetailModel{
////                        self.tripView.updateDestination(with: data)
////                    }else{
////                        self.fetchTripDetails()
////                    }
////                }else{
////                    //                    UberSupport.shared.removeProgressInWindow()
////                    AppDelegate.shared.createToastMessage(json.status_message)
////                    self.tripView.progressBtn.setState(.normal)
////
////                }
//                    let trip = JobDetailModel( json)
//                    if trip.isPoolTrip{
//                        Shared.instance.resumeTripHitCount = 0
//                    }else{
//                        Shared.instance.resumeTripHitCount += 1
//                    }
//                    let detail = JobDetailModel( json)
//                    detail.getCurrentTrip()?.storeRiderInfo(true)
//                    self.tripDetailModel = detail
//                    self.tripView.tripDataModel = detail
//                    self.tripView.updateDestination(with: detail)
//                    self.switchToCurrent(tripID: self.currentShareTripID)
//                    if let data = self.tripDetailModel{
//                        self.tripView.updateDestination(with: data)
//                    }else{
//                        self.fetchTripDetails()
//                    }
//                }else{
//                    //                    UberSupport.shared.removeProgressInWindow()
//                    AppDelegate.shared.createToastMessage(json.status_message)
//                    self.tripView.progressBtn.setState(.normal)
//
//                }
//            })
        
            .responseDecode(to: JobDetailModel.self, { (response) in
                    if response.statusCode == "1" {
                        //                    UberSupport.shared.removeProgressInWindow()
                        if response.statusCode == "2"{
                            let settingsActionSheet: UIAlertController = UIAlertController(title: NSLocalizedString("Message!!!", comment: ""), message: response.statusMessage, preferredStyle: .alert)
                            settingsActionSheet.addAction(UIAlertAction(title:NSLocalizedString(LangCommon.ok, comment: ""), style: .cancel, handler:{ action in
                                //                            @Karuppasamy
                                //                            let redirect = DriverHomeViewController.initWithStory()
                                //                            self.appDelegate.onSetRootViewController(viewCtrl: redirect)
                                let redirect = HandyHomeMapVC.initWithStory()
                                self.appDelegate.onSetRootViewController(viewCtrl: redirect)
                            }))
                            UIApplication.shared.keyWindow?.rootViewController?.present(settingsActionSheet, animated:true, completion:nil)
                            
                        }
                        
//                        let trip = JobDetailModel( json)
                        if response.isPoolTrip{
                            Shared.instance.resumeTripHitCount = 0
                        }else{
                            Shared.instance.resumeTripHitCount += 1
                        }
//                        let detail = JobDetailModel( json)
                        response.getCurrentTrip()?.storeRiderInfo(true)
                        self.tripDetailModel = response
                        self.tripView.tripDataModel = response
                        self.tripView.updateDestination(with: self.modelForYamini)
                        
                        //   self.switchToCurrent(tripID: self.currentShareTripID)
                        if self.tripDetailModel?.getCurrentTrip()?.isMultiTrip ?? false,
                           let waypoints = self.tripDetailModel?.getCurrentTrip()?.wayPoints{
                            self.handleButton(forWaypoint: waypoints)
                        }else{
                            self.switchToCurrent(tripID: nil)
                        }
                        
                        
                        self.switchToCurrent(tripID: self.currentShareTripID)
                        if let data = self.tripDetailModel{
                            self.tripView.updateDestination(with: self.modelForYamini)
                        }else{
                            self.fetchTripDetails()
                        }
                    }else{
                        //                    UberSupport.shared.removeProgressInWindow()
                        AppDelegate.shared.createToastMessage(response.statusMessage)
                        self.tripView.progressBtn.setState(.normal)
                        
                    }
            })
            .responseFailure({ (error) in
                //                UberSupport.shared.removeProgressInWindow()
                AppDelegate.shared.createToastMessage(error)
                self.tripView.progressBtn.setState(.normal)
            })
    }
}


//MARK:- TripOTPDelegate
extension TripManager : TripOTPDelegate{
    
    var actualOTP: String? {
        let otp = self.tripDetailModel != nil ? self.tripDetailModel.getCurrentTrip()!.otp : ""
        print("∂OTP : \(otp)")
        return otp
    }
    func otpValidatedSuccesfully() {
        guard let location = self.lastDriverLocation else{
            self.tripView.progressBtn.setState(ProgressState.normal)
            self.appDelegate.createToastMessage(LangCommon.gettingLocationTryAgain)
            return
        }
        //calling beign trip with driver current after otp validation
        //        self.apiInteractor?
        //            .getResponse(forAPI: .beginingTripNow,
        //                         params: ["trip_id":self.tripDetailModel.getCurrentTrip()?.id ?? 0,
        //                                  "begin_latitude":location.coordinate.latitude,
        //                                  "begin_longitude":location.coordinate.longitude])
        //            .shouldLoad(true)
        //        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared.getRequest(for: APIEnums.beginingJobNow,
                                               params: ["job_id":self.tripDetailModel.getCurrentTrip()?.jobID ?? 0,"begin_latitude":location.coordinate.latitude,"begin_longitude":location.coordinate.longitude],
                                               showLoader: true)
//            .responseJSON({ (json) in
//                if json.isSuccess {
//                    //                    UberSupport.shared.removeProgressInWindow()
//                    if json.status_code == 2{
//                        let settingsActionSheet: UIAlertController = UIAlertController(title: NSLocalizedString("Message!!!", comment: ""), message: json.status_message, preferredStyle: .alert)
//                        settingsActionSheet.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: ""), style: .cancel, handler:{ action in
//                            //                            @Karuppasamy
//                            //                            let redirect = DriverHomeViewController.initWithStory()
//                            //                            self.appDelegate.onSetRootViewController(viewCtrl: redirect)
//                        }))
//                        UIApplication.shared.keyWindow?.rootViewController?.present(settingsActionSheet, animated:true, completion:nil)
//
//                    }
//
//                    let trip = TripDetailDataModel( json)
//                    if trip.isPoolTrip{
//                        Shared.instance.resumeTripHitCount = 0
//                    }else{
//                        Shared.instance.resumeTripHitCount += 1
//                    }
////                    let detail = TripDetailDataModel( json)
////                    detail.getCurrentTrip()?.storeRiderInfo(true)
////                    self.tripDetailModel = detail
////                    self.tripView.tripDataModel = detail
////                    self.tripView.updateDestination(with: detail)
////                    self.switchToCurrent(tripID: self.currentShareTripID)
////                    if let data = self.tripDetailModel{
////                        self.tripView.updateDestination(with: data)
////                    }else{
////                        self.fetchTripDetails()
////                    }
////                }else{
////                    //                    UberSupport.shared.removeProgressInWindow()
////                    AppDelegate.shared.createToastMessage(json.status_message)
////                    self.tripView.progressBtn.setState(.normal)
////
////                }
//                    let detail = JobDetailModel( json)
//                    detail.getCurrentTrip()?.storeRiderInfo(true)
//                    self.tripDetailModel = detail
//                    self.tripView.tripDataModel = detail
//                    self.tripView.updateDestination(with: detail)
//                    self.switchToCurrent(tripID: self.currentShareTripID)
//                    if let data = self.tripDetailModel{
//                        self.tripView.updateDestination(with: data)
//                    }else{
//                        self.fetchTripDetails()
//                    }
//                }else{
//                    //                    UberSupport.shared.removeProgressInWindow()
//                    AppDelegate.shared.createToastMessage(json.status_message)
//                    self.tripView.progressBtn.setState(.normal)
//
//                }
//            })
            .responseJSON({ JSON in
                print("uamini : \(JSON)")
                let users = JSON["users"] as? JSON
                self.tripStatus = users?.string("job_status") ?? ""
                self.fetchTripDetails()
            })
            .responseDecode(to: JobDetailModel.self, { response in
           print("uamini response \(response)")
                print(dump(response))
                if response.statusCode == "1" {
                    //                    UberSupport.shared.removeProgressInWindow()
                    if response.statusCode == "2"{
                        let settingsActionSheet: UIAlertController = UIAlertController(title: NSLocalizedString("Message!!!", comment: ""), message: response.statusMessage, preferredStyle: .alert)
                        settingsActionSheet.addAction(UIAlertAction(title:NSLocalizedString(LangCommon.ok, comment: ""), style: .cancel, handler:{ action in
                            //                            @Karuppasamy
                            //                            let redirect = DriverHomeViewController.initWithStory()
                            //                            self.appDelegate.onSetRootViewController(viewCtrl: redirect)
                            let redirect = HandyHomeMapVC.initWithStory()
                            self.appDelegate.onSetRootViewController(viewCtrl: redirect)
                        }))
                        UIApplication.shared.keyWindow?.rootViewController?.present(settingsActionSheet, animated:true, completion:nil)
                        
                    }
                    
//                    let trip = TripDetailDataModel( json)
                    if response.isPoolTrip{
                        Shared.instance.resumeTripHitCount = 0
                    }else{
                        Shared.instance.resumeTripHitCount += 1
                    }
//                    let detail = JobDetailModel( json)
                    response.getCurrentTrip()?.storeRiderInfo(true)
                    self.tripDetailModel = response
                    self.tripView.tripDataModel = response
                    self.tripView.updateDestination(with: self.modelForYamini)
                    if self.tripDetailModel?.getCurrentTrip()?.isMultiTrip ?? false,
                       let waypoints = self.tripDetailModel?.getCurrentTrip()?.wayPoints{
                        self.handleButton(forWaypoint: waypoints)
                    }else{
                        self.switchToCurrent(tripID: self.currentShareTripID)
                    }
//                    self.switchToCurrent(tripID: self.currentShareTripID)
                    if let data = self.tripDetailModel{
                       // self.tripView.updateDestination(with: self.modelForYamini)
                    }else{
                        self.fetchTripDetails()
                    }
                }else{
                    //                    UberSupport.shared.removeProgressInWindow()
                    AppDelegate.shared.createToastMessage(response.statusMessage)
                    self.tripView.progressBtn.setState(.normal)
                    
                }
            })
            .responseFailure({ (error) in
                //                UberSupport.shared.removeProgressInWindow()
                AppDelegate.shared.createToastMessage(error)
                self.tripView.progressBtn.setState(.normal)
            })
    }
    func otpValidationCancelled() {
        self.tripView.progressBtn.setState(ProgressState.normal)
    }
    
}
//MARK:- ExtraTripFareDelegate
extension TripManager : ExtraTripFareDelegate{
    
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
extension TripManager {
    
    /**
     update offline location travelled to server
     - Author: Abishek Robin
     */
    func updateOfflineDistanceToServer(){
        
        let offileDistance = self.tripCache.offilneDistance/1000// meter to km
        debug(print: offileDistance.description+"KM")
        
        var params = [String:Any]()
        params["latitude"] = self.lastDriverLocation?.coordinate.latitude.description ?? ""
        params["longitude"] = self.lastDriverLocation?.coordinate.longitude.description ?? ""
        params["car_id"] = Constants().GETVALUE(keyname: USER_CAR_ID)
        params["status"] = Constants().GETVALUE(keyname: TRIP_STATUS)
        if currentTripStatus.isTripStarted {
            params["total_km"] = offileDistance
            params["trip_id"] = self.tripDetailModel.getCurrentTrip()?.jobID ?? 0
        } else {
            params["total_km"] = 0.0
            params["trip_id"] = self.tripDetailModel.getCurrentTrip()?.jobID ?? 0
        }
        //        self.apiInteractor?.getResponse(forAPI: .updateDriverLocation,
        //                                        params: params).shouldLoad(false)
        ConnectionHandler.shared.getRequest(for: APIEnums.updateDriverLocation,
                                               params: params,
                                               showLoader: false)
            .responseJSON({ (json) in
                if json.isSuccess {
                    print(json.status_message)
                    if let data = self.tripDetailModel{
                       // self.tripView.updateDestination(with: data)
                    }else{
                        //self.fetchTripDetails()
                    }
                    
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
            })
            .responseFailure({ (error) in
                AppDelegate.shared.createToastMessage(error)
                
            })
    }
    /**
     function to calculate optimal distance and path for the trip
     - Author: Abishek Robin
     */
    func calculateOptimalRoute() {
        if self.tripDetailModel.isPoolTrip{
            //            self.callEndTripAPI(with: 0.0)
            let drop = self.lastDriverLocation ??
            LocationHandler.default().lastKnownLocation ??
            CLLocation()
            let pickUp : CLLocation
            if let currentTrip = self.tripDetailModel.getCurrentTrip(){
                pickUp = CLLocation(latitude: currentTrip.pickupLat,
                                    longitude: currentTrip.pickupLng)
            }else{
                pickUp = drop
            }
            self.tripView.createPolyLine(start: pickUp,
                                         end: drop,
                                         skipValidation: true,
                                         getDistance: { (distanceFromGoogle,googlePath) in
                debug(print: distanceFromGoogle.description)
                
                guard self.iscalculationCalled == false else { return }
                
                self.iscalculationCalled = true
                

                self.getBestPath(localDistance: 0.0,
                                 localLocations: [CacheLocation(location: pickUp,
                                                                isOffline: false,
                                                                timeStamp: Date()),
                                                  CacheLocation(location: drop,
                                                                isOffline: false,
                                                                timeStamp: Date())],
                                 googeDistance: distanceFromGoogle,
                                 googlePath: googlePath)
            })
            return
        }
        self.tripCache.getTravelledLocations(forTrip: (self.tripDetailModel.getCurrentTrip()?.jobID ?? 0).description) { (locations) in
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
                self.tripCache.addTravelledLocation(forTrip: (self.tripDetailModel.getCurrentTrip()?.jobID ?? 0).description,
                                                    addedLocation)
                calculatingLocations.append(addedLocation)
                firstLoc = alternativeLocation
                lastLoc = alternativeLocation
            }
            self.tripView.createPolyLine(start: firstLoc,
                                         end: lastLoc,
                                         skipValidation: true,
                                         getDistance: { (distanceFromGoogle,googlePath) in
                
                debug(print: distanceFromGoogle.description)
                guard self.iscalculationCalled == false else { return }
                
                self.iscalculationCalled = true


                self.getBestPath(localDistance: self.tripCache.tripTravllerDistance,
                                 localLocations: calculatingLocations,
                                 googeDistance: distanceFromGoogle,
                                 googlePath: googlePath)
            })
        }
        
    }
    /**
     validate weather google or local distance is optimal
     - Author: Abishek Robin
     - NOTE: trip distance if calculated
     */
    func getBestPath(localDistance : Double,localLocations : [CacheLocation],
                     googeDistance : Double,googlePath : String){
        debug(print: "Local D : \(localDistance),Google D : \(googeDistance)")
        guard let firstLoc = localLocations.first,
              let lastLoc = localLocations.last else{
                  let alternativeLocation = self.lastDriverLocation ??
                  LocationHandler.default().lastKnownLocation ??
                  CLLocation()
                  self.tripCache.addTravelledLocation(forTrip: (self.tripDetailModel.getCurrentTrip()?.jobID ?? 0).description,
                                                      CacheLocation(location: alternativeLocation,
                                                                    isOffline: false,
                                                                    timeStamp: Date()))
                  self.tripView.progressBtn.setState(.normal)
                  self.tripView.progressBtn.set2Trip(state: .endTrip)
                  return
                  
              }
        
        if !(self.tripDetailModel.isPoolTrip) && localDistance >= googeDistance{
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
     - Author: Abishek Robin
     - Warning:- Call only when trip is ended(After api confirmation for end trip)
     */
    @objc func removeAllTripRelatedDataFromLocal(){
        
        
        if self.serverLocationUpdateTimer != nil
        {
            self.serverLocationUpdateTimer?.invalidate()
        }
        locationHandler.removeObserver(in: self)
        ChatInteractor.instance.deleteChats()
        if self.tripDetailModel.isPoolTrip && self.tripDetailModel.users.count > 1{
            DriverTripStatus.Trip.store()
            
        }else{
            DriverTripStatus.Online.store()
        }
        self.tripView.deinitObjects()
        self.tripDetailModel.getCurrentTrip()?.storeRiderInfo(false)
        self.tripCache.removeTripDataFromLocale((self.tripDetailModel.getCurrentTrip()?.jobID ?? 0).description)
    }
    
}

//MARK:- ServerUpdates
extension TripManager{
    /**
     update current driver location to firebase
     - Author: Abishek Robin
     */
    func updateDriveLocToFirebase(location : CLLocation) {
        guard let trip = self.tripDetailModel.getCurrentTrip() else {return}
        let tracking = FireBaseNodeKey.trip.ref()//.child(trip.jobID.description ?? "").child("Provider")
//        var locationInfo = [AnyHashable: Any]()
//        locationInfo["lat"] = location.coordinate.latitude.description
//        locationInfo["lng"] = location.coordinate.longitude.description
        let json = [
            "lat" : location.coordinate.latitude,
            "lng" : location.coordinate.longitude
        ]
        for rider in self.tripDetailModel.users{
            tracking.child((rider.jobID).description).child("Provider").setValue(json)
        }
        
        
    }
    /**
     update current driver locaiton to server for every 10sec
     - Author: Abishek Robin
     */
    @objc
    func updateCurrentLocationToServer() {
        guard let driverLocation = self.lastDriverLocation else{return}
        let networkAvailable = NetworkManager.instance.isNetworkReachable
        var dicts = [String: Any]()
        dicts["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["latitude"] = driverLocation.coordinate.latitude.description
        dicts["longitude"] = driverLocation.coordinate.longitude.description
        dicts["car_id"] = Constants().GETVALUE(keyname: USER_CAR_ID)
        dicts["status"] = Constants().GETVALUE(keyname: TRIP_STATUS)
        dicts["user_type"] = "Driver"
        if self.currentTripStatus.isTripStarted{
            dicts["total_km"] = 0.0
            dicts["trip_id"] = self.tripDetailModel.id
            tripCache.addTravelledLocation(forTrip: (self.tripDetailModel.getCurrentTrip()?.jobID ?? 0).description,
                                           CacheLocation(location : driverLocation,
                                                         isOffline: !networkAvailable,
                                                         timeStamp: Date()))
        }else{
            dicts["total_km"] = 0.0
            dicts["trip_id"] = self.tripDetailModel.id
        }
        //        self.apiInteractor?.getResponse(forAPI: .updateDriverLocation,
        //                                        params: dicts)
        //            .shouldLoad(false)
        ConnectionHandler.shared.getRequest(for: APIEnums.updateDriverLocation,
                                               params: dicts,
                                               showLoader: false)
            .responseJSON({ (json) in
                if json.isSuccess {
                    print(json.status_message)
                    if let data = self.tripDetailModel{
                        //self.tripView.updateDestination(with: data)
                    }else{
                        //self.fetchTripDetails()
                    }
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
            })
//            .responseDecode(to: JobDetailModel.self, {(response) in
//                if response.statusCode == "1" {
//                    if let data = self.tripDetailModel{
//                        self.tripView.updateDestination(with: data)
//                    }else{
//                        self.fetchTripDetails()
//                    }
//                }else{
//                    AppDelegate.shared.createToastMessage(response.statusMessage)
//                }
//            })
            .responseFailure({ (error) in
                AppDelegate.shared.createToastMessage(error)
                
            })
    }
    func fetchTripDetails(){
        var params = JSON()
        if !self.tripDetailModel.isPoolTrip{
            params["job_id"] = self.tripDetailModel.getCurrentTrip()?.jobID.description ?? ""
        }
        
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared.getRequest(for: APIEnums.getJobDetails,
                                               params: params,
                                               showLoader: true)
//            .responseJSON({ (json) in
//                if json.isSuccess {
//                    UberSupport.shared.removeProgressInWindow()
////                    let detail = TripDetailDataModel( json)
////                    detail.getCurrentTrip()?.storeRiderInfo(true)
////                    self.tripDetailModel = detail
////                    self.tripView.tripDataModel = detail
////                    self.tripView.updateDestination(with: detail)
////
////                    self.switchToCurrent(tripID: self.currentShareTripID)
////                    if let data = self.tripDetailModel{
////                        self.tripView.updateDestination(with: data)
////                    }else{
////                        self.fetchTripDetails()
////                    }
////                }else{
////                    UberSupport.shared.removeProgressInWindow()
////                    AppDelegate.shared.createToastMessage(json.status_message)
////                }
//                    let detail = JobDetailModel( json)
//                    detail.getCurrentTrip()?.storeRiderInfo(true)
//                    self.tripDetailModel = detail
//                    self.tripView.tripDataModel = detail
//                    self.tripView.updateDestination(with: detail)
//
//                    self.switchToCurrent(tripID: self.currentShareTripID)
//                    if let data = self.tripDetailModel{
//                        self.tripView.updateDestination(with: data)
//                    }else{
//                        self.fetchTripDetails()
//                    }
//                }else{
//                    UberSupport.shared.removeProgressInWindow()
//                    AppDelegate.shared.createToastMessage(json.status_message)
//                }
//            })
            .responseDecode(to: JobDetailModel.self, { (response) in
                if response.statusCode == "1" {
                    UberSupport.shared.removeProgressInWindow()
//                    let detail = JobDetailModel( json)
                    response.getCurrentTrip()?.storeRiderInfo(true)
                    self.tripDetailModel = response
                    self.tripView.tripDataModel = response
                    self.modelForYamini = response

                    self.tripView.updateDestination(with: self.modelForYamini)
                    self.switchToCurrent(tripID: self.currentShareTripID)
                    if self.tripDetailModel?.getCurrentTrip()?.isMultiTrip ?? false,
                       let waypoints = self.tripDetailModel?.getCurrentTrip()?.wayPoints{
                        self.handleButton(forWaypoint: waypoints)
                    }else{
                        self.switchToCurrent(tripID: self.currentShareTripID)
                    }

                    if let data = self.tripDetailModel{
                        self.tripView.updateDestination(with: self.modelForYamini)
                    }else{
                        self.fetchTripDetails()
                    }
                    self.updateMarker()

                }else{
                    UberSupport.shared.removeProgressInWindow()
                    AppDelegate.shared.createToastMessage(response.statusMessage)
                }
            })
            .responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                AppDelegate.shared.createToastMessage(error)
                
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
        //            let staticImageUrl = "https://maps.googleapis.com/maps/api/staticmap?top=\(strPickup)&bottom=\(strDrop)&size=1500x400&markers=size:mid|icon:\(iApp.baseURL.rawValue)images/pickup.png|\(strPickup)&markers=size:mid|icon:\(iApp.baseURL.rawValue)images/drop.png|\(strDrop)&key=\(iApp.instance.GoogleApiKey)&path=color:0x000000|weight:5|\(path)"
        
        
        //        let staticImageUrl = "https://maps.googleapis.com/maps/api/staticmap?top=\(strPickup)&bottom=\(strDrop)&size=1500x400&markers=size:mid|icon:\(iApp.baseURL.rawValue)images/pickup.png|\(strPickup)&markers=size:mid|icon:\(iApp.baseURL.rawValue)images/drop.png|\(strDrop)&style=feature:water|element:geometry.fill|color:0xcad2d3&key=\(iApp.instance.GoogleApiKey)"
        let staticImageUrl = "https://maps.googleapis.com/maps/api/staticmap?top=\(strPickup)&bottom=\(strDrop)&size=1500x400&markers=size:mid|icon:\(pickupImgUrl)|\(strPickup)&markers=size:mid|icon:\(dropImgUrl)|\(strDrop) &style=feature:administrative|element:geometry.fill|color:0xf6f6f4&style=feature:administrative|element:geometry.stroke|color:0xf6f6f4&style=feature:administrative|element:labels.text.fill|color:0x8d8d8d&style=feature:landscape.man_made|element:geometry.fill|color:0xf6f6f4&style=feature:landscape.man_made|element:geometry.stroke|color:0xcfd4d5&style=feature:landscape.natural|element:geometry.fill|color:0xf6f6f4&style=feature:landscape.natural|element:labels.text.fill|color:0x8d8d8d&style=feature:landscape.natural.terrain|element:geometry|color:0xececec|visibility:off&style=feature:landscape.natural.terrain|element:geometry.fill|color:0xf6f6f4&style=feature:poi|element:geometry.fill|color:0xdde2e3&style=feature:poi|element:labels.text.fill|color:0x8d8d8d&style=feature:poi.park|element:geometry.fill|color:0xc3eea5&style=feature:poi.par|element:geometry.stroke|color:0xbae6a1&style=feature:poi.sports_complex|element:geometry.fill|color:0xf1f1eb&style=feature:poi.sports_complex|element:geometry.stroke|color:0xf1f1eb&style=feature:road.arterial|element:geometry.fill|color:0xfcfcfc&style=feature:road.highway|element:geometry.fill|color:0xeceeed&style=feature:road.highway|element:geometry.stroke|color:0xeceeed&style=feature:road.highway.controlled_access|element:geometry.fill|color:0xeceeed&style=feature:road.local|element:geometry.fill|color:0xfcfcfc&style=feature:transit.line|element:geometry.fill|color:0xc3d3d4&style=feature:transit.line|element:labels.text.fill|color:0xececec&style=feature:transit.station|element:labels.text.fill|color:0xc3d4d6&style=feature:water|element:geometry.fill|color:0xcad2d3&style=feature:administrative.neighborhood|element:labels.text.fill|lightness:25&style=feature:poi|element:labels.icon|saturation:-100&style=feature:poi|element:labels.icon|saturation:-45|lightness:10|visibility:on&style=feature:road.highway|element:labels.icon|visibility:on&style=feature:transit|element:labels.icon|saturation:-70&style=feature:transit.station.airport|element:geometry.fill|saturation:-100|lightness:-5&key=\(GooglePlacesApiKey)"
        
        let darkStyle = staticImageUrl + "&style=element:geometry|invert_lightness:false&style=feature:landscape.natural.terrain|element:geometry|visibility:on&style=feature:landscape|element:geometry.fill|color:0x303030&style=feature:poi|element:geometry.fill|color:0x404040&style=feature:poi.park|element:geometry.fill|color:0x222222&style=feature:water|element:geometry|color:0x333333&style=feature:transit|element:geometry|visibility:on|color:0x333333&style=feature:road|element:geometry.stroke|visibility:on&style=feature:road.local|element:geometry.fill|color:0x606060&style=feature:road.arterial|element:geometry.fill|color:0x888888feature:road.local|element:geometry.fill|color:0x606060feature:road|color:0x606060|visibility:simplified&style=element:labels.text.fill|color:0x757575&style=element:labels.text.stroke|color:0x212121"
        print("DarkStyleImage==============>>>>>",darkStyle)
        
        if tripDetailModel!.getCurrentTrip()?.isMultiTrip ?? false{
                   var arrCompleted = tripDetailModel!.getCurrentTrip()?.wayPoints//Shared.instance.completedWayPoints
                   arrCompleted?.removeLast()
                   for waypoint in arrCompleted! {
                       if waypoint.isCalculated{
                       let startlatlong = "\(waypoint.end.coords.latitude),\(waypoint.end.coords.longitude)"
                       //let pickupImgUrl = String(format:"%@public/images/pickup_icon|",iApp.baseURL.rawValue)
                       let pos = "&markers=size:mid|icon:\(APIBaseUrl)images/way_point.png|\(startlatlong)"
                       //let positionOnMap = "&markers=size:mid|icon:" + pickupImgUrl + startlatlong
                       staticImageURL = staticImageURL + pos
                       }
                   }
               }

        
        if let urlStr = staticImageUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! as NSString?,
            let darkUrlStr = darkStyle.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed){
            let imageUrl = urlStr as String
            
            var maps = UserDefaults.standard.string(forKey: "staticMaps")
            let darkModeImageUrl = URL(string:"\(darkUrlStr)")
            if maps == nil{
                maps = ""
            }
            maps?.append("\n"+imageUrl)
            UserDefaults.standard.set(maps, forKey: "staticMaps")
            
            let url = URL(string:"\(imageUrl)")
            if imageUrl != "" {
                self.tripView.viewController.view.isUserInteractionEnabled = false
                if let data = try? Data(contentsOf: url!),
                    let darkData = try? Data(contentsOf: darkModeImageUrl!) {
                    let mapimage:UIImage = UIImage(data: data)!
                    let mapDarkImage:UIImage = UIImage(data: darkData)!
                    self.jpeg_map_snap_shot_dark = mapDarkImage.jpegData(compressionQuality: 1.0)
                    self.jpeg_map_snap_shot = mapimage.jpegData(compressionQuality: 1.0)//UIImageJPEGRepresentation(mapimage,1)
                    self.tripView.viewController.view.isUserInteractionEnabled = true
                    self.tripView.progressBtn.isUserInteractionEnabled = false//btnArriveNow
                    self.callEndTripAPI(with: distance)
                } else {
                    self.tripView.progressBtn.setState(.normal)
                    self.tripView.progressBtn.set2Trip(state: .endTrip)
                    self.tripView.progressBtn.isUserInteractionEnabled = true//btnArriveNow
                }
            } else {
                self.tripView.progressBtn.setState(.normal)
                self.tripView.progressBtn.set2Trip(state: .endTrip)
                self.tripView.progressBtn.isUserInteractionEnabled = true//btnArriveNow
            }
            
        }
    }
    func jsonToString(json: AnyObject) -> String{
        do {
            let data1 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) as NSString? ?? ""
            debugPrint(convertedString)
            return convertedString as String
        } catch let myJSONError {
            debugPrint(myJSONError)
            return ""
        }
    }
    //MARK: - API CALL -> END TRIP
    /*
     AFTER API DONE, NAVIGATING TO RATING PAGE
     */
    func callEndTripAPI(with distance : Double) {
        var params = [String:Any]()
        params["job_id"] = (tripDetailModel.getCurrentTrip()?.jobID ?? 0).description
        params["end_latitude"] = self.lastDriverLocation?.coordinate.latitude.description ?? ""
        params["end_longitude"] = self.lastDriverLocation?.coordinate.longitude.description ?? ""
        params["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        params["location_path"] = ""

        
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
            if let data = self.jpeg_map_snap_shot {
                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            if let dataDark = self.jpeg_map_snap_shot_dark {
                multipartFormData.append(dataDark, withName: "dark_image", fileName: "dark_image.png", mimeType: "image/png")
            }
        }, to: APIBaseUrl+"api/end_job", method: .post) .response { resp in
            switch resp.result {
            case .success(let data):
                do {
                    if let responseJson = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers) as? [String:Any] {
                        if responseJson["status_code"] as? String ?? String() == "1" {
                            self.removeAllTripRelatedDataFromLocal()
                            Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
                            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
                            Constants().STOREVALUE(value: "", keyname: USER_CURRENT_TRIP_ID)
                            UberSupport().removeProgressInWindow(viewCtrl: self.tripView.viewController)
                            self.tripView.onSuccessfullTripCompletion()
                        } else {
                            self.tripView.progressBtn.setState(.normal)
                            self.tripView.progressBtn.set2Trip(state: .endTrip)
                            self.tripView.progressBtn.isUserInteractionEnabled = true
                            UberSupport().removeProgressInWindow(viewCtrl: self.tripView.viewController)
                            self.appDelegate.createToastMessageForAlamofire(responseJson.status_message,
                                                                            bgColor: UIColor.PrimaryColor,
                                                                            textColor: UIColor.PrimaryTextColor,
                                                                            forView: self.self.tripView.viewController.view)
                        }
                    }
                    
                } catch {
                    print("Something went wrong")
                }
                break
                
            case .failure(let error):
                self.appDelegate.createToastMessage(error.localizedDescription)
                self.tripView.progressBtn.setState(.normal)
                self.tripView.progressBtn.set2Trip(state: .endTrip)
                self.tripView.progressBtn.isUserInteractionEnabled = true
                print("Error in upload: \(error.localizedDescription)")
                break
                
                
            }
        }
    }
}
//MARK:- Background task termination
extension TripManager {
    fileprivate func terminateBackgroundThread() {
        debug(print: "\(UIApplication.shared.backgroundTimeRemaining)")
        guard backGroundThread != .invalid else{return}
        guard UIApplication.shared.backgroundTimeRemaining < 1 else {return}
        UIApplication.shared.endBackgroundTask(backGroundThread)
        self.backGroundThread = .invalid
    }
}
//MARK:- ShareRide Func
extension TripManager{
    
    func handleMultiDropOnLocationChange(_ newCoordinate : CLLocationCoordinate2D){
            let startLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            if let drop = self.tripDetailModel?.getCurrentTrip()?.wayPoints.filter({($0.isCompleted == 0)}).first?.end{
                let lat = drop.coords.latitude
                let long = drop.coords.longitude
                let dropLoc = CLLocation(latitude: lat, longitude: long)
                self.tripView.createPolyLine(start: startLocation,end: dropLoc, skipValidation: false,getDistance: nil)
                self.tripView.handleButtonInteraction(withCurrent: CLLocation(latitude: newCoordinate.latitude,longitude: newCoordinate.longitude),forDrop: drop.getLoc)
                self.handleButton(forWaypoint: self.tripDetailModel?.getCurrentTrip()?.wayPoints ?? [WayPoint]())
                self.updateMarker()
            }
        }
    
    
    func switchToCurrent(tripID : Int?){
        //        guard self.tripDetailModel.isPoolTrip else{return}
        //Resetting
        if let trip = self.tripDetailModel.users.filter({$0.id == tripID}).first {
            if trip.jobStatus >= .payment {
                self.tripView.moveToPayment(tripID: trip.jobID,
                                            status: trip.jobStatus)
            } else {
                self.currentShareTripID = tripID
                self.tripDetailModel.currentDriverPrefered = tripID
                self.tripView.tripDataModel.currentDriverPrefered = tripID
                //Showing newData
                self.focusedDriver = false
                self.tripView.progressBtn.set2Trip(state: self.currentTripStatus)
                self.tripView.progressBtn.setState(.normal)
                self.tripView.shouldFocusPolyline = true
                if let lastLoc = locationHandler.lastKnownLocation{
                    self.didReceiveLocation(lastLoc)
                }
                
                
                if self.tripDetailModel?.getCurrentTrip()?.isMultiTrip ?? false,
                   let waypoints = self.tripDetailModel?.getCurrentTrip()?.wayPoints{
                    self.handleButton(forWaypoint: waypoints)
                }else{
                    self.switchToCurrent(tripID: nil)
                }
                
                
                self.tripView.updateDestination(with: self.tripDetailModel,
                                                skipPolyValidation: true)
                self.updateMarker()
            }
        }
    }
}
