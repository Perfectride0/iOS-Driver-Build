//
//  Constants.swift
//  GoferDriver
//
//  Created by Trioangle Technologies on 28/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

struct ImageConstants {
    
    let phone = "phone"
    
    let account = "account"
    
    let mapMarker = "map_marker"
    
    let clockOutline = "clock_outline"
    
    let busIcon = "bus_alert"
    
    let taxiIcon = "taxi"
    
    let radioSelected = "Radio_btn_selected"
    
    let radioUnselected = "Radio_btn_unselected"
    
    let phnIcon = "User_id"
    
    let pwdIcon = "Password"
    
}

extension NSNotification.Name{
    static let networkStateChanged = NSNotification.Name(rawValue: "network_reachability_observer")
    static let ContainerToHolderViews = NSNotification.Name(rawValue: "container_to_holder_views")
    static let HolderViewsToContainer = NSNotification.Name(rawValue: "holder_views_to_container")
}

