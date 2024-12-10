//
//  PayoutItemModel.swift
//  GoferDriver
//
//  Created by trioangle on 10/02/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

// MARK: - PayoutMethod
class PayoutModel: Codable {
    let statusCode: String
    let statusMessage: String
    let payoutMethods: [PayoutItemModel]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case payoutMethods = "payout_methods"
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        let items = try? container.decode([PayoutItemModel].self, forKey: .payoutMethods)
            self.payoutMethods = items ?? [PayoutItemModel]()
    }
    init(statusCode: String, statusMessage: String, payoutMethods: [PayoutItemModel]) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.payoutMethods = payoutMethods
    }
}
class PayoutItemModel: Codable {
    let id: Int
    let key: String
    let isDefault: Bool
    let value: String
    let icon : String
    let payoutData: PayoutData?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case key = "key"
        case isDefault = "is_default"
        case icon = "icon"
        case value = "value"
        case payoutData = "payout_data"
    }


    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.key = container.safeDecodeValue(forKey: .key)
        self.value = container.safeDecodeValue(forKey: .value)
        self.id = container.safeDecodeValue(forKey: .id)
        self.isDefault = container.safeDecodeValue(forKey: .isDefault)
        self.icon = container.safeDecodeValue(forKey: .icon)
        self.payoutData = try? container.decode(PayoutData.self, forKey: .payoutData)
    }
}

// MARK: - PayoutData
class PayoutData: Codable {
    let address1: String
    let address2: String
    let city: String
    let state: String
    let country: String
    let postalCode: String
    let paypalEmail: String
    let currencyCode: String
    let routingNumber: String
    let accountNumber: String
    let holderName: String
    let bankName: String
    let branchName: String
    let branchCode: String
    let bankLocation: String
    let ssnLast4 : String
    let document : String
    let phoneNumber : String

    enum CodingKeys: String, CodingKey {
        case address1 = "address1"
        case address2 = "address2"
        case city = "city"
        case state = "state"
        case country = "country"
        case postalCode = "postal_code"
        case paypalEmail = "paypal_email"
        case currencyCode = "currency_code"
        case routingNumber = "routing_number"
        case accountNumber = "account_number"
        case holderName = "holder_name"
        case bankName = "bank_name"
        case branchName = "branch_name"
        case branchCode = "branch_code"
        case bankLocation = "bank_location"
        case ssnLast4 = "ssn_last_4"
        case document = "document"
        case phoneNumber = "phone_number"
    }

    required init(from decoder : Decoder) throws{
          
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address1 = container.safeDecodeValue(forKey: .address1)
        self.address2 = container.safeDecodeValue(forKey: .address2)
        self.city = container.safeDecodeValue(forKey: .city)
        self.state = container.safeDecodeValue(forKey: .state)
        self.country = container.safeDecodeValue(forKey: .country)
        self.postalCode = container.safeDecodeValue(forKey: .postalCode)
        self.paypalEmail = container.safeDecodeValue(forKey: .paypalEmail)
        self.currencyCode = container.safeDecodeValue(forKey: .currencyCode)
        self.routingNumber = container.safeDecodeValue(forKey: .routingNumber)
        self.accountNumber = container.safeDecodeValue(forKey: .accountNumber)
        self.holderName = container.safeDecodeValue(forKey: .holderName)
        self.bankName = container.safeDecodeValue(forKey: .bankName)
        self.branchName = container.safeDecodeValue(forKey: .branchName)
        self.branchCode = container.safeDecodeValue(forKey: .branchCode)
        self.bankLocation = container.safeDecodeValue(forKey: .bankLocation)
        self.ssnLast4 = container.safeDecodeValue(forKey: .ssnLast4)
        self.document = container.safeDecodeValue(forKey: .document)
        self.phoneNumber = container.safeDecodeValue(forKey: .phoneNumber)
    }
}
