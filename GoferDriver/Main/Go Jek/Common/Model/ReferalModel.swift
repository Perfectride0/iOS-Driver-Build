//
//  ReferalModel.swift
//  GoferDriver
//
//  Created by Trioangle on 24/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

enum ReferalStatus : String{
    case pending = "Pending"
    case expired = "Expired"
    case completed = "Completed"
    var displayText : String{
        switch self {
        case .pending:
            return LangCommon.pending.uppercased()
        case .expired:
            return LangCommon.expired.uppercased()
        case .completed:
            return LangCommon.completed.uppercased()
        }
    }
}
enum ReferalType : Int{
    case completed = 1
    case inComplete = 0
}


class ReferalModelData : Codable {
       let status_code: String
       let status_message: String
       let apply_referral : String
       let referral_code, referral_amount, pending_amount, total_earning,referral_link : String
       let pending_referrals, completed_referrals:[ReferalModel]

    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case status_message = "status_message"
        case apply_referral = "apply_referral"
        case referral_code = "referral_code"
        case referral_amount = "referral_amount"
        case pending_amount = "pending_amount"
        case total_earning = "total_earning"
        case pending_referrals = "pending_referrals"
        case completed_referrals = "completed_referrals"
        case referral_link = "referral_link"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.apply_referral = container.safeDecodeValue(forKey: .apply_referral)
        self.referral_code = container.safeDecodeValue(forKey: .referral_code)
        self.referral_amount = container.safeDecodeValue(forKey: .referral_amount)
        self.pending_amount = container.safeDecodeValue(forKey: .pending_amount)
        self.total_earning = container.safeDecodeValue(forKey: .total_earning)
        self.referral_link = container.safeDecodeValue(forKey: .referral_link)
        let pendingRef = try? container.decodeIfPresent([ReferalModel].self, forKey: .pending_referrals)
        self.pending_referrals = pendingRef ?? [ReferalModel]()
        let completedRef = try? container.decodeIfPresent([ReferalModel].self, forKey: .completed_referrals)
        self.completed_referrals = completedRef ?? [ReferalModel]()
    }
}

class ReferalModel: Codable {
    let id, days, remaining_days, trips, remaining_trips : Int
    let name, profile_image, start_date, end_date, earnable_amount, getDesciptionText : String
    var status: ReferalStatus = .pending
    var default_status: ReferalStatus = .pending
    var profile_image_url:URL?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case days = "days"
        case remaining_days = "remaining_days"
        case trips = "jobs"
        case remaining_trips = "remaining_jobs"
        case name = "name"
        case profile_image = "profile_image"
        case start_date = "start_date"
        case end_date = "end_date"
        case earnable_amount = "earnable_amount"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.days = container.safeDecodeValue(forKey: .days)
        self.remaining_days = container.safeDecodeValue(forKey: .remaining_days)
        self.trips = container.safeDecodeValue(forKey: .trips)
        self.remaining_trips = container.safeDecodeValue(forKey: .remaining_trips)
        self.name = container.safeDecodeValue(forKey: .name)
        self.profile_image = container.safeDecodeValue(forKey: .profile_image)
        self.start_date = container.safeDecodeValue(forKey: .start_date)
        self.end_date = container.safeDecodeValue(forKey: .end_date)
        self.earnable_amount = container.safeDecodeValue(forKey: .earnable_amount)
        self.status = ReferalStatus.init(rawValue: self.status.rawValue) ?? .pending
        self.default_status = ReferalStatus.init(rawValue: self.default_status.rawValue) ?? .pending
        self.profile_image_url = URL(string: self.profile_image)
        var text = "\(self.remaining_days) "
        text.append(self.remaining_days == 1 ? LangCommon.dayLeftToComplete  : LangCommon.daysLeftToComplete )
        text.append(" \(self.remaining_trips) ")
        text.append(self.remaining_trips == 1 ? LangCommon.trip :LangCommon.trips)
        self.getDesciptionText = text
    }
}



//class ReferalModel{
//    var id =  Int()
//    var days =  Int()
//    var name = String()
//    var profile_image = String()
//    var profile_image_url : URL?{
//        return URL(string: self.profile_image)
//    }
//    var remaining_days =  Int()
//    var trips =  Int()
//    var remaining_trips =  Int()
//    var start_date =  String()
//    var end_date =  String()
//    var earnable_amount =  String()
//    var status = ReferalStatus.pending
//    var defaultStatus = ReferalStatus.pending
//    var getDesciptionText : String {
//        var text = "\(self.remaining_days) "
//        text.append(self.remaining_days == 1 ? LangCommon.dayLeftToComplete  : LangCommon.daysLeftToComplete )
//        text.append(" \(self.remaining_trips) ")
//        text.append(self.remaining_trips == 1 ? LangCommon.trip :LangCommon.trips)
//        return text
//    }
//    init(withJSON json : JSON){
//        self.id = json.int("id")
//        self.name = json.string("name")
//        self.profile_image = json.string("profile_image")
//        self.days = json.int("days")
//        self.remaining_days = json.int("remaining_days")
//        self.trips = json.int("jobs")
//        self.remaining_trips = json.int("remaining_jobs")
//        self.start_date = json.string("start_date")
//        self.earnable_amount = json.string("earnable_amount")
//        self.end_date = json.string("end_date")
//        self.status = ReferalStatus.init(rawValue: json.string("status")) ?? .pending
//        self.defaultStatus = ReferalStatus.init(rawValue: json.string("default_status")) ?? .pending
//    }
//}
