//
//  MyLocationModel.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 08/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MyLocationModel : CLLocation{
    private var address : String?

     init(address : String? = nil,location : CLLocation){
        self.address = address
    
        super.init(coordinate: location.coordinate,
                   altitude: location.altitude,
                   horizontalAccuracy: location.horizontalAccuracy,
                   verticalAccuracy: location.verticalAccuracy,
                   timestamp: Date())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func getAddress() -> String?{
        return self.address
    }
    func getAddress(_ address : @escaping Closure<String?>){
        if let _address = self.address{
            address(_address)
        }else{
          //  let geocoder = CLGeocoder()
//            geocoder.reverseGeocodeLocation(self) { (placemarkers, error) in
//                if let placeMarker = placemarkers?.first{
//                    self.address = placeMarker.compactAddress
//                    address(placeMarker.compactAddress)
//                }else{
//                    address(nil)
//                }
//            }
            let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
                        aGMSGeocoder.reverseGeocodeCoordinate(CLLocationCoordinate2DMake(self.coordinate.latitude, self.coordinate.longitude)) { (response, error) in
                            if error == nil && response != nil {
                                let gmsAddress: GMSAddress = response?.firstResult() ?? GMSAddress()
                                print("\ncoordinate.latitude=\(gmsAddress.coordinate.latitude)")
                                print("coordinate.longitude=\(gmsAddress.coordinate.longitude)")
                                print("thoroughfare=\(gmsAddress.thoroughfare ?? "")")
                                print("locality=\(gmsAddress.locality ?? "")")
                                print("subLocality=\(gmsAddress.subLocality ?? "")")
                                print("administrativeArea=\(gmsAddress.administrativeArea ?? "")")
                                print("postalCode=\(gmsAddress.postalCode ?? "")")
                                print("country=\(gmsAddress.country ?? "")")
                                print("lines=\(gmsAddress.lines ?? [])")
                                self.address = gmsAddress.lines?.last
                                address(gmsAddress.lines?.last)
                            }
                            else{
                                address(nil)
                            }
                        }
        }
    }
}
