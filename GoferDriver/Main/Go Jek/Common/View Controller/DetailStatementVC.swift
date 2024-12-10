//
//  DetailStatementVC.swift
//  GoferDriver
//
//  Created by trioangle on 25/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit

class DetailStatementVC: BaseVC {
    
    // --------------------
    // MARK: Outlets
    // --------------------
    @IBOutlet var detailStatementView: DetailStatementView!
    
    // ---------------------------------
    // MARK: Local Variables
    // ---------------------------------
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var localTimeZoneName: String { return TimeZone.current.identifier }
    var date: String?
    var purpose : ScreenPurpose = .weekly
    var jobViewModel : CommonViewModel!
    
    // ---------------------------------
    // MARK: Refresher and Loader
    // ---------------------------------
    
    lazy var Refresher : UIRefreshControl = {
        return self.getRefreshController()
    }()
    
    lazy var Loader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    
    // -------------------------
    // MARK: Init with Story
    // -------------------------
    
    class func initWithStory(for purpose : ScreenPurpose) -> DetailStatementVC {
        let vc : DetailStatementVC = UIStoryboard.gojekCommon.instantiateViewController()
        vc.purpose = purpose
        vc.jobViewModel = CommonViewModel()
        return vc
    }
    
    // -------------------------------------------
    // MARK: Life Cycle or Super Class Functions
    // -------------------------------------------
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailStatementView.currentTripPageIndex = 0
        self.detailStatementView.HittedTripPageIndex = 0
        self.detailStatementView.dailyStatementArray.removeAll()
        self.getDetailsFromApi()
    }
    
    
    // -------------------------
    // MARK: Local Functions
    // -------------------------
    func getRefreshController() -> UIRefreshControl {
        let refresher = UIRefreshControl()
        refresher.tintColor = .PrimaryColor
        refresher.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refresher.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        return refresher
    }
    @objc
    func onRefresh(_ sender : UIRefreshControl){
        self.detailStatementView.dailyStatementArray.removeAll()
        self.detailStatementView.currentTripPageIndex = 0
        self.detailStatementView.HittedTripPageIndex = 0
        self.getDetailsFromApi()
    }
    func getBottomLoader() -> UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.color = UIColor.PrimaryColor
        spinner.hidesWhenStopped = true
        return spinner
    }
    
    // -------------------------
    // MARK: ws Functions
    // -------------------------
    
    func getDetailsFromApi() {
        var params = [String:Any]()
        switch self.purpose {
        case .weekly:
            params["date"] = self.date
            params["currency_code"] = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash) as String
            // Handy Splitup Start
            params["business_id"] = AppWebConstants.currentBusinessType.rawValue
            // Handy Splitup End
            let connectionHandler = ConnectionHandler()
            connectionHandler.getRequest(for: .weeklyEarnings,
                                            params: params,
                                            showLoader: false)
                .responseDecode(to: DeteailStatementModel.self) { (json) in
                    self.detailStatementView.detailStatementModel = json
                    self.detailStatementView.loadValueFromAPI()
                    if self.Refresher.isRefreshing{
                        self.detailStatementView.payStatementTableView.reloadData()
                        self.Refresher.endRefreshing()
                    }
                    self.Loader.stopAnimating()
                    self.detailStatementView.payStatementTableView.reloadData()
                    
                }
                .responseFailure { (error) in
                    debug(print: error)
                }
            
            if !self.Refresher.isRefreshing{
                self.Loader.startAnimating()
            }
            
        case .daily(let statement):
            params["date"] = statement.date
            // Handy Splitup Start
            params["business_id"] = AppWebConstants.currentBusinessType.rawValue
            // Handy Splitup End
            params["currency_code"] = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash) as String
            params["timezone"] = localTimeZoneName
            params["page"] = self.detailStatementView.currentTripPageIndex + 1
            params["count"] = 20
            UberSupport.shared.removeProgressInWindow()
            guard  self.detailStatementView.HittedTripPageIndex != self.detailStatementView.currentTripPageIndex + 1 else {
                return
            }
            let connectionHandler = ConnectionHandler()
            connectionHandler.getRequest(for: .dailyEarnings,
                                            params: params,
                                            showLoader: false)
                
                .responseDecode(to: DeteailStatementModel.self) { (result) in
                    if result.currentPage == 1 {
                        self.detailStatementView.dailyStatementArray.removeAll()
                    }
                    for item in result.dailyStatement{
                        self.detailStatementView.dailyStatementArray.append(item)
                    }
                    if self.Refresher.isRefreshing{
                        self.detailStatementView.payStatementTableView.reloadData()
                        self.Refresher.endRefreshing()
                    }
                    self.detailStatementView.currentTripPageIndex = result.currentPage
                    self.detailStatementView.HittedTripPageIndex = result.currentPage
                    self.detailStatementView.totalTripPages = result.totalPage
                    if result.currentPage == 1 {
                        self.detailStatementView.detailStatementModel = nil
                        self.detailStatementView.detailStatementModel = result
                    }
                    self.detailStatementView.loadValueFromAPI()
                    self.Loader.stopAnimating()
                    self.detailStatementView.payStatementTableView.reloadData()
                    self.detailStatementView.oneTimeForHistory = true
                }
                .responseFailure { (error) in
                    debug(print: error)
            }
            if !self.Refresher.isRefreshing{
                self.Loader.startAnimating()
            }
        }
        
    }
    

}

