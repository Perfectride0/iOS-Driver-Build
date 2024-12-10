/**
 * RatingModel.swift
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

//class RatingModel : NSObject {
//    //MARK Properties
//    var status_message : String = ""
//    var status_code : String = ""
//    var total_rating : String = ""
//    var total_rating_count : String = ""
//    var five_rating_count : String = ""
//    var driver_rating : String = ""
//    var thumbsUpCount : String = ""
//    var thumbsDownCount : String = ""
//    override init() {
//        super.init()
//    }
//
//    convenience init(_ json : JSON){
//        self.init()
//        self.status_message = json["status_message"] as? String ?? String()
//        self.status_code = json["status_code"] as? String ?? String()
//
//        if self.status_code == "1" {
//            self.driver_rating = json.string("provider_rating")
//            self.total_rating = json.string("total_rating")
//            self.total_rating_count = json.string("total_rating_count")
//            self.five_rating_count = json.string("five_rating_count")
//            self.thumbsUpCount = json.string("thumbs_up_count")
//            self.thumbsDownCount = json.string("thumbs_down_count")
//        }
//    }
//
//}

class RatingModel: Codable {
    var status_message : String
    var status_code : String
    var total_rating : String
    var total_rating_count : String
    var five_rating_count : String
    var driver_rating : String
    var thumbsUpCount : String
    var thumbsDownCount : String
    enum CodingKeys: String, CodingKey {
        case status_message = "status_message"
        case status_code = "status_code"
        case total_rating = "total_rating"
        case total_rating_count = "total_rating_count"
        case five_rating_count = "five_rating_count"
        case driver_rating = "provider_rating"
        case thumbsUpCount = "thumbs_up_count"
        case thumbsDownCount = "thumbs_down_count"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.total_rating = container.safeDecodeValue(forKey: .total_rating)
        self.total_rating_count = container.safeDecodeValue(forKey: .total_rating_count)
        self.five_rating_count = container.safeDecodeValue(forKey: .five_rating_count)
        self.driver_rating = container.safeDecodeValue(forKey: .driver_rating)
        self.thumbsUpCount = container.safeDecodeValue(forKey: .thumbsUpCount)
        self.thumbsDownCount = container.safeDecodeValue(forKey: .thumbsDownCount)
    }
}


//class RatingFeedBackModel : NSObject
//{
//    //MARK Properties
//    var status_message : String = ""
//    var status_code : String = ""
//    var date : String = ""
//    var rider_rating : String = ""
//    var rating_comments : String = ""
//    var user_id : String = ""
//    override init() {
//        super.init()
//    }
//    convenience init(json : JSON){
//        self.init()
//        date = json.string("date")
//        rider_rating = json.string("rider_rating")
//        rating_comments = json.string("rider_comments")
//        user_id = json.string("trip_id")
//    }
//    // MARK: Inits
//    func initiateFeedbackData(responseDict: NSDictionary) -> Any
//    {
//        date = UberSupport().checkParamTypes(params: responseDict, keys:"date")
//        rider_rating = UberSupport().checkParamTypes(params: responseDict, keys:"rider_rating")
//        rating_comments = UberSupport().checkParamTypes(params: responseDict, keys:"rider_comments")
//        user_id = UberSupport().checkParamTypes(params: responseDict, keys:"trip_id")
//        return self
//    }
//}
