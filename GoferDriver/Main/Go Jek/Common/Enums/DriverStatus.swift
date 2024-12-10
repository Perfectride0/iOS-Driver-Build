//
//  DriverStatus.swift
//  GoferDriver
//
//  Created by trioangle on 22/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
let DRIVER_USER_STATUS = "user_driver_status"

enum DriverTripStatus : String{
    case Online
    case Offline
    case Trip
    case Job
    
    static var `default` : DriverTripStatus {
        let str : String = UserDefaults.value(for: .user_online_status) ?? ""
        return DriverTripStatus(rawValue: str) ?? .Offline
    }
    func store(){
        UserDefaults.set(self.rawValue, for: .user_online_status)
        UserDefaults.set(self.rawValue, for: .trip_status)
        
    }
}


enum DriverStatus : Int{
    case active = 5
    case inActive = 4
    case pending = 3
    case documentDetails = 2
    case carDetails = 1
    
    static func getStatus(forString string : String) -> DriverStatus{
        switch string {
        case "Active":
            return .active
        case "Inactive":
            return .inActive
        case "Pending":
            return .pending
        case "Car_details":
            return .carDetails
        case "Document_details":
            return .documentDetails
        default:
            return .pending
        }
    }
    static func getStatusFromPreference() -> DriverStatus{
        let preference = UserDefaults.standard
        return DriverStatus
            .init(rawValue: preference.integer(forKey: DRIVER_USER_STATUS)) ?? .pending
    }
    static func removerFromPreference(){
        let preference = UserDefaults.standard
        preference.removeObject(forKey: DRIVER_USER_STATUS)
    }
    func storeInPreference(){
        let prefernce = UserDefaults.standard
        prefernce.set(self.rawValue, forKey: DRIVER_USER_STATUS)
    }
    var getString : String{
        switch self {
        case .active:
            return LangCommon.active
        case .inActive:
            return LangCommon.inActive
        case .pending:
            return LangCommon.pendingStatus
        case .carDetails:
            return "Car_details"
        case .documentDetails:
            return "Document_details"
        }
    }
}
