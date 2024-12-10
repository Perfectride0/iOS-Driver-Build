/**
* WeeklyEarningVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import AVFoundation



class WeeklyEarningVC : UIViewController, UITableViewDelegate, UITableViewDataSource,APIViewProtocol
{
    func onAPIComplete(_ response: ResponseEnum, for API: APIEnums) {
        switch response {
        case .weeklyEarningStatement(let result):
            self.dataArray = result
            self.eachDayData = result.totDaysInWeek
            self.loadValueFromAPI()
            self.tblWeeklyInfo.reloadData()
        default:
            break
        }
    }
    func onFailure(error: String, for API: APIEnums) {
        self.appDelegate.createToastMessage(error)
    }
    var dataArray: PerWeekModel?
    var eachDayData = [EachDayInWeek]()
    
    @IBOutlet var tblWeeklyInfo: UITableView!
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
    
    var strTripID = ""
    var date: String?
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var apiInteractor: APIInteractorProtocol?
    var params = [String:Any]()
    
    // MARK: - ViewController Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initTextSetUp()
        UIApplication.shared.statusBarStyle = .lightContent
        self.apiInteractor = APIInteractor(self)
        params["date"] = self.date
        self.apiInteractor?.getResponse(forAPI: .weeklyEarnings, params: params).shouldLoad(true)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        UberSupport().changeStatusBarStyle(style: .lightContent)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func initTextSetUp(){
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
    func loadValueFromAPI(){
        guard let data = self.dataArray else {return}
        self.pageUpperTit.text = data.format_date
        self.pageUpperCostLbl.text = data.symbol + data.total_fare
        self.baseFareVal.text = data.symbol + data.basefare
        self.accessFeeVal.text = data.symbol + data.access_fee
        self.totGoferEarnVal.text = data.symbol + data.total_fare
        self.cashCollectedVal.text = data.symbol + data.cash_collected
        self.bankDepositVal.text = data.symbol + data.bank_deposits
        self.completedTripsVal.text = data.completed_trips.description
    }
    
    //MARK: ---------------------------------------------------------------
    //MARK: ***** Weekly Earning Table view Datasource Methods *****
    /*
     Weekly Earning Table Datasource & Delegates
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return  70
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return eachDayData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CellTripsInfo = tblWeeklyInfo.dequeueReusableCell(withIdentifier: "CellTripsInfo")! as! CellTripsInfo
        let data = eachDayData[indexPath.row]
        cell.lblTitle.text = "\(data.day) \(data.format)"
        print("aaa0",data.tot_fare)
        if let datas = self.dataArray {
        cell.costLbl.text = datas.symbol + data.driver_earning
        }
        return cell
    }
    
    //MARK: ---- Table View Delegate Methods ----
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let tripView = self.storyboard?.instantiateViewController(withIdentifier: "DailyEarningVC") as! DailyEarningVC
        let data = eachDayData[indexPath.row]
        tripView.date = data.date
        self.navigationController?.pushViewController(tripView, animated: true)
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
class CellTripsInfo : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblArrow: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    let bar = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        bar.frame = CGRect(x: 0, y: 1, width: self.contentView.frame.width, height: 1)
        bar.backgroundColor = .lightGray
        self.contentView.addSubview(bar)
    }
    func setBar(_ val : Bool){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.bar.frame = CGRect(x: 0, y: 1, width: self.contentView.frame.width, height: 1)
            self.bar.isHidden = !val
        }
    }
    
}

