/**
* RequestAcceptVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import AVFoundation
import MapKit
import Foundation
import GoogleMaps

class DeliveryAllRequestAcceptVC : BaseVC, ProgressViewHandlerDelegate {
    //MARK: - OUTLETS
    @IBOutlet var deliveryAllRequestAcceptView: DeliveryAllRequestAcceptView!
    
    
    //MARK: - LOCAL VARIABLES
    var viewModel:RouteViewModel!

    func onFailure(error: String, for API: APIEnums) {
        //self.appDelegate.createToastMessage(error)
    }
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var strRequestID = ""
    var strPickupLocation = ""
    var strPickupTime = ""
    var strPickUpLatitude = ""
    var strPickUpLongitude = ""
    var strStoreName = ""
    var orderID  = ""
    var restaurantName = ""
    var storeName = ""
    var store_Name = ""
    var totalOrders = ""
    var multipleDeliveryStatus = ""
    var groupID = ""
    var business_id = ""
    var justLaunced = false
    var strDropLocation = ""
   
// MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNotification()
    }

    func initNotification() {
        NotificationEnum.cancelRequest.removeObserver(self)
        NotificationEnum.cancelRequest.addObserver(self,
                                                   selector: #selector(self.cancelRequestUsingID(_:)))
    }

    @objc
    func cancelRequestUsingID(_ notification:Notification) {
        print("Working")
        if let json = notification.userInfo as? JSON {
            let requestID = json.int("request_id")
            print(requestID.description == strRequestID)
            if requestID.description == strRequestID {
                self.deliveryAllRequestAcceptView.clearAllAnimations()
                self.deliveryAllRequestAcceptView.onGoBack()
            } else {
                print("It's Not what we are Looking for ")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deliveryAllRequestAcceptView.timerAni.invalidate()
        self.deliveryAllRequestAcceptView.timerCancelTrip.invalidate()
    }
    
    func onAcceptReq(json:JSON,
                     status:String) {
        ConnectionHandler.shared.getRequest(for: APIEnums.acceptRequest,
                                               params: json,
                                               showLoader: true)
        
            .responseDecode(to: TripDataModel.self) { (json) in
                if json.status_code == "1"{
                    self.handleResponse(gModel: json,
                                        status : status)
                }else{
                    self.appDelegate.createToastMessage(json.status_message)
                    self.deliveryAllRequestAcceptView.onGoBack()
                }
          }
        
//            .responseJSON { (json) in
//                if json.isSuccess{
//                    let tripDetailData = DeliveryAllModel(json)
//                    self.handleResponse(gModel: tripDetailData,
//                                        status : status)
//                }else{
//                    self.appDelegate.createToastMessage(json.status_message)
//                    self.deliveryAllRequestAcceptView.onGoBack()
//                }
//            }
        .responseFailure { (error) in
           // self.appDelegate.createToastMessage(error)
            self.deliveryAllRequestAcceptView.onGoBack()
        }
    }
    
    
    
    //MARK: ACCEPT RIDER TRIP REQUEST
    func handleResponse(gModel : TripDataModel,status : String){
        
        if gModel.status_code == "1"
        {
            let cash = gModel.order_details?.paymentMode ?? ""
            let requestID = gModel.order_details?.requestID
            print("recived group ID \(requestID)")
            UserDefaults.standard.set(requestID, forKey: "req_ID")
            self.gotoToRouteView(with: gModel)
            Constants().STOREVALUE(value: status, keyname: USER_ONLINE_STATUS)
            Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
            Constants().STOREVALUE(value:  cash, keyname: CASH_PAYMENT)

        }
        else if gModel.status_code == "0"{
            
            print(gModel.status_message)
            let messages = gModel.status_message
            print(messages)
            if(messages == LangDeliveryAll.alreadyAccepted) {
                let msg = LangDeliveryAll.alreadyAcceptedBySomeone
                
            self.appDelegate.createToastMessage(msg)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
                let userDefaults = UserDefaults.standard
                userDefaults.set("driver", forKey:"getmainpage")
                self.appDelegate.onSetRootViewController(viewCtrl: self)
                
            }
            else{
                Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            }

        }
        else
        {
            if gModel.status_message == "user_not_found" || gModel.status_message == "token_invalid" || gModel.status_message == "Invalid credentials" || gModel.status_message == "Authentication Failed"
            {
                self.appDelegate.logOutDidFinish()
                return
            }
            else{
            }
           
        }

        
       
    }
    //MARK:- initWithStory
    class func initWithStory() -> DeliveryAllRequestAcceptVC{
        let view : DeliveryAllRequestAcceptVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
        return view
    }
    
    // MARK: - NAVIGATE TO ROUTE VIEW AFTER ACCETPTING REQUEST
    func gotoToRouteView(with trip : TripDataModel)
    {
        guard let intOrderID = Int(self.orderID) else{return}
        FireBaseNodeKey.rider.setValue(trip.order_details?.id.description, for: "\(trip.order_details?.riderID)","trip_id")
        
        let grp_ID = self.groupID
        UserDefaults.standard.set(grp_ID, forKey: "group_ID")

        Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
        let tripView = DeliveryRouteVC.initWithStory(intOrderID)
//        let tripView = self.storyboard?.instantiateViewController(withIdentifier: "RouteVC") as! RouteVC
        tripView.tripDataModel = trip
        tripView.shouldPopToRootVC = true
       // tripView.shouldPopToOrdersVC = true
        tripView.reqID = trip.order_details?.requestID ?? 0
        tripView.groupID = grp_ID
        tripView.multipleDelivery = self.multipleDeliveryStatus
        self.navigationController?.pushViewController(tripView, animated: true)
    }
    
    func animateBorderWidth(view: UIButton, from: CGFloat, to: CGFloat, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        view.layer.add(animation, forKey: "Width")
        view.layer.borderWidth = to
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
    }
    
}
