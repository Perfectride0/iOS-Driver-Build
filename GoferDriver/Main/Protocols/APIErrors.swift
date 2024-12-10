//
//  APIErrors.swift
//  GoferDriver
//
//  Created by trioangle on 10/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

enum APIErrors : Error{
    case JSON_InCompatable
}
extension APIErrors : LocalizedError{
    
    var errorDescription: String?{
        return self.localizedDescription
    }
    var localizedDescription: String{
        switch self {
        case .JSON_InCompatable:
            return LangCommon.jsonSerialaizationFailed
        default:
            return LangCommon.error
        }
    }
}
