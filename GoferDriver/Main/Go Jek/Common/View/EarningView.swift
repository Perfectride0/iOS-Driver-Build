//
//  EarningView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 08/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class EarningView: BaseView {
    
    @IBOutlet weak var viewTopHeader: HeaderView!
    @IBOutlet weak var titleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var BGView: TopCurvedView!
    @IBOutlet weak var TotalEarningBgView: CurvedView!
    @IBOutlet weak var totalEarningsTitleLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var totalEarningsValueLbl: SecondaryLargeLabel!
    @IBOutlet weak var chartHolderView: TopCurvedView!
    @IBOutlet weak var viewChartHolder: UIView!
    @IBOutlet weak var tblEarnings: CommonTableView!
    @IBOutlet weak var lblWeekDate: SecondarySmallHeaderLabel!
    @IBOutlet weak var btnNextWeek: SecondaryFontButton!
    @IBOutlet weak var btnPreviousWeek: SecondaryFontButton!
    @IBOutlet weak var lblWeekCost: PrimarySmallHeaderLabel!
    @IBOutlet weak var earningGraphContainerView: SecondaryView!
    @IBOutlet weak var viewRateHolder: UIView!
    @IBOutlet weak var lblCurrentRate: UILabel!
    @IBOutlet weak var lblNoData: SecondarySmallHeaderLabel!
    @IBOutlet weak var lblTopAmount: SecondarySmallHeaderLabel!
    @IBOutlet weak var lblTopAmount1: UILabel!
    @IBOutlet weak var lblTopAmount2: SecondarySmallHeaderLabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    
    var total_week_amount : String = ""
//    @IBOutlet weak var totalPayoutTitleLabel: PrimarySmallHeaderLabel
    override func darkModeChange() {
        super.darkModeChange()
        self.earningGraphContainerView.customColorsUpdate()
        self.lblTopAmount.customColorsUpdate()
        self.lblTopAmount2.customColorsUpdate()
        self.TotalEarningBgView.customColorsUpdate()
        self.chartHolderView.customColorsUpdate()
        self.btnNextWeek.customColorsUpdate()
        self.btnPreviousWeek.customColorsUpdate()
        self.lblWeekDate.customColorsUpdate()
        self.lblWeekDate.font = UIFont(name: G_BoldFont, size: 16)
        self.viewTopHeader.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.BGView.customColorsUpdate()
        self.BGView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
        self.totalEarningsTitleLbl.customColorsUpdate()
        self.totalEarningsTitleLbl.font = UIFont(name: G_BoldFont, size: 25)
        self.totalEarningsValueLbl.customColorsUpdate()
        self.totalEarningsValueLbl.textColor = .PrimaryColor
        self.tblEarnings.customColorsUpdate()
        self.tblEarnings.reloadData()
        self.lblNoData.customColorsUpdate()
        self.setChartWeeklyData()
        self.filterBtn.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    var viewController: EarningsVC!
    
    
    var arrMenus = [String]()
    var weekDays = [String]()
    
    var strStartDate = ""
    var strEndDate = ""
    
    var strStartDateTemp = ""
    var strEndDateTemp = ""
    
    var dateStart : NSDate = NSDate()
    var dateEnd : NSDate = NSDate()
    var dateStartTemp : NSDate = NSDate()
    var dateEndTemp : NSDate = NSDate()
    var arrWeeklyCharyData : NSMutableArray = NSMutableArray()
    var dateFormatter = DateFormatter()
    var chartModel : EarningsModel!
    var strCurrency = ""
    var status = ""
    var checkAvailabilityBtn = UIButton()
    
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? EarningsVC
        self.tblEarnings.delegate = self
        self.tblEarnings.dataSource = self
        self.initView()
        self.darkModeChange()
    }
    
    func initView() {
        self.filterBtn.setTitle("", for: .normal)
        self.filterBtn.setImage(UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.filterBtn.isHidden = isSingleApplication
        self.totalEarningsTitleLbl.text = LangCommon.driverEarnings.capitalized
        self.titleLbl.text = AppWebConstants.currentBusinessType.LocalizedString + " " + LangCommon.earnings.capitalized
        self.btnNextWeek.transform = isRTLLanguage ? .identity  : CGAffineTransform(scaleX: -1, y: 1)
        self.btnPreviousWeek.transform = isRTLLanguage ? CGAffineTransform(scaleX: -1, y: 1) : .identity
        status = Constants().GETVALUE(keyname: TRIP_STATUS)
//        self.totalPayoutTitleLabel.text = LangCommon.driverEarnings.uppercased()
        
        arrMenus = [LangHandy.jobPayment]
        if !Constants.userDefaults.bool(forKey: IS_COMPANY_DRIVER) {
            arrMenus.append(LangCommon.payStatement.capitalized)
        }
        weekDays = [LangCommon.sunday.capitalized,LangCommon.monday.capitalized,LangCommon.tuesday.capitalized,LangCommon.wednesday.capitalized,LangCommon.thursday.capitalized,LangCommon.friday.capitalized,LangCommon.saturday.capitalized]
        
        
        strCurrency = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        var rectTblView = tblEarnings.frame
        rectTblView.size.height = self.frame.size.height-120
        tblEarnings.frame = rectTblView
        lblNoData.isHidden = true
        view1.isHidden = false
        view2.isHidden = false
        viewRateHolder.isHidden = true
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "yyy-MM-dd"
        dateFormatter.locale = locale//Locale(identifier: "en_US")
        let todayDate = Date()
        let getWeekDayName = self.viewController.getDayOfWeek(today: dateFormatter.string(from: todayDate as Date))
        if !isRTLLanguage {
            
            if getWeekDayName == LangCommon.monday.capitalized
                
            {
                dateStart = viewController.get(.Next, "Monday",considerToday: true)
                let endDate = Calendar.current.date(byAdding: .day, value: 6, to: dateStart as Date)
                dateEnd = endDate! as NSDate
            }
            else
            {
                let startDate = Calendar.current.date(byAdding: .day, value: viewController.getMonday(setWeekDayName:getWeekDayName), to: todayDate as Date)
                dateStart = startDate! as NSDate
                let endDate = Calendar.current.date(byAdding: .day, value: viewController.getEndDate(setWeekDayName:getWeekDayName), to: todayDate as Date)
                
                dateEnd = endDate! as NSDate
            }
        }
        else{
            
            if getWeekDayName == LangCommon.sunday.capitalized
            {
                dateStart = viewController.get(.Next, "Sunday",considerToday: true)
                let endDate = Calendar.current.date(byAdding: .day, value: 6, to: dateStart as Date)
                dateEnd = endDate! as NSDate
            }
            else
            {
                let startDate = Calendar.current.date(byAdding: .day, value: viewController.getMonday(setWeekDayName:getWeekDayName), to: todayDate as Date)
                let startDateString = dateFormatter.string(from: startDate!)
                dateFormatter.locale = locale//Locale(identifier: "en_US")
                
                dateStart = dateFormatter.date(from: startDateString)! as NSDate
                // dateStart = startDate! as Date as NSDate
                
                let endDate = Calendar.current.date(byAdding: .day, value: viewController.getEndDate(setWeekDayName:getWeekDayName), to: todayDate as Date)
                let endDateString = dateFormatter.string(from: endDate!)
                dateFormatter.locale = locale//Locale(identifier: "en_US")
                dateEnd = dateFormatter.date(from: endDateString)! as NSDate
                // dateEnd = endDate! as Date as NSDate
            }
            
        }
        dateStartTemp = dateStart
        dateEndTemp = dateEnd
        strStartDate = dateFormatter.string(from: dateStart as Date)
        strEndDate = dateFormatter.string(from: dateEnd as Date)
        strStartDateTemp = strStartDate
        strEndDateTemp = strEndDate
        dateFormatter.dateFormat = "dd MMM yyy"
        lblWeekDate.text = String(format: "%@ - %@", dateFormatter.string(from: dateStartTemp as Date),dateFormatter.string(from: dateEndTemp as Date))
        
        if strStartDateTemp == strStartDate {
            btnNextWeek.isHidden = true
            lblWeekDate.text = LangCommon.week.capitalized
        } else {
            btnNextWeek.isHidden = false
        }
        self.lblNoData.text = LangCommon.noData
    }
    
    @IBAction func filterBtnPressed(_ sender: Any) {
        // Handy Splitup Start
        guard let selectedItem = AppWebConstants.selectedBusinessType.filter({$0.id == AppWebConstants.currentBusinessType.rawValue}).first?.name else { return }
        let vc = CustomBottomSheetVC.initWithStory(self,
                                                   pageTitle: LangCommon.earnings,
                                                   selectedItem: [selectedItem],
                                                   detailsArray: AppWebConstants.selectedBusinessType.compactMap({$0.name}), serviceArray: [])
        vc.isForTypeSelection = true
        self.viewController.present(vc, animated: true) {
            print("_________ CustomBottomSheetVC ______ Presented")
        }
        // Handy Splitup End
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.viewController.exitScreen(animated: true)
    }
    
    //MARK: - NEXT PREVIOUS ACTION
    /*
     PASSING START DATE & END DATE
     START DATE -> MONDAY
     END DATE -> SUNDAY
     */
    @IBAction func gotoNextPreviousOfWeek(_ sender: UIButton!)
    {
        viewRateHolder.isHidden = true
        if sender.tag == 11  //  Previous week
        {
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: dateStartTemp as Date)
            dateStartTemp = startDate! as NSDate
            let endDate = Calendar.current.date(byAdding: .day, value: 6, to: dateStartTemp as Date)
            dateEndTemp = endDate! as NSDate
            
        }
        else   //  Next week
        {
            let startDate = Calendar.current.date(byAdding: .day, value: 7, to: dateStartTemp as Date)
            dateStartTemp = startDate! as NSDate
            let endDate = Calendar.current.date(byAdding: .day, value: 6, to: dateStartTemp as Date)
            dateEndTemp = endDate! as NSDate
        }
        
        dateFormatter.dateFormat = "yyy-MM-dd"
        
        strStartDateTemp = dateFormatter.string(from: dateStartTemp as Date)
        strEndDateTemp = dateFormatter.string(from: dateEndTemp as Date)
        
        dateFormatter.dateFormat = "dd MMM yyy"
        lblWeekDate.text = String(format: "%@ - %@", dateFormatter.string(from: dateStartTemp as Date),dateFormatter.string(from: dateEndTemp as Date))
        if strStartDateTemp == strStartDate
        {
            btnNextWeek.isHidden = true
            lblWeekDate.text = LangCommon.week.capitalized
        }
        else
        {
            btnNextWeek.isHidden = false
        }
        
        self.viewController.getThisWeekEarnings(startDate: strStartDateTemp, endDate: strEndDateTemp)
    }
    
    
    
    // SETTING CHART INFO AFTER GETTING WEEKLY INFO
    func setChartWeeklyData() {
        guard let chartModel = chartModel else {
            return
        }
        lblWeekCost.text = "\(strCurrency) \(chartModel.total_week_amount)"
        self.totalEarningsValueLbl.text = String(format:"%@ %@",strCurrency,chartModel.total_week_amount)
        tblEarnings.reloadData()
        let refs: [Any] = ["M", "TU", "W", "TH", "F", "SA", "SU"]
        var vals: [String] = []
        
        if arrWeeklyCharyData.count > 0 {
            lblNoData.isHidden = true
            view1.isHidden = false
            view2.isHidden = false
            viewChartHolder.isHidden = false
            let arrTemp : NSMutableArray = NSMutableArray()
            arrTemp.removeAllObjects()
            for i in 0..<arrWeeklyCharyData.count {
                let modelInfo = arrWeeklyCharyData[i] as! EarningsDataModel
                
                arrTemp.add(modelInfo.daily_fare)

                //               print("arrTemp\(arrTemp)")
            }
            vals.removeAll()
            vals = arrTemp as! [String]
            
        }
        self.total_week_amount = chartModel.total_week_amount
        self.total_week_amount = self.total_week_amount.replacingOccurrences(of: ",", with: "")
        if Float(self.total_week_amount) == 0.0 {
            lblTopAmount.text = ""
            lblTopAmount1.text = ""
            lblTopAmount2.text = ""
            lblNoData.isHidden = false
            view1.isHidden = true
            view2.isHidden = true
            viewChartHolder.isHidden = true
        } else {
            let maxValue = vals.map({Double($0)!}).max()
            //            print("maxValue \(maxValue!)")
            let maxval = Float(maxValue!)
            let value = (Float(maxValue!) / 10)
            let value1 = Float(value)
            let add = Int(maxval + value1)

//            lblTopAmount.text = String(add)
//            lblTopAmount1.text = String(add/2)
            
            lblTopAmount2.text = "\(self.formatedString(number: NSNumber(value: add)))"
            lblTopAmount.text = "\(self.formatedString(number: NSNumber(value: add/2)))"
            // commented by Karuppasamy
            // need to formet the currency text
//            lblTopAmount.text = String(format:"%@ %@",strCurrency,String(add))
//            lblTopAmount1.text = String(format:"%@ %@",strCurrency,String(add/2))

            viewChartHolder.isHidden = false
            lblNoData.isHidden = true
            
        }
        for view in viewChartHolder.subviews {
            view.removeFromSuperview()
        }
        
        let chart = DSBarChart.init(frame: viewChartHolder.bounds,
                                    color: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor,
                                    references: refs,
                                    andValues: vals)
        chart?.inactiveBarColor = UIColor(hex: "2bcb7b").withAlphaComponent(0.5)
        chart?.activeBarColor = .PrimaryColor
        chart?.delegate = self
        viewChartHolder.addSubview(chart!)
        chart?.translatesAutoresizingMaskIntoConstraints = false
        chart?.topAnchor.constraint(equalTo: viewChartHolder.topAnchor).isActive = true
        chart?.bottomAnchor.constraint(equalTo: viewChartHolder.bottomAnchor).isActive = true
        chart?.leadingAnchor.constraint(equalTo: viewChartHolder.leadingAnchor).isActive = true
        chart?.trailingAnchor.constraint(equalTo: viewChartHolder.trailingAnchor).isActive = true
    }
    
    func formatedString(number: NSNumber) -> String {
        let numberFormetter = NumberFormatter()
        numberFormetter.usesGroupingSeparator = true
        numberFormetter.currencySymbol = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        numberFormetter.currencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        numberFormetter.numberStyle = .currency
        guard let numberFormetted = numberFormetter.string(from: number) else { return " Error " }
        return numberFormetted.replacingOccurrences(of: Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash), with: "\(Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)) ")
    }
    
    
    
    
}


extension EarningView : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellEarnItems = tblEarnings.dequeueReusableCell(withIdentifier: "CellEarnItems") as! CellEarnItems
        cell.setTheme()
        cell.lblTitle.customColorsUpdate()
        cell.lblSubTitle.customColorsUpdate()
        cell.lblArrow.customColorsUpdate()
        cell.nextArrowIV.customColorsUpdate()
        cell.selectionStyle = .none
        cell.lblTitle.text = arrMenus[indexPath.row]
        cell.lblIcon.text = indexPath.row == 0 ? "R" : "h"
        cell.lblIcon.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        cell.nextArrowIV.image = isRTLLanguage ? UIImage(named: "Back_Btn")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "Back_Btn")?.rotate(radians: .pi).withRenderingMode(.alwaysTemplate)
        if chartModel != nil {
            if indexPath.row == 0 {
                cell.lblSubTitle.text = LangHandy.lastJob + " " + ":" + " " + strCurrency + " " + chartModel.last_trip
                if isRTLLanguage{
                    cell.lblTitle.textAlignment = NSTextAlignment.right
                    cell.lblSubTitle.textColor = .PrimaryColor
                    cell.lblSubTitle.textAlignment = NSTextAlignment.right
                    cell.lblArrow.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
            }else{
                cell.lblSubTitle.isHidden = true
                if isRTLLanguage{
                    cell.lblTitle.textAlignment = NSTextAlignment.right
                    cell.lblSubTitle.textAlignment = NSTextAlignment.right
                    cell.lblArrow.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
            }
        }
        
        return cell
    }
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let tripView = HandyTripHistoryVC.initWithStory(
                // Handy Splitup Start
                businessType: AppWebConstants.currentBusinessType
                // Handy Splitup End
            )
            self.viewController.navigationController?.pushViewController(tripView, animated: true)
        } else if indexPath.row == 1 {
            let propertyView = PayStatementVC.initWithStory(
                // Handy Splitup Start
                businessType: AppWebConstants.currentBusinessType
                // Handy Splitup Start
            )
            self.viewController.navigationController?.pushViewController(propertyView, animated: true)
        }
    }
    
}

extension EarningView : ChartViewDelegate {
    // MOVEING PRICE INFO WHEN CHART BAR TAPPED
    func chartViewTapped(_ tag: Int) {
        viewRateHolder.isHidden = true
        var rectTblView = viewRateHolder.frame
        rectTblView.origin.x = CGFloat(tag * 50)
        viewRateHolder.frame = rectTblView
        let modelInfo = arrWeeklyCharyData[tag] as! EarningsDataModel
        lblCurrentRate.text = " \(strCurrency) \(modelInfo.daily_fare)"
    }
}
extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}


extension EarningView : CustomBottomSheetDelegate {
    func isDeselectAllSelected() {
    }
    
    func isSelectAllSelected(SelectAllValue: Bool) {
    }
    
    func serviceTypeSelected(SelectedItemName: String) {
    }
    
    func heatMapTapAction(selectedOptions: [String]) {
    }
    
   
    func MultipleTapAction(selectedOptions: [String]) {
    }
    
    func TappedAction(indexPath: Int, SelectedItemName: String) {
        // Handy Splitup Start
        print("__________Selected Item: \(indexPath) : \(SelectedItemName)")
        if let result =  AppWebConstants.selectedBusinessType.filter({$0.name == SelectedItemName}).first {
            AppWebConstants.currentBusinessType = result.busineesType
            self.viewController.getThisWeekEarnings(startDate: self.strStartDate,
                                                    endDate: self.strEndDate)
            self.titleLbl.text = AppWebConstants.currentBusinessType.LocalizedString + " " + LangCommon.earnings
        }
        // Handy Splitup End
    }
    func ActionSheetCanceled() {
        print("__________Sheet Cancelled")
    }
}
