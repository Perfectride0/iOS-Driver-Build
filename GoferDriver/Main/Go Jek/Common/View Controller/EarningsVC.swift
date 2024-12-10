/**
* MainMapView.swift
*
* @package GoferDriver
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
import Foundation
import MapKit

class EarningsVC : BaseVC {
    
    @IBOutlet var earningView: EarningView!
    let viewModel = EarningsVM()
    
    //MARK:-
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
// MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.earningView.strCurrency = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        self.getThisWeekEarnings(startDate: earningView.strStartDate, endDate: earningView.strEndDate)
    }
  
    
    
    override func viewWillAppear(_ animated: Bool) {
 
    }
  
    //MARK: Getting Previous Monday on this week
    /*
     Weekly earnings calculated by Moday - Sunday
     */
    func getMonday(setWeekDayName:String) -> Int
    {
        if setWeekDayName == LangCommon.tuesday.capitalized
        {
            return -1
        }
        else if setWeekDayName == LangCommon.wednesday.capitalized
        {
            return -2
        }
        else if setWeekDayName == LangCommon.thursday.capitalized
        {
            return -3
        }
        else if setWeekDayName == LangCommon.friday.capitalized
        {
            return -4
        }
        else if setWeekDayName == LangCommon.saturday.capitalized
        {
            return -5
        }
        else if setWeekDayName == LangCommon.sunday.capitalized
        {
            return -6
        }
        return 0
    }
    
    func getEndDate(setWeekDayName:String) -> Int
    {
        if setWeekDayName == LangCommon.tuesday.capitalized
        {
            return 5
        }
        else if setWeekDayName == LangCommon.wednesday.capitalized
        {
            return 4
        }
        else if setWeekDayName == LangCommon.thursday.capitalized
        {
            return 3
        }
        else if setWeekDayName == LangCommon.friday.capitalized
        {
            return 2
        }
        else if setWeekDayName == LangCommon.saturday.capitalized
        {
            return 1
        }
        else if setWeekDayName == LangCommon.sunday.capitalized
        {
            return 0
        }
        return 0
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- initWithStory
    class func initWithStory() -> EarningsVC{
        let view : EarningsVC = UIStoryboard.gojekCommon.instantiateViewController()
        return view
    }
    func getWeekDaysInEnglish() -> [String] {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return calendar.weekdaySymbols
    }
     
    enum SearchDirection
    {
        case Next
        case Previous
        
        var calendarOptions: NSCalendar.Options {
            switch self {
            case .Next:
                return .matchNextTime
            case .Previous:
                return [.searchBackwards, .matchNextTime]
            }
        }
    }
    
    // GETTING WEEKLY START DATE & END DATE
    func get(_ direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> NSDate {
        let weekdaysName = getWeekDaysInEnglish()
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let nextWeekDayIndex = weekdaysName.firstIndex(of: dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
        
        let today = NSDate()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        if consider && calendar.component(.weekday, from: today as Date) == nextWeekDayIndex {
            return today
        }
        
        let nextDateComponent = NSDateComponents()
        nextDateComponent.weekday = nextWeekDayIndex
        
        
        let date = calendar.nextDate(after: today as Date, matching: nextDateComponent as DateComponents, options: direction.calendarOptions)
        
        return date! as NSDate
    }
    
    func getDayOfWeek(today:String)->String {
        
        let formatter  = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "yyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return earningView.weekDays[weekDay!-1]
    }
    
    //MARK: - API CALL -> GETTING WEEKLY EARNINGS
    func getThisWeekEarnings(startDate: String, endDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "yyy-MM-dd"
        guard let start = dateFormatter.date(from: startDate),
            let end = dateFormatter.date(from: endDate) else{return}
        let englishFormatter = DateFormatter()
        englishFormatter.locale = Locale(identifier: "en")//LangCommon.english.locale
        englishFormatter.dateStyle = DateFormatter.Style.medium
        englishFormatter.timeStyle = DateFormatter.Style.none
        englishFormatter.dateFormat = "yyy-MM-dd"
        let englishStart = englishFormatter.string(from: start)
        let englishEnd = englishFormatter.string(from: end)
        var dicts = JSON()
        // Handy Splitup Start
        dicts["business_id"] = AppWebConstants.currentBusinessType.rawValue
        // Handy Splitup End
        dicts["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["currency_code"] = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        dicts["start_date"] = englishStart//String(format:"%@",startDate)
        dicts["end_date"] = englishEnd//String(format:"%@",endDate)
        self.viewModel.wsToGetWeeklyEarningDetails(dicts) { (result) in
            switch result {
            case .success(let json):
                if json.status_code == "1"{
                    let earnings = json
                    self.earningView.chartModel = earnings
                    self.earningView.arrWeeklyCharyData.removeAllObjects()
                    self.earningView.arrWeeklyCharyData.addObjects(from: (earnings.arrWeeklyData as NSArray) as! [Any])
                    self.earningView.tblEarnings.reloadData()
                }else{
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
                self.earningView.setChartWeeklyData()
            case .failure(let error):
                print("\(error.localizedDescription)")

                //AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        }
        
     
    }
   
    

}

class CellEarnItems: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTheme()
    }
    func setTheme() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBOutlet weak var lblTitle: SecondarySubHeaderLabel!
    @IBOutlet weak var lblSubTitle: SecondaryRegularLabel!
    @IBOutlet weak var lblIcon: UILabel!
    @IBOutlet weak var txtFldValues: UITextField!
    @IBOutlet weak var lblAccessory: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var selectedCurrency: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblArrow: ThemeFontBasedLabel!
    @IBOutlet weak var lblArrows: SecondaryFontBasedLabel!
    
    @IBOutlet weak var nextArrowIV: CommonColorImageView!
    @IBOutlet weak var RatingBgView: SecondaryView!
    @IBOutlet weak var celllBGView: SecondaryView!
    @IBOutlet weak var checkBoxIV: UIImageView!
    
    
   
   
    
}

