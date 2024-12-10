//
//  TripOTPVC.swift
//  GoferDriver
//
//  Created by trioangle on 19/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit

protocol TripOTPDelegate {
    var actualOTP : String? {get}
    func otpValidatedSuccesfully()
    func otpValidationCancelled()
}

class TripOTPVC: UIViewController {
   
    //MARK:- API Delegates
    
    //MARK:- Outlets
    @IBOutlet weak var bottomHolderView : SecondaryView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var doneBtn : PrimaryButton!
    
    @IBOutlet weak var cancelHolderView : SecondaryView!
    @IBOutlet weak var cancelLbl : ThemeButtonTypeLabel!
    @IBOutlet weak var transparentView : UIView!
    @IBOutlet weak var otpHolderView : SecondaryView!
    
    //MARK:- Variables
//    lazy var otpView : OTPView = {
//        let _otpView = OTPView.getView(with: self,
//                                       using: self.otpHolderView.bounds)
//        if isRTLLanguage{
//            _otpView.rotate()
//        }
//        return _otpView
//    }()
//
    
    lazy var otpView : CustomOtpView = {
        let _otpView = CustomOtpView.getView(with: self,
                                             using: self.otpHolderView.bounds)
        return _otpView
    }()
    
    func initNotifcation() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //Dissmiss keyboard
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let height = notification.getKeyboardHeight(){
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.bottomHolderView.transform = CGAffineTransform(translationX: 0, y: -(height - (UIDevice.current.hasNotch ? 39 : 0)))
            } completion: { isComplted in }
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.bottomHolderView.transform = .identity
        } completion: { isComplted in }
    }
    
    func setTheme() {
        self.bottomHolderView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.cancelHolderView.customColorsUpdate()
        self.cancelLbl.customColorsUpdate()
        self.otpHolderView.customColorsUpdate()
//        self.otpView.ThemeChange()
        self.otpView.darkModeChange()
        self.initNotifcation()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setTheme()
    }
    lazy var toolBar : UIToolbar = {
        let tool = UIToolbar(frame: CGRect(origin: CGPoint.zero,
                                           size: CGSize(width: self.view.frame.width,
                                                        height: 30)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done,
                                   target: self,
                                   action: #selector(self.doneToolBarAction))
        let clear = UIBarButtonItem(barButtonSystemItem: .refresh,
                                    target: self,
                                    action: #selector(self.clearToolBarAction))
        tool.setItems([clear,space,done], animated: true)
        tool.sizeToFit()
        tool.tintColor = .PrimaryColor
        return tool
    }()
    
    var tripOTPDelegate : TripOTPDelegate?
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initLanguage()
        self.initGestures()
        self.setTheme()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.6) {
            self.transparentView.alpha = 0.1
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initLanguage()
    }
    //MARK:- initializers
    
    func initView(){
        self.listen2Keyboard(withViews: [self.bottomHolderView,self.cancelHolderView])
        self.otpHolderView.subviews.forEach({$0.removeFromSuperview()})
        self.otpHolderView.insertSubview(self.otpView, at: 0)
        self.otpHolderView.bringSubviewToFront(self.otpView)
        self.otpView.setToolBar(self.toolBar)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.initLayers()
            self.checkStatus()
        }
    }
    func initLanguage(){
        self.titleLbl.text = LangCommon.enterOtp
        self.doneBtn.setTitle(LangCommon.done.uppercased(), for: .normal)
        self.cancelLbl.text = LangCommon.cancel.uppercased()
//        self.titleLbl.text = "Enter OTP to Begin Trip".localize
//        self.doneBtn.setTitle("Done".localize, for: .normal)
//        self.cancelLbl.text = "Cancel".localize
    }
    func initLayers(){
        self.cancelHolderView.isCurvedCorner = true
    }
    func initGestures(){
        self.cancelHolderView.addAction(for: .tap) { [weak self] in
            self?.tripOTPDelegate?.otpValidationCancelled()
            self?.view.endEditing(true)
            self?.dismiss(animated: true, completion: nil)
        }
    }

    class func initWithStory(with delegate : TripOTPDelegate) -> TripOTPVC{
        let view : TripOTPVC = UIStoryboard.gojekHandyUnique.instantiateIDViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.tripOTPDelegate = delegate
        return view
    }
    //MAKR:- Actions
    @IBAction func doneAction(_ sender : UIButton?){
        if let actualOTP = self.tripOTPDelegate?.actualOTP,
            let enteredOTP = self.otpView.otp,
            actualOTP == enteredOTP{
            self.tripOTPDelegate?.otpValidatedSuccesfully()
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.otpView.invalidOTP()
        }
    }
    @objc func doneToolBarAction(){
        self.view.endEditing(true)
        self.checkStatus()
    }
    @objc func clearToolBarAction(){
        
            self.otpView.clear()
        
    }
}
extension TripOTPVC: CheckStatusProtocol{
    func checkStatus() {
        self.doneBtn.isActive_MT = self.otpView.otp != nil && self.otpView.otp!.count == 4
    }
}
