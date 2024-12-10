//
//  DriverWalletView.swift
//  DriverWallet
//
//  Created by trioangle on 24/08/22.
//

//
//  PayToGoferView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 05/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import PaymentHelper
class DriverWalletView: BaseView {
    
    //PayToGoferVc
    @IBOutlet weak var refrealStack : UIStackView!
    @IBOutlet weak var changePaymentView : UIStackView!
    @IBOutlet weak var sampleLabel : UILabel!
    @IBOutlet weak var applybtn: PrimaryButton!
    @IBOutlet weak var giftcardfield: CommonTextField!
    @IBOutlet weak var contentCurvedHolderView: TopCurvedView!
    @IBOutlet weak var bottomCurvedHolderView: TopCurvedView!
    @IBOutlet weak var bgView: SecondaryView!
    @IBOutlet weak var lblTitle: SecondaryHeaderLabel!
    @IBOutlet weak var lbltext: SecondaryRegularLabel!
    @IBOutlet weak var lblAmount: SecondarySubHeaderLabel!
    @IBOutlet weak var payAmtView: UIView!
    @IBOutlet weak var payToGoferBtn : UIButton!
    @IBOutlet weak var scrollHolder: UIScrollView!
    @IBOutlet weak var topView: HeaderView!
    //payAmtView
    @IBOutlet weak var paytoGoferIcon: UIImageView!
    @IBOutlet weak var viewNextHolder: TopCurvedView!
    @IBOutlet weak var amountField: CommonTextField!
    @IBOutlet weak var paymentTypeImage: UIImageView!
    @IBOutlet var paymentTypeName: SecondaryRegularLabel!
    @IBOutlet weak var changeButton: TransparentPrimaryButton!
    @IBOutlet weak var hideViewBtn: UIButton!
    @IBOutlet weak var enterTheAmountLbl: SecondaryHeaderLabel!
    @IBOutlet weak var payBtn: PrimaryButton!
    @IBOutlet var currencyLabel: SecondaryTextFieldTypeLabel!
    @IBOutlet weak var ReferralLabel: ThemeButtonTypeLabel!
    @IBOutlet weak var ReferralAmtLbl: SecondarySmallBoldLabel!
    @IBOutlet weak var checkBox: PrimaryTintButton!
    @IBOutlet weak var Restrictlbl: SecondarySubHeaderLabel!
    
    var checkBoxAction : Bool = false
    
    override func darkModeChange() {
        super.darkModeChange()
        self.topView.customColorsUpdate()
        self.lblTitle.customColorsUpdate()

        self.contentCurvedHolderView.customColorsUpdate()
        self.bottomCurvedHolderView.customColorsUpdate()
        self.bgView.customColorsUpdate()
        self.amountField.customColorsUpdate()
        self.lbltext.customColorsUpdate()
        self.lbltext.font =  UIFont(name: G_RegularFont, size: 16)
        self.lblAmount.customColorsUpdate()
        self.lblAmount.font =  UIFont(name: G_BoldFont, size: 16)
        self.Restrictlbl.customColorsUpdate()
        self.Restrictlbl.font =  UIFont(name: G_BoldFont, size: 18)
        self.viewNextHolder.customColorsUpdate()
        self.paymentTypeName.customColorsUpdate()
        self.enterTheAmountLbl.customColorsUpdate()
        self.currencyLabel.customColorsUpdate()
        self.paymentTypeImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.paytoGoferIcon.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.checkBox.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.ReferralAmtLbl.customColorsUpdate()
       
    }
    
    let strCurrency = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
    var currency = ""
    var walletAmount = ""
    var request_restriction_content = ""
    var is_pending_amount = Bool()
    var minimum_balance_content = ""
    let preference = UserDefaults.standard
    var brainTree : BrainTreeProtocol?
    var stripeHandler : StripeHandler?
    var viewController: DriverWalletVC!
    let checked = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
    let unchecked = UIImage(named: "unchecked")?.withRenderingMode(.alwaysTemplate)
    
    // MARK: - ViewController Methods
    var oweAmount = ""{
        didSet{
            print(oweAmount)
        }
    }
    var amountSendable = ""{
        didSet{
            print(amountSendable)
        }
    }
    var referralEarnings = ""{
        didSet{
            print(referralEarnings)
        }
    }
    var deductedAmt = ""{
        didSet{
            print(deductedAmt)
        }
    }
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? DriverWalletVC
        self.initView()
        self.darkModeChange()
    }
    

    fileprivate func initView() {
        if self.viewController.companyID != nil{
          //  self.payToGoferBtn.isHidden = true
        }
        if UserDefaults.isNull(for: .payment_method) {
            PaymentOptions.paypal.setAsDefault()
        }
        
        amountField.delegate = self
        self.viewController.tabBarController?.tabBar.isHidden = true
        self.initLocalization()
        //self.initTextSetup()
        self.checkBox.setImage(unchecked,
                               for: .normal)
       // self.payBtn.btnOperations(to: .off)
        self.stripeHandler = StripeHandler(viewController)
        amountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: [.editingDidBegin,.editingChanged])
        self.initPayAmountView()
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewController.dismissKeyboard))
//        self.addGestureRecognizer(tap)
      //  NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide1), name: UIResponder.keyboardWillHideNotification, object: nil)

        if #available(iOS 10.0, *) {
            amountField.keyboardType = .decimalPad
        } else {
            // Fallback on earlier versions
            amountField.keyboardType = .decimalPad
        }
    }
    
    
    func initTextSetup(){
        let walletamount = self.oweAmount
        let intBal = Double(walletamount) ?? 0
        print("AA",intBal)
        if intBal.isZero == true{
//            self.payToGoferBtn.isUserInteractionEnabled = false
//            self.payToGoferBtn.backgroundColor = .TertiaryColor
        }
        currencyLabel.text = strCurrency
        lblTitle.text =  LangCommon.wallet
        lbltext.text = LangCommon.wallet_amount
        self.Restrictlbl.text = request_restriction_content
        if is_pending_amount == true{
            self.sampleLabel.isHidden = false
            self.sampleLabel.text = minimum_balance_content
            self.sampleLabel.textColor = UIColor.red
            self.sampleLabel.font = UIFont(name: G_BoldFont, size: 12)
        }else{
            self.sampleLabel.isHidden = true
        }
     
        
        print("\(self.oweAmount)")
        if self.oweAmount == "" {
            lblAmount.text = String(format: "\(strCurrency) %.2f", 0)
        } else {
            lblAmount.text = String(format: "\(strCurrency) %.2f", intBal)
        }
    }
    
  
    
    // MARK: When User Press Add Button
    @IBAction func payToGoferBtnTapped(_ sender: Any) {
        self.payToAdminView(show: true)
    }
    
    func payToAdminView(show: Bool) {
        self.payAmtView.isHidden = false
        let oldInteraction = payAmtView.isUserInteractionEnabled
        let initalColor = UIColor.clear
        let finalColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        if show {
            self.payAmtView.frame = self.frame
            self.addSubview(self.payAmtView)
            self.payAmtView.anchor(toView: self,
                                   leading: 0,
                                   trailing: 0,
                                   top: 0,
                                   bottom: 0)
            self.bringSubviewToFront(self.payAmtView)
        }
        payAmtView.backgroundColor = show ? initalColor : finalColor
        payAmtView.transform = show ? CGAffineTransform(translationX: 0,
                                                        y: self.frame.size.height) : .identity
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.payAmtView.backgroundColor = show ? finalColor : initalColor
            self.payAmtView.transform = !show ? CGAffineTransform(translationX: 0,
                                                                  y: self.frame.size.height) : .identity
        } completion: { isComplete in
            if !show && isComplete {
                self.amountField.text = ""
             //   self.payToGoferBtn.isUserInteractionEnabled = oldInteraction
                self.payAmtView.removeFromSuperview()
            }
        }
    }
    
    func hideView() {
        let oldColor = payAmtView.backgroundColor
        let oldInteraction = payAmtView.isUserInteractionEnabled
        UIView.animateKeyframes(withDuration: 0.8, delay: 0.15, options: [.layoutSubviews], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5/3, animations: {
                self.payAmtView.backgroundColor = .clear
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.payAmtView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
            })
        }, completion: { (_) in
            self.payAmtView.transform = .identity
            self.payAmtView.backgroundColor = oldColor
           // self.payToGoferBtn.isUserInteractionEnabled = oldInteraction
            self.payAmtView.isHidden = true
            self.amountField.text = ""
        })
    }
    // MARK:  back button
    @IBAction func backAction(_ sender: Any) {
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Pay Button Tapped
    @IBAction func payButtonTapped(_ sender :Any){
        self.endEditing(true)
        if let text = self.amountField.text,
            let amount = Double(text){
            if Shared.instance.isWebPayment{
                self.wsToWebPaytoAdmin(amount, payKey: nil)
            }
            else{
                if PaymentOptions.default == .stripe{
                    self.viewController.wsMethodToUpdateWalletAmount(using: nil)
                }else{
                    self.viewController.methodConvetCurrency(for: amount)
                }
            }
        } else {
            appDelegate.createToastMessage(LangCommon.enterTheAmount, bgColor: UIColor.black, textColor: UIColor.white)
        }
    }
    
    func wsToWebPaytoAdmin(_ enteredAmount : Double,payKey : String?){
        let referalAmount = UserDefaults.standard.bool(forKey: "DEDUCTION") ? "1" : "0"
        var paramForPayToAdmin = [String:Any]()
        paramForPayToAdmin["applied_referral_amount"] = referalAmount
        paramForPayToAdmin["payment_type"]  = PaymentOptions.default?.paramValue.lowercased() ?? "paypal"
        paramForPayToAdmin["amount"] = enteredAmount
        
        if let key = payKey{
            paramForPayToAdmin["pay_key"] = key
        }
        let paymentType =  PaymentOptions.default?.paramValue.lowercased() ?? "paypal"
        let token = preference.string(forKey: USER_ACCESS_TOKEN)!
        var mode = ""
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            mode = self.isDarkStyle ? "dark" : "light"
        } else {
            // Fallback on earlier versions
            mode = "light"
        }
        let UrlString = "\(APIBaseUrl + "api/" + APIEnums.webPayment.rawValue)?amount=\(enteredAmount)&payment_type=\(paymentType)&token=\(token)&applied_referral_amount=\(referalAmount)&pay_for=wallet&mode=\(mode)"
        let webVC = LoadWebKitView.initWithStory()
        webVC.strWebUrl = UrlString
        self.viewController.navigationController?.pushViewController(webVC, animated: true)
       
    }
    var enteredAmount : Double?
    func handleCurrencyConversion(response amount: Double,
                                  currency : String?,
                                  key : String ){
        switch PaymentOptions.default {
        case .brainTree:
            self.viewController.authenticateBrainTreePayment(for: amount, using: key)
        case .paypal:
//            self.paypalHandler?.makePaypal(payentOf: amount,
//                                           currency: currency ?? "USD",
//                                           for: .wallet)
            self.viewController.authenticatePaypalPayment(for: amount,currency: currency ?? "USD",using: key)
        default:
            break
        }
    }
    
    @IBAction func changeAction(_ sender: UIButton) {
        
        let paymentPickingVC = ChangePaymentVC.initWithStory(showingPaymentMethods: true, wallet: false, promotions: false)
        paymentPickingVC.paymentSelectionDelegate = self as paymentMethodSelection
        self.viewController.presentInFullScreen(paymentPickingVC, animated: true, completion: nil)
    }
   
    
    
    
    
    //GOTO WALLECT PAGE
    func gotoPayToGofer() {
        let stry = UIStoryboard(name: "Payment", bundle: nil)
        let propertyView = stry.instantiateViewController(withIdentifier: "PayToGoferVCID") as! PayToGoferVC
        self.viewController.navigationController?.pushViewController(propertyView, animated: true)
    }
    
    // HIDE THE ADDWALLECT AMOUNT
    @IBAction func hideView(_ sender:Any) {
        self.payToAdminView(show: false)
        let oldColor = payAmtView.backgroundColor
        UIView.animateKeyframes(withDuration: 0.8, delay: 0.15, options: [.layoutSubviews], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5/3, animations: {
                self.payAmtView.backgroundColor = .clear
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.payAmtView.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
            })
        }, completion: { (_) in
            self.payAmtView.transform = .identity
            self.payAmtView.backgroundColor = oldColor
            self.payAmtView.isUserInteractionEnabled = true
            self.payAmtView.isHidden = true
            self.amountField.text = ""
        })
    }
    
    //MARK: initializers
    func initLocalization(){
        self.payToGoferBtn.setTitle(LangCommon.addAmount.uppercased(),
                                    for: .normal)
        
        self.lblTitle.text = LangCommon.wallet_amount
        self.lbltext.text = LangCommon.wallet_amount
        self.payBtn.setTitle(LangCommon.addAmount.uppercased(), for: .normal)
        
        self.enterTheAmountLbl.text = LangCommon.enterTheAmount
        
    }
    
    func initPayAmountView(){
        
        if Shared.instance.isWebPayment {
            self.changePaymentView.isHidden = true
        } else {
            self.changePaymentView.isHidden = false
        }
        self.amountField.setTextAlignment()
     //   self.amountField.placeholder = String(format: "%.2f",
                        //                      Double(oweAmount) ?? 0)
        let refAmt = Double(self.referralEarnings) ?? 0
        
        if !refAmt.isZero {
            self.ReferralLabel.isHidden = false
            self.ReferralAmtLbl.isHidden = false
            self.refrealStack.isHidden = false
//            self.viewController.referralSlideConstraint.constant = 70
            self.ReferralLabel.text = "\(LangCommon.referralAmount.uppercased() )"
            self.ReferralAmtLbl.text = "\(self.strCurrency)\(self.referralEarnings)"
            self.checkBox.isUserInteractionEnabled = true
            self.checkBox.isHidden = false
            
        }else{
//            self.viewController.referralSlideConstraint.constant = 20
            self.refrealStack.isHidden = true
            self.checkBox.isUserInteractionEnabled = false
            self.checkBox.isHidden = true
            self.ReferralLabel.isHidden = true
            self.ReferralAmtLbl.isHidden = true
            
        }
        
        self.bringSubviewToFront(self.topView)
        self.payAmtView.addAction(for: .tap) {
//            self.payAmtView.isHidden = true
            self.payToAdminView(show: false)
            self.viewController.dismissKeyboard()
            self.amountField.text = ""
            self.payToGoferBtn.isUserInteractionEnabled = true
            self.checkBoxAction = false
            UserDefaults.standard.set(false, forKey: "DEDUCTION")
        }
        self.viewNextHolder.addAction(for: .tap) {
            
        }
        
//        payAmtView.isHidden = true
        self.changeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
        
        
    }
    
   
    //Show the keyboard
    @objc
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.payAmtView.transform = CGAffineTransform(translationX: 0,
                                                          y: UIDevice.current.hasNotch ? -(keyboardFrame.height + 34) :    -keyboardFrame.height)
        }
        //        UberSupport().keyboardWillShowOrHideForView(keyboarHeight: keyboardFrame.size.height, btnView: self.payAmtView)
    }
    //Hide the keyboard

    @objc
    func keyboardWillHide1(notification: NSNotification) {
        //        UberSupport().keyboardWillShowOrHideForView(keyboarHeight: 0, btnView: self.payAmtView)
        self.payToAdminView(show: false)
    }
}
extension DriverWalletView : paymentMethodSelection{
    
    func brainTree_isSelected() {
        self.changeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
        //self.paymentTypeImage.image = UIImage(named: "braintree")
        self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)),
                                          placeholderImage: UIImage(named: "braintree")?.withRenderingMode(.alwaysOriginal), completed: nil)
        self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
        self.paymentTypeName.text = UserDefaults.value(for: .brain_tree_display_name) ?? LangCommon.onlinepayment.capitalized
        self.preference.set(true, forKey: STRIPE_WALLET_PAYMENT)
        self.paymentTypeImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    
    
    func cash_isSelected() {
        
        self.changeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
        self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
        self.paymentTypeImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
//    func creditCard_isSelected(){
//        self.changeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
//        preference.set(false, forKey: STRIPE_WALLET_PAYMENT)
//        //self.paymentTypeImage.image = UIImage(named: "paypalnew")
//        self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: UIImage(named: "card_visa")?.withRenderingMode(.alwaysTemplate), completed: nil)
//        self.paymentTypeName.text = LangCommon.paypal.capitalized
//        self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
//        self.paymentTypeImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
//    }
    func paypal_isSelected() {
        self.changeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
        preference.set(false, forKey: STRIPE_WALLET_PAYMENT)
        //self.paymentTypeImage.image = UIImage(named: "paypalnew")
        self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: UIImage(named: "paypalnew")?.withRenderingMode(.alwaysTemplate), completed: nil)
        self.paymentTypeName.text = LangCommon.paypal.capitalized
        self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
        self.paymentTypeImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    func onlinepayment_isSelected() {
        self.changeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
        preference.set(false, forKey: STRIPE_WALLET_PAYMENT)
        self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: UIImage(named: "onlinePay")?.withRenderingMode(.alwaysTemplate), completed: nil)
        self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
        self.paymentTypeName.text = LangCommon.onlinePay.capitalized
        self.paymentTypeImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    func stripe_isSelected() {
        self.changeButton.setTitle(LangCommon.change.uppercased(), for: .normal)
        preference.set(true, forKey: STRIPE_WALLET_PAYMENT)
        if  UserDefaults.standard.bool(forKey: "CARD_DETAILS_GIVEN") == true{
            guard let brand : String = UserDefaults.value(for: .card_brand_name) else {return}
            guard let last4 : String = UserDefaults.value(for: .card_last_4) else {return}
           // Commmented Because of the Card Change Image
//            self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: self.viewController.getCardImage(forBrand: brand), completed: nil)
            self.paymentTypeImage.image = self.viewController.getCardImage(forBrand: brand)
            self.paymentTypeName.text = "**** "+last4
            
        }else{
           // self.paymentTypeImage.image = UIImage(named: "card_basic")
            self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: UIImage(named: "card_basic")?.withRenderingMode(.alwaysTemplate), completed: nil)
            self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
            self.paymentTypeName.text = LangCommon.addCard.uppercased()
            self.preference.set(false, forKey: STRIPE_WALLET_PAYMENT)
        }
        
        self.paymentTypeImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }

    
    
    func updatePaymentOption(){
        switch PaymentOptions.default {
        case .paypal:
            //self.paymentTypeImage.image = UIImage(named: "paypal")
            self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: UIImage(named: "paypal")?.withRenderingMode(.alwaysTemplate), completed: nil)
            self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
            self.paymentTypeName.text = LangCommon.paypal.uppercased()
            self.preference.set(false, forKey: STRIPE_WALLET_PAYMENT)
        case .onlinepayment:
            //self.paymentTypeImage.image = UIImage(named: "paypal")
            self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: UIImage(named: "onlinePay")?.withRenderingMode(.alwaysTemplate), completed: nil)
            self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
            self.paymentTypeName.text = LangCommon.onlinePay.uppercased()
            self.preference.set(false, forKey: STRIPE_WALLET_PAYMENT)
        case .brainTree:
            //self.paymentTypeImage.image = UIImage(named: "braintree")
            self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: UIImage(named: "braintree")?.withRenderingMode(.alwaysOriginal), completed: nil)
            self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
            self.paymentTypeName.text = UserDefaults.value(for: .brain_tree_display_name) ??  LangCommon.onlinepayment.uppercased()
            self.preference.set(false, forKey: STRIPE_WALLET_PAYMENT)
        case .stripe:
            if  UserDefaults.standard.bool(forKey: "CARD_DETAILS_GIVEN"),
                let brand : String = UserDefaults.value(for: .card_brand_name),!brand.isEmpty,
                let last4 : String = UserDefaults.value(for: .card_last_4),!last4.isEmpty{
                self.paymentTypeImage.image = self.viewController.getCardImage(forBrand: brand)
//                self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: self.viewController.getCardImage(forBrand: brand), completed: nil)
                self.paymentTypeName.text = "**** "+last4
                
            }else{
                //self.paymentTypeImage.image = UIImage(named: "card_basic")
                self.paymentTypeImage.sd_setImage(with: URL(string: Constants().GETVALUE(keyname: IS_Payment_image)), placeholderImage: UIImage(named: "card_basic")?.withRenderingMode(.alwaysTemplate), completed: nil)
                self.paymentTypeImage.image = self.paymentTypeImage.image?.withRenderingMode(.alwaysTemplate)
                self.paymentTypeName.text = LangCommon.addCard.uppercased()
                self.preference.set(false, forKey: STRIPE_WALLET_PAYMENT)
                fallthrough
            }
        default:
            self.paymentTypeImage.image = nil
            self.paymentTypeName.text = ""
            self.changeButton
                .setTitle(LangCommon.choosePaymentMethod, for: .normal)
        }
        self.paymentTypeImage.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
}
extension DriverWalletView {//PayPalHandlerDelegate
    func paypalHandler(didComplete paymentID: String) {
        
        guard let amount = enteredAmount else {return}
        self.viewController.wsMethodToUpdateWalletAmount(using: paymentID)
        enteredAmount = nil
    }
    
    func paypalHandler(didFail error: String) {
        self.viewController.appDelegate.createToastMessage(error)
    }

}




extension DriverWalletView : UITextFieldDelegate {
    //TEXT FIELD DELEGATE METHODS
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newLength = string.utf16.count - range.length
        let maxlength = 6
        
        if let text = amountField.text {
            newLength = text.utf16.count + string.utf16.count - range.length
            return newLength <= maxlength
        }
        
        let characterSet = NSMutableCharacterSet()
        characterSet.addCharacters(in: "1234567890")
        
        if string.rangeOfCharacter(from: characterSet.inverted) != nil || newLength > 4 {
            return false
        }
        return true
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) { // validation for amountTF
        let amount  = self.amountField.text
        let intAmt = Double(amount ?? "0") ?? 0
        var intBal: Double
        print("222",intAmt)
        if UserDefaults.standard.bool(forKey: "DEDUCTION") {  // if referral deducted payable owe amount also changed
            intBal = Double(self.deductedAmt) ?? 0
            print("111",intBal)
        } else {
            intBal = Double(self.oweAmount) ?? 0  // if referral not deducted owe amount payable doesnot changed
            print("121",intBal)
        }
        if amountField.placeholder != "0" {
            if intAmt <= intBal && intAmt != 0 {              // normal didchange validation
              //  self.payBtn.btnOperations(to: .on)            // amount field always less than balance else pay btn does not enabled
            }else{
               // self.payBtn.btnOperations(to: .off)
            }
        } else {
          //  self.payBtn.btnOperations(to: .on)                // if card added btn enabled
        }
    }
    
    @IBAction func btn_box(_ sender: UIButton){
        self.checkBoxAction = !self.checkBoxAction
        self.amountField.text = ""
        sender.setImage(self.checkBoxAction ? checked : unchecked ,
                        for: .normal)
        if self.checkBoxAction {                             //check Box selected
            let intOwe = Double(self.oweAmount) ?? 0
            let intRefAmt = Double(self.referralEarnings) ?? 0
            let deductedOwe = intOwe - intRefAmt
            if intRefAmt > intOwe{                       // in case referral amount more than owe amount the deduction will be minus so amount sendable should be zero
                self.amountField.placeholder = "0"
                self.amountField.text = ""
                self.amountField.isUserInteractionEnabled = false
            }else{
               // self.amountField.placeholder = String(format: "%.2f",
                                           //           deductedOwe)   // else normal deduction,amount field is optional
                self.amountField.isUserInteractionEnabled = true
            }
        //    self.payBtn.btnOperations(to: .on)
            self.deductedAmt = deductedOwe.description
            UserDefaults.standard.set(true, forKey: "DEDUCTION")
            print("deducted",self.deductedAmt)
        } else {                                          // checkbox unselected
            self.amountField.text = nil
//            self.amountField.placeholder = String(format: "%.2f",
//                                                  self.oweAmount)  // if unchecked, payable amount is same oweamount didnot deducted
            self.amountField.isUserInteractionEnabled = true
            UserDefaults.standard.set(false,
                                      forKey: "DEDUCTION")
            print("default",self.oweAmount)
          //  self.payBtn.btnOperations(to: .off)
        }
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if (text == "") {
            return true
        } else if (text != "") {
          //  self.checkNextButtonStatus()
        } else if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func checkNextButtonStatus() {
        payToGoferBtn.backgroundColor = ((amountField.text?.count)! >= 0) ? UIColor.PrimaryColor : UIColor.TertiaryColor
        payToGoferBtn.isUserInteractionEnabled = ((amountField.text?.count)! > 0)
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.endEditing(true)
//        return true;
//    }
}
