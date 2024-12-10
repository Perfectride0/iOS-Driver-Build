//
//  BaseVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 18/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    
    
    fileprivate var _baseView : BaseView? {
        return self.view as? BaseView
    }
    fileprivate var onExit : (()->())? = nil
    // MARK: - Variable for Language Protocol
    
    var stopSwipeExitFromThisScreen : Bool? {
        return nil
    }
    
    lazy var commonAlert :CommonAlert =  {
        let alert = CommonAlert()
        return alert
    }()
    //MARK:- life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      //  self._baseView?.darkModeChange()
        if #available(iOS 17.0, *) {
                print("DARKCHECKKK")
            }else{
                self._baseView?.darkModeChange()
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ðððð2")
        //          self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self._baseView?.didLoad(baseVC: self)
        // Do any additional setup after loading the view.
        if self.traitCollection.userInterfaceStyle == .light{
                   print("App  to light mode")
            Shared.instance.isdarkmode = false
               }else{
                   print("App  to dark mode")
                   Shared.instance.isdarkmode = true
               }
               
               if #available(iOS 17.0, *) {
                   registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
                       if self.traitCollection.userInterfaceStyle == .light {
                           // Code to execute in light mode
                           print("App switched to light mode")
                           Shared.instance.isdarkmode = false
                           self._baseView?.darkModeChange()
                       } else {
                           // Code to execute in dark mode
                           print("App switched to dark mode")
                           Shared.instance.isdarkmode = true
                           self._baseView?.darkModeChange()
                         
                       }
                   })
               } else {
                   var preferredStatusBarStyle: UIStatusBarStyle {
                       if self.traitCollection.userInterfaceStyle == .dark{
                           Shared.instance.isdarkmode = true
                           self._baseView?.darkModeChange()
                           
                       }else{
                           Shared.instance.isdarkmode = false
                           self._baseView?.darkModeChange()
                       }
                       
                       return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
                   }
               }
    }
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return  Shared.instance.isdarkmode  ? .lightContent : .darkContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._baseView?.willAppear(baseVC: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self._baseView?.didAppear(baseVC: self)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let attribute : UISemanticContentAttribute = isRTLLanguage ? .forceRightToLeft : .forceLeftToRight
        
        if self.navigationController?.navigationBar.semanticContentAttribute != attribute{
            self.navigationController?.view.semanticContentAttribute = attribute
            self.navigationController?.navigationBar.semanticContentAttribute = attribute
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self._baseView?.didLayoutSubviews(baseVC: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._baseView?.willDisappear(baseVC: self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self._baseView?.didDisappear(baseVC: self)
        
        if self.isMovingFromParent{
            self.willExitFromScreen()
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    //MARK:- UDF
    public  func exitScreen(animated : Bool,_ completion : (()->())? = nil){
        self.onExit = completion
        if self.isPresented(){
            self.dismiss(animated: animated) {
                completion?()
            }
        }else{
            self.navigationController?.popViewController(animated: true)
            completion?()
        }
    }
    
    //    func commonOkAlertAction() {
    //        print("Ø Pressed Ok Action!!!")
    //    }
    //    
    //    func commonSuccessAlertAction() {
    //        print("Ø Pressed Success Action!!!")
    //    }
    //    
    //    func commonFailureAlertAction() {
    //        print("Ø Pressed Failure Action!!!")
    //    }
    func cornerRadiusWithShadow(view: UIView){
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true;
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            view.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
            view.layer.shadowColor = isDarkStyle ? UIColor.TertiaryColor.withAlphaComponent(0.5).cgColor : UIColor.TertiaryColor.cgColor
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .SecondaryColor
            view.layer.shadowColor = UIColor.TertiaryColor.cgColor
        }
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 6.0
        view.layer.masksToBounds = false
        
    }
}

extension BaseVC : UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = self.navigationController else {return true}
        if self.stopSwipeExitFromThisScreen ?? false{return false }
        return nav.viewControllers.count > 1
    }
    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    ///called when screen will pop back
    func willExitFromScreen(){
        
    }
}
