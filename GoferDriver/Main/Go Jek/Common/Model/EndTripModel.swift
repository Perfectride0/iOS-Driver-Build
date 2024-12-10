/**
 * EndTripModel.swift
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

class EndTripModel : NSObject {
    
    //MARK Properties
//    var status_message : String = ""
//    var status_code : String = ""
//    var access_fee : String = ""
//    var base_fare : String = ""
//    var driver_payout : String = ""
//    var drop_location : String = ""
//    var pickup_location : String = ""
//    var payment_status : String = ""
//    var total_fare : String = ""
//    var total_km : String = ""
//    var total_km_fare : String = ""
//    var total_time : String = ""
//    var total_time_fare : String = ""
//    var payment_method : String = ""
//    var owe_amount : String = ""
//    var applied_owe_amount : String = ""
//    var wallet_amount : String = ""
//    var promo_amount : String = ""
//    var arrTemp2 : NSMutableArray = NSMutableArray()
//
//    var arrTemp3 : NSMutableArray = NSMutableArray()
// 
//    override init() {
//        super.init()
//    }
//    convenience init(_ json : JSON){
//        self.init()
//        self.access_fee = json.string("access_fee")
//        self.base_fare = json.string("base_fare")
//        self.drop_location = json.string("drop_location")
//        self.pickup_location = json.string("pickup_location")
//        self.total_fare = json.string("total_fare")
//        self.total_km = json.string("total_km")
//        self.total_km_fare = json.string("total_km_fare")
//        self.total_time = json.string("total_time")
//        self.total_time_fare = json.string("total_time_fare")
//        self.driver_payout = json.string("driver_payout")
//        self.payment_method = json.string( "payment_method")
//        self.payment_status = json.string("payment_status")
//        
//        if json["payment_details"] != nil
//        {
//            let arrData = json["payment_details"] as? NSArray ?? NSArray()
//            if arrData.count > 0
//            {
//                self.arrTemp3 = NSMutableArray()
//                
//                for i in 0 ..< arrData.count
//                {
//                    self.arrTemp3.addObjects(from: ([CashModel().getCashData(responseDict: arrData[i] as! NSDictionary)]))
//                    
//                }
//            }
//        }
//        if json["invoice"] != nil
//        {
//            let arrData1 = json["invoice"] as? NSArray ?? NSArray()
//            if arrData1.count > 0
//            {
//                self.arrTemp2 = NSMutableArray()
//                
//                for i in 0 ..< arrData1.count
//                {
//                    self.arrTemp2.addObjects(from: ([CashModel().getInvoiceData(responseDict: arrData1[i] as! NSDictionary)]))
//                    
//                }
//            }
//        }
//        
//    }
}
