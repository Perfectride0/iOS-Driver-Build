//
//  DriverOrderListVC.swift
//  GoferGroceryDriver
//
//  Created by trioangle on 13/08/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit
import Alamofire
//MARK: - PROTOCOL
protocol passLatitudeLongitude {
    func passLatLong(orderID: Int,tripModel:TripDataModel)
}

class DriverOrderListVC: BaseVC {
    
    
//MARK: - OUTLETS
    @IBOutlet var deliveryOrderView: DeliveryOrderListView!
    //MARK: - LOCAL VARIABLES
    var storeName : String!
    var driverAcceptOrders = [Driver_accepted_orders]()
    var delegate : passLatitudeLongitude!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var grpID_recived = ""
  
    lazy var connetionHandler = ConnectionHandler()

//    var pendingTrips:[TripDataModel]{
//        get {
//            return Shared.instance.pendingTrips
//        }
//    }
  

    


   
    func fetchTripDetails(orderId: Int){
        
        let support = UberSupport()
        support.showProgressInWindow(showAnimation:  true)
        
        
        ConnectionHandler.shared.getRequest(for: .getDeliveryDetail,
                                               params: ["order_id": orderId.description], showLoader: true)
        //            .responseJSON({ (response) in
        //             let model = response["order_details"] as? JSON ?? JSON()
        //                let model2 = TripDataModel(tripJSON: model)
        //
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
    func redirectionToTrip(order: TripDataModel) {
        AppRouter(self).routeInCompleteOrdersAfterAccept(order, shouldPopToRoot: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //        fetchDeliveryHistory()
        self.driverAcceptedOrders()
        self.deliveryOrderView.setStoreDetails()
        //        ordersTitleLbl.text = language.goferDeliveryAll.order.capitalized
    }
    
    //MARK:- initWithStory
    class func initWithStory(storeName: String? = nil) -> DriverOrderListVC {
        let view : DriverOrderListVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
        //view.order = order
        view.storeName = storeName
        return view
    }


    override func viewWillAppear(_ animated: Bool) {
        self.deliveryOrderView.driverOrderTable.reloadData()
    }

    

    func fetchPendingTripsData(forPage page: Int = 1){
     
        if !self.deliveryOrderView.pendingRefresher.isRefreshing{
            self.deliveryOrderView.pendingLoader.startAnimating()
        }
    }


    func driverAcceptedOrders() {
        var paramUrl = ""
        var driverAcceptUrl = ""
        let userToken = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)

        let driver_Url = APIUrl + "driver_accepted_orders?"

        var paramDict = [String:Any]()
        paramDict["token"] = userToken


        paramDict["group_id"] = self.grpID_recived


        print("Param Dicts :: \(paramDict)")
        let populatedDictionary = paramDict
        let urlQuery = populatedDictionary.queryString
        print(urlQuery)
        paramUrl = urlQuery

        driverAcceptUrl = driver_Url + paramUrl
        print(":::::::: driverAcceptUrl :::::::::",driverAcceptUrl)
        
        ConnectionHandler.shared
            .getRequest(for: .driverAcceptedOrders,
                        params: paramDict, showLoader: true)
            .responseDecode(to: DriverModel.self, { (response) in
                if response.status_code == "1" {
                    if let menuTypes = response.driver_accepted_orders {
                        self.driverAcceptOrders = menuTypes
                        print("Orders Found")
                        DispatchQueue.main.async {
                            //self.fetchPendingTripsData()
                            self.deliveryOrderView.driverOrderTable.reloadData()
                            self.deliveryOrderView.setStoreDetails()
                        }
                    }
                } else {
                    self.appDelegate.createToastMessage(response.status_message!, bgColor: UIColor.black, textColor: UIColor.white)
                }
                
            }).responseFailure { err in
                print(err)
            }
            







 

}


}
