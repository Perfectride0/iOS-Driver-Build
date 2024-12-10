//
//  TripCache.swift
//  GoferDriver
//
//  Created by trioangle on 31/10/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation


class TripCache {
    
    
    
    
    private let preference : UserDefaults
    private let cacheLocationHandler : CoreDataHandler<CacheLocation>
    fileprivate var fetchingIntermediatePathFromGoogle = false
    //MARK:- variables getter and setter
    /**
     Distance travelled when network is unavailble
     - Author: Abishek Robin
     - Warning: value is in meter
     */
    var offilneDistance : Double{
        get{return UserDefaults.value(for: .trip_offline_distance) ?? 0}
        set{UserDefaults.set(newValue, for: .trip_offline_distance)}
    }
    /**
     Total distance travelled when network is unavailble
     - Author: Abishek Robin
     - Warning: value is in meter
     */
    var tripTravllerDistance : Double{
        get{return UserDefaults.value(for: .trip_travelled_distance) ?? 0}
        set{
            UserDefaults.set(newValue, for: .trip_travelled_distance)
            debug(print: newValue.description)
        }
    }
    var storedDatasTripID : String{
        get{return UserDefaults.value(for: .cache_location_trip_id) ?? String()}
        set{UserDefaults.set(newValue, for: .cache_location_trip_id)}
    }
    init() {
        self.preference = UserDefaults.standard
        self.cacheLocationHandler = CoreDataHandler()
    }
    deinit {
    }
    
    
    //MARK:- UDF
    func addTravelledLocation(forTrip id : String,_ newLocation : CacheLocation){
        if self.storedDatasTripID.isEmpty || self.storedDatasTripID != id{
            /*
             *  if not a matching trip id, remove currupted data
             */
            self.cacheLocationHandler.removeAll()
        }
        
        self.storedDatasTripID = id
        debug(print: "Trip ID : \(id),\(newLocation.description)")
        self.getTravelledLocations(forTrip: id) { (locations) in
            if let lastLoction = locations.last{
                let distance = lastLoction.location.distance(from: newLocation.location)
                let timeDifference = abs(lastLoction.timeStamp.timeIntervalSince(newLocation.timeStamp))
                guard !self.fetchingIntermediatePathFromGoogle,
                      distance > 25 else{return}
                if timeDifference > (1 * 60) &&
                    distance > 250{
                    self.updateGoogleDistance(fromLast: lastLoction,
                                              toNew: newLocation) { (_) in
                        self.fetchingIntermediatePathFromGoogle = false
                        self.cacheLocationHandler.store(data: newLocation)
                    }
                }else{
                    self.updateNewDistance(fromLast: lastLoction,
                                           toNew: newLocation)
                    self.cacheLocationHandler.store(data: newLocation)
                }
                
            }else{
                self.cacheLocationHandler.store(data: newLocation)
            }
        }
        
        
    }
    func getTravelledLocations(forTrip id : String,locaitons : @escaping ([CacheLocation])->() ){
        guard id == self.storedDatasTripID else{
            locaitons([CacheLocation]())
            return
        }
        return self.cacheLocationHandler.getData({ (cacheLocations) in
            cacheLocations.forEach({debug(print: $0.description+"\n")})
            locaitons(cacheLocations)
        })
    }
    func removeTripDataFromLocale(_ tripID : String){
        guard self.storedDatasTripID == tripID else{return}
        self.cacheLocationHandler.removeAll()
        UserDefaults.removeValue(for: .cache_location_trip_id)
        UserDefaults.removeValue(for: .trip_offline_distance)
        UserDefaults.removeValue(for: .trip_travelled_distance)
    }
    func offlineLocaitonUpdatedToServer(){
        debug(print: self.offilneDistance.description)
        UserDefaults.removeValue(for: .trip_offline_distance)
    }
    fileprivate func updateNewDistance(fromLast lastLoction : CacheLocation,
                                       toNew newLocation : CacheLocation){
        let newMovedDistance = newLocation.getDistance(between: lastLoction)
        self.tripTravllerDistance += newMovedDistance
        
        if newLocation.isOffline{
            self.offilneDistance += newMovedDistance
        }
    }
    fileprivate func updateGoogleDistance(fromLast lastLoction : CacheLocation,
                                          toNew newLocation : CacheLocation,
                                          onCompletion : @escaping Closure<Void>){
        self.fetchingIntermediatePathFromGoogle = true
        ConnectionHandler.shared.getRequest(forAPI: "https://maps.googleapis.com/maps/api/directions/json", params: [
            "origin" : "\(lastLoction.latitude),\(lastLoction.longitude)",
            "destination" :"\(newLocation.latitude),\(newLocation.longitude)",
            "mode" : "driving",
            "units" : "metric",
            "sensor" : "true",
            "key" : "\(GooglePlacesApiKey)"
        ], showLoader: true, cacheAttribute: .none)
        
            .responseDecode(to: GoogleGeocode.self, { (geocode) in
                if let leg = geocode.routes.first?.legs.first,
                   let pathStr = geocode.routes.first?.overviewPolyline.points,
                   let gmsPath = GMSPath(fromEncodedPath: pathStr){
                    
                    //                    leg.steps.compactMap({$0.endLocation}).forEach { (point) in
                    //
                    //                        self.cacheLocationHandler
                    //                            .store(data: CacheLocation(location: point.location,
                    //                                                       isOffline: newLocation.isOffline,
                    //                                                       timeStamp: newLocation.timeStamp))
                    //                    }
                    
                    for index in 0..<gmsPath.count(){
                        
                        self.cacheLocationHandler
                            .store(data: CacheLocation(location: gmsPath.coordinate(at: index).location,
                                                       isOffline: newLocation.isOffline,
                                                       timeStamp: newLocation.timeStamp))
                    }
                    let distance = Double(leg.distance.value)
                    self.tripTravllerDistance += distance
                    
                    if newLocation.isOffline{
                        self.offilneDistance += distance
                    }
                }
                onCompletion(Void())
            })
            .responseFailure({ (error) in
                debug(print: error)
                onCompletion(Void())
            })
    }
}

class CacheLocation : CoreDataModel{
    let latitude : Double
    let longitude : Double
    let is_offline : Int
    let time_stamp : String
    //MARK:- Getters
    var location : CLLocation{
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    var isOffline : Bool{
        return self.is_offline == 1
    }
    var timeStamp : Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")// set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from:self.time_stamp) ?? Date()
    }
    //MARK:- UDF
    init(latitude : Double,longitude : Double,isOffline : Bool,timeStamp : Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.is_offline = isOffline ? 1: 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")// set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.time_stamp = dateFormatter.string(from: timeStamp)
    }
    convenience init(location : CLLocation,isOffline : Bool,timeStamp : Date){
        self.init(latitude : location.coordinate.latitude,
                  longitude : location.coordinate.longitude,
                  isOffline : isOffline,
                  timeStamp: timeStamp)
    }
    func getDistance(between location : CacheLocation) -> Double{
        return location.location.distance(from: self.location)
    }
    
}
extension CacheLocation : CustomStringConvertible{
    var description: String{
        return "\(self.latitude),\(self.longitude)"
    }
}

class TestDate : CoreDataModel{
    let stamp : Date
    init(stamp : Date){
        self.stamp = stamp
    }
}

