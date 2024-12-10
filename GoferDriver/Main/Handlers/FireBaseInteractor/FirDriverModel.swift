//
//  FirDriverModel.swift
//  GoferDriver
//
//  Created by trioangle on 04/06/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
protocol FIRModel {
    var childKey : String {get}
    var value : String{get}
    
    var updateValue : [AnyHashable:Any]{get}
    
}



//extension RiderDataModel : FIRModel{
//    var childKey: String {
//        return "trip_id"
//    }
//    
//    var value: String {
//        return self.description
//    }
//    
//    var updateValue: [AnyHashable:Any]{
//        return ["trip_id":self.description]
//    }
//    
//}

