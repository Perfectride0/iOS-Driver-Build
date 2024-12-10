//
//  HeatMapData.swift
//  GoferDriver
//
//  Created by trioangle on 01/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import CoreData
import GoogleMaps
import UIKit

class HeatMapDataModel : Codable {
    let status_code, status_message: String
    let today_amount,today_job: Double?
    let heat_map_data: [HeatMapData]
    let service : [GojekService]
    let last2Hours : [CLLocation]

    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case status_message = "status_message"
        case today_amount
        case heat_map_data = "heat_map_data"
        case service = "service"
        case today_job = "today_job"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.today_amount = container.safeDecodeValue(forKey: .today_amount)
        self.today_job = container.safeDecodeValue(forKey: .today_job)
        let heat_Map = try container.decodeIfPresent([HeatMapData].self, forKey: .heat_map_data)
        self.heat_map_data = heat_Map ?? []
        let serviceData = try container.decodeIfPresent([GojekService].self, forKey: .service)
        self.service = serviceData ?? []
        self.last2Hours = self.heat_map_data.compactMap({
            CLLocation(latitude: ($0.latitude).toDouble(),
                       longitude: ($0.longitude).toDouble())
            
        })
        // Handy Splitup Start
        AppWebConstants.selectedBusinessType.removeAll()
        AppWebConstants.selectedBusinessType = service.filter({$0.selectedBusinessId})
        // Handy Splitup End
        
    }
    
    func getTileLayer() -> GMUHeatmapTileLayer{
        let tileDataLayer = GMUHeatmapTileLayer()
        
        tileDataLayer.radius = 50
        tileDataLayer.maximumZoomIntensity = 5
        tileDataLayer.minimumZoomIntensity = 1
        
        var weightLocationList = [GMUWeightedLatLng]()
        for loc in last2Hours{
            weightLocationList.append(GMUWeightedLatLng(coordinate: loc.coordinate,
                                                        intensity: 5))
        }
        
      
        let gradientColors : [UIColor] = [
                        UIColor.systemYellow,//(hex: "2D882D"),//green
                        UIColor.yellow,//(hex:"FF3201"),//orange
                        UIColor.orange,//(hex: "FF4C43"),//red
                        UIColor.red,
                        UIColor.systemRed//(hex: "BD0000")//darkred
        ]
//        let gradientColors = [
//            UIColor.init(red: 102.0, green: 225.0, blue:0 , alpha: 0),//(hex: "2D882D"),//green
//            UIColor.init(red:225/3 * 2 , green:225.0 , blue: 102.0, alpha:0 ),//(hex:"FF3201"),//orange
//            UIColor.init(red: 247.0, green: 109.0, blue: 2.0, alpha: 0),//(hex: "FF4C43"),//red
//            UIColor.init(red: 255, green: 0, blue: 0, alpha: 0),//(hex: "BD0000")//darkred
//            UIColor.init(red: 255, green: 0, blue: 0, alpha: 0)
//        ]
        let gradientStartPoints : [NSNumber] = [
            0.1,
            0.3,
            0.5,
            0.75,
            1.0
            ]

        tileDataLayer.weightedData = weightLocationList
        tileDataLayer.gradient = GMUGradient(colors: gradientColors,
                                             startPoints: gradientStartPoints,
                                             colorMapSize: 256)

        tileDataLayer.opacity = 1.0
        
        return tileDataLayer
    }
}

class HeatMapData : Codable {
    let latitude : String
    let longitude : String
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = container.safeDecodeValue(forKey: .latitude)
        self.longitude = container.safeDecodeValue(forKey: .longitude)
    }
    

}
