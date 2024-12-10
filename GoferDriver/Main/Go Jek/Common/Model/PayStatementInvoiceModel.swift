//
//  PayStatementInvoiceModel.swift
//  GoferDriver
//
//  Created by trioangle on 23/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
// MARK: - Welcome
//class DeteailStatementModel{
//    let statusCode, statusMessage: String
//    let totalPage,currentPage : Int
//    let driverStatement: DriverStatement
//    var statement : [Statement]
//    var dailyStatement : [DailyStatement]
//
//    init(_ json: JSON){
//        self.statusCode = json.string("status_code")
//        self.statusMessage = json.string("status_message")
//        self.statement = json.array("statement").compactMap({Statement($0)})
//        self.driverStatement = DriverStatement(json.json("provider_statement"))
//        self.dailyStatement = json.array("daily_statement").compactMap({DailyStatement($0)})
//        self.currentPage = json.int("current_page")
//        self.totalPage = json.int("total_page")
//    }
//}


class DeteailStatementModel : Codable
{
    let statusCode, statusMessage: String
    let totalPage,currentPage : Int
    let driverStatement: DriverStatement?
    var statement : [Statement]
    var dailyStatement : [DailyStatement]
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case totalPage = "total_page"
        case statusMessage = "status_message"
        case currentPage = "current_page"
        case driverStatement = "provider_statement"
        case statement = "statement"
        case dailyStatement = "daily_statement"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.totalPage = container.safeDecodeValue(forKey: .totalPage)
        self.currentPage = container.safeDecodeValue(forKey: .currentPage)


        let cont = try? container.decodeIfPresent([Statement].self, forKey: .statement)
        self.statement = cont ?? [Statement]()
        let dailyStat = try? container.decodeIfPresent([DailyStatement].self, forKey: .dailyStatement)
        self.dailyStatement = dailyStat ?? [DailyStatement]()
        self.driverStatement = try? container.decodeIfPresent(DriverStatement.self, forKey: .driverStatement)
    }
}


// MARK: - DriverStatement
//class DriverStatement{
//    let header: Header
//    let title: String
//    var content = [PayStatementInvoice]()
//    var footer = [Header]()
//
//    init(_ json: JSON) {
//        self.content = json.array("content").compactMap({PayStatementInvoice($0)})
//        self.footer = json.array("footer").compactMap({Header($0)})
//        self.header = Header(json.json("header"))
//        self.title = json.string("title")
//
//    }
//}

class DriverStatement : Codable
{
    let header: Header?
    let title: String?
    var content : [PayStatementInvoice]
    var footer : [Footer]
    enum CodingKeys: String, CodingKey {
        case header = "header"
        case title = "title"
        case content = "content"
        case footer = "footer"

    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = container.safeDecodeValue(forKey: .title)
        let cont = try? container.decodeIfPresent([PayStatementInvoice].self, forKey: .content)
        self.content = cont ?? [PayStatementInvoice]()
        let foot = try? container.decodeIfPresent([Footer].self, forKey: .footer)
        self.footer = foot ?? [Footer]()
        self.header = try? container.decodeIfPresent(Header.self, forKey: .header)
    }
}


//class Header {
//    let key, value: String
//    init(_ json:JSON) {
//        self.key = json.string("key")
//        self.value = json.string("value")
//    }
//}


class Header : Codable
{
    let key, value: String
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = container.safeDecodeValue(forKey: .key)
        self.value = container.safeDecodeValue(forKey: .value)
    }
}

class Footer : Codable
{
    let key:String
    let value: Int
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = container.safeDecodeValue(forKey: .key)
        self.value = container.safeDecodeValue(forKey: .value)
    }
}



// MARK: - Content
//class PayStatementInvoice {
//    let key, value: String
//    let bar: Bool
//    let colour, tooltip: String
//
//    init(_ json: JSON) {
//        self.key = json.string("key")
//        self.value = json.string("value")
//        self.bar = json.bool("bar")
//        self.colour = json.string("colour")
//        self.tooltip = json.string("tooltip")
//    }
//}

class PayStatementInvoice : Codable
{
        let key, value: String
        let bar: Bool
        let colour, tooltip: String
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
        case bar = "bar"
        case colour = "colour"
        case tooltip = "tooltip"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = container.safeDecodeValue(forKey: .key)
        self.value = container.safeDecodeValue(forKey: .value)
        self.bar = container.safeDecodeValue(forKey: .bar)
        self.colour = container.safeDecodeValue(forKey: .colour)
        self.tooltip = container.safeDecodeValue(forKey: .tooltip)

    }
}

// MARK: - Statement
//class Statement {
//    let totalFare, driverEarning, day, format: String
//    let date : String
//
//    init(_ json: JSON) {
//        self.totalFare = json.string("total_fare")
//        self.driverEarning = json.string("provider_earning")
//        self.format = json.string("format")
//        self.date = json.string("date")
//        self.day = json.string("day")
//
//    }
//}

class Statement : Codable
{
    let totalFare, driverEarning, day, format: String
    let date : String
    enum CodingKeys: String, CodingKey {
        case totalFare = "total_fare"
        case driverEarning = "provider_earning"
        case day = "day"
        case format = "format"
        case date = "date"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalFare = container.safeDecodeValue(forKey: .totalFare)
        self.driverEarning = container.safeDecodeValue(forKey: .driverEarning)
        self.day = container.safeDecodeValue(forKey: .day)
        self.format = container.safeDecodeValue(forKey: .format)
        self.date = container.safeDecodeValue(forKey: .date)

    }
}


//class DailyStatement : Statement{
//
//    let id:Int
//    let time: String
//    override init(_ json: JSON) {
//
//        self.time = json.string("time")
//        self.id = json.int("id")
//        super.init(json)
//    }
//}

class DailyStatement : Codable
{
    let id:Int
    let time: String
    let driverEarning:String
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case time = "time"
        case driverEarning = "provider_earning"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.time = container.safeDecodeValue(forKey: .time)
        self.driverEarning = container.safeDecodeValue(forKey: .driverEarning)
    }
}

//class TripWeekDetailsModel{
//    let date: String
//    let year: String
//    let total_fare: String
//    let driver_payout: String
//    let week:  String
//    init(_ json: JSON){
//        self.date = json.string("date")
//        self.week = json.string("week")
//        self.year = json.string("year")
//        self.total_fare = json.string("total_fare")
//        self.driver_payout = json.string("provider_earnings")
//    }
//}


class TripWeekDetailsModel : Codable
{
    let date: String
    let year: String
    let total_fare: String
    let driver_payout: String
    let week:  String
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case year = "year"
        case total_fare = "total_fare"
        case driver_payout = "provider_earnings"
        case week = "week"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = container.safeDecodeValue(forKey: .date)
        self.year = container.safeDecodeValue(forKey: .year)
        self.total_fare = container.safeDecodeValue(forKey: .total_fare)
        self.driver_payout = container.safeDecodeValue(forKey: .driver_payout)
        self.week = container.safeDecodeValue(forKey: .week)
    }
}


class WeeklyJobModel : Codable
{
    let status_message: String
    let status_code: String
    let currency_code: String
    let symbol: String
    let current_page, total_page:  Int
    let jobweekdetails :[TripWeekDetailsModel]
    enum CodingKeys: String, CodingKey {
        case status_message = "status_message"
        case status_code = "status_code"
        case currency_code = "currency_code"
        case symbol = "symbol"
        case current_page = "current_page"
        case total_page = "total_page"
        case jobweekdetails = "job_week_details"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.currency_code = container.safeDecodeValue(forKey: .currency_code)
        self.symbol = container.safeDecodeValue(forKey: .symbol)
        self.current_page = container.safeDecodeValue(forKey: .current_page)
        self.total_page = container.safeDecodeValue(forKey: .total_page)
        let jobWeek = try? container.decodeIfPresent([TripWeekDetailsModel].self, forKey: .jobweekdetails)
        self.jobweekdetails = jobWeek ?? [TripWeekDetailsModel]()
    }
}
