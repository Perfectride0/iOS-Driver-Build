//
//  NavigationEnum.swift
//  GoferDriver
//
//  Created by trioangle on 05/12/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

enum ThirdPartyNavigation{
    case waze(pickup : CLLocationCoordinate2D,drop : CLLocationCoordinate2D)
    case google(pickup : CLLocationCoordinate2D,drop : CLLocationCoordinate2D)
}
extension ThirdPartyNavigation{
    //MARK:- application available
    var isApplicationAvailable : Bool{
        let url : URL
        switch self {
        case .waze(pickup: _, drop: _):
            guard let _url = URL(string:"waze://") else{return false}
            url = _url
        case .google(pickup: _, drop: _):
            guard let _url = URL(string:"comgooglemaps://") else{return false}
            url = _url
        }
        return UIApplication.shared.canOpenURL(url)
    }
    //MARK:- directionURL
    func openThirdPartyDirection(){
        let url : URL?
        switch self {
        case .waze(pickup: let pick, drop: let drop):
            let req_str_url = "?ll=\(drop.latitude),\(drop.longitude)&from=\(pick.latitude),\(pick.longitude)"
            url = URL(string: ("https://waze.com/ul\(req_str_url)&at=now&navigate=yes&zoom=17"))
        case .google(pickup: let pick, drop: let drop):
            let req_str_url = "?saddr=\(pick.latitude),\(pick.longitude)&daddr=\(drop.latitude),\(drop.longitude)"
            url = URL(string: ("comgooglemaps://"+req_str_url+"&zoom=14&views=traffic"))
        }
        guard let stableURL = url else{return}
        if #available(iOS 10.0, *){
            UIApplication.shared.open(stableURL, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.openURL(stableURL)
        }
    }
    //MARK:- openAppStorePage
    func openAppStorePage(){
        let url : URL
        switch self {
        case .waze(pickup: _, drop: _):
            url = URL(string:"http://itunes.apple.com/us/app/id323229106")!
        case .google(pickup: _, drop: _):
            url = URL(string:"https://itunes.apple.com/us/app/google-maps-transit-food/id585027354?mt=8")!
        }
        if #available(iOS 10.0, *){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.openURL(url)
        }
        
    }
    //MARK:- permission text
    var getDownloadPermissionText : String{
        switch self {
        case .waze(pickup: _, drop: _):
            return  LangCommon.pleaseInstallWazeMapsApp
        case .google(pickup: _, drop: _):
            return  LangCommon.pleaseInstallGoogleMapsApp
        }
    }
}

       
