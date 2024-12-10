//
//  Env Helper.swift
//  Goferjek Driver
//
//  Created by Trioangle on 06/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
struct Env {
    private static let isLiveCheck : Bool = {
        #if DEBUG
        debug(print: "DEBUG")
        return false
        #else
        debug(print: "PRODUCTION")
        return true
        #endif
    }()
    
    static func isLive() -> Bool {
        return self.isLiveCheck
    }
}
