//
//  LoginVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 18/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LoginVC: BaseVC{

    var accViewModel : AccountViewModel!
    @IBOutlet var loginView: LoginView!
    var welcomeNavigation : WelcomeNavigationProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    //Mark: - initWithStoryBoard
    class func initWithStory(_ delegate : WelcomeNavigationProtocol) -> LoginVC{
        let view : LoginVC = UIStoryboard.gojekAccount.instantiateViewController()
        view.accViewModel = AccountViewModel()
        view.welcomeNavigation = delegate
        return view
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        self.getCountryList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
      }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    func callLoginAPI(parms: [AnyHashable: Any])
       {
        accViewModel.LoginApicall(parms: parms){(result) in
            switch result{
            case .success:
                    self.loginView.showPage()
            case .failure(let error):
                if error.localizedDescription == "Those credentials don't look right. Please try again" {

                         AppDelegate.shared.createToastMessage(LangCommon.credentialsDontLook, bgColor: UIColor.black, textColor: UIColor.white)
                    self.loginView.removeProgress()
                     }else{

                    AppDelegate.shared.createToastMessage(error.localizedDescription, bgColor: UIColor.black, textColor: UIColor.white)
                    self.loginView.removeProgress()
                     }
            }
        }
        
       }

    
    func getCountryList(){
        self.accViewModel.getCountryList(){ result in
            switch result{
            case .success(let countries):
                Shared.instance.countryList.removeAll()
                Shared.instance.countryList = countries.country_list
            case .failure(let error):
                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
            
        }
    }
      

}
