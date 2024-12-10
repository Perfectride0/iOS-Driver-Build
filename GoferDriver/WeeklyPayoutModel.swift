//
//  WeeklyPayoutModel.swift
//  GoferDriver
//
//  Created by Trioangle on 10/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
class WeeklyPayoutData{
    let id: Int
    let driver_name: String
    let week_start: String
    let week_end: String
    let curr_code: String
    let driver_payout: String
    let day: String
    let created_at: String
    
    init(_ json:JSON){
        self.id = json.int("id")
        self.driver_name = json.string("driver_name")
        self.week_start = json.string("week_sart")
        self.week_end = json.string("week_end")
        self.curr_code = json.string("currency_code")
        self.driver_payout = json.string("driver_payout")
        self.day = json.string("day")
        self.created_at = json.string("created_at")
        
    }
}
