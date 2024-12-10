//
//  DyamicVehicleModel.swift
//  GoferDriver
//
//  Created by trioangle on 10/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
//class DynamicVehicleModel {
//
//
//    var id : Int
//    var status : String
//    var vehicleImage : String
//    private(set) var isActive : Bool
//    var isCurrentOrDefault = false
//    var make : VehicleMake
//    var year : String
//    var licenseNumber : String
//    var color : String
//
//    var type : String
//    var vehicleTypes = [DynamicVehicleTypeModel]()
//    var documents = [DynamicDocumentModel]()
//
//    var isNewVehicle = false
//    var requestOptions = [Requests]()
//    var name : String{
//        return self.make.item.name + " " + (self.make.selectedModel?.name ?? "")
//    }
//    init(){
//        self.isNewVehicle = true
//        self.id = 0
//        self.status = ""
//        self.type = ""
//
//        self.isActive = false
//
//        self.make = VehicleMake()
//        self.year = ""
//        self.licenseNumber = ""
//        self.color = ""
//
//        self.vehicleImage = ""
//
//
//        self.vehicleTypes = [DynamicVehicleTypeModel]()
//        self.documents = [DynamicDocumentModel]()
//        self.requestOptions = [Requests]()
//    }
//    init(copy : DynamicVehicleModel){
//        self.id = copy.id
//        self.status = copy.status
//        self.type = copy.type
//
//        self.isActive = copy.isActive
//
//        self.make = VehicleMake(copy: copy.make)
//        self.year = copy.year
//        self.licenseNumber = copy.licenseNumber
//        self.color = copy.color
//
//        self.vehicleImage = copy.vehicleImage
//        self.isCurrentOrDefault = copy.isCurrentOrDefault
//
//        self.vehicleTypes = copy.vehicleTypes.compactMap({DynamicVehicleTypeModel(copy: $0)})
//        self.documents = copy.documents
//        self.requestOptions = copy.requestOptions
//    }
//    init(_ json : JSON){
//        self.id = json.int("id")
//        self.status = json.string("status")
//        self.type = json.string("type")
//
//        self.isActive = json.bool("is_active")
//
//        self.make = VehicleMake(json.json("make"))//json.string("make")
//        self.make.selectedModel = Item(json.json("model"))
//        self.year = json.string("year")
//        self.licenseNumber = json.string("vehicle_number")
//        self.color = json.string("color")
//
//        self.vehicleImage = json.string("vehicleImageURL")
//        self.isCurrentOrDefault = json.string("is_default") == "1"
//
//        self.vehicleTypes = json.array("vehicle_types")
//            .compactMap({DynamicVehicleTypeModel($0)})
//        self.documents = json.array("vechile_documents")
//            .compactMap({DynamicDocumentModel($0)})
//        self.requestOptions = json.array("request_options").compactMap({Requests($0)})
//    }
//
//    func allFieldEntered(make: VehicleMake?) -> Bool {
//        return !self.year.isEmpty && !self.color.isEmpty && (make?.isVehicleNumber ?? true) ? !self.licenseNumber.isEmpty : true
//    }
//
//    var islicenseNumberEntered : Bool {
//        return !self.licenseNumber.isEmpty
//    }
//
//    var allFieldEntered : Bool{
//        return !self.year.isEmpty &&
//            !self.color.isEmpty
//    }
//    func hasAnyUpdated(value : DynamicVehicleModel) -> Bool{
//
//        let existingID = self.vehicleTypes.filter{($0.isChecked)}.compactMap({$0.id}).sorted()
//        let newID = value.vehicleTypes.filter{($0.isChecked)}.compactMap({$0.id}).sorted()
//
//        let noUpdates = self.id == value.id &&
//            self.make.item.id == value.make.item.id &&
//            self.make.selectedModel?.id == value.make.selectedModel?.id &&
//            self.year == value.year &&
//            self.color == value.color &&
//            existingID == newID
//
//
//        return !noUpdates
//
//
//    }
//}


class UpdateVehicleModel : Codable {
    let statusCode : Int
    let statusMessage : String
    let vehicleDetails : [DynamicVehicleModel]
    
    enum CodingKeys : String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case vehicleDetails = "vehicles_details"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.vehicleDetails = try container.decodeIfPresent([DynamicVehicleModel].self,
                                                            forKey: .vehicleDetails) ?? []
    }
}



class DynamicVehicleModel: Codable {
    var status, vehicleImage, year, licenseNumber, color, type, name,is_default: String
    var id:Int
    private(set) var isActive : Int
    var isCurrentOrDefault, isNewVehicle:Bool
    var make:Make?
    var vehicleTypes : [DynamicVehicleTypeModel]
    var documents : [DynamicDocumentModel]
    var requestOptions : [RequestOption]
    var model:Model?
    

    init(copy: DynamicVehicleModel) {
        self.status = copy.status
        self.vehicleImage = copy.vehicleImage
        self.year = copy.year
        self.is_default = copy.is_default
        self.isCurrentOrDefault = copy.isCurrentOrDefault
        self.isActive = copy.isActive
        self.isNewVehicle = copy.isNewVehicle
        self.licenseNumber = copy.licenseNumber
        self.color = copy.color
        self.type = copy.type
        self.id = copy.id
        self.make = copy.make
        self.documents = copy.documents
        self.vehicleTypes = copy.vehicleTypes
        self.requestOptions = copy.requestOptions
        self.model = copy.model
        self.name = copy.name
        self.make?.selectedModel = copy.make?.selectedModel
    }

    init() {
        self.status = ""
        self.vehicleImage = ""
        self.year = ""
        self.is_default = ""
        self.isCurrentOrDefault = false
        self.isActive = 0
        self.isNewVehicle = true
        self.licenseNumber = ""
        self.color = ""
        self.type = ""
        self.id = 0
        self.make = Make()
        self.documents = []
        self.vehicleTypes = []
        self.requestOptions = []
        self.model = nil
        self.name = ""
        self.make?.selectedModel = nil
    }
    
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case vehicleImage = "vehicleImageURL"
        case year = "year"
        case licenseNumber = "vehicle_number"
        case color = "color"
        case type = "type"
        case isActive = "is_active"
        case is_default = "is_default"
        case isNewVehicle = "currency_list"
        case make = "make"
        case vehicleTypes = "vehicle_types"
        case documents = "vechile_documents"
        case requestOptions = "request_options"
        case id = "id"
        case name = "vehicle_name"
        case model = "model"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = container.safeDecodeValue(forKey: .status)
        self.vehicleImage = container.safeDecodeValue(forKey: .vehicleImage)
        self.year = container.safeDecodeValue(forKey: .year)
        self.is_default = container.safeDecodeValue(forKey: .is_default)
        self.isCurrentOrDefault = self.is_default == "1" ? true : false
        self.isActive = container.safeDecodeValue(forKey: .isActive)
        self.isNewVehicle = container.safeDecodeValue(forKey: .isNewVehicle)
        self.licenseNumber = container.safeDecodeValue(forKey: .licenseNumber)
        self.color = container.safeDecodeValue(forKey: .color)
        self.type = container.safeDecodeValue(forKey: .type)
        self.id = container.safeDecodeValue(forKey: .id)

        self.make = try container.decodeIfPresent(Make.self, forKey: .make)

        let document = try? container.decodeIfPresent([DynamicDocumentModel].self, forKey: .documents)
        self.documents = document ?? []
 
        let vehicleType = try? container.decodeIfPresent([DynamicVehicleTypeModel].self, forKey: .vehicleTypes)
        self.vehicleTypes = vehicleType ?? []
        
        let req_options = try? container.decodeIfPresent([RequestOption].self, forKey: .requestOptions)
        self.requestOptions = req_options ?? []
        
        self.model = try container.decodeIfPresent(Model.self, forKey: .model)

        self.name  = container.safeDecodeValue(forKey: .name)
        self.make?.selectedModel = self.model
    }
    
    func allFieldEntered(make: Make?) -> Bool {
          return !self.year.isEmpty && !self.color.isEmpty && (make?.isVehicleNumber ?? true) ? !self.licenseNumber.isEmpty : true
      }
  
      var islicenseNumberEntered : Bool {
          return !self.licenseNumber.isEmpty
      }
  
      var allFieldEntered : Bool{
          return !self.year.isEmpty &&
              !self.color.isEmpty
      }
      func hasAnyUpdated(value : DynamicVehicleModel) -> Bool{
  
          let existingID = self.vehicleTypes.filter{($0.isChecked)}.compactMap({$0.id}).sorted()
          let newID = value.vehicleTypes.filter{($0.isChecked)}.compactMap({$0.id}).sorted()
  
          let noUpdates = self.id == value.id &&
              (self.make?.id == value.make?.id) &&
          (self.make?.selectedModel?.id == value.make?.selectedModel?.id) &&
              self.year == value.year &&
              self.color == value.color &&
              existingID == newID
  
  
          return !noUpdates
  
  
      }
        
}

extension DynamicVehicleModel : Equatable{
    static func == (lhs: DynamicVehicleModel, rhs: DynamicVehicleModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
