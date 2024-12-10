//
//  HandyPaymentVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 21/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class HandyPaymentVC: BaseVC {

    @IBOutlet var handyPaymentView: HandyPaymentView!

    var jobStatus : TripStatus!
    var jobDataModel : JobDetailModel!
    var jobViewModel : CommonViewModel!
    var isFromTripPage : Bool = false
    var jobId : Int? = 0
    static var currentJobID : Int? = nil
    //Gofer splitup start
    //Deliveryall_Newsplitup_start
    override var stopSwipeExitFromThisScreen: Bool?{
        let controllers = self.navigationController?.viewControllers ?? []
        // Handy Splitup Start
        //New_Delivery_splitup_Start
        //Laundry splitup start
        //Instacart splitup start
        //Deliveryall splitup start
       // return controllers.anySatisfy({$0 .isKind(of: AppWebConstants.currentBusinessType == .Services ? HandyEnRouteVC.self : DeliveryEnrouteVC.self) })

        // Laundry_NewSplitup_start

        //Handy_NewSplitup_Start

        


        // Laundry_NewSplitup_end
        if AppWebConstants.currentBusinessType == .Laundry{
            return false
        }
        else {
            return false
        }


        //New Delivery splitup End
        //Handy_NewSplitup_End


        //New_Delivery_splitup_End


        //Delivery Splitup End
        //Deliveryall splitup end
        //delivery splitup end
        // Handy Splitup End
        //Laundry splitup end
        //Instacart splitup end
        
    }
    //Deliveryall_Newsplitup_end
    //Gofer splitup end
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNotification()
//        if jobDataModel != nil {
//            Self.currentJobID = jobDataModel.users.jobID
//
//        }else{
//        if AppWebConstants.currentBusinessType != .Ride  {
        if let jobDataModel = self.jobDataModel {
            Self.currentJobID = self.jobId
            self.jobViewModel.jobDetailModel = jobDataModel
            self.jobDataModel = jobDataModel
            if let status = jobDataModel.getCurrentTrip()?.jobStatus {
                if status < .cancelled {
                    self.refreshInvoice()
                } else {
                    self.handyPaymentView.setData()
                }
            } else {
                print("Still Not Accuired The Model")
            }
        } else {
            if let jobID = self.jobId {
                Self.currentJobID = self.jobId
                var params = JSON()
                params["job_id"] = jobID
                let NeedCahce = self.jobStatus == .cancelled || self.jobStatus == .completed || self.jobStatus == .rating
                if NeedCahce {
                    // Handy Splitup Start
                    params["business_id"] = AppWebConstants.currentBusinessType.rawValue
                    // Handy Splitup End
                    params["cache"] = 1
                }
                self.jobViewModel.getJobApi(parms: params) { (result) in
                    switch result {
                    case .success(let job):
                        self.jobViewModel.jobDetailModel = job
                        self.jobDataModel = job
                        if let status = self.jobViewModel.jobDetailModel?.getCurrentTrip()?.jobStatus {
                            if status < .cancelled {
                                self.refreshInvoice()
                            } else {
                                self.handyPaymentView.setData()
                            }
                        } else {
                            print("Still Not Accuired The Model")
                        }
                    case .failure(let error):
                        print("\(error.localizedDescription)")
                        
                        // appDelegate.createToastMessage(error.localizedDescription)
                    }
                }
            } else {
                print("Job ID Is Missing")
            }
        }
          
       // }
        

//        }
//        AppUtilities().cornerRadiusWithShadow(view: self.HandyPaymentView.fareDetailsTable)
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let status = (self.jobViewModel.jobDetailModel?.getCurrentTrip()?.jobStatus) {
//            if status < .cancelled {
//                self.refreshInvoice()
//            }
//        }
//        // Hided Because of the Optional
////        if (self.jobViewModel.jobDetailModel?.users.jobStatus ?? .pending) < .cancelled {
////            self.refreshInvoice()
////        }
//
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func initNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .HandyRefreshInvoice,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.refreshInvoice),
                                               name: .HandyRefreshInvoice,
                                               object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .PaymentSuccess_job,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .PaymentSuccessInHomeAlert_job,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.getPaymentSuccess),
                                               name: NSNotification.Name.PaymentSuccess_job,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.gotoHomePage),
                                               name: NSNotification.Name.PaymentSuccessInHomeAlert_job,
                                               object: nil)
    }
    
    class func initWithStory(model: JobDetailModel?,
                             jobID : Int,
                             jobStatus : TripStatus) -> HandyPaymentVC{
        let view : HandyPaymentVC = UIStoryboard.gojekCommon.instantiateViewController()
        if let model = model {
            view.jobDataModel = model
            view.jobId = model.getCurrentTrip()?.jobID ?? 0
            view.jobStatus = model.getCurrentTrip()?.jobStatus ?? .pending
        } else {
            view.jobId = jobID
            view.jobStatus = jobStatus
        }
        view.jobViewModel = CommonViewModel()
        return view
    }
    //MARK:- Payment change status tracking in firebase

     // goto payment success page
       @objc func getPaymentSuccess(_ notification : Notification)
       {
        if self.handyPaymentView.isPaidShown
           {
               return
           }
//           self.handyPaymentView.collectPaymentBtn.setTitle(LangCommon.paid.uppercased(),for: .normal)
//           self.handyPaymentView.collectPaymentBtn.backgroundColor = .RatingColor
           self.handyPaymentView.collectPaymentBtn.isUserInteractionEnabled = false
           Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
           Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
           let rider_thumb_image = notification.userInfo?["rider_thumb_image"] as? String ?? String()
           let user_name = notification.userInfo?["user_name"] as? String ?? String()
           
           self.commonAlert.setupAlert(alert: LangCommon.success.capitalized,alertDescription: LangCommon.riderPaid.capitalized, okAction: LangCommon.ok.uppercased())
           self.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
               self.gotoRateYourRatingPage(withRiderImage: rider_thumb_image, RiderName: user_name)
           }

//           self.gotoRateYourRatingPage(withRiderImage: rider_thumb_image, RiderName: user_name)
   //        AppDelegate.shared.onSetRootViewController(viewCtrl: self.viewController)
       }
    // after completed the payment to go home page
    @IBAction func gotoHomePage()
    {
        switch self.jobDataModel.getCurrentTrip()?.paymentModeKey ?? "cash"{
        case let x where x.lowercased().contains("cash")://Cash
            if self.handyPaymentView.totalAmt.isZero{
                return
            }else{
                print("cash payment")
                self.cashPayment()
            }
        case let x where x.lowercased().first == "p"://Pay Pal
            return
        case let x where x.lowercased().first == "s"://Pay Pal
            return
        case let x where x.lowercased().first == "o":
            return
        default:
            Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            appDelegate.onSetRootViewController(viewCtrl: self)
        }
    }
       func onPaymentSucces(_ json : JSON){
           Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
           Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        //TRVicky
        self.commonAlert.setupAlert(alert: LangCommon.success.capitalized,alertDescription: LangCommon.riderPaid.capitalized, okAction: LangCommon.ok.uppercased())
          self.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                self.gotoRateYourRatingPage(withRiderImage: json.string("rider_thumb_image"), RiderName: json.string("user_name"))
          }
           
       }
    func gotoRateYourRatingPage(withRiderImage imgURL : String,RiderName: String)
    {
        let propertyView = RateYourRideVC.initWithStory(trip: self.jobDataModel)
         propertyView.isFromRoutePage = true
        self.navigationController?.pushViewController(propertyView, animated: true)
    }
    // if rider paid a cash payment driver update the server to the api
       func cashPayment(){
           var parameters = JSON()
           parameters["job_id"] = self.jobDataModel.getCurrentTrip()?.jobID.description ?? ""
           self.wsToCaseCollected(parameters)
       }
    func updateRating(ratingValue: String, jobId: String, RatingComments: String){
        var paramDict = [String: Any]()
        // Handy Splitup Start
        switch AppWebConstants.businessType {
        case .Ride:
            paramDict = ["token" : Constants().GETVALUE(keyname: USER_ACCESS_TOKEN),
            "trip_id" : jobId,
            "rating" : ratingValue,
            "rating_comments" :RatingComments,
            "user_type" : "driver"] as [String : Any]
        default:
            // Handy Splitup End
            paramDict = ["token" : Constants().GETVALUE(keyname: USER_ACCESS_TOKEN),
                         "job_id" : jobId,
            "rating" : ratingValue,
            "rating_comments" :RatingComments,
            "user_type" : "provider"] as [String : Any]
            // Handy Splitup Start
        }
        // Handy Splitup End
        self.jobViewModel.ratingApi(parms: paramDict){(result) in
            switch result{
            case .success(let json):
                if json.status_code.description == "1"{
                    print("success")
                    AppDelegate.shared.createToastMessage(LangCommon.ratingUpdatedSuccess)
                    NotificationEnum.completedTripHistory.postNotification()
//                    self.jobDataModel.users.jobStatus = .completed
                    self.handyPaymentView.submitBtn.isHidden = true
                    self.handyPaymentView.jobRatingView.editable = false
                    self.handyPaymentView.ratingCommentsTV.isEditable = false
                    self.handyPaymentView.ratingCommentsTV.isSelectable = false
                }
                else if json.status_code.description == "2" {
                    AppDelegate.shared.self.makeSplashView(isFirstTime: true)
                    AppDelegate.shared.createToastMessageForAlamofire(json.status_message, bgColor: UIColor.black, textColor: UIColor.white, forView:self.view)
                }
            case .failure(let error):
                print("\(error.localizedDescription)")

//                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
            
        }
        
    }
    @objc func refreshInvoice(){
        
        var params = JSON()
        params["job_id"] = self.jobDataModel.getCurrentTrip()?.jobID.description ?? ""
        params["user_type"] = "provider"
//        if AppWebConstants.currentBusinessType == .Ride{
//            self.goferInVoice()
//        }else{
        self.wsToGetInvoice(json: params)
      //  }
    }
    
    func goferInVoice(){
        
        
        AF.request("https://gofer.trioangle.com/api/get_invoice?device_id=94c8a93426e12a874c8e9355da737a15db2f4a1da0d9c38de7340e8f66812b34&device_type=1&language=en&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvZ29mZXJqZWsudHJpb2FuZ2xlZGVtby5jb21cL2FwaVwvbG9naW4iLCJpYXQiOjE2MzQ3MTAzNTEsImV4cCI6MTYzNzMzODM1MSwibmJmIjoxNjM0NzEwMzUxLCJqdGkiOiIyNkkzdFhYUUw0RFl6QkhyIiwic3ViIjoxMDE3NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.RxFxX4DMpBXsUD-1sBIZEmVXluprcncavOFGiKUZkFE&trip_id=169&user_type=driver",
                   method: .get,
                   parameters: nil)
            .responseJSON{ responseJSON in
                switch responseJSON.result {
                case .success(let value):
                    let data = value as! JSON
                    let json = data.array("invoice").compactMap({Invoice($0)})
                    self.jobDataModel.getCurrentTrip()?.invoice = json
                    self.handyPaymentView.setData()
                    self.handyPaymentView.fareDetailsTable.reloadData()
                case .failure(let error):
                    print(error)
                }
          }
    }
    
    
    
    func wsToGetInvoice(json:JSON) {
        self.jobViewModel.getInvoiceDetails(param: json) { (result) in
              switch result {
              case .success(let json):
              self.jobDataModel = json
                  let detail = json
                  guard let data = detail.getCurrentTrip() else{return}
                  self.handyPaymentView.paymentMode = data.paymentMode
                  self.handyPaymentView.totalAmt = Double(data.totalFare) ?? 0.00
//                  self.HandyPaymentView.invoiceDetails = data.invoice
                  self.handyPaymentView.checkPaymentStatus()
                self.handyPaymentView.priceTypeLbl.text = "\(LangCommon.priceType) :"
//                  self.HandyPaymentView.paymentStatusLbl.text = data.paymentStatus
                  self.handyPaymentView.jobRegValueLbl.text = data.scheduleDisplayDate
                  self.handyPaymentView.paymentTypeLbl.text = "\(LangCommon.paymentType) :"
                  self.handyPaymentView.totalFareValueLbl.text = data.currencySymbol + data.totalFare
                  
                self.handyPaymentView.pickupLbl.text = LangHandy.jobLocation
                if data.priceType == .Distance{
                    self.handyPaymentView.dropLbl.text = LangHandy.destinationLocation
                    self.handyPaymentView.dropLocationValueLbl.text = data.drop
                    
                    self.handyPaymentView.dropImg.isHidden = false
                    self.handyPaymentView.dropImgBack.isHidden = false
                }else{
                    self.handyPaymentView.dropLbl.text = ""
                    self.handyPaymentView.dropLocationValueLbl.text = ""
                    
                    self.handyPaymentView.dropImg.isHidden = true
                    self.handyPaymentView.dropImgBack.isHidden = true
                }
                  self.handyPaymentView.pickupLocValueLbl.text = data.pickup
                  self.handyPaymentView.dropLbl.isHidden = true
                  self.handyPaymentView.dropLocationValueLbl.isHidden = true
                  self.handyPaymentView.dropImg.isHidden = true

                  if data.priceType == .Distance{
                    self.handyPaymentView.dropImg.isHidden = false
                    self.handyPaymentView.dropLbl.isHidden = false
                    self.handyPaymentView.dropLocationValueLbl.isHidden = false
                  }
                    self.handyPaymentView.setData()
                  self.handyPaymentView.fareDetailsTable.reloadData()
              case .failure(let error):
                  print(error.localizedDescription)
                  
              }
          }
      }
      
      
      func wsToCaseCollected(_ json:JSON) {
        self.jobViewModel.caseCollected(param: json) { (result) in
              switch result {
              case .success(let json):
                  let _ = json
                  if json.int("status_code") == 1{
                      FireBaseNodeKey.trip.getReference(for: "\(self.jobDataModel.getCurrentTrip()?.jobID.description )").removeValue()
                    let image = json.string("user_thumb_image")
                    let userName = json.string("user_name")
//                      let image = self.jobDetailsModel.users.image
    //                   self.jobDetailsModel = detail
                      self.jobDataModel.getCurrentTrip()?.jobStatus = .rating
    //                  AppDelegate.shared.onSetRootViewController(viewCtrl: self)
                    Self.currentJobID = nil
                      let alertController = UIAlertController(title: "", message: json.status_message, preferredStyle: .alert)

                         // Create the actions
                      let okAction = UIAlertAction(title: LangCommon.ok, style: UIAlertAction.Style.default) {
                             UIAlertAction in
                             NSLog("OK Pressed")
                          self.gotoRateYourRatingPage(withRiderImage: image,RiderName: userName)
                         }
                      

                         // Add the actions
               
                         alertController.addAction(okAction)
                      
                    
                         // Present the controller
                      self.present(alertController, animated: true, completion: nil)
                   
                  }
                  else{
                    AppDelegate.shared.createToastMessage(json.string("status_message"))
                }
              case .failure(let error):
                  print(error.localizedDescription)
                  
              }
          }
      }
}
