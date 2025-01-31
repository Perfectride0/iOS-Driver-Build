//
//  OTPView.swift
//  Gofer
//
//  Created by trioangle on 11/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit


protocol TextFieldBackSpaceDelegate{
    func onBackSpaceTap(for textField : UITextField)
}
//Textfield which detectes back space on empty textfield
class DeleteTextField :UITextField{
    var backSpaceDelegate : TextFieldBackSpaceDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = .PrimaryColor
        self.textColor = .SecondaryTextColor
        self.font = .MediumFont(size: 14)
    }
    override func delete(_ sender: Any?) {
        super.delete(sender)
    }
    override func deleteBackward() {
        self.backSpaceDelegate?.onBackSpaceTap(for: self)
        super.deleteBackward()
    }
    
}
//MARK:- OTP View
class OTPView: UIView {
    
    @IBOutlet weak var tf1 : DeleteTextField!
    @IBOutlet weak var tf2 : DeleteTextField!
    @IBOutlet weak var tf3 : DeleteTextField!
    @IBOutlet weak var tf4 : DeleteTextField!
    @IBOutlet weak var holderStackView : UIStackView!
    @IBOutlet weak var invalidOTPLbl : ErrorLabel!
    var checkStatusDelegate  : CheckStatusProtocol?
    
    func ThemeChange() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.tf1.backgroundColor = self.isDarkStyle ?
                .DarkModeBackground :
                .SecondaryColor
            self.tf1.textColor = self.isDarkStyle ?
                .DarkModeTextColor :
                .SecondaryTextColor
            
            self.tf2.backgroundColor = self.isDarkStyle ?
                .DarkModeBackground :
                .SecondaryColor
            self.tf2.textColor = self.isDarkStyle ?
                .DarkModeTextColor :
                .SecondaryTextColor
            
            self.tf3.backgroundColor = self.isDarkStyle ?
                .DarkModeBackground :
                .SecondaryColor
            self.tf3.textColor = self.isDarkStyle ?
                .DarkModeTextColor :
                .SecondaryTextColor
            
            self.tf4.backgroundColor = self.isDarkStyle ?
                .DarkModeBackground :
                .SecondaryColor
            self.tf4.textColor = self.isDarkStyle ?
                .DarkModeTextColor :
                .SecondaryTextColor
        }
    }
    
    //input OTP value
    var otp : String?{
        if let text1 = tf1.text,
            let text2 = tf2.text,
            let text3 = tf3.text,
            let text4 = tf4.text{
            return text1+text2+text3+text4
        }
        return nil
    }
    //MARK:- View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    //MARK:- Initializers
    func initView(){
        self.elevate(2)
        self.tf1.delegate = self
        self.tf2.delegate = self
        self.tf3.delegate = self
        self.tf4.delegate = self
        self.tf1.backSpaceDelegate = self
        self.tf2.backSpaceDelegate = self
        self.tf3.backSpaceDelegate = self
        self.tf4.backSpaceDelegate = self
        
        
        self.tf1.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.tf2.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.tf3.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.tf4.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.invalidOTPLbl.isHidden = true
        
        
    }
    //MARK:- roatate stack for RTL vies
    func rotate(){
        var i = 0
        for view in self.holderStackView.arrangedSubviews.reversed(){
            self.holderStackView.insertArrangedSubview(view, at: i)
            i += 1
        }
    }
    //invalid OTP is given
    func invalidOTP(){
        self.invalidOTPLbl.text = LangCommon.enterValidOtp
        self.holderStackView.shake {
            self.invalidOTPLbl.isHidden = false
            
        }
    }
    //clear all input
    func clear(){
        self.tf1.text = ""
        self.tf2.text = ""
        self.tf3.text = ""
        self.tf4.text = ""
        self.tf1.becomeFirstResponder()
    }
    //set the parent toolbar for child textfields
    func setToolBar(_ bar : UIToolbar){
        self.tf1.inputAccessoryView = bar
        self.tf2.inputAccessoryView = bar
        self.tf3.inputAccessoryView = bar
        self.tf4.inputAccessoryView = bar
    }
    static func getView(with delegate : CheckStatusProtocol,using frame : CGRect) -> OTPView{
        let nib = UINib(nibName: "OTPView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! OTPView
        view.frame = frame
        view.checkStatusDelegate = delegate
        view.initView()
        return view
    }
}


//MARK:- for otp
extension OTPView : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.invalidOTPLbl.isHidden = true
        
        
        /*
         *This delegate prevent the user from entering the 4th digit before entering the first/precedign digits
         *if text is already given user can continue
         */
        let text1 = tf1.text ?? ""
        let text2 = tf2.text ?? ""
        let text3 = tf3.text ?? ""
        let text4 = tf4.text ?? ""
        
        guard (textField.text ?? "").isEmpty else{return true}
        switch textField {
        case self.tf1:
            return true
        case self.tf2:
            return !text1.isEmpty || !text3.isEmpty || !text4.isEmpty
        case self.tf3:
            return !text1.isEmpty || !text2.isEmpty || !text4.isEmpty
        case self.tf4:
            return !text1.isEmpty || !text2.isEmpty || !text3.isEmpty
        default:
            return false
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //If user select text after entering select the textfield to replace
        if !(textField.text  ?? "").isEmpty {
            textField.selectAll(nil)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //direct to next text on end
        guard !(textField.text?.isEmpty ?? true) else{return}
        let nextTF : UITextField?
        switch textField {
        case self.tf1:
            nextTF = self.tf2
        case self.tf2:
            nextTF = self.tf3
        case self.tf3:
            nextTF = self.tf4
        case self.tf4:
            fallthrough
        default:
            nextTF = nil
            self.endEditing(true)
            self.checkStatusDelegate?.checkStatus()
        }
        if let next = nextTF{
            next.becomeFirstResponder()
            //if next text contains data select all text to override
            if !(next.text ?? "").isEmpty{
                next.selectAll(nil)
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.invalidOTPLbl.isHidden = true
        guard let text = textField.text else{return true}
        let char = string.cString(using: String.Encoding.utf8)
        let isBackSpace: Bool = Int(strcmp(char, "\u{8}")) == -8
        
        if textField.selectedTextRange == textField
            .textRange(from: textField.beginningOfDocument,
                       to: textField.endOfDocument){
            return true
        }
        //Can't enter value ,Value already filled
        if text.count == 1 && !isBackSpace{
            return false
        }
        //Cant delete given text
        if text.count == 1 && isBackSpace{
            return true
         
        }
        //current text is empty,on back space move to preceding textfield
        if text.count == 0 && isBackSpace{
            switch textField{
            case self.tf4:
                self.tf3.becomeFirstResponder()
            case self.tf3:
                self.tf2.becomeFirstResponder()
            case self.tf2:
                self.tf1.becomeFirstResponder()
            case self.tf1:
                fallthrough
            default:
                self.endEditing(true)
            }
            return false
        }
        return true
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        //this delegate is used to forward next textfield when current textfeild is filled
        self.checkStatusDelegate?.checkStatus()
        guard !(textField.text?.isEmpty ?? true) else{return}
        switch textField {
        case self.tf1:
            
            self.tf2.becomeFirstResponder()
        case self.tf2:
            self.tf3.becomeFirstResponder()
        case self.tf3:
            self.tf4.becomeFirstResponder()
        case self.tf4:
            fallthrough
        default:
            self.endEditing(true)
            self.checkStatusDelegate?.checkStatus()
        }
    }
    
}


extension OTPView : TextFieldBackSpaceDelegate{
    func onBackSpaceTap(for textField: UITextField) {
        //this delegate moves to previous textfield on backspace tapped when current textfield is empty
        guard textField.text?.isEmpty ?? true else {return}
        switch textField {
        case self.tf4:
            self.tf3.text = ""
            self.tf3.becomeFirstResponder()
        case self.tf3:
            self.tf2.text = ""
            self.tf2.becomeFirstResponder()
        case self.tf2:
            self.tf1.text = ""
            self.tf1.becomeFirstResponder()
        case self.tf1:
            fallthrough
        default:
            
            self.checkStatusDelegate?.checkStatus()
        }
    }
    
    
}
