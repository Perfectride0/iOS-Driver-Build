//
//  VehilcleDesciption.swift
//  GoferDriver
//
//  Created by trioangle on 10/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

// MARK: - VehicleDescription
class VehicleDescription: Codable {
    let statusCode, statusMessage: String
    var startYear : Int = 1975
    let make: [Make]
    let vehicleTypes: [VehicleType]
    let requestOptions: [RequestOption]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case make
        case vehicleTypes = "vehicle_types"
        case requestOptions = "request_options"
    }

    init(copy: VehicleDescription) {
        self.statusCode = copy.statusCode
        self.statusMessage = copy.statusMessage
        self.make = copy.make
        self.vehicleTypes = copy.vehicleTypes
        self.requestOptions = copy.requestOptions
    }
    
    init(statusCode: String, statusMessage: String, make: [Make], vehicleTypes: [VehicleType], requestOptions: [RequestOption]) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.make = make
        self.vehicleTypes = vehicleTypes
        self.requestOptions = requestOptions
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.make = try container.decodeIfPresent([Make].self,
                                                  forKey: .make) ?? []
        self.vehicleTypes = try container.decodeIfPresent([VehicleType].self,
                                                          forKey: .vehicleTypes) ?? []
        self.requestOptions = try container.decodeIfPresent([RequestOption].self,
                                                            forKey: .requestOptions) ?? []
    }
}

// MARK: - Make
class Make: Codable {
    let id: Int
    let name: String
    let isVehicleNumber: Bool
    let model: [Model]
    var selectedModel : Model? = nil

    enum CodingKeys: String, CodingKey {
        case id, name
        case isVehicleNumber = "is_vehicle_number"
        case model
    }

    init() {
        self.id = 0
        self.name = ""
        self.isVehicleNumber = false
        self.model = []
    }
    
    init(id: Int, name: String, isVehicleNumber: Bool, model: [Model]) {
        self.id = id
        self.name = name
        self.isVehicleNumber = isVehicleNumber
        self.model = model
    }
    
    init(copy: Make) {
        self.id = copy.id
        self.name = copy.name
        self.isVehicleNumber = copy.isVehicleNumber
        self.model = copy.model
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.isVehicleNumber = container.safeDecodeValue(forKey: .isVehicleNumber)
        self.model = try container.decodeIfPresent([Model].self,
                                                   forKey: .model) ?? []
    }
}

// MARK: - Model
class Model: Codable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(copy: Model) {
        self.id = copy.id
        self.name = copy.name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
    }
}

// MARK: - RequestOption
class RequestOption: Codable {
    let id: Int
    let name: String
    var isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case id, name , isSelected
    }
    
    init(copy: RequestOption) {
        self.id = copy.id
        self.name = copy.name
        self.isSelected = copy.isSelected
    }
    
    init(id: Int, name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.isSelected = container.safeDecodeValue(forKey: .isSelected)
    }
}

// MARK: - VehicleType
class VehicleType: Codable {
    let id: Int
    let type: String
    let businessID: Int
    let service_id: Int
    let service_name: String
    let location: String
    var isSelected = false
    var isTitle = false
    // Handy Splitup Start
    var businessType : BusinessType = BusinessType.Services
    // Handy Splitup End
    enum CodingKeys: String, CodingKey {
        case id, type
        case businessID = "business_id"
        case location
        case service_id
        case service_name
    }

    init(copy: VehicleType) {
        self.id = copy.id
        self.type = copy.type
        self.businessID = copy.businessID
        self.location = copy.location
        // Handy Splitup Start
        self.businessType = copy.businessType
        // Handy Splitup End
        self.service_id = copy.service_id
        self.service_name = copy.service_name
    }
    
    init(id: Int, type: String, businessID: Int, location: String,service_id: Int,service_name: String, isTitle: Bool = false) {
        self.id = id
        self.type = type
        self.businessID = businessID
        self.location = location
        self.service_id = service_id
        self.service_name = service_name
        // Handy Splitup Start
        self.businessType = BusinessType.init(rawValue: self.businessID) ?? .Services
        self.isTitle = isTitle
        // Handy Splitup End
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.type = container.safeDecodeValue(forKey: .type)
        self.businessID = container.safeDecodeValue(forKey: .businessID)
        self.location = container.safeDecodeValue(forKey: .location)
        self.service_id = container.safeDecodeValue(forKey: .service_id)
        // Handy Splitup Start
        self.businessType = BusinessType.init(rawValue: self.businessID) ?? .Services
        self.service_name = container.safeDecodeValue(forKey: .service_name)
        // Handy Splitup End
    }
}


//import Foundation
//
//
//class VehicleDescription {
//    var startYear : Int
//    var make = [VehicleMake]()
//    var vehicleTypes = [VehicleType]()
//    var requestOptions = [Requests]()
//
//    init(_ json : JSON){
//        self.startYear = 1975//json.int("year")
//        self.make = json.array("make").compactMap({VehicleMake($0)})
//        self.vehicleTypes = json.array("vehicle_types").compactMap({VehicleType($0)})
//        self.requestOptions = json.array("request_options").compactMap({Requests($0)})
//    }
//}
//
//class VehicleMake {
//    var item = Item()
//    var models = [Item]()
//    var selectedModel : Item? = nil
//    var isVehicleNumber = Bool()
//    init(){}
//    init(copy : VehicleMake){
//        self.item = Item(copy: copy.item)
//        self.models = copy.models.compactMap({Item(copy: $0)})
//        if let selected = copy.selectedModel{
//            self.selectedModel = Item(copy: selected)
//        }
//        self.isVehicleNumber = copy.isVehicleNumber
//    }
//    init(_ json : JSON) {
//        self.item = Item(json)
//        self.models = json.array("model").compactMap({Item($0)})
//        self.isVehicleNumber = json.bool("is_vehicle_number")
//    }
//}
//class Item{
//    var id : Int = 0
//    var name : String = ""
//    init(){}
//    init(copy : Item){
//        self.id = copy.id
//        self.name = copy.name
//    }
//    init(_ json : JSON){
//        self.id = json.int("id")
//        self.name = json.string("name")
//    }
//}
//class VehicleType {
//    var id : Int = 0
//    var type : String = ""
//    var location : String = ""
//    var isSelected = false
//    var businessID : Int = 0
//    var businessType : BusinessType = BusinessType.Services
//
//    init(_ json : JSON){
//        self.id = json.int("id")
//        self.type = json.string("type")
//        self.location = json.string("location")
//        self.businessID = json.int("business_id")
//        self.businessType = BusinessType.init(rawValue: self.businessID) ?? .Services
//    }
//}
//
//class Requests {
//    var id:Int = 0
//    var name:String = ""
//    var isSelected:Bool = false
//    init(copy : Requests){
//        self.id = copy.id
//        self.name = copy.name
//        self.isSelected = copy.isSelected
//    }
//    init(_ json : JSON) {
//        self.id = json.int("id")
//        self.name = json.string("name")
//        self.isSelected = json.bool("isSelected")
//    }
//}
