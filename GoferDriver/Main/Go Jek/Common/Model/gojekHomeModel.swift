//
//  gojekHomeModel.swift
//  GoferHandy
//
//  Created by Trioangle on 28/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

//------------------------------------
// MARK: - GojeckServiceHome
//------------------------------------

class GojeckServiceHome : Codable {
    let statusCode, statusMessage: String
    let service: [GojekService]
    let banner: [GojekBanner]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case service, banner
    }

    init(statusCode: String,
         statusMessage: String,
         service: [GojekService],
         banner: [GojekBanner]) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.service = service
        self.banner = banner
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        let service = try container.decodeIfPresent([GojekService].self, forKey: .service)
        self.service = service ?? []
        let banner = try container.decodeIfPresent([GojekBanner].self, forKey: .banner)
        self.banner = banner ?? []
    }
}

//------------------------------------
// MARK: - Banner
//------------------------------------

class GojekBanner: Codable {
    let title, bannerDescription: String
    let image: String
    let serviceID: Int
    let backgroundColorCode, textColorCode: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case bannerDescription = "description"
        case image
        case serviceID = "service_id"
        case backgroundColorCode = "background_color_code"
        case textColorCode = "text_color_code"
    }
    
    init(title: String,
         bannerDescription: String,
         image: String,
         serviceID: Int,
         backgroundColorCode: String,
         textColorCode: String) {
        self.title = title
        self.bannerDescription = bannerDescription
        self.image = image
        self.serviceID = serviceID
        self.backgroundColorCode = backgroundColorCode
        self.textColorCode = textColorCode
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = container.safeDecodeValue(forKey: .title)
        self.bannerDescription = container.safeDecodeValue(forKey: .bannerDescription)
        self.image = container.safeDecodeValue(forKey: .image)
        self.serviceID  = container.safeDecodeValue(forKey: .serviceID)
        self.backgroundColorCode = container.safeDecodeValue(forKey: .backgroundColorCode)
        self.textColorCode = container.safeDecodeValue(forKey: .textColorCode)
    }
}

//------------------------------------
// MARK: - Service
//------------------------------------

class GojekService: Codable {
    let id : Int
    let name: String
    let serviceDescription: String
    let image: String
    let icon : String
    let isAvailable : Bool
    let locationError : String
    let selectedBusinessId : Bool
    var isHeatMapSelected : Bool
    // Handy Splitup Start
    var busineesType : BusinessType
    var service : [ServiceTypes]     //Gofer splitup start [Remove service types]

    // Handy Splitup End
    
    enum CodingKeys: String, CodingKey {
        case name
        case serviceDescription = "description"
        case image
        case id = "service_id"
        case icon
        case isAvailable = "is_available"
        case locationError = "location_error"
        case selectedBusinessId = "selected_business_id"
        case isHeatMapSelected = "is_heat"
        case service
    }
    
    init(name: String,
         serviceDescription: String,
         image: String,
         icon : String,
         id : Int,
         isAvailable : Bool,
         locationError : String,
         selectedBusinessId: Bool,
         // Handy Splitup Start
         busineesType: BusinessType,
         // Handy Splitup End
         isHeatMapSelected: Bool,service :[ServiceTypes]) {
        self.name = name
        self.serviceDescription = serviceDescription
        self.image = image
        self.icon = icon
        self.id = id
        self.locationError = locationError
        self.isAvailable = isAvailable
        self.selectedBusinessId = selectedBusinessId
        // Handy Splitup Start
        self.busineesType = busineesType
        // Handy Splitup End
        self.isHeatMapSelected = isHeatMapSelected
        self.service = service
    }
    
//    init(json: JSON) {
//        self.id = json.int("service_id")
//        self.name = json.string("name")
//        self.image = json.string("image")
//        self.icon = json.string("icon")
//        self.locationError = json.string("location_error")
//        self.serviceDescription = json.string("description")
//        self.isAvailable = json.bool("is_available")
//        self.selectedBusinessId = json.bool("selected_business_id")
//        self.busineesType = BusinessType.init(rawValue: self.id) ?? .Gojek
//        self.isHeatMapSelected = json.bool("is_heat")
//        self.service = json.array("service").compactMap({ServiceTypes(json: $0)})
//    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.serviceDescription = container.safeDecodeValue(forKey: .serviceDescription)
        self.icon  = container.safeDecodeValue(forKey: .icon)
        self.image = container.safeDecodeValue(forKey: .image)
        self.name = container.safeDecodeValue(forKey: .name)
        self.locationError = container.safeDecodeValue(forKey: .locationError)
        self.isAvailable = container.safeDecodeValue(forKey: .isAvailable)
        self.selectedBusinessId = container.safeDecodeValue(forKey: .selectedBusinessId)
        // Handy Splitup Start
        self.busineesType = BusinessType.init(rawValue: self.id) ?? .Gojek
        // Handy Splitup End
        self.isHeatMapSelected = container.safeDecodeValue(forKey: .isHeatMapSelected)
        let services = try? container.decode([ServiceTypes].self, forKey: .service)
      self.service = services ?? [ServiceTypes]()
    }
}
class ServiceTypes : Codable {
    var id : Int
    var name : String
    var isHeatMapSelected : Bool
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isHeatMapSelected = "is_heat"
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.isHeatMapSelected = container.safeDecodeValue(forKey: .isHeatMapSelected)
    }
//    init(json: JSON) {
//        self.id = json.int("id")
//        self.name = json.string("name")
//        self.isHeatMapSelected = json.bool("is_heat")
//    }
}
