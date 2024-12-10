//
//  LocationHandler.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

import CoreLocation

class LocationHandler : NSObject{
    static private var singleTon :  LocationHandlerProtocol = LocationHandler()
    static func `default`() -> LocationHandlerProtocol{
        return LocationHandler()
    }
    static func shared() -> LocationHandlerProtocol{
        return Self.singleTon
    }
    
    //background thread handler
    var backGroundThread : UIBackgroundTaskIdentifier = .invalid
    
    //MARK:- Varaibles
    var lastKnownLocation : CLLocation?{
        didSet{
            debug(print: "\(String(describing: self.lastKnownLocation))")
            guard let loc = self.lastKnownLocation else{return}
            self.observers.compactMap({$0.value}).forEach({$0(loc)})
            
        }
    }
    var isListenting  = false
    
    //MARK:- private Varaibles
    fileprivate var locationManager : CLLocationManager
    fileprivate var observers : [String : LocationObserver]
    //MARK:- init
    private override init() {
        self.locationManager = CLLocationManager()
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.observers = [:]
        super.init()
        
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
}
//MARK:- LocationHandlerProtocol
extension LocationHandler : LocationHandlerProtocol{
    
    func startListening(toLocationChanges listen : Bool){
        self.backGroundThread = UIApplication
            .shared
            .beginBackgroundTask {
                [weak self] in
                self?.terminateBackgroundThread()
        }
        self.isListenting = listen
        if listen{
            self.initLocaitonManger()
        }else{
            self.locationManager.stopUpdatingLocation()
            self.removeAllObservers()
        }
    }
    
    func addObserver(in object : Any, forLocationUpdates observer:@escaping (CLLocation) -> ()) {
        debug(print: "\(object)")
        self.observers["\(object)"] = observer
    }
    func removeObserver(in object: Any) {
        debug(print: "\(object)")
        guard self.observers.count > 0 else {return}
        self.observers.removeValue(forKey: "\(object)")
    }
    func removeAllObservers() {
        self.observers.removeAll()
    }
    
}
//MARK:- UDF
extension LocationHandler {
    fileprivate func initLocaitonManger(){
        guard  self.isListenting else {
            self.locationManager.stopUpdatingLocation()
            return
        }
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .restricted, .denied:
                self.forceEnablePermission()
            case .authorizedAlways, .authorizedWhenInUse:
                let alert = CommonAlert()
                alert.removeAlert()
                self.initLocationManagerWithAccuracy()
            case .notDetermined:
                fallthrough
            @unknown default:
                locationManager.requestWhenInUseAuthorization()
            }
          
        }
        else {
            self.forceEnablePermission()
        }
        
        
        locationManager.delegate = self
    }
    ///init LocationManager With Accuracy precise location
    private func initLocationManagerWithAccuracy(){
        if #available(iOS 14.0, *) {
            switch locationManager.accuracyAuthorization{
            case .reducedAccuracy:
                self.forceEnableAccuracy()
            case .fullAccuracy:
                self.locationManager.startUpdatingLocation()
            @unknown default:
                self.requestForAccuracy()
            }
        } else {
            // Fallback on earlier versions
            self.locationManager.startUpdatingLocation()
        }
    }
    ///Forcing user for Location Permission
    fileprivate func forceEnablePermission(){
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let root = appDelegate.window?.rootViewController else{return}
        let permission = PermissionManager(root,LocationConfig())
        guard permission.isEnabled else{
            permission.forceEnableService()
            return
        }
    }
    ///Requesting for precise accuracy
    @available(iOS 14.0, *)
    private func requestForAccuracy(){
        locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "wantAccurateLocation", completion: { [self]
            error in
            self.initLocaitonManger()
        })
    }
    ///Forcing user for Precise accuracy
    @available(iOS 14.0, *)
    private func forceEnableAccuracy(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let root = appDelegate.window?.rootViewController else{return}
        let permission = PermissionManager(root,PreciseLocationConfig(manager: self.locationManager))
        guard permission.isEnabled else{
            permission.forceEnableService()
            return
        }
    }
  
}
//MARK:- CLLocationManagerDelegate
extension LocationHandler : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if !self.isListenting {
            self.initLocaitonManger()
//        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        debug(print: "\(locations.last)")
        guard let newLocation = locations.last,//first!
                  newLocation.isValid,self.isValidLocation(newLocation)
        else{return}
        Constants().STOREVALUE(value: String(format: "%f", newLocation.coordinate.longitude) as String, keyname: USER_LONGITUDE)
        Constants().STOREVALUE(value: String(format: "%f", newLocation.coordinate.latitude) as String, keyname: USER_LATITUDE)
       
        self.lastKnownLocation = newLocation
      
    }
    /**
        validate drivers current location
        - Author: Abishek Robin
        - Parameters:
        - currentLocaiton: Current Driver CLLocation
        - NOTE: validate given location for difference of 10 sec and 5 meter distance from exisiting location
        */
    func isValidLocation(_ currentLocaiton : CLLocation) ->Bool{
     
        
        
        guard let lastLocation = self.lastKnownLocation else {//first time so no last user location
            self.lastKnownLocation = currentLocaiton
            return true
        }
        
        let maxAge:TimeInterval = 1;//minimum differenace between valid locaiton
        let minDistance = 25.0 // minimum distance difference
        
        let timeStampDif:Double = -(lastLocation.timestamp.timeIntervalSince(currentLocaiton.timestamp) )
        let deferedDistance = lastLocation.distance(from: currentLocaiton)
        
        let valid_TimeDifference = (timeStampDif  > maxAge)
        let valid_SpaceDifference = (deferedDistance > minDistance)
        
        let locationIsValid:Bool =  valid_TimeDifference && valid_SpaceDifference
        
     
        return locationIsValid
    }
}
extension LocationHandler{
    fileprivate func terminateBackgroundThread() {
        debug(print: "\(UIApplication.shared.backgroundTimeRemaining)")
        guard backGroundThread != .invalid else{return}
        guard UIApplication.shared.backgroundTimeRemaining < 1 else {return}
        
        UIApplication.shared.endBackgroundTask(backGroundThread)
        self.backGroundThread = .invalid
        
        self.startListening(toLocationChanges: self.isListenting)
    }
}
