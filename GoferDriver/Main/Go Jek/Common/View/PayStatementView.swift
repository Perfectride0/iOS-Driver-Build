//
//  PayStatementView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 05/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class PayStatementView: BaseView {

    
//    var remainigAPIHits : Int = 0
//    var currentPage : Int = 1
//    var isWeekAPIOneTimeHitted : Bool = true
    
    var viewController: PayStatementVC!
    var currencyCode: String?
    var currSymbol: String?
    var weeklyTripData = [TripWeekDetailsModel]()
    // Handy Splitup Start
    var orginalBusinessType : BusinessType!
    // Handy Splitup End
    
    @IBOutlet var tblPayStatement: CommonTableView!
    @IBOutlet weak var pageTitle : SecondaryHeaderLabel!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var contentCurvedView: TopCurvedView!
    @IBOutlet weak var contentHolderView: SecondaryView!
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.contentCurvedView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.pageTitle.customColorsUpdate()
        self.tblPayStatement.customColorsUpdate()
        self.tblPayStatement.reloadData()
    }
    
    override
    func willDisappear(baseVC: BaseVC) {
        super.willDisappear(baseVC: baseVC)
        // Handy Splitup Start
        if self.viewController.type == nil {
            AppWebConstants.currentBusinessType = self.orginalBusinessType
        }
        // Handy Splitup End
    }
    
    var arrMenus: [String] = ["Trip History", "Pay Statements"]
    let strCurrency = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
    //MARK:- Refreshers
    var oneTimeForHistory : Bool = true

    lazy var Refresher : UIRefreshControl = {
        return self.getRefreshController()
    }()
  
    lazy var Loader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    //MARK:- indexed
    var HittedTripPageIndex = 0
    var currentTripPageIndex = 1{
        didSet{
            debug(print:currentTripPageIndex.description)
        }
    }
    var totalTripPages = 1{
        didSet{
            debug(print: totalTripPages.description)
        }
    }
    @objc func onRefresh(_ sender : UIRefreshControl){
        
        self.weeklyTripData.removeAll()
        self.currentTripPageIndex = 0
        self.HittedTripPageIndex = 0
        self.viewController.wsTogetWeaklyTripDetails()
    }
    func getRefreshController() -> UIRefreshControl{
        let refresher = UIRefreshControl()
        refresher.tintColor = .PrimaryColor
        refresher.attributedTitle = NSAttributedString(string: LangCommon.pullToRefresh)
        refresher.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        return refresher
    }
    func getBottomLoader() -> UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .PrimaryColor
        spinner.hidesWhenStopped = true
        return spinner
    }
    private var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? PayStatementVC
        self.tblPayStatement.dataSource = self
        self.tblPayStatement.delegate = self
        // Handy Splitup Start
        self.orginalBusinessType = AppWebConstants.currentBusinessType
        // Handy Splitup End
        self.initLanguage()
        self.darkModeChange()
    }
    func setRefresher()
    {
        self.tblPayStatement.tableFooterView = self.Loader

        if #available(iOS 10.0, *) {
            self.tblPayStatement.refreshControl = self.Refresher
        } else {
            self.tblPayStatement.addSubview(self.Refresher)
        }

    }
    // MARK: When User Press Back Button
       @IBAction func onBackTapped(_ sender:UIButton!)
       {
        self.viewController.navigationController?.popViewController(animated: true)
       }
    //MARK:- init Language
    func initLanguage(){
       self.pageTitle?.text = LangCommon.payStatement.capitalized
      self.arrMenus = [LangHandy.jobHistory.capitalized, LangCommon.payStatement.capitalized]
    }

}
extension PayStatementView :UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if weeklyTripData.count == 0 && !Refresher.isRefreshing && !Loader.isAnimating {
            let noDataLabel = SecondarySubHeaderLabel()
            noDataLabel.text = LangHandy.noJobs
            noDataLabel.customColorsUpdate()
            noDataLabel.textAlignment = .center
            self.tblPayStatement.backgroundView = noDataLabel
        }else{
            print("data avialable")
            self.tblPayStatement.backgroundView = nil
        }
        return weeklyTripData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellEarnItems = tblPayStatement.dequeueReusableCell(withIdentifier: "CellEarnItems") as! CellEarnItems
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        guard let payModel = weeklyTripData.value(atSafe: indexPath.row) else {return cell}

        
        cell.celllBGView.border(1, .TertiaryColor)
        cell.celllBGView.cornerRadius = 15
        if isRTLLanguage{

            cell.lblTitle.textAlignment = NSTextAlignment.right
            cell.lblSubTitle.textAlignment = NSTextAlignment.left
            cell.lblArrows.transform = CGAffineTransform(scaleX: -1, y: 1)
            cell.lblArrows.textAlignment = NSTextAlignment.left
        }
        cell.lblTitle.text = payModel.week
        cell.lblSubTitle.text = "\(strCurrency)\(payModel.driver_payout)"
        cell.accessibilityHint = indexPath.row.description
        cell.lblTitle.customColorsUpdate()
        cell.lblSubTitle.customColorsUpdate()
        cell.lblArrows.customColorsUpdate()
        cell.celllBGView.customColorsUpdate()
        cell.setTheme()
        return cell
    }
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let vc = DetailStatementVC.initWithStory(for: .weekly)
        let payModel = weeklyTripData[indexPath.row]
        vc.date = payModel.date
        self.viewController.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PayStatementView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Based On the Current Tab Find The last cell id and Check with our model Last id
        // If it matches hit the api only ones
        
            let cell = tblPayStatement.visibleCells.last as? CellEarnItems
        guard ((cell?.lblTitle.text) != nil),(self.weeklyTripData.last != nil) else {return}
        
        if cell?.lblTitle.text == self.weeklyTripData.last?.week.description && oneTimeForHistory && self.currentTripPageIndex != self.totalTripPages && cell?.accessibilityHint == (self.weeklyTripData.count - 1).description {
            self.viewController.wsTogetWeaklyTripDetails()
                self.oneTimeForHistory = !self.oneTimeForHistory
                print("å:: This is Last For Completed")
            } else {
                print("å:: Already Hitted Api Completed")
            }
       
        
    }
}
