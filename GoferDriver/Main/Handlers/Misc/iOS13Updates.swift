//
//  iOS13Updates.swift
//  GoferDriver
//
//  Created by trioangle1 on 27/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
extension UIApplication {


    class var statusBarBackgroundColor: UIColor? {
        get {
            return statusBarUIView?.backgroundColor
        } set {
            statusBarUIView?.backgroundColor = newValue
        }
    }

    class var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 987654321
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            }
            else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag

                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
    
}
