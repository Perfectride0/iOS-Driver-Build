//
//  DriverModel.swift
//  GoferHandyProvider
//
//  Created by trioangle on 28/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

struct DriverModel : Codable {
    let status_message : String?
    let status_code : String?
    let driver_accepted_orders : [Driver_accepted_orders]?

    enum CodingKeys: String, CodingKey {

        case status_message = "status_message"
        case status_code = "status_code"
        case driver_accepted_orders = "driver_accepted_orders"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_message =  values.safeDecodeValue( forKey: .status_message)
        status_code =  values.safeDecodeValue( forKey: .status_code)
        driver_accepted_orders = try values.decodeIfPresent([Driver_accepted_orders].self, forKey: .driver_accepted_orders)
    }

}

struct Driver_accepted_orders : Codable {
    let id : Int?
    let order_id : Int?
    let vehicle_id : String?
    let driver_id : Int?
    let pickup_latitude : String?
    let pickup_longitude : String?
    let drop_latitude : String?
    let drop_longitude : String?
    let pickup_location : String?
    let drop_location : String?
    let trip_path : String?
    let group_id : String?
    let status : Int?
    let orders_list : String?
    let deleted_at : String?
    let created_at : String?
    let updated_at : String?
    let distance : String?
     let eater_name : String?
     let estimatedDist : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case order_id = "order_id"
        case vehicle_id = "vehicle_id"
        case driver_id = "driver_id"
        case pickup_latitude = "pickup_latitude"
        case pickup_longitude = "pickup_longitude"
        case drop_latitude = "drop_latitude"
        case drop_longitude = "drop_longitude"
        case pickup_location = "pickup_location"
        case drop_location = "drop_location"
        case trip_path = "trip_path"
        case group_id = "group_id"
        case status = "status"
        case orders_list = "orders_list"
        case deleted_at = "deleted_at"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case distance = "distance"
        case eater_name = "user_name"
        case estimatedDist = "estimated_distance"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id =  values.safeDecodeValue( forKey: .id)
        order_id =  values.safeDecodeValue( forKey: .order_id)
        vehicle_id =  values.safeDecodeValue( forKey: .vehicle_id)
        driver_id =  values.safeDecodeValue( forKey: .driver_id)
        pickup_latitude =  values.safeDecodeValue( forKey: .pickup_latitude)
        pickup_longitude =  values.safeDecodeValue( forKey: .pickup_longitude)
        drop_latitude =  values.safeDecodeValue( forKey: .drop_latitude)
        drop_longitude =  values.safeDecodeValue( forKey: .drop_longitude)
        pickup_location =  values.safeDecodeValue( forKey: .pickup_location)
        drop_location =  values.safeDecodeValue( forKey: .drop_location)
        trip_path =  values.safeDecodeValue( forKey: .trip_path)
        group_id =  values.safeDecodeValue( forKey: .group_id)
        status =  values.safeDecodeValue( forKey: .status)
        orders_list =  values.safeDecodeValue( forKey: .orders_list)
        deleted_at =  values.safeDecodeValue( forKey: .deleted_at)
        created_at =  values.safeDecodeValue( forKey: .created_at)
        updated_at =  values.safeDecodeValue( forKey: .updated_at)
        eater_name =  values.safeDecodeValue( forKey: .eater_name)
        distance =  values.safeDecodeValue( forKey: .distance)
        estimatedDist =  values.safeDecodeValue( forKey: .estimatedDist)
        
    }

}
