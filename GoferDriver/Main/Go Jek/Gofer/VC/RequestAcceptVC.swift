//
//  RequestAcceptVC.swift
//  Goferjek Driver
//
//  Created by trioangle on 19/10/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import FirebaseDatabase
import Foundation
import GoogleMaps
import Alamofire

class RequestAcceptVC: BaseVC {

    @IBOutlet var requestView: RequestAcceptView!
    
    lazy var spinnerView = JTMaterialSpinner()
    lazy var gif = UIView()
    
    var timerAni = Timer()
    var timerCancelTrip = Timer()
    static var ScreenIsActive = false
    lazy var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var player: AVAudioPlayer?
    var strRequestID = ""
    var isPoolRequest = false
    var localTimeZoneName: String { return TimeZone.current.identifier }
    var strPickupLocation = ""
    var strDropLocation = ""
    var strPickupTime = ""
    var strPickUpLatitude = ""
    var strPickUpLongitude = ""
    var startTime: String?
    var endTime: String?
    var requestTime = 10
    var maxReqTime : Int?
    var numberOfSeats = 1
    var no_of_stops = 0
    var isMultiTrip = Bool()

    static var requestID : Int? = nil
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Self.ScreenIsActive = true
        self.initNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Self.ScreenIsActive = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
           self.removeMemory()
       }
    
    //MARK:- initWithStory
    class func initWithStory() -> RequestAcceptVC{
        let view : RequestAcceptVC = UIStoryboard.shruti.instantiateViewController()
        return view
    }

    func initNotification() {
        NotificationEnum.cancelRequest.removeObserver(self)
        NotificationEnum.cancelRequest.addObserver(self,
                                                   selector: #selector(self.cancelRequestUsingID(_:)))
    }

    
    @objc
    func cancelRequestUsingID(_ notification:Notification) {
        if let json = notification.userInfo as? JSON {
            let requestID = json.int("request_id")
            if requestID.description == strRequestID {
                self.onGoBack()
            }
        }
    }
    
    func removeMemory() {
        self.requestView.gMapView?.removeFromSuperview()
        self.requestView.gMapView = nil
    }
    
    //MARK: ACCEPT RIDER TRIP REQUEST
    func callRequestAcceptAPI(status: String) {
        if !isSimulator {
            if !(UIApplication.shared.isRegisteredForRemoteNotifications) {
                let settingsActionSheet: UIAlertController = UIAlertController(title:LangCommon.message, message: LangCommon.pleaseEnablePushNotification.uppercased(),preferredStyle:UIAlertController.Style.alert)
                settingsActionSheet.addAction(UIAlertAction(title:NSLocalizedString(LangCommon.ok, comment: ""), style:UIAlertAction.Style.cancel, handler:{ action in
                    self.appDelegate.pushManager.registerForRemoteNotification()
                }))
                present(settingsActionSheet, animated:true, completion:nil)
                return
            }
        }
        
        clearAllAnimations()
        self.requestView.btnAccept.isUserInteractionEnabled = false
        var dicts = Parameters()
//        dicts["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
//        dicts["status"] = status
        dicts["request_id"] = strRequestID
        dicts["timezone"] = self.localTimeZoneName        
        ConnectionHandler.shared.getRequest(for: APIEnums.acceptRequest, params: dicts, showLoader: false)
//            .responseJSON({ (json) in
//               let tripDetailData = TripDetailDataModel(json)
//               if json.isSuccess{
//                   self.handleResponse(gModel: tripDetailData,status : status)
//               }else{
//                   self.appDelegate.createToastMessage(json.status_message)
//               }
//           })
            .responseDecode(to: JobDetailModel.self, { (response) in
//               let tripDetailData = TripDetailDataModel(json)
               if response.statusCode == "1" {
                   self.handleResponse(gModel: response,status : status)
               }else{
                   self.appDelegate.createToastMessage(response.statusMessage)
               }
           })
            .responseFailure({ (error) in
               self.appDelegate.createToastMessage(error)
           })
    }
    
    
    func handleResponse(gModel : JobDetailModel,status : String){
        if gModel.statusCode == "1"
        {
            Self.ScreenIsActive = false
            self.isMultiTrip = ((gModel.getCurrentTrip()?.isMultiTrip) != nil)
            let cash = gModel.getCurrentTrip()?.paymentMode ?? "cash"
            Constants().STOREVALUE(value: status, keyname: USER_ONLINE_STATUS)
            Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
            Constants().STOREVALUE(value:  cash, keyname: CASH_PAYMENT)
            self.gotoToRouteView(with: gModel)
        }
        else if gModel.statusCode == "0"{
            print(gModel.statusMessage)
            let messages = gModel.statusMessage
            print(messages)
            if(messages == LangCommon.alreadyAccepted) {
                let msg = LangCommon.alreadyAcceptedBySomeone
                self.appDelegate.createToastMessage(msg,
                                                    bgColor: UIColor.PrimaryColor,
                                                    textColor: UIColor.PrimaryTextColor)
                Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
                let userDefaults = UserDefaults.standard
                userDefaults.set("driver", forKey:"getmainpage")
                self.appDelegate.onSetRootViewController(viewCtrl: self)                        }
            else{
                Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            }
        }
        else
        {
            if gModel.statusMessage == "user_not_found" || gModel.statusMessage == "token_invalid" || gModel.statusMessage == "Invalid credentials" || gModel.statusMessage == "Authentication Failed"
            {
                self.appDelegate.logOutDidFinish()
                return
            }
            else{
            }
        }
    }
    
    // MARK: - NAVIGATE TO ROUTE VIEW AFTER ACCETPTING REQUEST
    func gotoToRouteView(with trip : JobDetailModel) {
//        FireBaseNodeKey.rider.setValue(trip.description, for: "\(trip.getCurrentTrip()!.riderID)","trip_id")
        UserDefaults.removeValue(for: .requestID)
        Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
        //        Shared.instance.completedWayPoints.removeAll()

        guard let currentTrip = trip.getCurrentTrip() else { return }
        let tripView = ShareRouteVC.initWithStory(tripDataModel: nil,
                                                  tripId: 0,
                                                  tripStatus: currentTrip.jobStatus)
        self.navigationController?.pushViewController(tripView, animated: true)
        
//        if isPoolRequest {
//            let tripView = ShareRouteVC.initWithStory(tripDataModel: trip,
//                                                      tripId: currentTrip.id,
//                                                      tripStatus: currentTrip.status, updateTripHistory: self,
//                                                      shouldPopToRootVC: true)
//            self.navigationController?.pushViewController(tripView, animated: true)
//        } else {
//            let tripView = RouteVC.initWithStory()
//            tripView.tripDataModel = trip
//            tripView.tripId = trip.getCurrentTrip()?.id ?? 0
//            tripView.tripStatus = trip.getCurrentTrip()?.status ?? .pending
//            tripView.shouldPopToRootVC = true
//            self.navigationController?.pushViewController(tripView, animated: true)
//        }
    }
    
    
    func clearAllAnimations(){
        self.player?.stop()
        self.timerAni.invalidate()
        self.timerCancelTrip.invalidate()
        self.requestView.viewAccepting.isHidden = false
        self.view.addSubview(self.requestView.viewAccepting)
        self.requestView.viewAccepting.addSubview(self.spinnerView)
        self.spinnerView.frame = CGRect(x: 60, y: (self.requestView.viewAccepting.frame.size.height - 40) / 2, width: 40, height: 40)
        self.spinnerView.circleLayer.lineWidth = 3.0
        self.spinnerView.circleLayer.strokeColor =  UIColor(red: 0.0 / 255.0, green: 150.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0).cgColor
        self.spinnerView.beginRefreshing()
        self.requestView.viewCircular.removeFromSuperview()
    }
    
    
    @objc func onGoBack(){ //Cancel request
        self.requestView.timerLbl.isHidden = true
        self.requestView.lblAcceptOrCancel.text = LangCommon.cancellingRequest
        self.requestView.btnAccept.isUserInteractionEnabled = false
        self.timerAni.invalidate()
        self.timerCancelTrip.invalidate()
        NotificationCenter.default.post(name: NSNotification.Name.HandleTimer, object: self, userInfo: nil)
        Self.ScreenIsActive = false
        self.navigationController?.popViewController(animated: true)
    }
    
}
