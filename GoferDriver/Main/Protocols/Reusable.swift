//
//  File.swift
//  GoferDriver
//
//  Created by trioangle on 15/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// UIViewController.swift
extension UIViewController: ReusableView { }

// UIStoryboard.swift
extension UIStoryboard {
    
    static var gojekHandyUnique: UIStoryboard{
        return UIStoryboard(name: "GoJek_HandyUnique", bundle: nil)
    }
    static var karuppasamy: UIStoryboard{
        return UIStoryboard(name: "Karuppasamy", bundle: nil)
    }
    static var gojekAccount: UIStoryboard{
        return UIStoryboard(name: "GoJek_Account", bundle: nil)
    }
    static var gojekCommon: UIStoryboard{
        return UIStoryboard(name: "GoJek_Common", bundle: nil)
    }
    static var gojekHandyBooking: UIStoryboard{
        return UIStoryboard(name: "GoJek_HandyBooking", bundle: nil)
    }
    static var gojekDeliveryallTrip: UIStoryboard{
        return UIStoryboard(name: "GojekDeliveryallTrip", bundle: nil)
    }
    static var delivery : UIStoryboard{
        return UIStoryboard(name: "Delivery", bundle: nil)
    }
    
    
    static var shruti : UIStoryboard{
        return UIStoryboard(name: "Shruti", bundle: nil)
    }
    static var Towshruti : UIStoryboard{
        return UIStoryboard(name: "TowShruti", bundle: nil)
    }
    static var kirangofer : UIStoryboard{
        return UIStoryboard(name: "kirangofer", bundle: nil)
    }
    
    static var Venkkat : UIStoryboard{
        return UIStoryboard(name: "Venkkat", bundle: nil)
    }
    
    static var Instacart : UIStoryboard{
        return UIStoryboard(name: "Instacart", bundle: nil)
    }
    
    static var LaundryStoryboard : UIStoryboard{
        return UIStoryboard(name: "LaundryStoryboard", bundle: nil)
    }
    static var Towkaruppasamy: UIStoryboard{
        return UIStoryboard(name: "TowKaruppasamy", bundle: nil)
    }
    
    /**
     initialte viewController with identifier as class name
     - Author: Abishek Robin
     - Returns: ViewController
     - Warning: Only ViewController which has identifier equal to class should be parsed
     */
    func instantiateViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
    }
    /**
     initialte viewController with identifier as class name and suffix("ID")
     - Author: Abishek Robin
     - Returns: ViewController
     - Warning: Only ViewController with "ID" in suffix should be parsed
     */
    func instantiateIDViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier + "ID") as! T
    }
}


extension UITableViewCell: ReusableView { }
extension UICollectionViewCell: ReusableView { }
extension UITableView{
    /**
    Registers UITableViewCell with identifier and nibName as class name
    - Author: Abishek Robin
    - Parameters:
       - cell: the Cell class instance to be registered
    - Warning: Only UITableViewCell which has identifier equal to class should be parsed
    */
    func registerNib(forCell cell : ReusableView.Type){
        
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
        
        self.register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    /**
     initialte UITableViewCell with identifier as class name
     - Author: Abishek Robin
     - Returns: ReusableView(UITableViewCell)
     - Warning: Only UITableViewCell which has identifier equal to class should be parsed
     */
    func dequeueReusableCell<T>(for index : IndexPath) -> T where T : ReusableView{
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: index) as! T
    }
}

extension UICollectionView{
    /**
     initialte UICollectionViewCell with identifier as class name
     - Author: Abishek Robin
     - Returns: ReusableView(UITableViewCell)
     - Warning: Only UICollectionViewCell which has identifier equal to class should be parsed
     */
    func dequeueReusableCell<T>(for index : IndexPath) -> T where T : ReusableView{
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: index) as! T
    }
}

extension UIView {
    func getCurrentCell<T:AnyObject>(cellType:T.Type) -> T? {
        if let cell = self.superview?.superview as? T {
            return cell
        }
        return nil
    }
}
