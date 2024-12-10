//
//  APIInteractor.swift
//  GoferDriver
//
//  Created by trioangle on 05/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation

import Alamofire
enum GoferError : Error{
    case failure(_ reason : String)
}
extension GoferError : LocalizedError{
    public var errorDescription : String?{
        switch self {
        case .failure(let error):
            return error
        default:
            return LangCommon.internalServerError
        }
    }
}
