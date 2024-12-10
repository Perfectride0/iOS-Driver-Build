//
//  APIResponseProtocol.swift
//  GoferDriver
//
//  Created by trioangle on 03/02/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
//MARK:- protocol APIResponseProtocol
protocol APIResponseProtocol{
    func responseDecode<T: Decodable>(to modal : T.Type,
                              _ result : @escaping Closure<T>) -> APIResponseProtocol
    func responseJSON(_ result : @escaping Closure<JSON>) -> APIResponseProtocol
    func responseFailure(_ error :@escaping Closure<String>)
}
