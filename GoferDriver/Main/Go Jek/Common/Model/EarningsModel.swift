/**
 * EarningsModel.swift
 *
 * @package UberDiver
 * @subpackage Controller
 * @category Calendar
 * @author Trioangle Product Team
 *  
 * @link http://trioangle.com
 */



import Foundation
import UIKit

//class EarningsModel : NSObject
//{
//    //MARK Properties
//    var status_message : String = ""
//    var status_code : String = ""
//    var last_trip : String = ""
//    var recent_payout : String = ""
//    var total_week_amount : String = ""
//    var currency_code : String = ""
//    var currency_symbol : String = ""
//    var arrWeeklyData : NSMutableArray = NSMutableArray()
//    override init(){
//        super.init()
//    }
//    convenience init(json : JSON){
//        self.init()
//        if json["error"] != nil
//        {
//            self.status_message = json["error"] as? String ?? String()
//            self.status_code = "0"
//        }
//        else
//        {
//            self.status_message = json["status_message"] as? String ?? String()
//            self.status_code = json["status_code"] as? String ?? String()
//
//            if self.status_code == "1"
//            {
//                self.last_trip = json.string("last_job")
//                self.recent_payout = json.string("recent_payout")
//                self.total_week_amount = json.string("total_week_amount")
//                self.currency_code = json.string("currency_code")
//                self.currency_symbol = json.string("currency_symbol")
//
//                if json["job_details"] != nil
//                {
//                    let arrData = json["job_details"] as? NSArray ?? NSArray()
//                    if arrData.count > 0
//                    {
//                        self.arrWeeklyData = NSMutableArray()
//
//                        for i in 0 ..< arrData.count
//                        {
//                            self.arrWeeklyData.addObjects(from: ([EarningsDataModel().getWeeklyData(responseDict: arrData[i] as! NSDictionary)]))
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

//class EarningsDataModel : NSObject {
//
//    //MARK Properties
//    var created_at : String = ""
//    var daily_fare : String = ""
//    var day : String = ""
//
//    //Get the weekly data
//    func getWeeklyData(responseDict: NSDictionary) -> Any
//    {
//        created_at =  UberSupport().checkParamTypes(params: responseDict, keys:"created_at")
//        daily_fare = UberSupport().checkParamTypes(params: responseDict, keys:"daily_fare")
//        day = UberSupport().checkParamTypes(params: responseDict, keys:"day")
//        return self
//    }
//}

class EarningsDataModel : Codable
{
        var created_at : String
        var daily_fare : String
        var day : String
    enum CodingKeys: String, CodingKey {
        case created_at = "created_at"
        case daily_fare = "daily_fare"
        case day = "day"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.created_at = container.safeDecodeValue(forKey: .created_at)
        self.daily_fare = container.safeDecodeValue(forKey: .daily_fare)
        self.day = container.safeDecodeValue(forKey: .day)
    }
}



class EarningsModel : Codable
{
    var status_message : String
    var status_code : String
    var last_trip : String
    var recent_payout : String
    var total_week_amount : String
    var currency_code : String
    var currency_symbol : String
    var arrWeeklyData : [EarningsDataModel]
    enum CodingKeys: String, CodingKey {
        case status_message = "status_message"
        case status_code = "status_code"
        case last_trip = "last_job"
        case recent_payout = "recent_payout"
        case currency_code = "currency_code"
        case currency_symbol = "currency_symbol"
        case arrWeeklyData = "job_details"
        case total_week_amount = "total_week_amount"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.last_trip = container.safeDecodeValue(forKey: .last_trip)
        self.recent_payout = container.safeDecodeValue(forKey: .recent_payout)
        self.currency_code = container.safeDecodeValue(forKey: .currency_code)
        self.currency_symbol = container.safeDecodeValue(forKey: .currency_symbol)
        self.total_week_amount = container.safeDecodeValue(forKey: .total_week_amount)
        let arrWeek = try? container.decodeIfPresent([EarningsDataModel].self, forKey: .arrWeeklyData)
        self.arrWeeklyData = arrWeek ?? [EarningsDataModel]()
    }
}
