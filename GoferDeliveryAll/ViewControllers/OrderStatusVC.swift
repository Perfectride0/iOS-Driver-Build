//
//  OrderStatusVC.swift
//  GoferHandyProvider
//
//  Created by trioangle on 23/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//
import UIKit
import Alamofire



class OrderStatusVC: BaseVC {
    
 //MARK: - LOCAL VARIABLES
    var acceptOrders = [Order_details]()
    var reasonList = [Issues]()
    
    lazy var connetionHandler = ConnectionHandler()
    
    var orderId = ""
    
    //MARK: - OUTLETS
        
    @IBOutlet weak var orderStatusView:OrderStatusVcView!
    
    
   //MARK: - NECESSARY CLASS FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //MARK:- initWithStory
    class func initWithStory() -> OrderStatusVC {
         let view : OrderStatusVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
         //view.routeVM = RouteViewModel()
         return view
     }
    

  
   
    
    func listReasonForDislike() {
           var paramUrl = ""
           var _ = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
           var _ =  UserDefaults.standard.string(forKey: "group_ID")
          
           var paramDict = [String:Any]()
           paramDict["order_id"] = orderId
          
           var driverAcceptUrl = ""
           let driver_Url = APIUrl + "pickup_data?"
          
          let populatedDictionary = paramDict
          let urlQuery = populatedDictionary.queryString
          print(urlQuery)
                                   
                               
           driverAcceptUrl = driver_Url + urlQuery
           print("::::::::reason:::::::::",driverAcceptUrl)
        
        ConnectionHandler.shared
            .getRequest(for: .getPickupDislikeReasons,
                        params: paramDict, showLoader: true)
            .responseDecode(to: ReasonModel.self, { (response) in
                
               
            if response.status_code == "1"
               {
                if let menuTypes = response.issues {
                self.reasonList = menuTypes
               }
            DispatchQueue.main.async {
              self.orderStatusView.picker.isHidden = false
              self.orderStatusView.picker.reloadAllComponents()
               }
          }
      else {
            //  print(response.status_message)
           }
            })
    }
    //MARK: - WS FUNCTIONS
    func  wsToConfirmItemPickup() {
        //        var paramUrl = ""
        // let userToken = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        
        var paramDict = [String:Any]()
        paramDict["is_thumbs"] = orderStatusView.liked
        paramDict["order_id"] = orderId
        paramDict["issues"] = orderStatusView.resondID
        
        ConnectionHandler.shared
            .getRequest(for: .pickedDeliveryItems,
                           params: paramDict,
                           showLoader: true)
            .responseDecode(to: likeDislike.self, { (response) in
                if response.status_code == "1" {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print(response.status_message!)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "GoferDeliveryAll", message: response.status_message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }})
            .responseFailure { error in
                print("Error: \(error)")
            }
    }
}


