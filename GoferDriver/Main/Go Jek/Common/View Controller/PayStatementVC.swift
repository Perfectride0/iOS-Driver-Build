/**
* PayStatementVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
import Foundation
import MapKit


class PayStatementVC : BaseVC {
   
    
    @IBOutlet var payStatementView: PayStatementView!
    let viewModel = PayoutVM()
    // Handy Splitup Start
    var type : BusinessType!
    // Handy Splitup End
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Handy Splitup Start
        if let type = type {
            AppWebConstants.currentBusinessType = type
        }
        // Handy Splitup End
    }
    //MARK:- initWithStory
    class func initWithStory(
        // Handy Splitup Start
        businessType: BusinessType? = nil
        // Handy Splitup End
    ) -> PayStatementVC{
        let vc : PayStatementVC = UIStoryboard.gojekCommon.instantiateViewController()
        // Handy Splitup Start
        if let businessType = businessType {
            vc.type = businessType
        }
        // Handy Splitup End
        return vc
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }

    
    func wsTogetWeaklyTripDetails() {
        var param = JSON()
        param["page"] = self.payStatementView.currentTripPageIndex + 1
        param["count"] = 20
        // Handy Splitup Start
        param["business_id"] = AppWebConstants.currentBusinessType.rawValue
        // Handy Splitup End
        guard  self.payStatementView.HittedTripPageIndex != self.payStatementView.currentTripPageIndex + 1 else {
            return
        }
        self.viewModel.getWeeklyTripDetails(param) { (result) in
            switch result {
            case.success(let json):
                let curr_sym = json.symbol
                let curr_code = json.currency_code
                let totalPage = json.total_page
                let currentPage = json.current_page
                if currentPage == 1 {
                    self.payStatementView.weeklyTripData.removeAll()
                }
                let weeklytrips = json.jobweekdetails
                self.payStatementView.currencyCode = curr_code
                self.payStatementView.currSymbol = curr_sym
                for item in weeklytrips {
                    self.payStatementView.weeklyTripData.append(item)
                }
//                self.payStatementView.weeklyTripData = weeklytrips
                if self.payStatementView.Refresher.isRefreshing{
                    self.payStatementView.tblPayStatement.reloadData()
                    self.payStatementView.Refresher.endRefreshing()
                }
                self.payStatementView.currentTripPageIndex = currentPage
                self.payStatementView.HittedTripPageIndex = currentPage
                self.payStatementView.totalTripPages = totalPage
                self.payStatementView.Loader.stopAnimating()
                self.payStatementView.tblPayStatement.reloadData()
                self.payStatementView.oneTimeForHistory = true
            case .failure(let error):
                self.payStatementView.Refresher.endRefreshing()
                self.payStatementView.Loader.stopAnimating()
                self.payStatementView.tblPayStatement.reloadData()
               // self.appDelegate.createToastMessage(error.localizedDescription)
                
            }
        }
        if !self.payStatementView.Refresher.isRefreshing{
            self.payStatementView.Loader.startAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.payStatementView.setRefresher()
        self.payStatementView.currentTripPageIndex = 0
        self.payStatementView.HittedTripPageIndex = 0
        self.payStatementView.weeklyTripData.removeAll()
        self.wsTogetWeaklyTripDetails()

    }

  
    
}
