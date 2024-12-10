//
//  TripParticularModel.swift
//  GoferHandyProvider
//
//  Created by trioangle on 24/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
struct TripParticularModel : Codable {
    let status_code : String?
    let status_message : String?
    let trip_details : Trip_details?
    let invoice : [Invoice]

    enum CodingKeys: String, CodingKey {

        case status_code = "status_code"
        case status_message = "status_message"
        case trip_details = "trip_details"
        case invoice = "invoice"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(String.self, forKey: .status_code)
        status_message = try values.decodeIfPresent(String.self, forKey: .status_message)
        trip_details = try values.decodeIfPresent(Trip_details.self, forKey: .trip_details)
        let invoice = try values.decodeIfPresent([Invoice].self, forKey: .invoice)
        self.invoice = invoice ?? [Invoice(JSON())]
    }

}

struct Trip_details : Codable {
    let order_id : Int?
    let is_KM: Bool
    let total_fare : String?
    let status : Int?
    let vehicle_name : String?
    let map_image : String?
    let map_image_dark:String?
    let trip_date : String?
    let pickup_latitude : String?
    let pickup_longitude : String?
    let pickup_location : String?
    let drop_location : String?
    let drop_latitude : String?
    let drop_longitude : String?
    let duration_hour : String?
    let duration_min : String?
    let distance : String?
    let pickup_fare : String?
    let drop_fare : String?
    let driver_payout : String?
    let trip_amount : String?
    let delivery_fee : String?
    let owe_amount : String?
    let admin_payout : String?
    let distance_fare : String?
    let cash_collected : String?
    let driver_penality : String?
    let applied_penality : String?
    let cancel_payout : String?
    let applied_owe : String?
    let notes : String?
    let tips : String?
    let paymentMode : String
    let firstDriver : String
    let promoAdded : Bool
    let walletSelected : Bool
    var paymentResult : String {
        get {
            var str = paymentMode
            if walletSelected { str += (promoAdded ? " , " : " & ") + LangCommon.wallet }
            if promoAdded { str +=  " & "  + (LangCommon.promo.isEmpty ? "Promo" : LangCommon.promo) }
            return str
        }
    }
    
    enum CodingKeys: String, CodingKey {

        case order_id = "order_id"
        case is_KM = "is_km"
        case total_fare = "total_fare"
        case status = "status"
        case vehicle_name = "vehicle_name"
        case map_image = "map_image"
        case trip_date = "trip_date"
        case pickup_latitude = "pickup_latitude"
        case pickup_longitude = "pickup_longitude"
        case pickup_location = "pickup_location"
        case drop_location = "drop_location"
        case drop_latitude = "drop_latitude"
        case drop_longitude = "drop_longitude"
        case duration_hour = "duration_hour"
        case duration_min = "duration_min"
        case distance = "distance"
        case pickup_fare = "pickup_fare"
        case drop_fare = "drop_fare"
        case driver_payout = "driver_payout"
        case trip_amount = "trip_amount"
        case delivery_fee = "delivery_fee"
        case owe_amount = "owe_amount"
        case admin_payout = "admin_payout"
        case distance_fare = "distance_fare"
        case cash_collected = "cash_collected"
        case driver_penality = "driver_penality"
        case applied_penality = "applied_penality"
        case cancel_payout = "cancel_payout"
        case applied_owe = "applied_owe"
        case notes = "notes"
        case tips = "tips"
        case map_image_dark = "map_image_dark"
        case paymentMode = "payment_mode"
        case firstDriver = "first_driver"
        case promoAdded = "promo_added"
        case walletSelected = "wallet_selected"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        self.total_fare = try values.decodeIfPresent(String.self, forKey: .total_fare)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.vehicle_name = try values.decodeIfPresent(String.self, forKey: .vehicle_name)
        self.map_image = try values.decodeIfPresent(String.self, forKey: .map_image)
        self.trip_date = try values.decodeIfPresent(String.self, forKey: .trip_date)
        self.pickup_latitude = try values.decodeIfPresent(String.self, forKey: .pickup_latitude)
        self.pickup_longitude = try values.decodeIfPresent(String.self, forKey: .pickup_longitude)
        self.pickup_location = try values.decodeIfPresent(String.self, forKey: .pickup_location)
        self.drop_location = try values.decodeIfPresent(String.self, forKey: .drop_location)
        self.drop_latitude = try values.decodeIfPresent(String.self, forKey: .drop_latitude)
        self.drop_longitude = try values.decodeIfPresent(String.self, forKey: .drop_longitude)
        self.duration_hour = try values.decodeIfPresent(String.self, forKey: .duration_hour)
        self.duration_min = try values.decodeIfPresent(String.self, forKey: .duration_min)
        self.distance = try values.decodeIfPresent(String.self, forKey: .distance)
        self.pickup_fare = try values.decodeIfPresent(String.self, forKey: .pickup_fare)
        self.drop_fare = try values.decodeIfPresent(String.self, forKey: .drop_fare)
        self.driver_payout = try values.decodeIfPresent(String.self, forKey: .driver_payout)
        self.trip_amount = try values.decodeIfPresent(String.self, forKey: .trip_amount)
        self.delivery_fee = try values.decodeIfPresent(String.self, forKey: .delivery_fee)
        self.owe_amount = try values.decodeIfPresent(String.self, forKey: .owe_amount)
        self.admin_payout = try values.decodeIfPresent(String.self, forKey: .admin_payout)
        self.distance_fare = try values.decodeIfPresent(String.self, forKey: .distance_fare)
        self.cash_collected = try values.decodeIfPresent(String.self, forKey: .cash_collected)
        self.driver_penality = try values.decodeIfPresent(String.self, forKey: .driver_penality)
        self.applied_penality = try values.decodeIfPresent(String.self, forKey: .applied_penality)
        self.cancel_payout = try values.decodeIfPresent(String.self, forKey: .cancel_payout)
        self.applied_owe = try values.decodeIfPresent(String.self, forKey: .applied_owe)
        self.notes = try values.decodeIfPresent(String.self, forKey: .notes)
        self.tips = try values.decodeIfPresent(String.self, forKey: .tips)
        self.map_image_dark = try values.decodeIfPresent(String.self, forKey: .map_image_dark)
        self.paymentMode = values.safeDecodeValue(forKey: .paymentMode)
        self.firstDriver = values.safeDecodeValue(forKey: .firstDriver)
        self.promoAdded = values.safeDecodeValue(forKey: .promoAdded)
        self.walletSelected = values.safeDecodeValue(forKey: .walletSelected)
        self.is_KM = values.safeDecodeValue(forKey: .is_KM)
    }

}
