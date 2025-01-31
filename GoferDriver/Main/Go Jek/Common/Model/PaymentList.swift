//
//  PaymentList.swift
//  GoferDriver
//
//  Created by trioangle on 03/02/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
struct PaymentList : Codable{
    var options : [PaymentOptionModel]
    enum CodingKeys : String,CodingKey{
        case options = "payment_list"
    }
    init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.options = container.safeDecodeValue(forKey: .options)
        
        //Storing card
        if let card = self.options
        .filter({$0.key.lowercased() == "stripe"})
        .first{
            let data = try JSONEncoder().encode(card)
            UserDefaults.set(data, for: .stripe_card)
        }else{
            UserDefaults.removeValue(for: .stripe_card)
        }
        
        if PaymentOptions.default == nil ||
            !self.options.compactMap({$0.option}).contains(PaymentOptions.default){
            let defaultOption = self.options.filter { (option) -> Bool in
                return option.isDefault
            }.first
            defaultOption?.option.setAsDefault()
            Constants().STOREVALUE(value: defaultOption?.icon ?? "", keyname: IS_Payment_image)
            
        }
        if let defaultOption = PaymentOptions.default{
            
            self.options.forEach { (option) in
                option.isDefault = option.option == defaultOption
                if option.key == "stripe_card"{
                    option.isDefault = false
                }
            }
        }
        
    }
    func didSelect(optionNamed string : String) -> PaymentOptionModel?{
        return self.options.filter({$0.value == string}).first
    }
}
