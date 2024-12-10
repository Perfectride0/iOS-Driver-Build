//
//  InfoPlistKeys.swift
//  GoferDriver
//
//  Created by trioangle on 15/05/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

enum InfoPlistKeys : String{
    case Querries = "LSApplicationQueriesSchemes"
    case apiKey = "API_KEY"
    case Google_API_keys
    case Google_Places_keys
    case App_URL
    case is_Live
    case RedirectionLink_provider
    case iTunesData_user
    case iTunesData_provider
    case ThemeColors
    case ReleaseVersion
    case UserType
}
extension InfoPlistKeys : PlistKeys{
    var key: String{
        return self.rawValue
    }
    
    static var fileName: String {
        return "Info"
    }
    
    
}
