//
//  RegisterView.swift
//  Handyman
//
//  Created by trioangle1 on 14/08/20.
//  Copyright © 2020 trioangle. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import Alamofire

class RegisterView: BaseView,UITextFieldDelegate,CountryListDelegate{

    // MARK: - Outlets

    @IBOutlet weak var errorEmailLbl: ErrorLabel!
    @IBOutlet weak var registerUrInfo : SecondaryHeaderLabel!
    @IBOutlet weak var scrollObjHolder: UIScrollView!
    @IBOutlet weak var txtFldFirstName: CommonTextField!
    @IBOutlet weak var txtFldLastName: CommonTextField!
    @IBOutlet weak var txtFldEmail: CommonTextField!
    @IBOutlet weak var imgCountryFlag: UIImageView!
    @IBOutlet weak var lblDialCode: SecondaryTextFieldTypeLabel!
    @IBOutlet weak var txtFldPhoneNo: CommonTextField!
    @IBOutlet weak var txtFldPassword: CommonTextField!
    @IBOutlet weak var txtFieldReferal : CommonTextField!
    @IBOutlet weak var checkImgView: PrimaryImageView!
    @IBOutlet weak var loginBtn:PrimaryButton!
    @IBOutlet weak var noAccBtn: UIButton!
    @IBOutlet weak var terms_and_condition: TTTAttributedLabel!
    @IBOutlet weak var cityField: CommonTextField!
    
    @IBOutlet weak var countryStack: UIStackView!
    @IBOutlet weak var referalStack: UIStackView!
    @IBOutlet weak var checkImgBtn: UIButton!
    @IBOutlet weak var secureButton: PrimaryTintButton!
    // MARK: - Class Variables
    @IBOutlet weak var bgView: SecondaryView!
    
    @IBOutlet weak var passwordVisibleIV: CommonColorImageView!
    @IBOutlet weak var contentBgView: TopCurvedView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var minimumPasswordErrorLAbel: ErrorLabel!
    @IBOutlet weak var firstNameBgView: InactiveBorderSecondaryView!
    @IBOutlet weak var lastNameBgView: InactiveBorderSecondaryView!
    
    @IBOutlet weak var emailBgView: InactiveBorderSecondaryView!
    
    @IBOutlet weak var mobileBgView: InactiveBorderSecondaryView!
    @IBOutlet weak var countryBgView: InactiveBorderSecondaryView!
    
    @IBOutlet weak var passwordBgView: InactiveBorderSecondaryView!
    @IBOutlet weak var cityBgview: InactiveBorderSecondaryView!
    @IBOutlet weak var referalBgView: InactiveBorderSecondaryView!
    @IBOutlet weak var termsBgView: SecondaryView!
    var spinnerView = JTMaterialSpinner()
    var fieldCollection  = [UITextField]()
    let bottomViewHeight : CGFloat = 80
    var controller:RegisterVC!
    var checkTOC = false
    var isSecure: Bool = true
    
    override func darkModeChange() {
        super.darkModeChange()
        self.termsBgView.customColorsUpdate()
        self.firstNameBgView.customColorsUpdate()
        self.lastNameBgView.customColorsUpdate()
        self.emailBgView.customColorsUpdate()
        self.countryBgView.customColorsUpdate()
        self.mobileBgView.customColorsUpdate()
        self.passwordBgView.customColorsUpdate()
        self.cityBgview.customColorsUpdate()
        self.referalBgView.customColorsUpdate()
        self.contentBgView.customColorsUpdate()
        self.bgView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.registerUrInfo.customColorsUpdate()
        self.txtFldFirstName.customColorsUpdate()
        self.txtFldLastName.customColorsUpdate()
        self.txtFldEmail.customColorsUpdate()
        self.txtFldPassword.customColorsUpdate()
        self.txtFldPhoneNo.customColorsUpdate()
        self.txtFieldReferal.customColorsUpdate()
        self.lblDialCode.customColorsUpdate()
        self.cityField.customColorsUpdate()
        self.setNoAccountBtn()
    }
    
    //MARK: - Life Cycles
       override func didLoad(baseVC: BaseVC) {
           super.didLoad(baseVC: baseVC)
           self.controller = baseVC as? RegisterVC
        self.initView()
        self.passwordVisibleIV.image = #imageLiteral(resourceName: "visible")
//        secureButton.setImage(#imageLiteral(resourceName: "visible"), for: .normal)
        self.loginBtn.isUserInteractionEnabled = false
        self.loginBtn.backgroundColor = .TertiaryColor
        self.minimumPasswordErrorLAbel.isHidden = true
        self.minimumPasswordErrorLAbel.text = LangCommon.passwordValidationMsg
        self.darkModeChange()
       }
       override func willAppear(baseVC: BaseVC) {
            super.willAppear(baseVC: baseVC)
        self.checkImgView.image =  self.checkTOC ? UIImage(named: Images.radioSelected) : UIImage(named: Images.radioUnselected)
       }
       override func didAppear(baseVC: BaseVC) {
           super.didAppear(baseVC: baseVC)
       }
       
   // MARK: - Initializers
    func initView() {
        self.passwordVisibleIV.addAction(for: .tap) {
            self.secureButtonTapped()
        }
        
        self.errorEmailLbl.isHidden = true
        self.errorEmailLbl.text = LangCommon.pleaseEnterValidEmail
        self.txtFldFirstName.delegate = self
        self.txtFldLastName.delegate = self
        self.txtFldPassword.delegate = self
        self.txtFldPassword.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        self.txtFieldReferal.delegate = self
        self.txtFldEmail.delegate = self
        self.txtFldPhoneNo.delegate = self
        self.cityField.delegate = self
        self.terms_and_condition.delegate = self
        if isRTLLanguage{
            self.txtFldFirstName.textAlignment = .right
            self.txtFldLastName.textAlignment = .right
            self.txtFldPassword.textAlignment = .right
            self.txtFieldReferal.textAlignment = .right
            self.txtFldEmail.textAlignment = .right
            self.cityField.textAlignment = .right
            self.txtFldPhoneNo.textAlignment = .right
            self.terms_and_condition.textAlignment = .right
        } else{
            self.txtFldFirstName.textAlignment = .left
            self.txtFldLastName.textAlignment = .left
            self.txtFldPassword.textAlignment = .left
            self.txtFieldReferal.textAlignment = .left
            self.txtFldEmail.textAlignment = .left
            self.cityField.textAlignment = .left
            self.txtFldPhoneNo.textAlignment = .left
            self.terms_and_condition.textAlignment = .left
        }
        self.loginBtn.setTitle(LangCommon.register.capitalized, for: .normal)
        self.registerUrInfo.text = LangCommon.register.capitalized
        self.txtFldFirstName.placeholder = LangCommon.firstName
        self.txtFldLastName.placeholder = LangCommon.lastName
        self.txtFldPassword.placeholder = LangCommon.password.lowercased().capitalized
        self.txtFieldReferal.placeholder = LangCommon.referral
        self.txtFldEmail.placeholder = LangCommon.nameEmail
        self.cityField.placeholder = LangCommon.city
        
        if #available(iOS 10.0, *) {
            txtFldFirstName.keyboardType = .asciiCapable
            txtFldLastName.keyboardType = .asciiCapable
            txtFldPassword.keyboardType = .asciiCapable
            txtFldEmail.keyboardType = .emailAddress
            txtFldPhoneNo.keyboardType = .asciiCapableNumberPad
            txtFieldReferal.keyboardType = .asciiCapable
            cityField.keyboardType = .asciiCapable
        } else {
            // Fallback on earlier versions
            txtFldFirstName.keyboardType = .default
            txtFldLastName.keyboardType = .default
            txtFldPassword.keyboardType = .default
            txtFldEmail.keyboardType = .emailAddress
            txtFldPhoneNo.keyboardType = .numberPad
            txtFieldReferal.keyboardType = .default
            cityField.keyboardType = .default
        }
        self.txtFieldReferal.isSecureTextEntry = false
        self.setCountryFlatAndDialCode()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        self.setUserInfo()
        self.setHyperLink()
        if !Shared.instance.isReferralEnabled(){
            self.txtFieldReferal.isHidden = true
            self.referalStack.isHidden = true
        }
    }
    
    // MARK: - Buttons Actions And TextField delegate methods

    @IBAction private func textFieldDidChange(textField: UITextField) {
        
        if textField.tag  == 3 {
            if let text = textField.text , text.count > 0 {
                self.errorEmailLbl.isHidden = UberSupport().isValidEmail(testStr: text)
            } else {
                self.errorEmailLbl.isHidden = true
            }
        }
        
        
        self.checkNextButtonStatus()
    }
    
    
    @IBAction func checkImgBtnAction(_ sender: Any) {
        self.checkTOC = !checkTOC
        self.checkImgView.image =  self.checkTOC ? UIImage(named: Images.radioSelected) : UIImage(named: Images.radioUnselected)
        self.checkNextButtonStatus()
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        //TRVicky
        self.controller.commonAlert.setupAlert(alert: LangCommon.areYouSure, okAction: LangCommon.ok.uppercased(), cancelAction: LangCommon.cancel)
       
        self.controller.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            if self.controller.isPresented(){
                   self.controller.dismiss(animated: true, completion: nil)
                       }else{
                   self.controller.navigationController?.popViewController(animated: true)
            }
        }
      
    }
  
    @IBAction func onNextTapped(_ sender:UIButton!)
    {
        if(!checkTOC){
            AppUtilities().customCommonAlertView(titleString: "", messageString: "Agree the terms & Conditions, Privacy Policy to continue.")
        }else{
            addProgress()
            self.endEditing(true)
            self.loginBtn.isUserInteractionEnabled = false
            var params = Parameters()
            params["first_name"]    = txtFldFirstName.text!
            params["last_name"]    = txtFldLastName.text!
            params["password"]    = txtFldPassword.text!
            params["mobile_number"]    = txtFldPhoneNo.text!
            params["email_id"]    = txtFldEmail.text!
            params["referral_code"] = txtFieldReferal.text
            params["city"] = cityField.text!
            let strDeviceType = "1"
            let strDeviceToken = Shared.instance.getDeviceToken()
            let strUserType = "Driver"
            params["new_user"] = "1"
          //  params["device_id"] = strDeviceToken
            params["device_id"] = Constants().GETVALUE(keyname: USER_DEVICE_TOKEN)//strDeviceToken
            params["device_type"] = strDeviceType
            params["user_type"] = strUserType
            params["auth_type"] = "email"
            params["country_code"] = self.controller.country.country_code
            params["language"] = currentLanguage.key
            self.controller.callSocialSignUpAPI(parms: params)
        }
    }
    
    @IBAction func gotoLoginPage(_ sender: UIButton!) {
        self.endEditing(true)
        self.controller.navigationController?.popToRootViewController(animated: false)
        self.controller.welcomeNavigation?.navigateToLoginVC()
    }
    
    func setNoAccountBtn() {
        let text = LangCommon.haveAnAccount == "" ? "Have an account ?" : LangCommon.haveAnAccount
        self.noAccBtn.isHidden = false
        let haveAccount : NSMutableAttributedString = NSMutableAttributedString()
            .normal(text + " ",fontSize: 14)
            .underlined(LangCommon.login,fontSize: 14)
        haveAccount.setColorForText(textToFind: LangCommon.login, withColor: .ThemeTextColor)
        haveAccount.setColorForText(textToFind: text, withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
        self.noAccBtn.setAttributedTitle(haveAccount, for: .normal)
    }
   
    func getNextBtnText() -> String{
        return isRTLLanguage ? "e" : "I"
    }
    // setting social loggedin user infomation
    func setUserInfo()
    {
        txtFldPhoneNo.isUserInteractionEnabled = false
        let flag = self.controller.country!
        txtFldPhoneNo.text = self.controller.verified_mobile_number
        let url = URL(string: flag.flag)
        self.imgCountryFlag.sd_setImage(with: url, completed: nil)
        self.imgCountryFlag.contentMode = .scaleToFill
        self.imgCountryFlag.clipsToBounds = true
        self.lblDialCode.text = flag.dial_code
       
    }
    var selectedFlag : CountryModel?
    // GETTING USER CURRENT COUNTRY CODE AND FLAG IMAGE
    func setCountryFlatAndDialCode()
    {
        
        
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let flag = CountryModel(withCountry: countryCode)
            let url = URL(string: flag.flag)
            self.imgCountryFlag.sd_setImage(with: url, completed: nil)
            lblDialCode.text = flag.dial_code
        }
        
        var rect = lblDialCode.frame
        rect.size.width = UberSupport().onGetStringWidth(lblDialCode.frame.size.width, strContent: lblDialCode.text! as NSString, font: lblDialCode.font)
        lblDialCode.frame = rect
        return
    }
    
    //Show the keyboard
    @objc
    func keyboardWillShow(notification: NSNotification) {

    }
    
    //Hide the keyboard
    @objc
    func keyboardWillHide(notification: NSNotification) {

    }
   
    
    // MARK: - TextField Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        

        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtFieldReferal{
            let ACCEPTABLE_CHARACTERS = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = string.components(separatedBy: cs).joined(separator: "")
            return string == filtered
        }
        if  textField == txtFldFirstName || textField == txtFldLastName {
            do {
                                          let regex = try NSRegularExpression(pattern: ".*[^A-Za-z].*", options: [])
                                          if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                                              return false
                                          }
                                      }
                                      catch {
                                          print("ERROR")
                                      }
                                  return true
        }
        if textField == txtFldEmail{
            let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@_."
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                  let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
                  return (string == filtered)
        }
        if textField == txtFldPassword{
            if (textField.text?.count)! >= 17 {
                   let char  = string.cString(using: String.Encoding.utf8)!
                   let backspece = strcmp(char, "\\b")
                   if backspece == -92 {
                       return true
                   }
                   return false
               }
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

    
    @objc func textFieldEditingChanged(sender: UITextField){
        
        if let  password = sender.text
        {
            if let errorMsg = InvalidPassword(password)
            {
                self.minimumPasswordErrorLAbel.text = errorMsg
                self.minimumPasswordErrorLAbel.isHidden = false
            }else{
                self.minimumPasswordErrorLAbel.isHidden = true
            }
        }
//        if sender.text?.count ?? 0  == 0{
//            minimumPasswordErrorLAbel.isHidden = true
//        }else if sender.text?.count ?? 0 < 6{
//            minimumPasswordErrorLAbel.isHidden = false
//        }else{
//            minimumPasswordErrorLAbel.isHidden = true
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        //scrollObjHolder.translatesAutoresizingMaskIntoConstraints = true
        return true
    }
    
    // MARK: - Checking Next Button status
    /*
     Checking all textfield values exist
     and making next button interaction enable/disable
     */
    func checkNextButtonStatus()
    {
        if ((txtFldFirstName.text?.count)!>0 && (txtFldLastName.text?.count)!>0 && ((txtFldEmail.text?.count)!>0 && UberSupport().isValidEmail(testStr: txtFldEmail.text!)) && (txtFldPhoneNo.text?.count)!>3 && (cityField.text?.count)!>0 && (txtFldPassword.text?.count)! > 7 && (txtFldPassword.text?.count)! < 17) && checkTOC == true && !containsDigit(txtFldPassword.text!)
        {
            self.loginBtn.isUserInteractionEnabled = true
            self.loginBtn.backgroundColor = UIColor.PrimaryColor
        }
        else
        {
            self.loginBtn.isUserInteractionEnabled = false
            self.loginBtn.backgroundColor = UIColor.TertiaryColor
        }
    }
    @IBAction func onChangeDialCodeTapped(_ sender:UIButton!) {
        let propertyView = CountryListVC.initWithStory()
          propertyView.delegate = self
        self.controller.navigationController?.pushViewController(propertyView, animated: true)
      }
      
      // CountryListVC Delegate Method
      internal func countryCodeChanged(countryCode:String, dialCode:String, flagImg:String)
      {
          lblDialCode.text = "\(dialCode)"
          let url = URL(string: flagImg)
          self.imgCountryFlag.sd_setImage(with: url, completed: nil)
          
          Constants().STOREVALUE(value: dialCode, keyname: USER_DIAL_CODE)
          Constants().STOREVALUE(value: countryCode, keyname: USER_COUNTRY_CODE)
          
          var rect = lblDialCode.frame
          rect.size.width = UberSupport().onGetStringWidth(lblDialCode.frame.size.width, strContent: dialCode as NSString, font: lblDialCode.font)
          lblDialCode.frame = rect
        if !isRTLLanguage {
              var rectTxtFld = txtFldPhoneNo.frame
              rectTxtFld.origin.x = lblDialCode.frame.origin.x + lblDialCode.frame.size.width + 5
              rectTxtFld.size.width = self.frame.size.width - rectTxtFld.origin.x - 20
              txtFldPhoneNo.frame = rectTxtFld
          }
      }
      
      // MARK: Navigating to Main Map Page
      /*
       After filled all user details validating api will call
       */
        
        // Add progress View
        func addProgress() {
            self.loginBtn.addSubview(spinnerView)
            self.spinnerView.anchor(toView: self.loginBtn,
                                    trailing: -15)
            self.spinnerView.setEqualHightWidthAnchor(toView: self.spinnerView,
                                                      height: 25)
            self.spinnerView.setCenterXYAncher(toView: loginBtn,
                                               centerY: true)
            self.spinnerView.circleLayer.lineWidth = 3.0
            self.spinnerView.circleLayer.strokeColor =  UIColor.PrimaryTextColor.cgColor
            self.spinnerView.beginRefreshing()
        }
        //Remove Progress View
        func removeProgress()
        {
//            loginBtn.titleLabel?.text = NSLocalizedString(NEXT_ICON_NAME, comment: "")
//            loginBtn.setTitle(NSLocalizedString(NEXT_ICON_NAME, comment: ""), for: .normal)
            spinnerView.endRefreshing()
            spinnerView.removeFromSuperview()
        }
    
    @objc
    func secureButtonTapped() {
        self.isSecure = !self.isSecure
        self.passwordVisibleIV.image = self.isSecure ? #imageLiteral(resourceName: "visible") : #imageLiteral(resourceName: "invisible")
        self.txtFldPassword.isSecureTextEntry = self.isSecure
        
    }
    
    func InvalidPassword(_ value: String) -> String?
    {
        if containsDigit(value){
            return LangCommon.passwordWarn
        }
        return nil
    }
    func containsDigit(_ value: String) -> Bool{
//        let regularExpression = ".*[0-9].*"
        let predicate = NSPredicate(format: "SELF MATCHES %@","((?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\"!@#$%&*()_+=/|<>?{}\\[\\].:,~`^-]).{8,16})")
        return !predicate.evaluate(with: value)
    }

}

//MARK:  Hyper link Attribute text
extension RegisterView : TTTAttributedLabelDelegate{
    func setHyperLink(){

        let full_text = "\(LangCommon.iAgreeToThe) \(LangCommon.termsConditions) \(LangCommon.and) \(LangCommon.privacyPolicy)"
        let terms_text = LangCommon.termsConditions
        let privacy_text = LangCommon.privacyPolicy
        self.terms_and_condition.setText(full_text, withLinks: [
            
            HyperLinkModel(url: URL(string: "\(APIBaseUrl)term_conditions")!, string: terms_text),
            HyperLinkModel(url: URL(string: "\(APIBaseUrl)privacy_policy")!, string: privacy_text)
            ])
    }
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}


