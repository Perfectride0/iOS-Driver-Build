//
//  DynamicVehicleTypeModel.swift
//  GoferDriver
//
//  Created by trioangle on 10/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation


//class DynamicVehicleTypeModel {
//    var id : Int
//    var type : String
//    var isChecked : Bool
//    var isPool : Bool
//    var locations : String
//
//    init(_ json : JSON){
//        self.id = json.int("id")
//        self.type = json.string("type")
//        self.isChecked = json.bool("is_checked")
//        self.isPool = json.bool("isPooled")
//        self.locations = json.string("location")
//    }
//
//    init(copy : DynamicVehicleTypeModel){
//        self.id = copy.id
//        self.type = copy.type
//        self.isChecked = copy.isChecked
//        self.isPool = copy.isPool
//        self.locations = copy.locations
//    }
//}


class DynamicVehicleTypeModel : Codable
{
    let id:Int
    let type,locations : String
    let isChecked, isPool:Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case locations = "location"
        case isChecked = "is_checked"
        case isPool = "isPooled"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.type = container.safeDecodeValue(forKey: .type)
        self.locations = container.safeDecodeValue(forKey: .locations)
        self.isChecked = container.safeDecodeValue(forKey: .isChecked)
        self.isPool = container.safeDecodeValue(forKey: .isPool)
    }
    
    
    //MARK Properties
//    var base_fare : String = ""
//    var capacity : String = ""
//    var car_name : String = ""
//    var car_description : String = ""
//    var car_id : String = ""
//    var min_fare : String = ""
//    var per_km : String = ""
//    var per_min : String = ""
//    var status : String = ""
//
//    //MARK: Inits
//    func initCarDetails(responseDict: NSDictionary) -> Any
//    {
//        let json = responseDict as! JSON
//
//        base_fare = json.string("base_fare")
//        capacity = json.string("capacity")
//        car_name = json.string("car_name")
//        car_description = json.string("description")
//        car_id = json.string("id")
//        min_fare = json.string("min_fare")
//        per_km = json.string("per_km")
//        per_min = json.string("per_min")
//        status = json.string("status")
//        return self
//    }

}
