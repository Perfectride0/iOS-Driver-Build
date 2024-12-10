//
//  AddStripeCardVC.swift
//  GoferDriver
//
//  Created by Trioangle on 20/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Stripe

class AddStripeCardVC: BaseVC {
    
   
    @IBOutlet var addStripeCardView: AddStripeCardView!
    let viewModel = PayoutVM()
    let appDelegate = AppDelegate()
    
    var updateDelegate : UpdateContentProtocol?
    
    
    //MARK: View life cycles
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.listen2Keyboard(withView: self.addStripeCardView.doneBtn)
        // Do any additional setup after loading the view.
        
    }
    
    
    
    
    //MARK: initialize VC
    class func initWithStory(_ delegate : UpdateContentProtocol) -> AddStripeCardVC{
       
        let view : AddStripeCardVC = UIStoryboard.gojekCommon.instantiateIDViewController()
        view.updateDelegate = delegate
        return view
    }

    
    
    
    func wsToAddCardDetail(token : String){
        guard UserDefaults.standard.string(forKey: USER_ACCESS_TOKEN) != nil else{return}
        self.viewModel.addStripeCard(["intent_id" : token]) { (result) in
             UberSupport.init().removeProgressInWindow()
            switch result {
            case .success(let json) :
                if json.status_code == 0 {
                    print("∂",json.status_message)
                } else {
                    UserDefaults.set(json.string("last4"), for: .card_last_4)
                    UserDefaults.set(json.string("brand"), for: .card_brand_name)
                    self.updateDelegate?.updateContent()
                    UserDefaults.standard.set(true, forKey: "CARD_DETAILS_GIVEN")
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error) :
                print("\(error.localizedDescription)")

               // self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }
        
        
    }
    
    func wsToGetCardDetails() {
        self.viewModel.getStripeCard { (result) in
            switch result {
            case .success( let json):
                 if json.isSuccess{
                    let stripeClientKey = json.string("intent_client_secret")
                    self.addStripeCardView.createIntent(using: self.addStripeCardView.cardTextField, forClient: stripeClientKey)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
}

extension UIViewController{
    func getCardImage(forBrand brand : String) -> UIImage{
        switch brand.capitalized{
        case "Visa".capitalized:
            return UIImage(named: "card_visa") ?? #imageLiteral(resourceName: "card_basic")
        case "MasterCard".capitalized:
            return UIImage(named: "card_master") ?? #imageLiteral(resourceName: "card_basic")
        case "Discover".capitalized:
            return UIImage(named: "card_discover") ?? #imageLiteral(resourceName: "card_basic")
        case "Amex".capitalized,"American Express".capitalized:
            return UIImage(named: "card_amex") ?? #imageLiteral(resourceName: "card_basic")
        case "JCB".capitalized,"JCP".capitalized:
            return UIImage(named: "card_jcp") ?? #imageLiteral(resourceName: "card_basic")
        case "Diner".capitalized,"Diners".capitalized,"Diners Club".capitalized:
            return UIImage(named: "card_diner") ?? #imageLiteral(resourceName: "card_basic")
        case "Union".capitalized,"UnionPay".capitalized:
            return UIImage(named: "card_unionpay") ?? #imageLiteral(resourceName: "card_basic")
        default:
            return UIImage(named: "card_basic") ?? #imageLiteral(resourceName: "card_basic")
        }
    }
}
