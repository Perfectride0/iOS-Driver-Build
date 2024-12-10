//  PayToGoferVc.swift
//  Gofer
//
//  Created by Trioangle Technologies on 16/11/17.
//  Copyright © 2017 Trioangle Technologies. All rights reserved.
//

import UIKit
import PaymentHelper
import IQKeyboardManagerSwift

class PayToGoferVC : BaseVC{
    var resultText = ""
    var companyID: Int?
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let viewModel = PayoutVM()
   
     @IBOutlet weak var referralSlideConstraint : NSLayoutConstraint!
    @IBOutlet var payToGoferView: PayToGoferView!
    override var stopSwipeExitFromThisScreen: Bool?{
        return (!self.payToGoferView.payAmtView.isHidden)
            || (self.payToGoferView.enteredAmount != nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatePayToGoferAmount(_:)), name: NSNotification.Name(rawValue: "PayToGoferApi"), object: nil)

    }
    @objc func updatePayToGoferAmount(_ notification: NSNotification) {
        
        if let amount = notification.userInfo?["pay_to_gofer"] as? String {
            let status = notification.userInfo?["status"] as? String
        // do something with your image
            self.payToGoferView.oweAmount = amount
            self.commonAlert.setupAlert(alert: LangCommon.success.uppercased(),
                                                         alertDescription: status,
                                                         okAction: LangCommon.ok.uppercased())

           
            self.payToGoferView.payBtn.btnOperations(to: .off)
            self.payToGoferView.checkBox.isSelected = false
            UserDefaults.standard.set(false, forKey: "DEDUCTION")
        }
       }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.payToGoferView.updatePaymentOption()
    }
    
    //MARK: init with story
    class func initWithStory()-> PayToGoferVC{
        
        let vc : PayToGoferVC = UIStoryboard.gojekCommon.instantiateIDViewController()
       
        return vc
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getOweAmtAPI()
        
        self.payToGoferView.initPayAmountView()
        self.navigationController?.isNavigationBarHidden = true
        if #available(iOS 10.0, *) {
            self.payToGoferView.amountField.keyboardType = .decimalPad
        } else {
            // Fallback on earlier versions
            self.payToGoferView.amountField.keyboardType = .decimalPad
        }
        self.payToGoferView.amountField.delegate = payToGoferView
        IQKeyboardManager.shared.enable = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false

    }
    
       //WHEN DISS MISS THE KEYBOARD
       @objc override func dismissKeyboard() {
           //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.payToGoferView.amountField.resignFirstResponder()
       }
    //wsTOGet Owe amount
       func getOweAmtAPI() {
        self.viewModel.getProviderProfile { (result) in
            switch result {
            case .success(let responseDict):
                let result = responseDict.string("owe_amount")
                let referal = responseDict.string("provider_referral_earning")
                self.payToGoferView.oweAmount = result
                self.payToGoferView.referralEarnings = referal
                print("111",self.payToGoferView.referralEarnings)
                print("111",self.payToGoferView.oweAmount)
                self.payToGoferView.initTextSetup()
                self.payToGoferView.initPayAmountView()
            case .failure(let error):
                //self.appDelegate.createToastMessage(error.localizedDescription)
                print("\(error.localizedDescription)")

            }
        }
       }

    
    
   
    func wsMethodConvetCurrency(for enteredAmount : Double){
        let param = ["amount": enteredAmount,
                     "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"] as [String : Any]
        self.viewModel.currencyConversation(param) { (result) in
            switch result {
            case .success(let json):
                let amount = json.double("amount")
                let brainTreeClientID = json.string("braintree_clientToken")
                let currency = json.string("currency_code")
                self.payToGoferView.handleCurrencyConversion(response: amount,enteredAmount: enteredAmount,currency: currency,key: brainTreeClientID)
            case .failure(let error):
               // self.appDelegate.createToastMessage(error.localizedDescription)
                print("\(error.localizedDescription)")

            }
        }
        
        
    }
    
    func authenticateBrainTreePayment(for convertedAmount : Double,enteredAmount : Double,using clientId : String){
        self.payToGoferView.brainTree = BrainTreeHandler.default
        self.payToGoferView.brainTree?.initalizeClient(with: clientId)
        self.view.isUserInteractionEnabled = false
        self.payToGoferView.brainTree?.authenticatePaymentUsing(self,
                                                                email : UserDefaults.value(for: .user_email_id) ?? "test@email.com",
                                                                givenName :  UserDefaults.value(for: .first_name) ?? "Albin",
                                                                surname :  UserDefaults.value(for: .last_name) ?? "MrngStar",
                                                                phoneNumber :  UserDefaults.value(for: .phonenumber) ?? "123456",
                                                                for: convertedAmount) { (result) in
            self.view.isUserInteractionEnabled = true
            switch result{
            case .success(let token):
                self.wsToPaytoAdmin(enteredAmount, payKey: token.nonce)
            case .failure(let error):
                //self.appDelegate.createToastMessage(error.localizedDescription)
                print("\(error.localizedDescription)")

            }
        }
    }
    func authenticatePaypalPayment(for convertedAmount : Double,
                                   enteredAmount : Double,
                                   currency: String,
                                   using clientId : String){
        self.payToGoferView.brainTree = BrainTreeHandler.default
        self.payToGoferView.brainTree?.initalizeClient(with: clientId)
        self.view.isUserInteractionEnabled = false
        self.payToGoferView.brainTree?.authenticatePaypalUsing(self,for: convertedAmount, currency: currency) { (result) in
            self.view.isUserInteractionEnabled = true
            switch result{
            case .success(let token):
                self.wsToPaytoAdmin(enteredAmount, payKey: token.nonce)
            case .failure(let error):
                //self.appDelegate.createToastMessage(error.localizedDescription)
                print("\(error.localizedDescription)")

            }
        }
    }

    
    func initiate3DSecureValidaiton(for intent : String,enteredAmount : Double){
        self.payToGoferView.stripeHandler?.confirmPayment(for: intent, completion: { (stResult) in
            switch stResult{
            case .success(let token):
                self.wsToPaytoAdmin(enteredAmount, payKey: token)
            case .failure(let error):
                //self.appDelegate.createToastMessage(error.localizedDescription)
                print("\(error.localizedDescription)")

            }
        })
    }
    func wsToPaytoAdmin(_ enteredAmount : Double,payKey : String?){
        
        var paramForPayToAdmin = [String:Any]()
        paramForPayToAdmin["applied_referral_amount"] = UserDefaults.standard.bool(forKey: "DEDUCTION") ? "1" : "0"
        paramForPayToAdmin["payment_type"]  = PaymentOptions.default?.paramValue.lowercased() ?? "paypal"
        paramForPayToAdmin["amount"] = enteredAmount
        paramForPayToAdmin["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        if let key = payKey{
            paramForPayToAdmin["pay_key"] = key
        }
        self.viewModel.payToAdmin(paramForPayToAdmin) { (result) in
            switch result {
            case .success(let json):
                if json.status_code == 2{
                    let intent = json.string("two_step_id")
                    self.initiate3DSecureValidaiton(for: intent,enteredAmount: enteredAmount)
                }else{
                    //TRVicky
                    self.commonAlert.setupAlert(alert: LangCommon.success.uppercased(),
                                                                 alertDescription: json.status_message,
                                                                 okAction: LangCommon.ok.uppercased())

                   
                    self.payToGoferView.payBtn.btnOperations(to: .off)
                    self.payToGoferView.checkBox.isSelected = false
                    UserDefaults.standard.set(false, forKey: "DEDUCTION")
                    self.viewWillAppear(true)
                }
                
                
            case .failure(let error):
                print("\(error.localizedDescription)")
                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }
        
        
        self.payToGoferView.hideView()
        self.dismissKeyboard()
    }
    
    
    
}
