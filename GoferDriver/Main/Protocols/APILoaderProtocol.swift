//
//  APILoaderProtocol.swift
//  GoferDriver
//
//  Created by trioangle on 03/02/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
/**
 api progress loading handler
 - Author: Abishek Robin
 */
protocol APILoadersProtocol{
    func shouldLoad(_ shouldLoad: Bool,function : String)
}
extension APILoadersProtocol{
    
    func shouldLoad(_ shouldLoad: Bool,function : String = #function){
        self.shouldLoad(shouldLoad, function: function)
    }
}
