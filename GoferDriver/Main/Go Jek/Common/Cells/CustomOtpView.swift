//
//  CustomOtpView.swift
//  Goferjek
//
//  Created by Trioangle on 21/09/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class CustomOtpView: UIView {

    @IBOutlet weak var contentHolderStack: UIStackView!
    @IBOutlet weak var otpField: CommonTextField!
    @IBOutlet weak var errorLbl: ErrorLabel!
    
    var checkStatusDelegate  : CheckStatusProtocol?
    var otp : String? {
        return self.otpField.text
    }
    static func getView(with delegate : CheckStatusProtocol,using frame : CGRect) -> CustomOtpView {
        let nib = UINib(nibName: "CustomOtpView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! CustomOtpView
        view.frame = frame
        view.checkStatusDelegate = delegate
        view.initView()
        return view
    }
    
    func darkModeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.otpField.customColorsUpdate()
        self.otpField.font = .MediumFont(size: 18)
        self.errorLbl.customColorsUpdate()
    }
    
    func initView() {
        self.otpField.cornerRadius = 10
        self.otpField.border(0.5, .TertiaryColor)
        self.otpField.delegate = self
        self.otpField.keyboardType = .numberPad
        self.otpField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.darkModeChange()
    }
    
    func clear() {
        self.otpField.text = ""
        self.errorLbl.isHidden = true
    }
    
    func setToolBar(_ bar : UIToolbar){
        self.otpField.inputAccessoryView = bar
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard !(textField.text?.isEmpty ?? true) else{return}
        self.checkStatusDelegate?.checkStatus()
    }
    
    func invalidOTP() {
        self.errorLbl.text = LangCommon.enterValidOtp
        self.otpField.shake {
            self.errorLbl.isHidden = false
        }
    }
    
}

extension CustomOtpView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorLbl.isHidden = true
        self.checkStatusDelegate?.checkStatus()
    }
}
