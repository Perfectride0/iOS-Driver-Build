//
//  InvoiceModel.swift
//  Gofer
//
//  Created by Trioangle on 17/10/18.
//  Copyright © 2018 Trioangle Technologies. All rights reserved.
//

import UIKit



//class InvoiceModel: NSObject {
//    
//    var invoiceKey : String = ""
//    var invoiceValue : String = ""
//    var bar = 0
//    var color = String()
//    var comment : String?
//    
//    override init(){}
//    init(_ json : JSON){
//        invoiceKey = json.string("key")
//        invoiceValue = json.string("value")
//        bar = json.int("bar")
//        color = json.string("colour")
//        if !json.string("comment").isEmpty{
//            comment = json.string("comment")
//        }
//    }
//    
//    func initInvoiceData(responseDict: NSDictionary) -> Any
//    {
//        guard let json = responseDict as? JSON else {return self}
//        invoiceKey = json.string("key")
//        invoiceValue = json.string("value")
//        bar = json.int("bar")
//        color = json.string("colour")
//        if !json.string("comment").isEmpty{
//            comment = json.string("comment")
//        }
//        return self
//    }
//
//}


/*import Foundation

// MARK: - Welcome
class Welcome {
    let statusCode, statusMessage: String
    let driverStatement: DriverStatement
    let statement: [Statement]
    
    init(statusCode: String, statusMessage: String, driverStatement: DriverStatement, statement: [Statement]) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.driverStatement = driverStatement
        self.statement = statement
    }
}

// MARK: - DriverStatement
class DriverStatement {
    let header: Header
    let title: String
    let content: [Content]
    let footer: [Footer]
    
    init(header: Header, title: String, content: [Content], footer: [Footer]) {
        self.header = header
        self.title = title
        self.content = content
        self.footer = footer
    }
}

// MARK: - Content
class Content {
    let key, value: String
    let bar: Bool
    let colour, tooltip: String
    
    init(key: String, value: String, bar: Bool, colour: String, tooltip: String) {
        self.key = key
        self.value = value
        self.bar = bar
        self.colour = colour
        self.tooltip = tooltip
    }
}

// MARK: - Footer
class Footer {
    let key: String
    let value: Int
    
    init(key: String, value: Int) {
        self.key = key
        self.value = value
    }
}

// MARK: - Header
class Header {
    let key, value: String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

// MARK: - Statement
class Statement {
    let totalFare, driverEarning, day, format: String
    let date: String
    
    init(totalFare: String, driverEarning: String, day: String, format: String, date: String) {
        self.totalFare = totalFare
        self.driverEarning = driverEarning
        self.day = day
        self.format = format
        self.date = date
    }
}
*/
