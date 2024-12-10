//
//  AddStripeCardView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 04/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import PaymentHelper
import Stripe

class AddStripeCardView: BaseView {
    
    var viewController:AddStripeCardVC!
    @IBOutlet weak var doneBtn : PrimaryButton!
    @IBOutlet weak var pageTitle : SecondaryHeaderLabel!
    @IBOutlet weak var stripeCardTextField: UIView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var curvedContentHolderView: TopCurvedView!
    @IBOutlet weak var contentHolderView: UIView!
    @IBOutlet weak var bottomView: TopCurvedView!
    
    var params = [String:Any]()
    
    
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    
    override func darkModeChange() {
        super.darkModeChange()
        self.headerView.customColorsUpdate()
        self.pageTitle.customColorsUpdate()
        self.curvedContentHolderView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
    }
    
    
    let appDelegate = AppDelegate()
    var stripeHandler : StripeHandler?
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? AddStripeCardVC
        self.initStripeCardTextField()
        self.stripeHandler = StripeHandler(self.viewController)
        self.initView()
        self.darkModeChange()
    }
    func initView(){
        self.addAction(for: .tap) {
            self.endEditing(true)
        }
        self.doneBtn.setTitle(LangCommon.done,
                              for: .normal)
        self.pageTitle.text = LangCommon.addCreditCard
        //            self.pageTitle.text = "Add Credit or Debit Card".localize
        
    }
    func initStripeCardTextField(){
        
        self.stripeCardTextField.addSubview(self.cardTextField)
        self.cardTextField.anchor(toView: self.stripeCardTextField,
                                  leading: 0,
                                  trailing: 0,
                                  top: 0,
                                  bottom: 0)
        self.cardTextField.postalCodeEntryEnabled = false
    }
    @IBAction func doneAct(_ sender: UIButton) {
        self.endEditing(true)
        guard NetworkManager.instance.isNetworkReachable else { return}
        let cardTF = cardTextField
        dump(cardTF)
        /*cardTF.cardNumber == nil || cardTF.cvc == nil || cardTF.cardNumber!.count == 0 || cardTF.cvc!.count == 0 || cardTF.expirationYear == 0 || cardTF.expirationMonth == 0 || cardTF.cvc!.count < 3 */
        guard cardTF.isValid else{
            let enter_valid_details = LangCommon.pleaseEnterValidCard
            self.appDelegate.createToastMessage(enter_valid_details, bgColor: .black, textColor: .white)
            return
        }
        
        print(cardTF.cardNumber!)
        print(cardTF.cvc!)
        print(cardTF.expirationYear)
        print(cardTF.expirationMonth)
        self.viewController.wsToGetCardDetails()
        
        
        
    }
    @IBAction func cardEditing(_ sender: STPPaymentCardTextField) {
        
        if sender.isValid{
            self.doneBtn.isUserInteractionEnabled = true
            self.doneBtn.backgroundColor = .PrimaryColor
        }else{
            self.doneBtn.isUserInteractionEnabled = false
            self.doneBtn.backgroundColor = .TertiaryColor
        }
    }
    
    @IBAction func onBackTapped(_ sender: UIButton) {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    func createIntent(using card : STPPaymentCardTextField,forClient secret : String){
        UberSupport().showProgressInWindow(showAnimation: true)
        self.stripeHandler?
            .setUpCard(textField: card,
                       secret: secret,
                       completion: { (result) in
                        UberSupport().showProgressInWindow(showAnimation: false)
                        UberSupport().removeProgressInWindow()
                        switch result{
                        case .success(let token):
                            self.viewController.wsToAddCardDetail(token: token)
                        case .failure(let error):
                            print("\(error.localizedDescription)")

                            //self.appDelegate.createToastMessage(error.localizedDescription)
                        }
                       })
    }
}
