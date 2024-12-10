//
//  TripsDetailVC.swift
//  GoferHandyProvider
//
//  Created by trioangle on 09/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class TripsDetailVC: BaseVC {
//MARK: - OUTLETS
    @IBOutlet weak var tripDetailView:TripsDetailView!
    //MARK: - LOCAL VARIABLES
    var currentTripID : Int!
    var seats = Int()
    var invoice : [Invoice]!
    var tripsDetailsDict = [[String:Any]]()
    var selectedIndex = Int()
    lazy var arrInfoKey : NSMutableArray = NSMutableArray()
    var paramForAPI = [String:Any]()
    var is_KM = Bool()
    var orderId = ""
    //lazy var tripData : RiderDataModel? = nil
    
    var trip_Details : Trip_details?{
        didSet{
           
        }
    }
//    var tripDetailData : TripDetailDataModel?{
//        didSet{
//            if let detail = self.tripDetailData {
//                tripData = detail.getCurrentTrip()
//            }
//        }
//    }
    //MARK: - NECESSARY CLASS FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        //apiCall()
    }
    
    class func initWithStory(orderId:Int) -> TripsDetailVC {
        
        let vc : TripsDetailVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
        vc.orderId = orderId.description
        
        return vc
    }
    
    func apiCall(){
        paramForAPI["order_id"] = self.orderId
        paramForAPI["cache"] = 1
        //    if self.tripDetailData == nil {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared
            .getRequest(for: .getParticlarOrderDetail,
                           params: paramForAPI,
                           showLoader: true)
            .responseDecode(to: TripParticularModel.self) { (json) in
                if json.status_code == 1.description {
                    UberSupport.shared.removeProgressInWindow()
                    print("::::: json response :::::::\(json)")
                    self.trip_Details = json.trip_details
                    self.is_KM = ((self.trip_Details?.is_KM) != nil)
                    self.invoice = json.invoice
                    self.currentTripID = self.trip_Details?.order_id
                    self.tripDetailView.headerView.tripIdlbl.text = "\(LangDeliveryAll.tripId)\(String(describing: self.currentTripID))"
                    self.tripDetailView.sampleDesign()
                    self.tripDetailView.tblTripsInfo.reloadData()
                    // self.tripDetailView.tblTripsInfo.reloadData()
                }else{
                    UberSupport.shared.removeProgressInWindow()
                    AppDelegate.shared.createToastMessage(json.status_message ?? "Error")
                    self.tripDetailView.tblTripsInfo.reloadData()
                }
            }
            .responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                self.tripDetailView.tblTripsInfo.reloadData()
                //            AppDelegate.shared.createToastMessage(error)
            })
    }
        
        
    }
    //MARK: - EXTENSIONS

//Gofer splitup start [Moved to extension]


//Gofer splitup end
