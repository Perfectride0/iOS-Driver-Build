/**
* CancelRideVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/


import UIKit
import Foundation

class CancelRideVC: BaseVC {
    
    //---------------------------------
    // MARK: - Outlets
    //---------------------------------
    
    @IBOutlet var CancelRideView: CancelRideView!
    
    //---------------------------------
    // MARK: - Local Variables
    //---------------------------------
    
    // Handy Splitup Start
    var businessType : BusinessType!
    // Handy Splitup End
    var isMultipleDelivery : Bool = false
    var strTripId = ""
    var requestID = 0
    var isManualBooking : Bool = false
    var usertype = ""
    var cancelReasonId = ""
    var isFromHistory : Bool = false
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    //---------------------------------
    // MARK: - ViewController Methods
    //---------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        var param = JSON()
        // Handy Splitup Start
        if businessType == .DeliveryAll || businessType == .Instacart || businessType == .Laundry {
            param["order_id"] = self.strTripId
        }
        else   if businessType == .Laundry {
            param["order_id"] = self.strTripId
        }else {
            // Handy Splitup End
            param["job_id"] = self.strTripId
            // Handy Splitup Start
        }
        // Handy Splitup End
        self.wsToGetCancelReasons(parm: param)
        self.initNotification()
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
  
    //---------------------------------
    //MARK: - Local Functions
    //---------------------------------
    
    func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.driverCancelledTrip), name: NSNotification.Name.TripCancelDriver, object: nil)
    }
    
    //--------------------------------------------
    //MARK: -CANCEL TRIP DONE NAVIGATE TO HOME PAGE
    //--------------------------------------------
    
    @objc
    func driverCancelledTrip(notification: Notification) {
        Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        self.appDelegate.onSetRootViewController(viewCtrl: self)
    }
    //---------------------------------
    // MARK: - API CALL -> CANCEL TRIP
    //---------------------------------
   
    func cancelJobProcess() {
        var dicts = JSON()
        dicts["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["cancel_comments"] = CancelRideView.txtViewCancel.text!
        dicts["reason_id"] = cancelReasonId
        // Handy Splitup Start
        if businessType == .DeliveryAll || businessType == .Instacart {
            dicts["order_id"] = strTripId
        }
        else   if businessType == .Laundry {
            dicts["order_id"] = self.strTripId
        }else {
            // Handy Splitup End
            dicts["job_id"] = strTripId
            // Handy Splitup Start
        }
        // Handy Splitup End
        dicts["user_type"] = usertype
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared.getRequest(for: APIEnums.cancelJob, params: dicts, showLoader: true)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.isSuccess{
                    
                    Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
                    NotificationCenter.default.post(name: NSNotification.Name.JobCancelledByDriver, object: self, userInfo: nil)
                    let info: [AnyHashable: Any] = [
                        "cancelled_by" : "YES",
                    ]
                    if self.isFromHistory || self.isMultipleDelivery {
                        NotificationEnum.pendingTripHistory.postNotification()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name.ShowHomePage_job, object: self, userInfo: info)
                    }
                    
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
                self.CancelRideView.btnSave.isUserInteractionEnabled = true
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                self.CancelRideView.btnSave.isUserInteractionEnabled = true
               // AppDelegate.shared.createToastMessage(error)
                
            })
    }
    
    func wsToGetCancelReasons(parm: JSON) {
       let _CancelReasonModel = CancelReasonModel()
        _CancelReasonModel.getCancelReasons(parm: parm) { (results) in
            switch results {
            case .success(let reasons):
                self.CancelRideView.cancelReasons = reasons
                let height = self.CancelRideView.tblCancelList.frame.height
                let  contentHeight = 50 * reasons.count
                let size : CGFloat = Int(height) > contentHeight ? CGFloat(contentHeight) : height
                let originalFrame = self.CancelRideView.tblCancelList.frame
                self.CancelRideView.tblCancelList.frame = CGRect(x: originalFrame.minX,
                                             y: originalFrame.minY,
                                             width: originalFrame.width,
                                             height: size > 450 ? 450 : size)
                self.CancelRideView.tblCancelList.reloadData()
            case .failure(_):
                print("error")

                //self.appDelegate.createToastMessage("error")
            }
        }
    }
    
    func cancelRequestProcess() {
        var dicts = JSON()
        dicts["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["id"] = strTripId
        dicts["reason"] = CancelRideView.txtViewCancel.text!
        dicts["reason_id"] = cancelReasonId
        dicts["user_type"] = usertype
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared.getRequest(for: .cancelScheduleJob, params: dicts, showLoader: true)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.isSuccess{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
                self.CancelRideView.btnSave.isUserInteractionEnabled = true
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                self.CancelRideView.btnSave.isUserInteractionEnabled = true
               // AppDelegate.shared.createToastMessage(error)
            })
    }
    
    //---------------------------------
    //MARK:-init with story
    //---------------------------------
    
    class func initWithStory(
        // Handy Splitup Start
        businessType: BusinessType
        // Handy Splitup End
    )-> CancelRideVC{
        let vc : CancelRideVC = UIStoryboard.gojekCommon.instantiateViewController()
        // Handy Splitup Start
        vc.businessType = businessType
        // Handy Splitup End
        return vc
    }
}
