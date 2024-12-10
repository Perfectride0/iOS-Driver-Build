//
//  ServiceModel.swift
//  Handyman
//
//  Created by trioangle1 on 11/08/20.
//  Copyright © 2020 trioangle. All rights reserved.
//

import UIKit


enum PaymentResponsible : String,Codable{
    case sender
    case receiver
    case eachReceipient = "recipients"
}


import UIKit
//initial commit
enum PriceType : String,Codable{
    case Fixed = "Fixed"
    case Hourly = "Hourly"
    case Distance = "Time & Distance"
}
// Handy Splitup Start
enum BusinessType : Int, Codable,CaseIterable{

    case Delivery = 2
    case DeliveryAll = 3
    case Ride = 4
    case Gojek = 8
    case Tow = 7
    case Instacart = 5
    case Laundry = 6
    case Services = 1

    var APIBaseURL : String {
        switch self {
        case .Services:
            return APIUrl
        case .Ride:
            return "http://gofer.trioangledemo.com/api/"
        case .Delivery:
            return "https://goferdelivery.trioangledemo.com/api/"
        case .DeliveryAll:
            return "https://goferdeliveryall.trioangledemo.com/api/"
        case .Laundry:
            return "https://laundry.trioangledemo.com/api/"
        case .Instacart:
            return "https://gofercart.trioangledemo.com/api/"
        case .Gojek:
            return ""
        case .Tow:
            return ""
        }
    }
    
    func saveName(BusinessID: Int,
                  value: String) {
        if let business = BusinessType.allCases.filter({$0.rawValue == BusinessID}).first {
            UserDefaults.standard.set(value,
                                      forKey: business.LocalizedString)
        }
    }
    
    var LocalToken : String {
        switch self {
        case .Services:
            return ""
        case .Ride:
            return ""
        case .Delivery:
            return ""
        case .DeliveryAll:
            return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2dvZmVyZGVsaXZlcnlhbGwudHJpb2FuZ2xlZGVtby5jb20vYXBpL2xvZ2luIiwiaWF0IjoxNjI3NjE1OTc3LCJleHAiOjE2MzAyNDM5NzcsIm5iZiI6MTYyNzYxNTk3NywianRpIjoiQnNMZlZ3cEVuY0Y2clliWSIsInN1YiI6MTAwNzIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.P3VP32lpYOs59vHggEmPErjk-BpZin1E5h7azbU63CU"
        case .Laundry:
            return ""
        case .Instacart:
            return ""
        case .Gojek:
            return ""
        case .Tow:
            return ""
        }
    }
    
    var LocalizedString: String {
        switch self {
        case .Services:
            return "Services"
        case .Ride:
            return "Ride"
        case .Delivery:
            return "Delivery"
        case .DeliveryAll:
            return "DeliveryAll"
        case .Laundry:
            return "Laundry"
        case .Instacart:
            return "Instacart"
        case .Gojek:
            return ""
        case .Tow:
            return "Tow"
        }
    }
}
// Handy Splitup Start



