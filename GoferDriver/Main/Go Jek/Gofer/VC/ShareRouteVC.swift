//
//  ShareRouteVC.swift
//  GoferDriver
//
//  Created by trioangle on 28/04/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreLocation
import GoogleMaps

class ShareRouteVC : BaseVC {
    
    //MARK:- Outlets
    
    @IBOutlet var shareRouteView : ShareRouteView!
    
    //MARK:- Varaibles
    var tripId : Int = 0
    var tripDataModel : JobDetailModel!
    var tripStatus : TripStatus = .pending
    var updateTripHistory : UpdateContentProtocol?
    var shouldFocusPolyline = true
    
    // MARK: - ViewController Methods
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var stopSwipeExitFromThisScreen: Bool? {
        return true
    }
    
    override
    func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        Constants().STOREVALUE(value: self.tripId.description,
                               keyname: USER_CURRENT_TRIP_ID)
        self.navigationController?.isNavigationBarHidden = true
        if let model = self.tripDataModel,
           let trip = model.getCurrentTrip(),
               !trip.pickupLat.isZero,
           !trip.pickupLng.isZero {
            let preference = UserDefaults.standard
            preference.set("\(trip.pickupLat),\(trip.pickupLng)",
                           forKey: PICKUP_COORDINATES)
            self.tripId = trip.id
            self.tripStatus = trip.jobStatus
            self.getTripDetails()
            //            self.shareRouteView.initialize()
//            UIView.animate(withDuration: 0.3,
//                           delay: 0,
//                           options: .curveEaseIn) {
//                self.shareRouteView.viewDetailHoder.transform = CGAffineTransform(scaleX: 1.15,
//                                                                                  y: 1)
//            } completion: { completed in
//                print(completed)
//            }

        } else {
            self.getTripDetails()
        }
    }

    override
    func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override
    var prefersStatusBarHidden: Bool {
        return false
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getTripDetails() {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        var param = JSON()
        if self.tripId != 0 {
            param["job_id"] = self.tripId.description
        }
        ConnectionHandler.shared
            .getRequest(for: .getJobDetails,
                           params: param,
                           showLoader: true)
//            .responseJSON({ (json) in
//                if json.isSuccess{
//                    UberSupport.shared.removeProgressInWindow()
//                    let trip = TripDetailDataModel(json)
//                    self.tripDataModel = trip
//                    self.tripId = trip.getCurrentTrip()?.id ?? 0
//                    self.tripStatus = trip.getCurrentTrip()?.status ?? .pending
//                    if let trip = self.tripDataModel.getCurrentTrip(),
//                       !trip.pickupLatitude.isZero,
//                       !trip.pickupLongitude.isZero {
//                        let preference = UserDefaults.standard
//                        preference.set("\(trip.pickupLatitude),\(trip.pickupLongitude)",
//                                       forKey: PICKUP_COORDINATES)
//                    }
//                    self.shareRouteView.initialize()
//                } else {
//                    UberSupport.shared.removeProgressInWindow()
//                }
//            })
            .responseDecode(to: JobDetailModel.self,  { (response) in
                if response.statusCode == "1"{
                    UberSupport.shared.removeProgressInWindow()
                    self.tripDataModel = response
                    Shared.instance.enableExtraFare(response.additionalfee)
                    if let trip = self.tripDataModel.getCurrentTrip(),
                       !trip.pickupLat.isZero,
                       !trip.pickupLng.isZero {
                        let preference = UserDefaults.standard
                        preference.set("\(trip.pickupLat),\(trip.pickupLng)",
                                       forKey: PICKUP_COORDINATES)
                        self.tripId = trip.id
                        self.tripStatus = trip.jobStatus
                        // Shared.instance.completedWayPoints = trip.wayPoints
                        // self.shareRouteView.wayPoints = Shared.instance.completedWayPoints
                        // print(self.shareRouteView.wayPoints)


                    }
                    self.shareRouteView.initialize()
                } else {
                    self.shareRouteView.initialize()
                    UberSupport.shared.removeProgressInWindow()
                }
            })
            .responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
            })
    }
  
    //MARK:- initWithStory
    class func initWithStory(tripDataModel: JobDetailModel?,
                             tripId:Int,
                             tripStatus: TripStatus) -> ShareRouteVC {
        let vc : ShareRouteVC = UIStoryboard.karuppasamy.instantiateViewController()
        if let tripDataModel = tripDataModel {
            vc.tripDataModel = tripDataModel
        }
        vc.tripId = tripId
        vc.tripStatus = tripStatus
        return vc
    }
    
}







