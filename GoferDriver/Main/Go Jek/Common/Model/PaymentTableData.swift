//
//  PaymentTableData.swift
//  GoferDriver
//
//  Created by Trioangle on 20/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation



class PaymentTableSection{
    var title : String!
    var datas = [PaymentTableData]()
    init(withTitle title : String,datas : [PaymentTableData] ){
        self.title = title
        self.datas = datas
    }
}
class PaymentTableData{
    
    var name : String!
    var image : UIImage?
    var imageURL : URL?
    var isSelected = false
    init(withName name : String){
        self.name = name
    }
}
