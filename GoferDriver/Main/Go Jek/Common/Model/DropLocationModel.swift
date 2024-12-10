//
//  DropLocationModel.swift
//  GoferDriver
//
//  Created by trioangle on 23/09/22.
//  Copyright © 2022 Vignesh Palanivel. All rights reserved.
//

import Foundation

class DropLocationModel:Codable,Equatable{
    
    var latitude : String?
    var longitude : String?
    var location : String?
    var isEdgePoint = Bool()
    var isCompleted = Int()
    
    
    var coords : CLLocationCoordinate2D{
        guard let lat = Double(self.latitude ?? ""),
            let long = Double(self.longitude ?? "") else{
                return CLLocationCoordinate2D()
        }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    var getLoc : CLLocation{
        let coords = self.coords
        return CLLocation(latitude: coords.latitude, longitude: coords.longitude)
    }
//    lazy var view : DropLocationView = {
//        let dropView = DropLocationView.createView()
//        dropView.initView(withDropLoc: self)
//        return dropView
//    }()
    enum CodingKeys: String, CodingKey {
        case latitude = "drop_lat"
        case longitude = "drop_lng"
        case location = "drop_location"
        case isEdgePoint = "isEdgePoint"
        case isCompleted = "isCompleted"
       
    }
    init(json: JSON){
        self.latitude = json.string("latitude")
        self.longitude = json.string("longitude")
        self.location = json.string("location")
        self.isEdgePoint = json.bool("isEdgePoint")
        self.isCompleted = json.int("isCompleted")

    }
    init(){
        self.latitude = ""
        self.longitude = ""
        self.location = ""
        self.isEdgePoint = false
        self.isCompleted = 0

    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = container.safeDecodeValue(forKey: .latitude)
        self.longitude = container.safeDecodeValue(forKey: .longitude)
        self.location = container.safeDecodeValue(forKey: .location)
        self.isEdgePoint = container.safeDecodeValue(forKey: .isEdgePoint)
        self.isCompleted = container.safeDecodeValue(forKey: .isCompleted)
        
        
    }
    init(latitude : String,longitude : String,location : String){
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
    }
    init(location : String?){
        self.location = location
    }
    init(googleJSON json : JSON,isForStart start : Bool ){
        let coords = json.json("\(start ? "start" : "end")_location")
        self.location = json.string("\(start ? "start" : "end")_address")
        self.latitude =  coords.string("lat")
        self.longitude =  coords.string("lng")
    }
    init(APIjson json : JSON,isForPickUP pickUp : Bool){
        let prefix = pickUp ? "pickup_" : "drop_"
        self.location = json.string("\(prefix)location")
        self.latitude =  json.string("\(prefix)lat")
        self.longitude =  json.string("\(prefix)lng")
        self.isEdgePoint = false
        self.isCompleted = json.int("is_completed")
    }
    init(location: String, lat: String, lng: String,isCompleted:Int){
        self.location = location
        self.latitude = lat
        self.longitude = lng
        self.isEdgePoint = false
        self.isCompleted = isCompleted
    }
    func getEdgePointStatus() -> Bool{
        return self.isEdgePoint
    }
    func setAsEdgePoint(_ isEdgePoint : Bool){
        self.isEdgePoint = isEdgePoint
//        self.view.setAsEdgePoint(isEdgePoint)
    }
    func update(location : String){
        self.location = location
//        self.view.setLocationName(location)
    }
    func update(latitude : String,longitude : String){
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
extension DropLocationModel : Hashable{
    var hashValue: Int {
        return Int(self.coords.latitude) ^ Int(self.coords.longitude) ^ (self.location?.count ?? 23)
    }
    static func == (lhs: DropLocationModel, rhs: DropLocationModel) -> Bool {
        return lhs.location != rhs.location
    }
    
    
}

extension String{
    var decode2JSON : JSON?{
        guard let data = self.data(using: .utf8,
                                            allowLossyConversion: false) else {
                                                return nil
                                                
        }
        do{
            if let json = try JSONSerialization.jsonObject(with: data,
                                                           options: .mutableContainers) as? JSON{
               return json
            }else{
                return nil
            }
        }catch{
            return nil
        }
    }
}
