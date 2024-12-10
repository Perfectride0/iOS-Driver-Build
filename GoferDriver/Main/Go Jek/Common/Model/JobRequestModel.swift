//
//  JobRequestModel.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 11/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
class NotificationRequest {
    var requestId,userName,address,rating,startTime,endTime,serviceName,bid_amount,price_modal,date,time: String
    var requestTime,minBid : Int
    var isCompleted: Bool
    init(_ json : JSON){
        self.requestId = json.string("request_id")
        self.userName = json.string("user_name")
        self.address = json.string("address")
        self.rating = json.string("rating")
        self.requestTime = json.int("requestTime")
        self.startTime = json.string("startTime")
        self.endTime =  json.string("endTime")
        self.serviceName = json.string("serviceName")
        self.bid_amount = json.string("bid_amount")
        self.price_modal = json.string("price_modal")
        self.minBid = json.int("min_bid")
        self.date = json.string("date")
        self.time = json.string("time")
        self.isCompleted = false
    }
    init(requestId: String,userName: String,address: String,rating: String,requestTime: Int,startTime: String,endTime: String,serviceName: String,bid_amount: String,price_modal: String,minBid: Int,date: String,time: String){
        self.requestId = requestId
        self.userName = userName
        self.address = address
        self.rating = rating
        self.requestTime = requestTime
        self.startTime = startTime
        self.endTime =  endTime
        self.isCompleted = false
        self.serviceName = serviceName
        self.bid_amount = bid_amount
        self.price_modal = price_modal
        self.minBid = minBid
        self.date = date
        self.time = time
    }
}

//class NotificationRequest :Codable{
//    var requestId,userName,address,rating,startTime,endTime,serviceName: String
//    var requestTime : Int
//    var isCompleted: Bool
//    enum CodingKeys: String, CodingKey {
//        case requestId = "request_id"
//        case userName = "user_name"
//        case address = "address"
//        case rating = "rating"
//        case requestTime = "requestTime"
//        case startTime = "startTime"
//        case endTime =  "endTime"
//        case serviceName = "serviceName"
//
//    }
//    required init(from decoder : Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.requestId = container.safeDecodeValue(forKey: .requestId)
//        self.userName = container.safeDecodeValue(forKey: .userName)
//        self.address = container.safeDecodeValue(forKey: .address)
//        self.rating = container.safeDecodeValue(forKey: .rating)
//        self.requestTime = container.safeDecodeValue(forKey: .requestTime)
//        self.startTime = container.safeDecodeValue(forKey: .startTime)
//        self.endTime = container.safeDecodeValue(forKey: .endTime)
//        self.endTime = container.safeDecodeValue(forKey: .endTime)
//        self.serviceName = container.safeDecodeValue(forKey: .serviceName)
//        self.isCompleted = false
//    }
//}

class JobRequestModel: Codable {
    let statusCode, statusMessage, userName, address, rating,serviceName: String
    let priceType : PriceType
    let service: [RequestedServiceModel]
    let startTime,endTime : String
    let requestId: Int
    var requestTime: Int
    var isCompleted : Bool = false
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case userName = "user_name"
        case address, service, rating
        case priceType = "price_type"
        case startTime = "id"
        case endTime = "end_time"
        case serviceName = "service_name"
        case requestId = "request_id"
        case requestTime = "request_time"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let service = try? container.decodeIfPresent([RequestedServiceModel].self, forKey: .service)
        self.service = service ?? [RequestedServiceModel]()
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.userName = container.safeDecodeValue(forKey: .userName)
        self.address = container.safeDecodeValue(forKey: .address)
        self.rating = container.safeDecodeValue(forKey: .rating)
        let priceTypee = try? container.decodeIfPresent(PriceType.self, forKey: .priceType)
        self.priceType = priceTypee ?? PriceType.Hourly
        self.startTime = container.safeDecodeValue(forKey: .startTime)
        self.endTime = container.safeDecodeValue(forKey: .endTime)
        self.serviceName = container.safeDecodeValue(forKey: .serviceName)
        self.requestId = container.safeDecodeValue(forKey: .requestId)
        self.requestTime = container.safeDecodeValue(forKey: .requestTime)
    }
}

// MARK: - Service
class RequestedService: Codable {
    let id: Int
    let name: String
    let quantity: Int
    let instruction: String
    init(id: Int, name: String, quantity: Int,instruction: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.instruction = instruction
    }
     required init(from decoder : Decoder) throws{
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = container.safeDecodeValue(forKey: .id)
            self.name = container.safeDecodeValue(forKey: .name)
            self.quantity = container.safeDecodeValue(forKey: .quantity)
            self.instruction = container.safeDecodeValue(forKey: .instruction)
    }
}

class MultiRequest: Codable {
    let statusCode, statusMessage: String
    let requests: [JobRequestModel]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case requests
    }
    required init(from decoder : Decoder) throws{
           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.statusCode = container.safeDecodeValue(forKey: .statusCode)
           self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
            let request = try? container.decodeIfPresent([JobRequestModel].self, forKey: .requests)
            self.requests = request ?? [JobRequestModel]()
   }
    
}



