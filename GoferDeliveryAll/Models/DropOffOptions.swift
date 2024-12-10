//
//  DropOffOptions.swift
//  GoferGroceryDriver
//
//  Created by trioangle on 04/04/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation

// MARK: - DropOptionHolder
class DropOptionHolder: Codable {
    let statusMessage, statusCode: String
    let issues: [OrderDeliveryIssue]
    let dropoffOptions: [DropoffOption]

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
        case issues
        case dropoffOptions = "dropoff_options"
    }

    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.issues = try container.decodeIfPresent([OrderDeliveryIssue].self, forKey: .issues) ?? []
        self.dropoffOptions = try container.decodeIfPresent([DropoffOption].self, forKey: .dropoffOptions) ?? []
    }
}

// MARK: - DropoffOption
class DropoffOption: Codable {
    let id: Int
    let name: String
    
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
    }
}
extension DropoffOption : Equatable{
    static func == (lhs: DropoffOption, rhs: DropoffOption) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
// MARK: - Issue
class OrderDeliveryIssue: Codable {
    let id: Int
    let issue: String

    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.issue = container.safeDecodeValue(forKey: .issue)
    }
}
extension OrderDeliveryIssue : Equatable{
    static func == (lhs: OrderDeliveryIssue, rhs: OrderDeliveryIssue) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
