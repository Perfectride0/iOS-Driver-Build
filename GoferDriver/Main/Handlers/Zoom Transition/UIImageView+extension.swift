//
//  UIImageView+extension.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/16/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

extension UIView {

    convenience init(baseImageView: UIView, frame: CGRect) {
        self.init(frame: CGRect.zero)
        self.frame = frame
    }
}
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
extension UIView{
    func addDashedBorder(view: UIView, strokeColor:UIColor) {
            //Create a CAShapeLayer
            let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [7, 3]

            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: 0, y:view.frame.height)])
            shapeLayer.path = path
            layer.addSublayer(shapeLayer)
        }
}
extension NSObject{
    public func topMostViewController() -> UIViewController {
        let windowKey = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        return self.topMostViewController(withRootViewController: (windowKey?.rootViewController!)!)
    }
    
    public func topMostViewController(withRootViewController rootViewController: UIViewController) -> UIViewController {
        if (rootViewController is UITabBarController) {
            let tabBarController = (rootViewController as! UITabBarController)
            return self.topMostViewController(withRootViewController: tabBarController.selectedViewController!)
        }
        else if (rootViewController is UINavigationController) {
            let navigationController = (rootViewController as! UINavigationController)
            return self.topMostViewController(withRootViewController: navigationController.topViewController!)
        }
        
        
        else if rootViewController.presentedViewController != nil {
            let presentedViewController = rootViewController.presentedViewController!
            return self.topMostViewController(withRootViewController: presentedViewController)
        }
        else {
            return rootViewController
        }
        
    }
    
    
}
extension Dictionary {
    var queryString: String {
        var output: String = ""
        forEach({ output += "\($0.key)=\($0.value)&" })
        output = String(output.dropLast())
        return output
    }
}
//MARK: - EXTENSIONS
extension UITableView {
  func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
    return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
  }

  func scrollToTop(animated: Bool) {
    let indexPath = IndexPath(row: 0, section: 0)
    if self.hasRowAtIndexPath(indexPath: indexPath) {
      self.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
  }
}
extension UIButton {
    func mainThemeCorner() {
        self.isRoundCorner = true
    }
    func whiteThemeCorner() {
        self.isRoundCorner = true
    }
}
