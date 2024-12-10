//
//  LanguageEnum.swift
//  Makent
//
//  Created by trioangle on 08/08/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC


class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3).cgColor
        let colorBottom = UIColor(red: 0.0/255.0,
                                  green: 0.0/255.0,
                                  blue: 0.0/255.0, alpha: 0.0)
            .cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.startPoint = CGPoint(x: 0.5, y: 0.0)
        self.gl.endPoint = CGPoint(x: 0.5, y: 1)
        self.gl.locations = [1.0, 0.0]
        
    }
}
private var associatedLanguageBundle:Character = "0"

class PrivateBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let bundle: Bundle? = objc_getAssociatedObject(self, &associatedLanguageBundle) as? Bundle
        return (bundle != nil) ? (bundle!.localizedString(forKey: key, value: value, table: tableName)) : (super.localizedString(forKey: key, value: value, table: tableName))

    }
}

extension Bundle {
    class func setLanguage(_ language: String) {
        var onceToken: Int = 0

        if (onceToken == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            object_setClass(Bundle.main, PrivateBundle.self)
        }
        onceToken = 1
        objc_setAssociatedObject(Bundle.main, &associatedLanguageBundle, (language != nil) ? Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj") ?? "") : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
