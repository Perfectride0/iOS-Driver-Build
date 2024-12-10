//
//  NewRegisterVC.swift
//  GoferDriver
//
//  Created by trioangle on 15/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class RegisterVC: BaseVC {
    
    @IBOutlet var registerView: RegisterView!
    var accViewModel : AccountViewModel!
    
    var verified_mobile_number : String!
    var country : CountryModel!
    var darkMode = false
//    var statusBarHidden = false
    var welcomeNavigation : WelcomeNavigationProtocol?

    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    //MARK:-init with story
    
    class func initWithStory(withNumber number: String?,_ country : CountryModel? ,navigaiton : WelcomeNavigationProtocol) -> RegisterVC {
        let vc : RegisterVC = UIStoryboard.gojekAccount.instantiateViewController()
        vc.accViewModel = AccountViewModel()
        vc.verified_mobile_number = number
        vc.country = country
        vc.welcomeNavigation = navigaiton
        return vc
    }
    
    override
    var prefersStatusBarHidden: Bool {
        return false
    }
    func callSocialSignUpAPI(parms: [AnyHashable: Any]){
              accViewModel.SocialInfoApiCall(parms: parms){(result) in
                
                switch result{
                case .success(let msg):
                     AppDelegate.shared.createToastMessage(msg)

                   let flag = self.country!
                       flag.store()
                       let userDefaults = UserDefaults.standard
                       userDefaults.set("driver", forKey:"getmainpage")
                   AppDelegate.shared.onSetRootViewController(viewCtrl: self)
                case .failure(let error):
                    AppDelegate.shared.createToastMessage(error.localizedDescription)
                    self.registerView.removeProgress()
                    self.registerView.loginBtn.isUserInteractionEnabled = true
                }
              }
          }
          
}
