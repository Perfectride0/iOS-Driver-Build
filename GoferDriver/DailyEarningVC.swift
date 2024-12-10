/**
* DailyEarningVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import AVFoundation



class DailyEarningVC : UIViewController, UITableViewDelegate, UITableViewDataSource,APIViewProtocol
{
    func onAPIComplete(_ response: ResponseEnum, for API: APIEnums) {
        switch response {
        case .dailyEarningStatement(let result):
            self.dataArray = result
            self.cellDataArray = result.dailyStatement
            self.loadValuesFromAPI()
            self.tblDailyEarning.reloadData()
        default:
            break
        }
    }
    func onFailure(error: String, for API: APIEnums) {
        self.appDelegate.createToastMessage(error)
    }
    
    @IBOutlet var tblDailyEarning : UITableView!
    @IBOutlet weak var tripEarningTitle: UILabel!
    @IBOutlet weak var baseFareLbl: UILabel!
    @IBOutlet weak var baseFareSymb: UILabel!
    @IBOutlet weak var accessFeeLbl: UILabel!
    @IBOutlet weak var totGoferEarnTit: UILabel!
    @IBOutlet weak var cashCollectedLabel: UILabel!
    @IBOutlet weak var riderFaresEarntit: UILabel!
    @IBOutlet weak var bankDepositLbl: UILabel!
    @IBOutlet weak var completedTripsTit: UILabel!
    @IBOutlet weak var dailyEarningTit: UILabel!
    @IBOutlet weak var pageUpperTit: UILabel!
    @IBOutlet weak var pageUpperCostLbl: UILabel!
    @IBOutlet weak var baseFareVal: UILabel!
    @IBOutlet weak var accessFeeVal: UILabel!
    @IBOutlet weak var cashCollectedVal: UILabel!
    @IBOutlet weak var totGoferEarnVal: UILabel!
    @IBOutlet weak var bankDepositVal: UILabel!
    @IBOutlet weak var completedTripsVal: UILabel!
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var apiInteractor: APIInteractorProtocol?
    var date: String?
    var params = [String:Any]()
    var dataArray: DailyStatementModel?
    var cellDataArray = [PerDayModel]()
    
    // MARK: - ViewController Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initTextSetup()
        self.apiInteractor = APIInteractor(self)
        UIApplication.shared.statusBarStyle = .lightContent
        params["date"] = self.date
        self.apiInteractor?.getResponse(forAPI: .dailyEarnings, params: params).shouldLoad(true)
    }
    
    func initTextSetup(){
        
        self.tripEarningTitle.text = "TRIP EARNINGS".localize
        self.baseFareLbl.text = "Base Fare".localize
        self.accessFeeLbl.text = "Access Fee".localize
        self.totGoferEarnTit.text = "Total Gofer Earnings".localize
        self.cashCollectedLabel.text = "Cash Collected".localize
        self.riderFaresEarntit.text = "Rider fares earned and kept.".localize
        self.bankDepositLbl.text = "Bank Deposit".localize
        self.completedTripsTit.text = "COMPLETED TRIPS".localize
        self.dailyEarningTit.text = "DAILY EARNINGS"
    }
    func loadValuesFromAPI(){
        guard let data = self.dataArray else {return}
        UserDefaults.standard.set(data.symbol,forKey: "CURR_SYMBOL")
        self.pageUpperTit.text =  data.day + " " + data.format_date
        self.pageUpperCostLbl.text = data.symbol + data.total_fare
        self.baseFareVal.text = data.symbol + data.basefare
        self.accessFeeVal.text = data.symbol + data.access_fee
        self.totGoferEarnVal.text = data.symbol + data.total_fare
        self.cashCollectedVal.text = data.symbol + data.cash_collected
        self.bankDepositVal.text = data.symbol + data.bank_deposits
        self.completedTripsVal.text = data.completed_trips.description
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        UberSupport().changeStatusBarStyle(style: .lightContent)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK: ---------------------------------------------------------------
    //MARK: ***** Weekly Earning Table view Datasource Methods *****
    /*
     Weekly Earning Table Datasource & Delegates
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return  80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("count",cellDataArray.count)
        return cellDataArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellTripsInfo = tblDailyEarning.dequeueReusableCell(withIdentifier: "CellTripsInfo")! as! CellTripsInfo
        let data = cellDataArray[indexPath.row]
        cell.lblTitle.text = data.time
        if let datas = self.dataArray {
        cell.costLbl.text =  datas.symbol + data.driver_earn
        }
        return cell
    }
    
    //MARK: ---- Table View Delegate Methods ----
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let propertyView = self.storyboard?.instantiateViewController(withIdentifier: "NewTripsDetailsVC") as! NewTripsDetailsVC
        self.navigationController?.pushViewController(propertyView, animated: true)
        

    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
    }
    
    
}

/*@IBOutlet var lblPickUpLoc : UILabel!
@IBOutlet var lblDropLoc : UILabel!
@IBOutlet var lblTripTime: UILabel!
@IBOutlet var lblCost: UILabel!
@IBOutlet var lblCarType: UILabel!
@IBOutlet var lblTripStatus: UILabel!
@IBOutlet var lblDriverName: UILabel!
@IBOutlet var viewTapper:UIView!
@IBOutlet var btnHelp : UIButton!
@IBOutlet var btnReceipt : UIButton!
@IBOutlet var imgMapRoot : UIImageView!
@IBOutlet var imgUserThumb : UIImageView!*/
