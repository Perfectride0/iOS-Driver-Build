//
//  LoginView.swift
//  Handyman
//
//  Created by trioangle1 on 14/08/20.
//  Copyright © 2020 trioangle. All rights reserved.
//

import UIKit

class LoginView: BaseView {
    
    //------------------------------------------
    // MARK: - Outlets
    //------------------------------------------
    
    @IBOutlet weak var signInBtn: PrimaryButton!
    @IBOutlet weak var phnTextField: CommonTextField!
    @IBOutlet weak var passwordTextField: CommonTextField!
    @IBOutlet weak var forgotPasswordBtn: TransperentIndicatorButton!
    @IBOutlet weak var dialCodelbl: SecondaryTextFieldTypeLabel!
    @IBOutlet weak var flagIV: UIImageView!
    @IBOutlet weak var pageTitle: SecondaryHeaderLabel!
    @IBOutlet weak var bottomContainerView: TopCurvedView!
    @IBOutlet weak var noAccountBtn: TransparentPrimaryButton!
    @IBOutlet weak var mobileHolderStackView: UIStackView!
    @IBOutlet weak var passwordHolderStackView: UIStackView!
    @IBOutlet weak var phoneNumberUpdateBtn: UIButton!
    @IBOutlet weak var phoneBGView: InactiveBorderSecondaryView!
    @IBOutlet weak var countryCodeBgView: InactiveBorderSecondaryView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var passwordBGView: InactiveBorderSecondaryView!
    @IBOutlet weak var passwordVisibleIV: CommonColorImageView!
    
    //------------------------------------------
    // MARK: - Class Variables
    //------------------------------------------
    
    var strPhoneNo = ""
    var strLastName = ""
    var isFromProfile:Bool = false
    var isFromForgotPage:Bool = false
    var spinnerView = JTMaterialSpinner()
    var selectedCountry : CountryModel?
    var viewcontroller:LoginVC!
    var isSecure: Bool = true
    
    //------------------------------------------
    //MARK: - Life Cycles
    //------------------------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewcontroller = baseVC as? LoginVC
        self.initNotification()
        self.initLanguage()
        self.initView()
        self.initGesture()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.headerView.customColorsUpdate()
        self.passwordVisibleIV.customColorsUpdate()
        self.countryCodeBgView.customColorsUpdate()
        self.phoneBGView.customColorsUpdate()
        self.passwordBGView.customColorsUpdate()
        self.bottomContainerView.customColorsUpdate()
        self.signInBtn.customColorsUpdate()
        self.phnTextField.customColorsUpdate()
        self.phnTextField.font = .lightFont(size: 15)
        self.passwordTextField.customColorsUpdate()
        self.passwordTextField.font = .lightFont(size: 15)
        self.forgotPasswordBtn.customColorsUpdate()
        self.forgotPasswordBtn.titleLabel?.font = .lightFont(size: 15)
        self.dialCodelbl.customColorsUpdate()
        self.dialCodelbl.font = .lightFont(size: 15)
        self.pageTitle.customColorsUpdate()
        self.noAccountBtn.customColorsUpdate()
    }
    
    override
    func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        self.checkNextButtonStatus()
        self.initLanguage()
        self.viewcontroller.navigationController?.isNavigationBarHidden = true
        let support = UberSupport()
        support.showProgressInWindow(showAnimation: true)
        DispatchQueue.main.async{ [weak self] in
            self?.setCountryFlatAndDialCode()
            support.removeProgressInWindow()
        }
    }
    
    override
    func didAppear(baseVC: BaseVC) {
        super.didAppear(baseVC: baseVC)
        
    }
    
    //------------------------------------------
    // MARK: - Initializers
    //------------------------------------------
    
    func initView() {
        self.countryCodeBgView.cornerRadius = 15
        self.countryCodeBgView.border(1, .TertiaryColor)
        self.phoneBGView.cornerRadius = 15
        self.phoneBGView.border(1, .TertiaryColor)
        self.passwordBGView.cornerRadius = 15
        self.passwordBGView.border(1, .TertiaryColor)
        self.phnTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordVisibleIV.image = #imageLiteral(resourceName: "visible")
        if #available(iOS 10.0, *) {
            self.phnTextField.keyboardType = .asciiCapableNumberPad
            self.passwordTextField.keyboardType = .asciiCapable
        } else {
            // Fallback on earlier versions
            self.phnTextField.keyboardType = .numberPad
            self.passwordTextField.keyboardType = .default
        }
        AppDelegate.shared.pushManager.registerForRemoteNotification()
        self.viewcontroller.navigationController?.isNavigationBarHidden = true
        if strPhoneNo.count > 0 {
            phnTextField.text = strPhoneNo
        }
        phnTextField.becomeFirstResponder()
    }
    
    func initGesture() {
        self.passwordVisibleIV.addAction(for: .tap) {
            self.secureButtonTapped()
        }
    }
    
    func initNotification() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(self.keyboardWillShow),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(self.keyboardWillHide),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }
    
    //------------------------------------------
    //MARK:- init Language
    //------------------------------------------
    
    func initLanguage(){
        let attributedString : NSAttributedString = NSAttributedString(
            string: LangCommon.dontHaveAcc,
            attributes: [.underlineColor : UIColor.PrimaryColor,
                         .underlineStyle : NSUnderlineStyle.single.rawValue])
        self.noAccountBtn.setAttributedTitle(attributedString,
                                             for: .normal)
        self.pageTitle.text = LangCommon.signIn.capitalized
        self.forgotPasswordBtn.setTitle(LangCommon.forgotPassword.capitalized,
                                        for: .normal)
        self.phnTextField.placeholder = LangCommon.mobileno.capitalized
        self.passwordTextField.placeholder = LangCommon.password.capitalized
        self.signInBtn.setTitle(LangCommon.login.capitalized,
                                for: .normal)
        self.phnTextField.setTextAlignment()
        self.passwordTextField.setTextAlignment()
    }
    
    //-------------------------------------------------------------
    //MARK: - Getting Country Dial Code and Flag from plist file
    //-------------------------------------------------------------
    
    func setCountryFlatAndDialCode() {
        let strCountryCode = Constants().GETVALUE(keyname: USER_COUNTRY_CODE)
        let country = CountryModel(forDialCode: nil, withCountry: strCountryCode)
        let url = URL(string: country.flag)
        self.flagIV.sd_setImage(with: url, completed: nil)
        dialCodelbl.text = country.dial_code
        self.selectedCountry = country
        var rect = dialCodelbl.frame
        rect.size.width = UberSupport().onGetStringWidth(dialCodelbl.frame.size.width, strContent: dialCodelbl.text! as NSString, font: dialCodelbl.font)
        dialCodelbl.frame = rect
    }
    
    //-------------------------------------------------------------
    //MARK: - Dissmiss the keyboard
    //-------------------------------------------------------------
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Button Actions
    //-------------------------------------------------------------
    
    @IBAction
    func changeFlagAction(_ sender: UIButton) {
        let propertyView = CountryListVC.initWithStory()
        propertyView.delegate = self
        self.viewcontroller.navigationController?
            .pushViewController(propertyView,
                                animated: true)
    }
    
    @IBAction
    func forgotPasswordBtnAction(_ sender: Any) {
        self.endEditing(true)
        let mobileValidationVC = MobileValidationVC
            .initWithStory(usign: self,
                           for: .forgotPassword)
        self.viewcontroller.presentInFullScreen(mobileValidationVC,
                                                animated: true,
                                                completion: nil)
    }
    
    @IBAction
    func noAccBtnAction(_ sender: Any) {
        self.endEditing(true)
        self.viewcontroller.navigationController?.popViewController(animated: false)
        self.viewcontroller.welcomeNavigation?.navigateToRegisterVC()
    }
    
    @IBAction
    func loginBtnAction(_ sender: Any) {
        if !isSimulator {
            if !(UIApplication.shared.isRegisteredForRemoteNotifications) {
                //TRVicky
                self.viewcontroller.commonAlert
                    .setupAlert(
                        alert: LangCommon.message,
                        alertDescription: LangCommon.pleaseEnablePushNotification,
                        okAction: LangCommon.ok.uppercased())
                self.viewcontroller.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                    AppDelegate.shared.pushManager.registerForRemoteNotification()
                }
                return
            }
        }
        self.addProgress()
        self.endEditing(true)
        let country : CountryModel
        if let _selectedCountry = self.selectedCountry{
            country = _selectedCountry
        }else{
            country = CountryModel(forDialCode: self.dialCodelbl.text ?? "+1", withCountry: nil)
        }
        var dicts = JSON()
        dicts["country_code"] = country.country_code
        dicts["mobile_number"] = String(format:"%@",phnTextField.text!)
        dicts["password"] = String(format:"%@",passwordTextField.text!)
        self.viewcontroller.callLoginAPI(parms: dicts)
    }
    
    @IBAction
    func backBtnAction(_ sender: Any) {
        self.viewcontroller.navigationController?.popViewController(animated: true)
    }
    @IBAction
    private func textFieldDidChange(textField: UITextField) {
        self.checkNextButtonStatus()
    }
    
    func showPage() {
        let userDefaults = UserDefaults.standard
        userDefaults.set("driver", forKey:"getmainpage")
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.onSetRootViewController(viewCtrl: self.viewcontroller)
        if Constants().GETVALUE(keyname: USER_PAYPAL_EMAIL_ID).count == 0 {
            // @Karuppasamy
//            let propertyView = AddPaymentVC.initWithStory()
//            propertyView.isFromHomePage = true
//            self.viewcontroller.navigationController?.pushViewController(propertyView, animated: false)
        } else {
            let userDefaults = UserDefaults.standard
            userDefaults.set("driver", forKey:"getmainpage")
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            appDelegate.onSetRootViewController(viewCtrl: self.viewcontroller)
        }
        return
    }
    
    //-------------------------------------------------------------
    // MARK: - NAVIGATE TO DOCUMENT PAGE
    //-------------------------------------------------------------
    
    /*
     IF USER NOT UPLODING DOCUMENT
     */
   
    
    //-------------------------------------------------------------
    // MARK: - NAVIGATE TO ADD VEHICLE DETAILS PAGE
    //-------------------------------------------------------------
    
    /*
     IF USER NOT UPDATING HIS VEHICLE DETAILS
     */
   
    //-------------------------------------------------------------
    // MARK: - DISPLAY PROGRESS WHEN API CALLING
    //-------------------------------------------------------------
    
    func addProgress() {
        self.signInBtn.isUserInteractionEnabled = false
        self.signInBtn.addSubview(spinnerView)
        self.spinnerView.anchor(toView: self.signInBtn,
                                trailing: -15)
        self.spinnerView.setEqualHightWidthAnchor(toView: self.spinnerView,
                                                  height: 25)
        self.spinnerView.setCenterXYAncher(toView: signInBtn,
                                           centerY: true)
        self.spinnerView.circleLayer.lineWidth = 3.0
        self.spinnerView.circleLayer.strokeColor =  UIColor.PrimaryTextColor.cgColor
        self.spinnerView.beginRefreshing()
    }
    
    //-------------------------------------------------------------
    // MARK: - REMOVE PROGRESS WHEN API CALL DONE
    //-------------------------------------------------------------
    
    func removeProgress() {
        self.signInBtn.isUserInteractionEnabled = true
        spinnerView.endRefreshing()
        spinnerView.removeFromSuperview()
    }
    
    //-------------------------------------------------------------
    // MARK: - Checking Next Button status
    //-------------------------------------------------------------
    
    /*
     USER NAME & PASSWORD IS FILLED
     */
    func checkNextButtonStatus() {
        if let number = self.phnTextField.text,
           let password = self.passwordTextField.text {
            let isActive = 3 < number.count && number.count < 16 && password.count > 5
            self.signInBtn.backgroundColor = isActive ? .PrimaryColor : .TertiaryColor
            self.signInBtn.isUserInteractionEnabled = isActive
        } else {
            self.signInBtn.backgroundColor = .TertiaryColor
            self.signInBtn.isUserInteractionEnabled = false
        }
    }
    
    @objc
    func secureButtonTapped() {
        self.isSecure = !self.isSecure
        self.passwordVisibleIV.image = self.isSecure ? #imageLiteral(resourceName: "visible") : #imageLiteral(resourceName: "invisible")
        self.passwordTextField.isSecureTextEntry = self.isSecure
    }

}

//-------------------------------------------------------------
// MARK: - Mobile Number Valiadation Protocol
//-------------------------------------------------------------

extension LoginView : MobileNumberValiadationProtocol {
    func verified(number: MobileNumber) {
        let otpView = ResetPasswordVC.initWithStory()
        otpView.strMobileNo = number.number
        otpView.countryModel = number.flag
        self.viewcontroller.navigationController?.pushViewController(otpView,
                                                                     animated: true)
    }
}

//-------------------------------------------------------------
// MARK: - TextField Delegate Method
//-------------------------------------------------------------

extension LoginView : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == phnTextField) {
        } else {
        }
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if textField == phnTextField{
            if (textField.text?.count)! >= 16 {
                   let char  = string.cString(using: String.Encoding.utf8)!
                   let backspece = strcmp(char, "\\b")
                   if backspece == -92 {
                       return true
                   }
                   return false
               }
        }
        
        if textField == phnTextField {
            let ACCEPTABLE_CHARACTERS = "1234567890"
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        }
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        else if (string == " ") {
            return false
        }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
}

//-------------------------------------------------------------
// MARK: - CHANGE DIAL CODE DELEGATE METHOD
//-------------------------------------------------------------

extension LoginView : CountryListDelegate {
    /*
     IF USER CHANGED THE COUNTRY CODE
     */
    internal func countryCodeChanged(countryCode:String, dialCode:String, flagImg:String) {
        dialCodelbl.text = "\(dialCode)"
        self.selectedCountry = CountryModel(forDialCode: nil, withCountry: countryCode)
        let url = URL(string: flagImg)
        self.flagIV.sd_setImage(with: url, completed: nil)
        Constants().STOREVALUE(value: dialCode, keyname: USER_DIAL_CODE)
        Constants().STOREVALUE(value: countryCode, keyname: USER_COUNTRY_CODE)
        var rect = dialCodelbl.frame
        rect.size.width = UberSupport().onGetStringWidth(dialCodelbl.frame.size.width, strContent: dialCode as NSString, font: dialCodelbl.font)
        dialCodelbl.frame = rect
    }
}
