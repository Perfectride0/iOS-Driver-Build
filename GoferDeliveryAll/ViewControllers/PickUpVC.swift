//
//  PickUpVC.swift
//  GoferHandyProvider
//
//  Created by trioangle on 22/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//


import UIKit
import Alamofire

class PickUpVC: BaseVC {
    

    
    
    
   
    //MARK: - OUTLETS
    @IBOutlet weak var pickupView:PickUpVCView!
    //MARK: - LOCAL VARIABLES
    lazy var connetionHandler = ConnectionHandler()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var delegate : passLatitudeLongitude!
    var order : DeliveryOrderDetail!
    var reqID = 0
    var group_ID = String()
    var PopToRootVC = Bool()
    var isFood = true
    
    var addonQuantity : String = ""
    var addonName : String = ""
    var driver_recieved_orders = [Order_details]()
//    var pendingTrip:[TripDataModel] {
//        get {
//            return Shared.instance.pendingTrips
//        }
//    }
    var order_items = [Order_item]()
    var pendingTrips = [TripDataModel]()
    
  
    var orderDetailsForTrip: DeliveryOrderDetail?
    var routeVM: DeliveryRouteVM!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.driverAcceptedOrders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.driverAcceptedOrders()
        //@karthik//
    }
    
    //MARK:- initWithStory
      class func initWithStory() -> PickUpVC {
         let view : PickUpVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
         view.routeVM = DeliveryRouteVM()
         return view
     }
    func fetchTripDetails(orderId: Int){

        let support = UberSupport()
        support.showProgressInWindow(showAnimation:  true)
        ConnectionHandler.shared
            .getRequest(for: .getDeliveryDetail,
                        params: ["order_id": orderId], showLoader: true)
//            .responseJSON({ (response) in
//                //@karthik//
//                let model = response["order_details"] as? JSON ?? JSON()
//                let model2 = TripDataModel(tripJSON: model)
//                self.redirectionToTrip(order: model2)
//             })
        
            .responseDecode(to: TripDataModel.self) { (json) in
                self.redirectionToTrip(order: json)
          }
        
            .responseFailure({ (error) in
                debug(print: error)
                support.removeProgressInWindow()
            })
     }
    func redirectionToTrip(order: TripDataModel)
    {
        //AppRouter(self).routeInCompleteTrips(order, shouldPopToRoot: true )
        AppRouter(self).routeInCompleteOrdersAfterAccept(order, shouldPopToRoot: true)
    }
  func driverAcceptedOrders() {
        
    _ = ""
    _ = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        self.pickupView.loader.showProgressInWindow(showAnimation: true)

        var paramDict = [String:Any]()
        paramDict["group_id"] = self.group_ID
    
    self.routeVM.wsToGetDriverOrderReceivedDetails(params: paramDict) { result in
        switch result {
        case .success(let response):
            if response.status_code == "1" {
                print(":::Status code 1:::")
                self.isFood = response.isFood
                if response.store_name != "" , let storename = response.store_name {
                  self.pickupView.storename = storename
                }else{
                  self.pickupView.storename = LangDeliveryAll.noOrderFound
                }
                if let menuTypes = response.order_details {
                  self.pickupView.isAccepted = response.accepted_status!
                    self.driver_recieved_orders = menuTypes
                  self.pickupView.distance = self.driver_recieved_orders.map({($0.estimated_distance ?? "")})
                }
                DispatchQueue.main.async {
                  self.pickupView.storeName_Lbl.text = self.pickupView.storename
                  //  self.fetchDeliveryHistory()
                  if self.pickupView.isAccepted == "true" {
                      self.pickupView.nextBtn.isHidden = false
                      self.pickupView.bottomView.isHidden = false
                    } else {
                      self.pickupView.nextBtn.isHidden = true
                      self.pickupView.bottomView.isHidden = true
                    }
                  self.pickupView.orderTableView.reloadData()
                  self.pickupView.loader.removeProgressInWindow(viewCtrl: self)
                }
                
            } else {
                print(":::Status code 0 - Error :::")
                AppDelegate.shared.createToastMessage(response.status_message ?? "")
            }
        case .failure(let error):
            print("\(error.localizedDescription)")

           // AppDelegate.shared.createToastMessage(error.localizedDescription)
        }
    }
  }    
//func fetchDeliveryHistory(){
//
//    _ = ""
//    let user_Token = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
//
//        var paramDict = [String:Any]()
////        paramDict["group_id"] = self.group_ID
//
//    paramDict["group_id"] = self.group_ID
//
//    ConnectionHandler.shared
//        .getRequest(for: .getDeliveryHistory,
//                    params: paramDict, showLoader: true)
//               .responseJSON({ (response) in
//
//
//                   self.pendingTrips.removeAll()
//                self.pendingTrips = response
//                       .array("today_delivery")
//                       .compactMap({TripDataModel(resuaruntJSON: $0)})
//
//                self.pickupView.pendingLoader.stopAnimating()
//
//                }).responseFailure({ (error) in
//
//                    self.pickupView.pendingLoader.stopAnimating()
//                })
//
//       }
}

