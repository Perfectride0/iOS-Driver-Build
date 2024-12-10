//
//  OrderDetails.swift
//  GoferHandyProvider
//
//  Created by trioangle on 22/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation


struct RequestRecieved : Codable{
    
    
    let status_code : String?
    let status_message : String?
    let store_name : String?
    let total_order : Int?
    var isFood : Bool = false
    private let is_food : String
    let remaining_order_count : Int?
    let order_details : [Order_details]?
    let accepted_status : String?
    
    enum CodingKeys: String, CodingKey {
        case is_food = "is_food"
        case status_code = "status_code"
        case status_message = "status_message"
        case store_name = "store_name"
        case total_order = "total_order"
        case remaining_order_count = "remaining_order_count"
        case order_details = "order_details"
        case accepted_status = "accepted_status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code =  values.safeDecodeValue(forKey: .status_code)
        status_message =  values.safeDecodeValue(forKey: .status_message)
        store_name =  values.safeDecodeValue(forKey: .store_name)
        total_order = values.safeDecodeValue(forKey: .total_order)
        remaining_order_count = values.safeDecodeValue(forKey: .remaining_order_count)
        let orderDet = try? values.decodeIfPresent([Order_details].self, forKey: .order_details)
        self.order_details = orderDet ?? [Order_details]()
        accepted_status = values.safeDecodeValue(forKey: .accepted_status)
        self.is_food = values.safeDecodeValue(forKey: .is_food)
        self.isFood = self.is_food.lowercased() == "yes"
    }
}

struct Order_details : Codable {
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
    let orders_list : String?
    let distance : String?
    let status : Int?
    let deleted_at : String?
    let created_at : String?
    let updated_at : String?
    let user_name : String?
    let estimated_distance : String?
    let order_item : [Order_item]?
    let is_picked : String?
    let trip_status : Int?

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
        case orders_list = "orders_list"
        case distance = "distance"
        case status = "status"
        case deleted_at = "deleted_at"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case user_name = "eater_name"
        case estimated_distance = "estimated_distance"
        case order_item = "order_item"
        case is_picked = "is_picked"
        case trip_status = "trip_status"
    }

     init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.safeDecodeValue(forKey: .id)
        order_id = container.safeDecodeValue(forKey: .order_id)
        vehicle_id = container.safeDecodeValue(forKey: .vehicle_id)
        driver_id = container.safeDecodeValue(forKey: .driver_id)
        pickup_latitude = container.safeDecodeValue(forKey: .pickup_latitude)
        pickup_longitude = container.safeDecodeValue(forKey: .pickup_longitude)
        drop_latitude = container.safeDecodeValue(forKey: .drop_latitude)
        drop_longitude = container.safeDecodeValue(forKey: .drop_longitude)
        pickup_location = container.safeDecodeValue(forKey: .pickup_location)
        drop_location = container.safeDecodeValue(forKey: .drop_location)
        trip_path = container.safeDecodeValue(forKey: .trip_path)
        group_id = container.safeDecodeValue(forKey: .group_id)
        orders_list = container.safeDecodeValue(forKey: .orders_list)
        distance = container.safeDecodeValue(forKey: .distance)
        status = container.safeDecodeValue(forKey: .status)
        deleted_at = container.safeDecodeValue(forKey: .deleted_at)
        created_at = container.safeDecodeValue(forKey: .created_at)
        updated_at = container.safeDecodeValue(forKey: .updated_at)
        user_name = container.safeDecodeValue(forKey: .user_name)
        estimated_distance = container.safeDecodeValue(forKey: .estimated_distance)
        let order_item = try container.decodeIfPresent([Order_item].self, forKey: .order_item)
        self.order_item = order_item ?? [Order_item]()
        is_picked = container.safeDecodeValue(forKey: .is_picked)
        trip_status = container.safeDecodeValue(forKey: .trip_status)
    }

}

struct Modifiers : Codable {
    let id : Int?
    let count : Int?
    let price : String?
    let name : String?
    let tax : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case count = "count"
        case price = "price"
        case name = "name"
        case tax = "tax"
    }

      init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.safeDecodeValue(forKey: .id)
        count = container.safeDecodeValue(forKey: .count)
        price = container.safeDecodeValue(forKey: .price)
        name = container.safeDecodeValue(forKey: .name)
        tax = container.safeDecodeValue(forKey: .tax)
    }

}

struct Order_item : Codable {
    let id : Int?
    let name : String?
    let quantity : Int?
    let isVeg : Bool
    private let itemType : Int
    let modifiers : [Modifiers]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case itemType = "item_type"
        case quantity = "quantity"
        case modifiers = "modifiers"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.quantity = container.safeDecodeValue(forKey: .quantity)
        self.itemType = container.safeDecodeValue(forKey: .itemType)
        self.isVeg = self.itemType == 0
        let modifiers = try container.decodeIfPresent([Modifiers].self, forKey: .modifiers)
        self.modifiers = modifiers ?? [Modifiers]()
    }

}
