//
//  codeHelper.swift
//  GoferDriver
//
//  Created by Trioangle Technologies on 20/12/18.
//  Copyright © 2018 Trioangle Technologies. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


typealias JSON = [String: Any]
extension Dictionary where Dictionary == JSON{
    
    init?(_ data : Data){
         if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
             self = json
         }else{
             return nil
         }
     }
    var status_code : Int{
        return self.int("status_code")
        //Int(self["status_code"] as? String ?? String()) ?? Int()
    }
    var isSuccess : Bool{
        return status_code != 0
    }
    var status_message : String{
        let statusMessage = self.string("status_message")
        let successMessage = self.string("success_message")
        return statusMessage.isEmpty ? successMessage : statusMessage
    }

    func value<T>(forKeyPath path : String) -> T?{
        var keys = path.split(separator: ".")
        var childJSON = self
        let lastKey : String
        if let last = keys.last{
            lastKey = String(last)
        }else{
            lastKey = path
        }
        keys.removeLast()
        for key in keys{
            childJSON = childJSON.json(String(key))
        }
        return childJSON[lastKey] as? T
    }
    func array<T>(_ key : String) -> [T]{
        return self[key] as? [T] ?? [T]()
    }
    func array(_ key : String) -> [JSON]{
        return self[key] as? [JSON] ?? [JSON]()
    }
    func json(_ key : String) -> JSON{
        return self[key] as? JSON ?? JSON()
    }
    
     func string(_ key : String)-> String{
     // return self[key] as? String ?? String()
         let value = self[key]
         if let str = value as? String{
            return str
         }else if let int = value as? Int{
            return int.description
         }else if let double = value as? Double{
            return double.description
         }else{
            return String()
         }
     }
     func int(_ key : String)-> Int{
     //return self[key] as? Int ?? Int()
         let value = self[key]
         if let str = value as? String{
            return Int(str) ?? Int()
         }else if let int = value as? Int{
            return int
         }else if let double = value as? Double{
            return Int(double)
         }else{
            return Int()
         }
     }
     func double(_ key : String)-> Double{
         //return self[key] as? Double ?? Double()
         let value = self[key]
         if let str = value as? String{
            return Double(str) ?? Double()
         }else if let int = value as? Int{
            return Double(int)
         }else if let double = value as? Double{
            return double
         }else{
            return Double()
         }
     }
    func bool(_ key : String) -> Bool{
        let value = self[key]
        if let bool = value as? Bool{
            return bool
        }else if let int = value as? Int{
            return int == 1
        }else if let str = value as? String{
            return ["1","true"].contains(str)
        }else{
            return Bool()
        }
    }
    
    func setModelArray<T:Decodable>(_ key:String, type:T.Type)-> [T] {
        var baseModel = [T]()
        self.array(key).forEach { (json) in
            let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
             let model = try! JSONDecoder().decode(T.self,
                                                               from: data)
           
            baseModel.append(model)
            
            
        }
        return baseModel
        
    }
    
    func setModelFromKey<T:Decodable>(_ key:String, type:T.Type)-> T {
        let data = try! JSONSerialization.data(withJSONObject: self.json(key), options: .prettyPrinted)
        let model = try! JSONDecoder().decode(T.self,from: data)
        return model
    }
    
    func setModel<T:Decodable>(type:T.Type)-> T {
        let data = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        let model = try! JSONDecoder().decode(T.self,from: data)
        return model
    }
    
    
    
//    func
    
}
extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

func isValidMail(mail : String) -> Bool{
    //let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailTest.evaluate(with: mail)
}
extension UIAlertController {
    
    func addColorInTitleAndMessage(titleColor:UIColor,messageColor:UIColor,titleFontSize:CGFloat = 18, messageFontSize:CGFloat = 13){
        
        let attributesTitle =  [NSAttributedString.Key.foregroundColor:titleColor,NSAttributedString.Key.font:UIFont.systemFont(ofSize: titleFontSize)]
        
        let attributesMessage = [NSAttributedString.Key.foregroundColor:messageColor,NSAttributedString.Key.font:UIFont.systemFont(ofSize: messageFontSize)]
        let attributedTitleText = NSAttributedString(string: self.title ?? "", attributes: attributesTitle)
        let attributedMessageText = NSAttributedString(string: self.message ?? "", attributes: attributesMessage)
        
        self.setValue(attributedTitleText, forKey: "attributedTitle")
        self.setValue(attributedMessageText, forKey: "attributedMessage")
        
    }
    
}
extension UIViewController {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if #available(iOS 13.0, *){
            let view = UIApplication.shared.statusBarView
            
            view?.backgroundColor = style == .lightContent ? UIColor.PrimaryColor : .SecondaryColor
//            view?.setValue(style == .lightContent ? UIColor.white : .ThemeMain, forKey: "foregroundColor")
        }else if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = style == .lightContent ? UIColor.PrimaryColor : .SecondaryColor
//            statusBar.setValue(style == .lightContent ? UIColor.white : .ThemeMain, forKey: "foregroundColor")
        }
    }
    func logMessage(_ message: String,
                    fileName: String = #file,
                    functionName: String = #function,
                    lineNumber: Int = #line,
                    columnNumber: Int = #column) {
        
        print("🤡🤡🤡 Called by \(fileName) - \(functionName) at line \(lineNumber)[\(columnNumber)]")
    }
}
extension UIViewController{
    func presentProjectError(message : String){
        self.presentAlertWithTitle(title: appName,
                                   message: message,
                                   options:LangCommon.ok.capitalized) { (_) in
                                    
        }
    }
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        //TRVicky
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: title, alertDescription: message, okAction: options.first?.replacingOccurrences(of: "Ð", with: "") ?? "", cancelAction: options.count > 1 ? options.last : nil)
        commonAlert.addAdditionalOkAction(isForSingleOption: options.count == 1) {
            completion(0)
        }
        if options.count > 1 {
            commonAlert.addAdditionalCancelAction {
                completion(1)
            }
        }
        
    }
}
public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}
extension UIButton{
    /**
     Variable to change button Active Status(MainThemeColor)
     - Author: Abishek Robin
     - Note: MainTheme Color is applied
     */
    var isActive_MT : Bool{
        get{return self.isUserInteractionEnabled}
        set{
            self.isUserInteractionEnabled = newValue
            self.backgroundColor = newValue ? .PrimaryColor : .TertiaryColor
        }
    }
    /**
     Variable to change button Active Status(LightTheme)
     - Author: Abishek Robin
     - Note: LightTheme Color is applied
     */
    var isActive_LT : Bool{
        get{return self.isUserInteractionEnabled}
        set{
            self.isUserInteractionEnabled = newValue
            self.backgroundColor = newValue ? .PrimaryColor : .TertiaryColor
        }
    }
}

extension Array{
    
    var isNotEmpty : Bool{
        return !self.isEmpty
    }
    
    func
    value(atSafe index : Int) -> Element?{
        guard self.indices.contains(index) else {return nil}
        return self[index]
    }
    func find(includedElement: @escaping ((Element) -> Bool)) -> Int? {
        for arg in self.enumerated(){
            let (index,item) = arg
            if includedElement(item) {
                return index
            }
        }
        
        return nil
    }
}
extension UIButton{
    func btnOperations(to:btnState){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0){
            switch to {
            case .on:
                self.isUserInteractionEnabled = true
                self.backgroundColor = UIColor.PrimaryColor
            case .off:
                self.isUserInteractionEnabled = false
                self.backgroundColor = UIColor.TertiaryColor
            }
        }
        
    }
}
enum btnState : String{
    case on
    case off
}
