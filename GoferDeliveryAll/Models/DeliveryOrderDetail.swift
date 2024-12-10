//
//  OrderDetailModel.swift
//  GoferGroceryDriver
//
//  Created by trioangle on 03/04/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import GoogleMaps

// MARK: - Welcome
class OrderDetailHolder: Codable {
    let statusMessage, statusCode: String
    let orderDetails: DeliveryOrderDetail?

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
        case orderDetails = "order_details"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.orderDetails = try container.decodeIfPresent(DeliveryOrderDetail.self, forKey: .orderDetails)
    }
}

// MARK: - OrderDetails
class DeliveryOrderDetail:Codable{
    let orderID: Int
    let requestID: Int
    let eaterName, eaterMobileNumber,eaterCountryCode: String
    let eaterThumbImage: String
    let storeName, storeMobileNumber, storeCountryCode: String
    let storeThumbImage: String
    let vehicleType, pickupLocation: String
    let dropLocation : String
    let dropLatitude, dropLongitude, pickupLatitude, pickupLongitude: Double
    var statusCode: String
    let collectCash, deliveryNote: String
    let flatNumber : String
    let multipleDelivery : String
    let orderItems: [OrderItem]
    let groupId : String
    let contactless_delivery : String
    let userID : Int
    let businessId : Int
    let userRating : Int
    let storeID : Int
    let storeRating : String
    
    lazy var foodItems : [FoodItem] = {
        var foodItems = [FoodItem]()
        let currency : String = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        for item in self.orderItems{
            foodItems.append(FoodItem(
                counter: "\(item.quantity)×",
                name: item.name,
                isMainItem: true))
            
            for subItem in item.modifiers{
                var name = ""
                if let count = Double(subItem.count),
                    count > 1{
                    name.append("\(Int(count))× ")
                }
                name.append("\(subItem.name)")
                if let price = Double(subItem.price),
                    price > 0{
                    name.append(" ( \(currency)\(subItem.price) )")
                }
                foodItems.append(FoodItem(
                    counter: "",
                    name: name,
                    isMainItem: false))
            }
        }
        return foodItems
    }()
    enum CodingKeys: String, CodingKey {
        case multipleDelivery = "multiple_delivery"
        case orderID = "order_id"
        case requestID = "request_id"
        case eaterName = "user_name"
        case userRating = "user_rating"
        case userID = "user_id"
        case businessId = "business_id"
        case eaterMobileNumber = "user_mobile_number"
        case eaterCountryCode = "user_country_code"
        case eaterThumbImage = "user_thumb_image"
        case storeName = "store_name"
        case storeMobileNumber = "store_mobile_number"
        case storeCountryCode = "store_country_code"
        case storeThumbImage = "store_thumb_image"
        case vehicleType = "vehicle_type"
        case pickupLocation = "pickup_location"
        case pickupLatitude = "pickup_latitude"
        case pickupLongitude = "pickup_longitude"
        case dropLocation = "drop_location"
        case dropLatitude = "drop_latitude"
        case dropLongitude = "drop_longitude"
        case statusCode = "status"
        case collectCash = "collect_cash"
        case deliveryNote = "delivery_note"
        case orderItems = "order_items"
        case flatNumber = "flat_number"
        case groupId = "group_id"
        case contactless_delivery = "contactless_delivery"
        case storeID = "store_user_id"
        case storeRating = "store_rating"
    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.multipleDelivery = container.safeDecodeValue(forKey: .multipleDelivery)
        self.orderID = container.safeDecodeValue(forKey: .orderID)
        self.requestID = container.safeDecodeValue(forKey: .requestID)
        self.eaterName = container.safeDecodeValue(forKey: .eaterName)
        self.eaterMobileNumber = container.safeDecodeValue(forKey: .eaterMobileNumber)
        self.eaterThumbImage = container.safeDecodeValue(forKey: .eaterThumbImage)
        self.storeName = container.safeDecodeValue(forKey: .storeName)
        self.storeMobileNumber = container.safeDecodeValue(forKey: .storeMobileNumber)
        self.storeCountryCode = container.safeDecodeValue(forKey: .storeCountryCode)
        self.eaterCountryCode = container.safeDecodeValue(forKey: .eaterCountryCode)
        self.storeThumbImage = container.safeDecodeValue(forKey: .storeThumbImage)
        self.vehicleType = container.safeDecodeValue(forKey: .vehicleType)
        self.pickupLocation = container.safeDecodeValue(forKey: .pickupLocation)
        self.pickupLatitude = container.safeDecodeValue(forKey: .pickupLatitude)
        self.pickupLongitude = container.safeDecodeValue(forKey: .pickupLongitude)
        self.dropLocation = container.safeDecodeValue(forKey: .dropLocation)
        self.dropLatitude = container.safeDecodeValue(forKey: .dropLatitude)
        self.dropLongitude = container.safeDecodeValue(forKey: .dropLongitude)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.collectCash = container.safeDecodeValue(forKey: .collectCash)
        self.deliveryNote = container.safeDecodeValue(forKey: .deliveryNote)
        self.flatNumber = container.safeDecodeValue(forKey: .flatNumber)
        self.orderItems = try container.decodeIfPresent([OrderItem].self, forKey: .orderItems) ?? []
        self.groupId = container.safeDecodeValue(forKey: .groupId)
        self.contactless_delivery = container.safeDecodeValue(forKey: .contactless_delivery)
        self.userID = container.safeDecodeValue(forKey: .userID)
        self.businessId = container.safeDecodeValue(forKey: .businessId)
        self.userRating = container.safeDecodeValue(forKey: .userRating)
        self.storeID = container.safeDecodeValue(forKey: .storeID)
        self.storeRating = container.safeDecodeValue(forKey: .storeRating)
        print("items:\(self.foodItems.count)")
    }
    
    func getStatus() -> TripStatus{
        return .init(fromDeliveryCode: self.statusCode)
    }
    func setStatus(_ status : TripStatus){
        self.statusCode = status.rawValue
    }
   
    /**     destination to which driver should travel
     - Author: Abishek Robin
     - NOTE: return drop location if trip is started else pickup
     */
    
    var getDestination : CLLocation{
        if self.getStatus().isDelOrderStarted{
            
            return CLLocation(latitude: self.dropLatitude, longitude: self.dropLongitude)
        }else{
            if multipleDelivery == "Yes"{
                return CLLocation(latitude: self.dropLatitude, longitude: self.dropLongitude)
            }else{
                return CLLocation(latitude: self.pickupLatitude, longitude: self.pickupLongitude)
            }
            
        }
    }
    var getTargetUser : (name : String,image : String,mobile: String,country: String,address : String){
        if self.getStatus().isDelOrderStarted{
            return (self.eaterName,self.eaterThumbImage,self.eaterMobileNumber,self.eaterCountryCode,address: self.dropLocation)
        }else{
            if multipleDelivery == "Yes"{
                return (self.eaterName,self.eaterThumbImage,self.eaterMobileNumber,self.eaterCountryCode,address: self.dropLocation)
            }else{
                return (self.storeName,self.storeThumbImage,self.storeMobileNumber,self.storeCountryCode,address: self.pickupLocation)
            }
            
        }
    }
    
    var getTargetUserDetails : (name : String,image : String,mobile: String,country: String,address : String){
        if self.getStatus().isDelOrderStarted{
            return (self.eaterName,self.eaterThumbImage,self.eaterMobileNumber,self.eaterCountryCode,address: self.dropLocation)
        }else{
            return (self.storeName,self.storeThumbImage,self.storeMobileNumber,self.storeCountryCode,address: self.pickupLocation)
        }
    }
    var getPickupDetails : (String){
        if self.getStatus().isDelOrderStarted{
            let Name = "DropOff"
            return Name
        }else{
            if multipleDelivery == "Yes"{
                let Name = "DropOff"
                return Name
            }else{
                let Name = "PickUp"
                return Name
            }
            
        }
    }
    var getDestinationMarkerImage : String{
           if self.getStatus().isDelOrderStarted{
               return "dropoff_icon_pin.png"
           }else{
               return "pickup_icon.png"
           }
       }
    func storeUserInfo(_ val : Bool){
//        let preference = UserDefaults.standard
        if val{
            UserDefaults.set(self.eaterName, for: .eater_user_name)
            UserDefaults.set(self.eaterThumbImage, for: .eater_image)
            UserDefaults.set(self.storeName, for: .store_user_name)
            UserDefaults.set(self.storeThumbImage , for: .store_image)
        }else{
            UserDefaults.removeValue(for: .eater_user_name)
            UserDefaults.removeValue(for: .eater_image)
            UserDefaults.removeValue(for: .store_user_name)
            UserDefaults.removeValue(for: .store_image)
        }
    }
}

// MARK: - OrderItem
class OrderItem: Codable {
    let id: Int
    let name: String
    let quantity: Int
    let modifiers : [Modifier]
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.quantity = container.safeDecodeValue(forKey: .quantity)
        self.modifiers = try container.decodeIfPresent([Modifier].self,
                                                   forKey: .modifiers) ?? []
    }
}
class Modifier : Codable{
    let id: Int
    let name,price,count: String
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.count = container.safeDecodeValue(forKey: .count)
        self.price = container.safeDecodeValue(forKey: .price)
        self.name = container.safeDecodeValue(forKey: .name)
    }
}
class FoodItem {
    let isMainItem : Bool
    let counter,name : String
    init(counter : String,name : String,isMainItem :Bool){
        self.isMainItem = isMainItem
        self.counter = counter
        self.name = name
    }
}
