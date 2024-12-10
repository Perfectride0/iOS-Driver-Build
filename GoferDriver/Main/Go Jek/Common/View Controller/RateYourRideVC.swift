/**
 * RateYourRideVC.swift
 *
 * @package UberClone
 * @author Trioangle Product Team
 *  
 * @link http://trioangle.com
 */

import UIKit

class RateYourRideVC: BaseVC{
    @IBOutlet var rateYourRideView: RateYourRideView!
    
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var tripDetailData : JobDetailModel!
    var isFromRoutePage : Bool = false
    var isFromTripPage : Bool = false
    var tripModel : EndTripModel!
    var arrTemp1 : NSMutableArray = NSMutableArray()
    var arrTripsData : NSMutableArray = NSMutableArray()
    
    override var stopSwipeExitFromThisScreen: Bool?{
        return true
    }
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
// MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(self.tabBarController?.tabBar.isHidden ?? false){
            self.tabBarController?.tabBar.isHidden = true
        }

        self.wsToGetData()
       
        if let data = self.tripDetailData{
            self.rateYourRideView.setDisplayData(data)
        }else{
            // Handy Splitup Start
            if AppWebConstants.businessType == .Services || (AppWebConstants.businessType == .Delivery){
                // Handy Splitup End
                ConnectionHandler.shared
                    .getRequest(for: APIEnums.getJobDetails,
                                   params: ["job_id":self.tripDetailData.getCurrentTrip()?.jobID ?? 0 ],
                                   showLoader: true)
                    .responseDecode(to: JobDetailModel.self, { response in
                        if response.statusCode == "1"{
                            self.tripDetailData = response
                            self.rateYourRideView.setDisplayData(response)
                        }
                    })
                    .responseFailure({ (error) in
                   })
                // Handy Splitup Start
            } else {
                ConnectionHandler.shared
                    .getRequest(for: APIEnums.getJobDetails,
                                   params: ["trip_id":self.tripDetailData.getCurrentTrip()?.id ?? 0],
                                   showLoader: true)
                    .responseDecode(to: JobDetailModel.self, { response in
                        if response.statusCode == "1"{
                            self.tripDetailData = response
                        
                            self.rateYourRideView.setDisplayData(response)
                        }
                    })
                    .responseFailure({ (error) in
                   })
            }
            // Handy Splitup End
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
   
    
  
   
    // MARK: - ViewController Methods
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
   
    
    //MARK:- initWithStory
    class func initWithStory(trip : JobDetailModel) -> RateYourRideVC{
        let view : RateYourRideVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.tripDetailData = trip
        return view
    }
    
    
//MARK: - API CALL -> SUBMIT RATING
    
    
    func updateRatingToApi(floatRating:Int,comments:String) {
        
        var paramDict = [String: Any]()
        // Handy Splitup Start
        if (AppWebConstants.businessType == .Services) || (AppWebConstants.businessType == .Delivery) || (AppWebConstants.businessType == .Ride){
            // Handy Splitup End
            paramDict = ["token" : Constants().GETVALUE(keyname: USER_ACCESS_TOKEN),
                         "job_id" : (self.tripDetailData.getCurrentTrip()?.jobID ?? 0 ).description,
            "rating" : String(format: "%d", floatRating),
            "rating_comments" : comments,
            "user_type" : "provider"] as [String : Any]
            // Handy Splitup Start
        }else{
            paramDict = ["token" : Constants().GETVALUE(keyname: USER_ACCESS_TOKEN),
            "trip_id" : (self.tripDetailData.getCurrentTrip()?.id ?? 0).description,
            "rating" : String(format: "%d", floatRating),
            "rating_comments" :comments,
            "user_type" : "driver"] as [String : Any]
            
        }
        // Handy Splitup End
        WebServiceHandler.sharedInstance.getWebService(wsMethod:"job_rating", paramDict: paramDict, viewController:self, isToShowProgress:true, isToStopInteraction:true) { (response) in
            let responseJson = response
            DispatchQueue.main.async {
                if responseJson["status_code"] as? String ?? String() == "1" {
                    /* yamini hiding it
                     
                    let makePaymentVC = MakePaymentVC.initWithStory(trip: self.tripDetailData)
//                    let makePaymentVC = UIStoryboard.main.instantiateViewController() as MakePaymentVC
//                    makePaymentVC.tripData = self.tripData
//                    makePaymentVC.paymentMode = responseJson["payment_method"] as? String ?? String()
//                    makePaymentVC.totalAmt = responseJson["total_fare"] as? String ?? String()
//                    makePaymentVC.strTripID = self.strTripID
//                    makePaymentVC.arrInfoKey = self.arrTripsData
                    self.navigationController?.pushViewController(makePaymentVC, animated: true)
                    */
                    
            for controller in self.navigationController!.viewControllers as Array {
                           if controller.isKind(of: HandyHomeMapVC.self) {
                               _ =  self.navigationController!.popToViewController(controller, animated: true)
                               break
                           }
                       }
                    
                }
                else if responseJson["status_code"] as? String ?? String() == "2" {
                    self.appDelegate.self.makeSplashView(isFirstTime: true)
                    self.appDelegate.createToastMessageForAlamofire(responseJson.status_message, bgColor: UIColor.black, textColor: UIColor.white, forView:self.view)
                    self.rateYourRideView.onBackTapped(nil)
                }
                else{
                    self.appDelegate.createToastMessageForAlamofire(responseJson.status_message, bgColor: UIColor.black, textColor: UIColor.white, forView:self.view)
                }
            }
        }
    }
    func gotoHome() {
        for controller in self.navigationController!.viewControllers as Array {
                                  if controller.isKind(of: HandyHomeMapVC.self) {
                                      _ =  self.navigationController!.popToViewController(controller, animated: true)
                                      break
                                  }
                              }
    }
   

        func wsToGetData() {
            
        }
  
}

