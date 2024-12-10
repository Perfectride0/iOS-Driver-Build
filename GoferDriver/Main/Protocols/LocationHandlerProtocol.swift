//
//  LocationHandlerProtocol.swift
//  GoferDriver
//
//  Created by trioangle on 14/12/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import CoreLocation


typealias LocationObserver = (CLLocation)->()


protocol LocationHandlerProtocol {
    /**
    last registered driver location
     - Author: Abishek Robin
     */
    var lastKnownLocation : CLLocation? {get set}
    
    /**
     force manget to start or stop listening drivers location
     - Author: Abishek Robin
     - Parameters:
     - toLocationChanges: whether to lister for changes or not
     - Note: Manager will handle all the authorization states
     */
    func startListening(toLocationChanges listen : Bool)
    
    /**
    get updates when location is changed
    - Author: Abishek Robin
    - Parameters:
    - in: caller (used as ID)
    - observer: LocationObserver : (CLLocation)->()
    - Warning: use one lisener for a class
    */
    func addObserver(in object : Any,forLocationUpdates observer:@escaping LocationObserver)
    
     /**
      stop getting updates when location is changed
      - Author: Abishek Robin
      - Parameters:
      - in: caller (used as ID)
      - Warning: use one lisener for a class
      */
    func removeObserver(in object : Any)
    
    /**
       disconnect every listener on application
       - Author: Abishek Robin
       */
    func removeAllObservers()
    
}
