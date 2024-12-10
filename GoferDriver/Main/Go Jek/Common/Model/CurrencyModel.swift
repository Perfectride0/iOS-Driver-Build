/**
* CurrencyModel.swift
 //  Gofer
 //
 //  Created by Trioangle on 16/05/18.
 //  Copyright © 2018 Trioangle Technologies. All rights reserved.
 //
* @link http://trioangle.com
*/


import Foundation
import UIKit

class CurrencyModel: Codable {
    var statusCode, statusMessage: String
    var currencyList:[CurrencyList]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case currencyList = "currency_list"

    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.statusMessage = container.safeDecodeValue(forKey: .statusMessage)
        let service = try? container.decodeIfPresent([CurrencyList].self, forKey: .currencyList)
        self.currencyList = service ?? [CurrencyList]()
        
    }
}

class CurrencyList: Codable {
    var currency_code, currency_symbol: String

    enum CodingKeys: String, CodingKey {
        case currency_code = "code"
        case currency_symbol = "symbol"

    }
    required init(from decoder : Decoder) throws{
           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.currency_code = container.safeDecodeValue(forKey: .currency_code)
           self.currency_symbol = container.safeDecodeValue(forKey: .currency_symbol)
   }
    // MARK: Inits
     func initiateCurrencyData(responseDict: NSDictionary) -> Any
     {
         currency_code = self.checkParamTypes(params: responseDict, keys:"code").description
         currency_symbol = self.checkParamTypes(params: responseDict, keys:"symbol").description
         return self
     }
     
     
     //MARK: Check Param Type
     func checkParamTypes(params:NSDictionary, keys:NSString) -> NSString
     {
         if let latestValue = params[keys] as? NSString {
             return latestValue as NSString
         }
         else if let latestValue = params[keys] as? String {
             return latestValue as NSString
         }
         else if let latestValue = params[keys] as? Int {
             return String(format:"%d",latestValue) as NSString
         }
         else if (params[keys] as? NSNull) != nil {
             return ""
         }
         else
         {
             return ""
         }
     }
}
