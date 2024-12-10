////
////  Flutter+Extension.swift
////  FlutterWave
////
////  Created by trioangle on 31/08/22.
////
//
//import Foundation
//import UIKit
//
extension UIView {
//
//    var isDarkStyle : Bool {
//        get {
//            self.traitCollection.userInterfaceStyle == .dark
//        }
//    }
//    
//    
//    var isHiddenInStackView: Bool {
//        get {
//            return isHidden
//        }
//        set {
//            if isHidden != newValue {
//                isHidden = newValue
//            }
//        }
//    }
//    
    func setTopCorners(radius: CGFloat) {
        self.layer.maskedCorners = [.layerMinXMinYCorner,
                                    .layerMaxXMinYCorner]
        self.layer.cornerRadius = radius
    }
//    func setBottomCorners(radius: CGFloat) {
//        self.layer.maskedCorners = [.layerMaxXMaxYCorner,
//                                    .layerMinXMaxYCorner]
//        self.layer.cornerRadius = radius
//    }
}
//
//class commonTextField : UITextField {
//    func customColorsUpdate() {
//        self.textColor = self.isDarkStyle ? .gray : .gray
//        self.backgroundColor = self.isDarkStyle ? .gray : .gray
////        self.tintColor = .PrimaryColor
////        self.font = AppTheme.Fontmedium(size: 14).font
//    }
//    override func awakeFromNib() {
//        self.customColorsUpdate()
//    }
//}
//
//class SecondaryNewView: UIView {
//    func customColorsUpdate() {
//        self.clipsToBounds = true
//    //    self.backgroundColor = self.isDarkStyle ? .gray : .lightGray
//        self.layer.borderWidth = 1
//        self.layer.borderColor = self.isDarkStyle ? UIColor.lightGray.cgColor : UIColor.lightGray.cgColor
//    }
//    override func awakeFromNib() {
//        self.customColorsUpdate()
//    }
//}
//
//
extension UITextField{

      @IBInspectable var doneAccessory: Bool{
          get{
              return self.doneAccessory
          }
          set (hasDone) {
              if hasDone{
                  addDoneButtonOnKeyboard()
              }
          }
      }

      func addDoneButtonOnKeyboard()
      {
          let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
          doneToolbar.barStyle = .default

          let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

          let items = [flexSpace, done]
          doneToolbar.items = items
          doneToolbar.sizeToFit()

          self.inputAccessoryView = doneToolbar
      }

      @objc func doneButtonAction() {
          self.resignFirstResponder()
      }

  }
//
//extension UIView {
//   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
//}
//typealias JSON = [String: Any]
//extension Dictionary where Dictionary == JSON{
//    
//    init?(_ data : Data){
//         if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
//             self = json
//         }else{
//             return nil
//         }
//     }
//    var status_code : Int{
//        return self.int("status_code")
//        //Int(self["status_code"] as? String ?? String()) ?? Int()
//    }
//    var isSuccess : Bool{
//        return status_code != 0
//    }
//    var status_message : String{
//        let statusMessage = self.string("status_message")
//        let successMessage = self.string("success_message")
//        return statusMessage.isEmpty ? successMessage : statusMessage
//    }
//
//    func value<T>(forKeyPath path : String) -> T?{
//        var keys = path.split(separator: ".")
//        var childJSON = self
//        let lastKey : String
//        if let last = keys.last{
//            lastKey = String(last)
//        }else{
//            lastKey = path
//        }
//        keys.removeLast()
//        for key in keys{
//            childJSON = childJSON.json(String(key))
//        }
//        return childJSON[lastKey] as? T
//    }
//    func array<T>(_ key : String) -> [T]{
//        return self[key] as? [T] ?? [T]()
//    }
//    func array(_ key : String) -> [JSON]{
//        return self[key] as? [JSON] ?? [JSON]()
//    }
//    func json(_ key : String) -> JSON{
//        return self[key] as? JSON ?? JSON()
//    }
//    
//     func string(_ key : String)-> String{
//     // return self[key] as? String ?? String()
//         let value = self[key]
//         if let str = value as? String{
//            return str
//         }else if let int = value as? Int{
//            return int.description
//         }else if let double = value as? Double{
//            return double.description
//         }else{
//            return String()
//         }
//     }
//     func int(_ key : String)-> Int{
//     //return self[key] as? Int ?? Int()
//         let value = self[key]
//         if let str = value as? String{
//            return Int(str) ?? Int()
//         }else if let int = value as? Int{
//            return int
//         }else if let double = value as? Double{
//            return Int(double)
//         }else{
//            return Int()
//         }
//     }
//     func double(_ key : String)-> Double{
//         //return self[key] as? Double ?? Double()
//         let value = self[key]
//         if let str = value as? String{
//            return Double(str) ?? Double()
//         }else if let int = value as? Int{
//            return Double(int)
//         }else if let double = value as? Double{
//            return double
//         }else{
//            return Double()
//         }
//     }
//    func bool(_ key : String) -> Bool{
//        let value = self[key]
//        if let bool = value as? Bool{
//            return bool
//        }else if let int = value as? Int{
//            return int == 1
//        }else if let str = value as? String{
//            return ["1","true"].contains(str)
//        }else{
//            return Bool()
//        }
//    }
//    
//    func setModelArray<T:Decodable>(_ key:String, type:T.Type)-> [T] {
//        var baseModel = [T]()
//        self.array(key).forEach { (json) in
//            let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//             let model = try! JSONDecoder().decode(T.self,
//                                                               from: data)
//           
//            baseModel.append(model)
//            
//            
//        }
//        return baseModel
//        
//    }
//    
//    func setModelFromKey<T:Decodable>(_ key:String, type:T.Type)-> T {
//        let data = try! JSONSerialization.data(withJSONObject: self.json(key), options: .prettyPrinted)
//        let model = try! JSONDecoder().decode(T.self,from: data)
//        return model
//    }
//    
//    func setModel<T:Decodable>(type:T.Type)-> T {
//        let data = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
//        let model = try! JSONDecoder().decode(T.self,from: data)
//        return model
//    }
//    
//    
//    
////    func
//    
//}
