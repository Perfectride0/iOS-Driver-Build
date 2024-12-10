//
//  ResetPasswordView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 03/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class ResetPasswordView: BaseView,UITextFieldDelegate{
    
    
    @IBOutlet weak var headerView: HeaderView!
    // MARK: - Outlets
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var txtFldPassword: CommonTextField!
    @IBOutlet weak var passwordFieldErrLblHolderView: SecondaryView!
    @IBOutlet weak var passwordFieldErrLbl: ErrorLabel!
    @IBOutlet weak var confirmPasswordFieldErrLblHolderView: SecondaryView!
    @IBOutlet weak var confirmPasswordFieldErrLbl: ErrorLabel!
    @IBOutlet weak var txtFldConfirmPassword: CommonTextField!
    @IBOutlet weak var viewObjHolder: TopCurvedView!
    @IBOutlet weak var lblErrorMsg: ErrorLabel!
    @IBOutlet weak var closeButtonOutlet: SecondaryTintButton!
    @IBOutlet weak var resetTitleLabel: SecondaryHeaderLabel!
    @IBOutlet weak var confirmPassword: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    
    @IBOutlet weak var cancelPopUpView : TopCurvedView!
    @IBOutlet weak var cancelForgetPasswordTitleLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var yourAccountNotSavedLbl : SecondaryRegularLabel!
    @IBOutlet weak var cancelBtn : PrimaryButton!
    @IBOutlet weak var confirmBtn : SecondaryButton!
    @IBOutlet weak var contentBgView: SecondaryView!
    @IBOutlet weak var passwordBgView: InactiveBorderSecondaryView!
    
    @IBOutlet weak var confirmPasswordBgView: InactiveBorderSecondaryView!
    override func darkModeChange() {
        super.darkModeChange()
        self.headerView.customColorsUpdate()
        self.resetTitleLabel.customColorsUpdate()
        self.viewObjHolder.customColorsUpdate()
        self.contentBgView.customColorsUpdate()
        self.passwordBgView.customColorsUpdate()
        self.passwordFieldErrLblHolderView.customColorsUpdate()
        self.txtFldPassword.customColorsUpdate()
        self.confirmPasswordBgView.customColorsUpdate()
        self.confirmPasswordFieldErrLblHolderView.customColorsUpdate()
        self.txtFldConfirmPassword.customColorsUpdate()
        self.cancelPopUpView.customColorsUpdate()
        self.cancelBtn.customColorsUpdate()
        self.cancelForgetPasswordTitleLbl.customColorsUpdate()
        self.yourAccountNotSavedLbl.customColorsUpdate()
        self.confirmPassword.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.passwordButton.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.confirmBtn.customColorsUpdate()
        self.confirmBtn.cornerRadius = 15
        self.confirmBtn.elevate(2)
    }
    
    // MARK: - Class Variables
    var viewController:ResetPasswordVC!
    var spinnerView = JTMaterialSpinner()
    var isSecurePassword: Bool = true
    var isSecureConfirmPassword: Bool = true
    //MARK:- Life Cycle
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? ResetPasswordVC
        self.txtFldPassword.delegate = self
        
        self.passwordButton.setImage(#imageLiteral(resourceName: "visible"), for: .normal)
        self.confirmPassword.setImage(#imageLiteral(resourceName: "visible"), for: .normal)
        //confirmPassword.imageView?.image = #imageLiteral(resourceName: "invisible")
        
        self.txtFldConfirmPassword.delegate = self
        if isRTLLanguage{
            self.btnSignIn.setTitle("e", for: .normal)
            self.txtFldPassword.textAlignment = .right
            self.txtFldConfirmPassword.textAlignment = .right
        }else{
            self.btnSignIn.setTitle("I", for: .normal)
            self.txtFldPassword.textAlignment = .left
            self.txtFldConfirmPassword.textAlignment = .left
        }
        if #available(iOS 10.0, *) {
            txtFldPassword.keyboardType = .asciiCapable
        } else {
            // Fallback on earlier versions
            txtFldPassword.keyboardType = .asciiCapable
        }
        
        //        if appDelegate.language == "ja" {
        //            closeButtonOutlet.setTitle("CLOSE".localize, for: .normal)
        //            resetTitleLabel.text = "RESET PASSWORD".localize
        //            txtFldPassword.placeholder = "PASSWORD".localize
        //            txtFldConfirmPassword.placeholder = "CONFIRM PASSWORD".localize
        //
        //        }
        //   self.appDelegate.registerForRemoteNotification()
        AppDelegate.shared.pushManager.registerForRemoteNotification()
        self.viewController.navigationController?.isNavigationBarHidden = true
        btnSignIn.layer.cornerRadius = btnSignIn.frame.size.width / 2
        
        //
        lblErrorMsg.isHidden = true
        txtFldConfirmPassword.setLeftPaddingPoints(10)
        txtFldConfirmPassword.setRightPaddingPoints(10)
        
        txtFldPassword.setLeftPaddingPoints(10)
        txtFldPassword.setRightPaddingPoints(10)
        txtFldPassword.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.initView()
        self.initLanguage()
        self.darkModeChange()
    }
    
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
    }
    override func didAppear(baseVC: BaseVC) {
        super.didAppear(baseVC: baseVC)
    }
    // MARK:- init View
    func initView() {
        self.checkNextButtonStatus()
        self.passwordFieldErrLblHolderView.isHidden = true
        self.confirmPasswordFieldErrLblHolderView.isHidden = true
    }
    //MARK:- init Language
    func initLanguage(){
        self.resetTitleLabel.text = LangCommon.resetPassword.capitalized
        self.txtFldPassword.placeholder = LangCommon.enterYourNewPassword.capitalized
        self.txtFldConfirmPassword.placeholder = LangCommon.enterYourConformPassword.capitalized
        self.passwordFieldErrLbl.text = LangCommon.passwordValidationMsg
        self.confirmPasswordFieldErrLbl.text = LangCommon.passwordValidationMsg
        self.cancelForgetPasswordTitleLbl.text = LangCommon.cancel
            + " "
            + LangCommon.resetPassword
        self.yourAccountNotSavedLbl.text = LangCommon.infoNotSaved
        self.cancelBtn.setTitle(LangCommon.cancel.uppercased(), for: .normal)
        self.confirmBtn.setTitle(LangCommon.confirm.uppercased(), for: .normal)
    }
    //Dissmiss the keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
    }
    
    // MARK: TextField Delegate Method
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
        let isActivepass = (txtFldPassword.text?.count)! > 7 && (txtFldPassword.text?.count)! < 17 && !containsDigit(txtFldPassword.text!)
        let isActiveConfirm = (txtFldConfirmPassword.text?.count)! > 7 && (txtFldConfirmPassword.text?.count)! < 17 && !containsDigit(txtFldConfirmPassword.text!)
        if textField.tag == 1 {
            self.passwordFieldErrLblHolderView.isHidden = isActivepass//(txtFldPassword.text?.count)!>5 || textField.text?.count == 0
        } else if textField.tag == 2 {
            self.confirmPasswordFieldErrLblHolderView.isHidden = isActiveConfirm//(txtFldConfirmPassword.text?.count)!>5 || textField.text?.count == 0
        } else {
            
        }
        self.checkNextButtonStatus()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
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
    // MARK: - Checking Next Button status
    /*
     new & confirm Password filled or not
     and making user interaction enable/disable
     */
    func checkNextButtonStatus() {
        
        let isActivepass = (txtFldPassword.text?.count)! > 7 && (txtFldPassword.text?.count)! < 17 && !containsDigit(txtFldPassword.text!)
        let isActiveConfirm = (txtFldConfirmPassword.text?.count)! > 7 && (txtFldConfirmPassword.text?.count)! < 17 && !containsDigit(txtFldConfirmPassword.text!)
        btnSignIn.backgroundColor = (isActivepass && isActiveConfirm) ? .PrimaryColor : .TertiaryColor
        btnSignIn.isUserInteractionEnabled = isActivepass && isActiveConfirm
//        
//        if (txtFldConfirmPassword.text?.count)!>5 && (txtFldPassword.text?.count)!>5 {
//            btnSignIn.backgroundColor = .PrimaryColor
//            btnSignIn.isUserInteractionEnabled = true
//        } else {
//            btnSignIn.backgroundColor = .TertiaryColor
//            btnSignIn.isUserInteractionEnabled = false
//        }
    }
    
    func containsDigit(_ value: String) -> Bool{
//        let regularExpression = ".*[0-9].*"
        let predicate = NSPredicate(format: "SELF MATCHES %@","((?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\"!@#$%&*()_+=/|<>?{}\\[\\].:,~`^-]).{8,16})")
        return !predicate.evaluate(with: value)
    }
    
    // MARK: API CALLING - UDPATE NEW PASSWORD
    /*
     After filled new & confirm Password
     */
    @IBAction func onSignInTapped(_ sender:UIButton!) {
        
        self.endEditing(true)
        if txtFldConfirmPassword.text != txtFldPassword.text {
            self.viewController.presentAlertWithTitle(title: LangCommon.passwordMismatch.capitalized, message: "", options: LangCommon.ok.capitalized) { (finished) in
                
            }
            //            lblErrorMsg.isHidden = false
            //            lblErrorMsg.text = "Password Mismatch".localize
            return
        }
        if !isSimulator {
            if !(UIApplication.shared.isRegisteredForRemoteNotifications)
            {
                //TRVicky
                self.viewController.commonAlert.setupAlert(alert: LangCommon.message,
                                                           alertDescription: LangCommon.pleaseEnablePushNotification,
                                                           okAction: LangCommon.ok.uppercased())
                self.viewController.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                    AppDelegate.shared.pushManager.registerForRemoteNotification()
                }
                
                return
            }
        }
        addProgress()
        spinnerView.beginRefreshing()
        
        var dicts = JSON()
        dicts["mobile_number"] = String(format:"%@",viewController.strMobileNo)
        dicts["country_code"] = self.viewController.countryModel.country_code//String(format:"%@",Constants().GETVALUE(keyname: USER_COUNTRY_CODE))
        dicts["password"] = String(format:"%@",txtFldPassword.text!)
        self.viewController.resetPasswordApiCall(params: dicts)
    }
    
    func showPage()
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set("driver", forKey:"getmainpage")
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.onSetRootViewController(viewCtrl: self.viewController)
        if Constants().GETVALUE(keyname: USER_PAYPAL_EMAIL_ID).count == 0
        {
        }
        else
        {
            let userDefaults = UserDefaults.standard
            userDefaults.set("driver", forKey:"getmainpage")
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            appDelegate.onSetRootViewController(viewCtrl: self.viewController)
        }
        return
    }
    
    // NAVIGATE TO DOCUMENT PAGE
    /*
     IF USER NOT UPLODING DOCUMENT
     */
    
    
    // NAVIGATE TO ADD VEHICLE DETAILS PAGE
    /*
     IF USER NOT UPDATING HIS VEHICLE DETAILS
     */
   
    
    func addProgress() {
        lblErrorMsg.isHidden = true
        self.btnSignIn.isUserInteractionEnabled = false
        self.btnSignIn.addSubview(spinnerView)
        self.spinnerView.anchor(toView: self.btnSignIn,
                                trailing: -15)
        self.spinnerView.setEqualHightWidthAnchor(toView: self.spinnerView,
                                                  height: 25)
        self.spinnerView.setCenterXYAncher(toView: btnSignIn,
                                           centerY: true)
        self.spinnerView.circleLayer.lineWidth = 3.0
        self.spinnerView.circleLayer.strokeColor =  UIColor.PrimaryTextColor.cgColor
        self.spinnerView.beginRefreshing()
        btnSignIn.titleLabel?.text = ""
        btnSignIn.setTitle("", for: .normal)
    }
    
    func removeProgress()
    {
        self.btnSignIn.isUserInteractionEnabled = true
        if isRTLLanguage{
            self.btnSignIn.setTitle("e", for: .normal)
        } else {
            self.btnSignIn.setTitle("I", for: .normal)
        }
        spinnerView.endRefreshing()
        spinnerView.removeFromSuperview()
    }
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.endEditing(true)
        self.addSubview(cancelPopUpView)
        self.setUpCancelPopup()
        self.cancelPopUpAnimation(isBegin: true)
        self.bringSubviewToFront(cancelPopUpView)
    }
    
    @IBAction func cancelBtnPressed(_ sender:UIButton!) {
        self.cancelPopUpAnimation(isBegin: false)
    }
    
    @IBAction func confirmBtnPressed(_ sender:UIButton!) {
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    
    func set(UserInteraction : Bool) {
        self.txtFldPassword.isUserInteractionEnabled = UserInteraction
        self.txtFldConfirmPassword.isUserInteractionEnabled = UserInteraction
        self.backBtn?.isUserInteractionEnabled = UserInteraction
    }
    
    func cancelPopUpAnimation(isBegin: Bool) {
        self.cancelPopUpView.frame.origin.y = isBegin ? self.frame.maxY : self.cancelPopUpView.frame.minY
        UIView.animate(withDuration: 0.7) {
            self.cancelPopUpView.frame.origin.y = isBegin ? self.frame.maxY - 200 : self.frame.maxY + 200
        } completion: { (completedTheAnimation) in
            self.set(UserInteraction: !isBegin)
            if !isBegin { self.cancelPopUpView.removeFromSuperview() }
        }
    }
    
    func setUpCancelPopup() {
        self.cancelPopUpView.translatesAutoresizingMaskIntoConstraints = false
        self.cancelPopUpView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.cancelPopUpView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.cancelPopUpView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.cancelPopUpView.heightAnchor.constraint(equalToConstant: 210).isActive = true
    }
    
    @IBAction func confirmPasswordAction(_ sender: Any) {
        self.isSecureConfirmPassword = !self.isSecureConfirmPassword
        self.confirmPassword.setImage(self.isSecureConfirmPassword ? UIImage(named: "visible") : UIImage(named: "invisible") ,
                                      for: .normal)
        self.txtFldConfirmPassword.isSecureTextEntry = self.isSecureConfirmPassword
    }
    
    @IBAction func passwordAction(_ sender: Any) {
        self.isSecurePassword = !self.isSecurePassword
        self.passwordButton.setImage(self.isSecurePassword ? UIImage(named: "visible") : UIImage(named: "invisible") ,
                                      for: .normal)
        self.txtFldPassword.isSecureTextEntry = self.isSecurePassword
    }
}
