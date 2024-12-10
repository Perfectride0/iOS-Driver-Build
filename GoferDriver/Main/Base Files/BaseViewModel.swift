//
//  BaseViewModel.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import CoreLocation

class BaseViewModel: NSObject {
    
    lazy var connectionHandler = ConnectionHandler()
     var locationHandler : LocationHandlerProtocol?
        func getCurrentLocation(_ fetchedLocation : @escaping Closure<MyLocationModel>){
            self.locationHandler = LocationHandler.default()
            if let lastLoc = self.locationHandler?.lastKnownLocation,
                lastLoc.timestamp.timeIntervalSince(Date()) < 1200{
                    fetchedLocation(MyLocationModel(location: lastLoc))
                    self.locationHandler?.startListening(toLocationChanges: false)
                    self.locationHandler?.removeObserver(in: self)
                return
            }
                
            self.locationHandler?.addObserver(in: self) { (location) in
                fetchedLocation(MyLocationModel(location: location))
                self.locationHandler?.startListening(toLocationChanges: false)
                self.locationHandler?.removeObserver(in: self)
            }
            self.locationHandler?.startListening(toLocationChanges: true)
            
        }
}
