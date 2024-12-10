//
//  WayPoint.swift
//  GoferDriver
//
//  Created by trioangle on 23/09/22.
//  Copyright © 2022 Vignesh Palanivel. All rights reserved.
//

import Foundation
import SwiftUI

class WayPoint: Codable,Equatable{
    
    static func == (lhs: WayPoint, rhs: WayPoint) -> Bool {
        lhs.id == rhs.id &&
        lhs.distance == rhs.distance &&
        lhs.duration == rhs.duration &&
        lhs.isCompleted == rhs.isCompleted &&
        lhs.isCalculated == rhs.isCalculated &&
        lhs.start == rhs.start &&
        lhs.end == rhs.end
    }
    var isStarted : Int
    let start : DropLocationModel
    let end : DropLocationModel
    let distance : String
    let duration : String
    var isCompleted : Int
    var isCalculated = Bool()
    var id =  Int()
    var pickuplocation : String
    var pickuplat : String
    var pickuplng : String
    var droplocation : String
    var droplat : String
    var droplng : String
    
    enum CodingKeys: String, CodingKey {
        case distance = "distance"
        case duration = "duration"
        case isCompleted = "is_completed"
        case isCalculated = "is_calculate"
        case id = "id"
        case start
        case end
        case pickuplocation = "pickup_location"
        case pickuplat = "pickup_lat"
        case pickuplng = "pickup_lng"
        case droplocation = "drop_location"
        case droplat = "drop_lat"
        case droplng = "drop_lng"
        case isStarted = "is_started"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = container.safeDecodeValue(forKey: .id)
        self.distance = container.safeDecodeValue(forKey: .distance)
        self.duration = container.safeDecodeValue(forKey: .duration)
        self.isCompleted = container.safeDecodeValue(forKey: .isCompleted)
        self.isCalculated = container.safeDecodeValue(forKey: .isCalculated)
        self.pickuplat = container.safeDecodeValue(forKey: .pickuplat)
        self.pickuplng = container.safeDecodeValue(forKey: .pickuplng)
        self.pickuplocation = container.safeDecodeValue(forKey: .pickuplocation)
        self.droplat = container.safeDecodeValue(forKey: .droplat)
        self.droplng = container.safeDecodeValue(forKey: .droplng)
        self.droplocation = container.safeDecodeValue(forKey: .droplocation)
        self.start = DropLocationModel.init(location: self.pickuplocation, lat: pickuplat, lng: pickuplng, isCompleted: self.isCompleted)
        self.end = DropLocationModel.init(location: self.droplocation, lat: droplat, lng: droplng, isCompleted: self.isCompleted)
        self.isStarted = container.safeDecodeValue(forKey: .isStarted)
    }
    
    init(_ json : JSON){
        self.start = DropLocationModel(APIjson: json, isForPickUP: true)
        self.end = DropLocationModel(APIjson: json, isForPickUP: false)
        self.distance = json.string("distance")
        self.duration = json.string("duration")
        self.isCompleted = json.int("is_completed")
        self.isCalculated = json.bool("is_calculate")
        self.id = json.int("id")
        self.pickuplng = json.string("pickup_lng")
        self.pickuplat = json.string("pickup_lat")
        self.pickuplocation = json.string("pickup_location")
        self.droplng = json.string("drop_lng")
        self.droplat = json.string("drop_lat")
        self.droplocation = json.string("drop_location")
        self.isStarted = json.int("is_started")

    }
    
    init(start : DropLocationModel, end : DropLocationModel, distance : String, duration : String){
        self.start = start
        self.end = end
        self.distance = distance
        self.duration = duration
        self.isCompleted = 0
        self.isStarted = 0
        self.pickuplng = start.longitude ?? ""
        self.pickuplat = start.latitude ?? ""
        self.pickuplocation = start.location ?? ""
        self.droplng = end.longitude ?? ""
        self.droplat = end.latitude ?? ""
        self.droplocation = end.location ?? ""
        
    }
    
    func getJSONString()-> String?{
        var json = JSON()
        json["pickup_lat"] = self.start.coords.latitude
        json["pickup_lng"] = self.start.coords.longitude
        json["pickup_location"] = self.start.location!
        json["drop_lat"] = self.end.coords.latitude
        json["drop_lng"] = self.end.coords.longitude
        json["drop_location"] = self.end.location!
        json["distance"] = self.distance
        json["duration"] = self.duration
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print("∂",jsonString)
                return jsonString
            }else{
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
}

extension WayPoint {
    
}
