//
//  TripHistoryVC.swift
//  GoferDriver
//
//  Created by trioangle on 14/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire

class HandyTripHistoryVC: BaseVC {
    
    var viewModel = EarningsVM()
    var jobViewModel: CommonViewModel!
    var pendingJobHistoryModel : GoferDataModel?
    var completedJobHistoryModel : GoferDataModel?
    var gojekhomeVM : GojekHomeVM!
    // Handy Splitup Start
    var currentSelection : BusinessType!
    // Handy Splitup End
    
    @IBOutlet var tripHistoryView: HandyTripHistoryView!
    var selectedIndex = 0
    //MARK:- Refreshers
    lazy var pendingRefresher : UIRefreshControl = {
        return self.getRefreshController()
    }()
    lazy var completedRefresher : UIRefreshControl = {
        return self.getRefreshController()
    }()
    //MARK:- loaders
    lazy var pendingLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    lazy var completedLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    //MARK:- indexed
    var currentCompletedTripPageIndex = 0{
        didSet{
            debug(print:currentCompletedTripPageIndex.description)
        }
    }
    var totalCompletedTripPages = 1{
        didSet{
            debug(print: totalPendingTripPages.description)
        }
    }
    var currentPendingTripPageIndex = 0{
        didSet{
            debug(print:currentPendingTripPageIndex.description)
        }
    }
    var totalPendingTripPages = 1{
        didSet{
            debug(print:totalPendingTripPages.description)
        }
    }
    
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()         // access the features of the main view did load
        self.deinitObservers()      // removing the observers
        self.initObservers()        // initalizing the observers
    }
    
    func deinitObservers() {
        NotificationEnum.completedTripHistory.removeObserver(self)  // remove completed history observer
        NotificationEnum.pendingTripHistory.removeObserver(self)    // remove pending history observer
    }
    
    func initObservers() {
        NotificationEnum.completedTripHistory.addObserver(self, selector: #selector(self.completedJobHistoryRefresh))  // initialize completed history observer
        NotificationEnum.pendingTripHistory.addObserver(self, selector: #selector(self.pendingJobHistoryRefresh))    // initialize pending history observer
    }
    
/*
     Refresh The Pending history Using Observer
     - : Observer Name :: pendingTripHistory
*/
    
    @objc
    func pendingJobHistoryRefresh() {
        self.pendingJobHistoryModel = nil     // Clear the old Data's
        self.tripHistoryView.pendingTable.reloadData()    // Reload The tableview to Take a Effect of empty table
        self.fetchPendingTripsData(NeedCache: false)  // fetch the new data,Fill in tableview and refresh the tableview
    }
    
/*
     Refresh The Pending history Using Observer
     - : Observer Name :: completedTripHistory
*/
    
    @objc
    func completedJobHistoryRefresh() {
        self.completedJobHistoryModel = nil     // Clear the old Data's
        self.tripHistoryView.completedTable.reloadData()    // Reload The tableview to Take a Effect of empty table
        self.fetchCompletedTripsData(NeedCache: false)  // fetch the new data,Fill in tableview and refresh the tableview
    }
    

    
    //MARK:- UDF
    func fetchCompletedTripsData(NeedCache: Bool){
        self.viewModel.wsToGetCompletedJobs(needCache: NeedCache,
                                            completedJobHistoryModel: self.completedJobHistoryModel) { (result) in
                switch result {
                case.success(let data):
                  
                    self.completedJobHistoryModel = data
                    if self.completedRefresher.isRefreshing {
                        self.tripHistoryView.completedTable.reloadData()
                        self.completedRefresher.endRefreshing()
                    }
                    self.currentCompletedTripPageIndex = data.currentPage
                    self.totalCompletedTripPages = 1 + data.totalPages
                    self.completedLoader.stopAnimating()
                    self.tripHistoryView.updateCurrentTab()
//                    self.tripHistoryView.pendingTable.reloadData()
                    self.tripHistoryView.completedTable.reloadData()
                    self.tripHistoryView.oneTimeForCompleted = !(data.currentPage == data.totalPages)
                   // self.tripHistoryView.updateCurrentTab()
                
                case .failure( _):
                    self.completedRefresher.endRefreshing()
                    self.completedLoader.stopAnimating()
                    self.tripHistoryView.completedTable.reloadData()
                }
            }
          
            if !self.completedRefresher.isRefreshing{
                self.completedLoader.startAnimating()
            }
        }
    func fetchPendingTripsData(NeedCache: Bool){
        self.viewModel.wsToGetPendingJobs(needCache: NeedCache, pendingJobHistoryModel: self.pendingJobHistoryModel) { (result) in
                switch result {
                case .success(let data) :
            
                        self.pendingJobHistoryModel = data
                        if self.pendingRefresher.isRefreshing{
                            self.tripHistoryView.pendingTable.reloadData()
                            self.pendingRefresher.endRefreshing()
                        }
                        self.currentPendingTripPageIndex = data.currentPage
                        self.totalPendingTripPages = 1 + data.totalPages
                        self.pendingLoader.stopAnimating()
                        self.tripHistoryView.updateCurrentTab()
                        self.tripHistoryView.pendingTable.reloadData()
//                        self.tripHistoryView.completedTable.reloadData()
//                        self.tripHistoryView.updateCurrentTab()
                        self.tripHistoryView.oneTimeForPending = !(data.currentPage == data.totalPages)
                    
                case .failure( _):
                    self.pendingRefresher.endRefreshing()
                    self.pendingLoader.stopAnimating()
                    self.tripHistoryView.pendingTable.reloadData()
                }
            }
            if !self.pendingRefresher.isRefreshing{
                self.pendingLoader.startAnimating()
            }
        }
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    //MARK:- initWithStory
    class func initWithStory(
        // Handy Splitup Start
        businessType: BusinessType? = nil
        // Handy Splitup End
    ) -> HandyTripHistoryVC{
        let vc :HandyTripHistoryVC = UIStoryboard.gojekCommon.instantiateViewController()
        vc.jobViewModel = CommonViewModel()
        vc.gojekhomeVM = GojekHomeVM()
        // Handy Splitup Start
        if let businessType = businessType {
            vc.currentSelection = businessType
        }
        // Handy Splitup End
        return vc
    }
    
    
  
    func getRefreshController() -> UIRefreshControl{
        let refresher = UIRefreshControl()
        refresher.tintColor = .PrimaryColor
        refresher.attributedTitle = NSAttributedString(string: LangCommon.pullToRefresh)
        refresher.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        return refresher
    }
    
    @objc func onRefresh(_ sender : UIRefreshControl){
        
        if sender == self.pendingRefresher{
            self.pendingJobHistoryModel = nil
            self.fetchPendingTripsData(NeedCache: false)
        }else{
            self.completedJobHistoryModel = nil
            self.fetchCompletedTripsData(NeedCache: false)
        }
    }
    
    func getBottomLoader() -> UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.color = UIColor.PrimaryColor
        spinner.hidesWhenStopped = true
        return spinner
    }
    //New_Delivery_splitup_Start
    //Gofer splitup start
    //Laundry splitup start
    //Instacart splitup start

    func acceptJobApiCall(params: [AnyHashable:Any]){
    self.jobViewModel.acceptJobApi(parms: params){(result) in
              switch result {
              case .success(let val):
                 print("success")
                  //Deliveryall_Newsplitup_start
                self.gotoToRouteView(with: val)
                  //Deliveryall_Newsplitup_end
              case .failure(let error):
                print("\(error.localizedDescription)")
              }
          }
      }
    //Deliveryall_Newsplitup_start
    //Deliveryall splitup start
    // MARK: - NAVIGATE TO ROUTE VIEW AFTER ACCETPTING REQUEST
    func gotoToRouteView(with trip : JobDetailModel) {
        UserDefaults.removeValue(for: .requestID)
        Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
        guard let currentTrip = trip.getCurrentTrip() else { return }
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    //Deliveryall_Newsplitup_end
    //New_Delivery_splitup_End
    //Gofer splitup end
    //Deliveryall splitup end
    func getJobDetailsApiCall(params: JSON, jobStatus: TripStatus ) {
        self.jobViewModel.getJobApi(parms: params){(json) in
               switch json {
               case .success(let profile):
                
                if jobStatus == .completed || jobStatus == .cancelled {
                    AppRouter(self).routeInCompleteJobs(profile)
                }
                      
               case .failure(let error):
                              print(error.localizedDescription)
                //AppDelegate.shared.createToastMessage(error.localizedDescription, bgColor: UIColor.black, textColor: UIColor.white)
                }
            
        }
    }
    //Laundry splitup end
    //Instacart splitup end
}
extension HandyTripHistoryVC : UpdateContentProtocol{
    func updateContent() {
        self.tripHistoryView.pendingTable.reloadData()
        self.tripHistoryView.completedTable.reloadData()
        self.fetchPendingTripsData(NeedCache: false)
        self.fetchCompletedTripsData(NeedCache: false)
    }
    
    
}
