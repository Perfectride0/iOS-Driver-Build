//
//  DriverWalletVC.swift
//  DriverWallet
//
//  Created by trioangle on 24/08/22.
//

import UIKit
import PaymentHelper
import IQKeyboardManagerSwift

class DriverWalletVC : BaseVC{
    var resultText = ""
    var companyID: Int?
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let viewModel = PayoutVM()
    var brainTree : BrainTreeProtocol?
     @IBOutlet weak var referralSlideConstraint : NSLayoutConstraint!
    @IBOutlet var payToGoferView: DriverWalletView!
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
//            self.commonAlert.setupAlert(alert: LangCommon.success.uppercased(),
//                                                         alertDescription: status,
//                                                         okAction: LangCommon.ok.uppercased())

            self.payToGoferView.hideView("")
            self.getOweAmtAPI()
            appDelegate.createToastMessage(status!)
            
           
         //   self.payToGoferView.payBtn.btnOperations(to: .off)
            self.payToGoferView.checkBox.isSelected = false
            UserDefaults.standard.set(false, forKey: "DEDUCTION")
        }
       }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.payToGoferView.updatePaymentOption()
    }
    
    //MARK: init with story
    class func initWithStory()-> DriverWalletVC{
        
        let vc : DriverWalletVC = UIStoryboard.gojekCommon.instantiateIDViewController()
       
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
                let result = responseDict.string("wallet_amount")
                let referal = responseDict.string("provider_referral_earning")
                let request_restriction_content = responseDict.string("request_restriction_content")
                let minimum_balance_content = responseDict.string("minimum_balance_content")
                let is_pending_amount = responseDict.bool("is_pending_amount")
                self.payToGoferView.oweAmount = result
                self.payToGoferView.referralEarnings = referal
                self.payToGoferView.minimum_balance_content = minimum_balance_content
                self.payToGoferView.request_restriction_content = request_restriction_content
                self.payToGoferView.is_pending_amount = is_pending_amount
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

    
    
    func methodConvetCurrency(for amount : Double) {
        Shared.instance.showLoaderInWindow()
        ConnectionHandler.shared.getRequest(for: .currencyConversion,
                                               params: ["amount": amount,
                                                        "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"], showLoader: true)
            .responseJSON({ json in
                if json.isSuccess {
                    self.handleCurrencyConversion(response: json.double("amount"),
                                                  currency: json.string("currency_code"),
                                                  key: json.string("braintree_clientToken"))
                } else {
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
                Shared.instance.removeLoaderInWindow()
            }).responseFailure({ error in
                print(error)
                Shared.instance.removeLoaderInWindow()
            })
    }
    func handleCurrencyConversion(response amount: Double,
                                  currency : String?,
                                  key : String ){
        switch PaymentOptions.default {
        case .brainTree:
            self.authenticateBrainTreePayment(for: amount, using: key)
        case .paypal:
//            self.paypalHandler?.makePaypal(payentOf: amount,
//                                           currency: currency ?? "USD",
//                                           for: .wallet)
            self.authenticatePaypalPayment(for: amount,currency: currency ?? "USD",using: key)
        default:
            break
        }
    }
    
    func authenticateBrainTreePayment(for amount : Double,using clientId : String){
        self.brainTree = BrainTreeHandler.default
        self.brainTree?.initalizeClient(with: clientId)
        self.view.isUserInteractionEnabled = false
        self.brainTree?.authenticatePaymentUsing(self,
                                                 email : UserDefaults.value(for: .user_email_id) ?? "test@email.com",
                                                 givenName :  UserDefaults.value(for: .first_name) ?? "Albin",
                                                 surname :  UserDefaults.value(for: .last_name) ?? "MrngStar",
                                                 phoneNumber :  UserDefaults.value(for: .phonenumber) ?? "123456",
                                                 for: amount) { (result) in
            self.view.isUserInteractionEnabled = true
            switch result{
            case .success(let token):
                self.wsMethodToUpdateWalletAmount(using: token.nonce)
            case .failure(let error):
                print("\(error.localizedDescription)")

//                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }
    }
    func authenticatePaypalPayment(for amount : Double,currency: String,using clientId : String){
        self.brainTree = BrainTreeHandler.default
        self.brainTree?.initalizeClient(with: clientId)
        self.view.isUserInteractionEnabled = false
        self.brainTree?.authenticatePaypalUsing(self,for: amount, currency: currency) { (result) in
            self.view.isUserInteractionEnabled = true
            switch result{
            case .success(let token):
                self.wsMethodToUpdateWalletAmount(using: token.nonce)
            case .failure(let error):
                print("\(error.localizedDescription)")

//                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }
    }
    func initiate3DSecureValidaiton(for intent : String){
        self.payToGoferView.stripeHandler?.confirmPayment(for: intent, completion: { (stResult) in
            switch stResult{
            case .success(let token):
                self.wsMethodToUpdateWalletAmount(using: token)
            case .failure(let error):
                print("\(error.localizedDescription)")

                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        })
    }
    
//    func initiate3DSecureValidaiton(for intent : String,enteredAmount : Double){
//        self.payToGoferView.stripeHandler?.confirmPayment(for: intent, completion: { (stResult) in
//            switch stResult{
//            case .success(let token):
//                self.wsToPaytoAdmin(enteredAmount, payKey: token)
//            case .failure(let error):
//                //self.appDelegate.createToastMessage(error.localizedDescription)
//                print("\(error.localizedDescription)")
//
//            }
//        })
//    }

    func wsMethodToUpdateWalletAmount(using payKey : String?){
        
        var params : [String : Any] = [
            "amount":self.payToGoferView.amountField.text ?? "",
                                        "payment_type": PaymentOptions.default?.paramValue.lowercased() ?? "cash"
        ]
        if let key = payKey{
            params["pay_key"] = key
        }
   print(params)
        ConnectionHandler.shared.getRequest(for: .addAmountToWallet, params: params, showLoader: true)
            .responseJSON({ json in
                if json.isSuccess {
                    if json.status_code == 2 {
                        let intent = json.string("two_step_id")
                        self.initiate3DSecureValidaiton(for: intent)
                    } else {
                        self.payToGoferView.hideView("")
                        self.getOweAmtAPI()
                        self.appDelegate.createToastMessage(json.status_message)
                    }
                } else {
                    self.presentAlertWithTitle(title: appName.capitalized,
                                               message: json.status_message,
                                               options: LangCommon.ok) { (_) in
                    }
                }
                Shared.instance.removeLoaderInWindow()
            })
            .responseFailure({ error in
                print(error)
                self.presentAlertWithTitle(title: appName.capitalized,
                                           message: error,
                                           options: LangCommon.ok) { (_) in
                }
                Shared.instance.removeLoaderInWindow()
            })
    
    
}
}
