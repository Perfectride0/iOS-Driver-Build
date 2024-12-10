//
//  ReasonModel.swift
//  GoferHandyProvider
//
//  Created by trioangle on 23/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

struct ReasonModel : Codable {
    let status_message : String?
    let status_code : String?
    let issues : [Issues]?

    enum CodingKeys: String, CodingKey {

        case status_message = "status_message"
        case status_code = "status_code"
        case issues = "issues"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_message = try values.decodeIfPresent(String.self, forKey: .status_message)
        status_code = try values.decodeIfPresent(String.self, forKey: .status_code)
        issues = try values.decodeIfPresent([Issues].self, forKey: .issues)
    }

}

struct Issues : Codable {
    let id : Int?
    let issue : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case issue = "issue"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        issue = try values.decodeIfPresent(String.self, forKey: .issue)
    }

}

struct likeDislike : Codable {
    let status_message : String?
    let status_code : String?

    enum CodingKeys: String, CodingKey {

        case status_message = "status_message"
        case status_code = "status_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_message = try values.decodeIfPresent(String.self, forKey: .status_message)
        status_code = try values.decodeIfPresent(String.self, forKey: .status_code)
    }

}
