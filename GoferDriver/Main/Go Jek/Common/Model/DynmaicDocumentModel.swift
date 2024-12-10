//
//  DynmaicDocumentModel.swift
//  GoferDriver
//
//  Created by trioangle on 10/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation



class DynamicDocumentModel: Codable {
    var name : String
    var urlString : String
    var id : Int
    var status : Int
    var expiryRequired = false
    var exipryDate : String
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case urlString = "document"
        case id = "id"
        case status = "status"
        case expiryRequired = "expiry_required"
        case exipryDate = "expired_date"

    }

    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = container.safeDecodeValue(forKey: .name)
        self.urlString = container.safeDecodeValue(forKey: .urlString)
        self.id = container.safeDecodeValue(forKey: .id)
        self.status = container.safeDecodeValue(forKey: .status)
        self.expiryRequired = container.safeDecodeValue(forKey: .expiryRequired)
        self.exipryDate = container.safeDecodeValue(forKey: .exipryDate)
    }
}

//class DynamicDocumentModel {
//    var name : String
//    var urlString : String
//    var id : Int
//    var status : Int
//    var expiryRequired = false
//    var exipryDate : String
//    init(_ json : JSON){
//        self.name = json.string("name")
//        self.urlString = json.string("document")
//        self.id = json.int("id")
//        self.status = json.int("status")
//        self.expiryRequired = json.bool("expiry_required")
//        self.exipryDate = json.string("expired_date")
//    }
//}
//
