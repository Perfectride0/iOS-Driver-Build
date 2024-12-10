//
//  CallModel.swift
//  Goferjek Driver
//
//  Created by trioangle on 16/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
class CallViewModel: Codable {
    let status_code,status_message, first_name, last_name, profile_image: String
    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case status_message = "status_message"
        case first_name = "first_name"
        case last_name = "last_name"
        case profile_image = "profile_image"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.first_name = container.safeDecodeValue(forKey: .first_name)
        self.last_name = container.safeDecodeValue(forKey: .last_name)
        self.profile_image = container.safeDecodeValue(forKey: .profile_image)
    }
}
