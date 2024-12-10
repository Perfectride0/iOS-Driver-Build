//
//  WelcomeVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 18/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit


protocol WelcomeNavigationProtocol {
    func navigateToLoginVC()
    func navigateToRegisterVC()
}


class WelcomeVC: BaseVC {
    
    //--------------------------------
    //MARK:- outlets
    //--------------------------------
    
    @IBOutlet var welcomeView: WelcomeView!
    
    //--------------------------------
    //MARK:- Local Variables
    //--------------------------------
    
    var accViewModel : AccountViewModel!
    
    //--------------------------------
    //MARK:- Life Cycles
    //--------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //--------------------------------
    //MARK:- Connection
    //--------------------------------
    
    class func initWithStory() -> WelcomeVC {
        let vc : WelcomeVC = UIStoryboard.gojekAccount.instantiateViewController()
        vc.accViewModel = AccountViewModel()
        return vc
    }
}


//------------------------------------
// MARK:- Welcome Navigation Protocol
//------------------------------------

extension WelcomeVC : WelcomeNavigationProtocol{
    func navigateToLoginVC() {
        let vc = LoginVC.initWithStory(self)
        self.navigationController?
            .pushViewController(vc,
                                animated: false)
    }
    
    func navigateToRegisterVC() {
        let mobileValidationVC = MobileValidationVC
            .initWithStory(usign: self.welcomeView,
                           for: .register)
        self.presentInFullScreen(mobileValidationVC,
                                 animated: false,
                                 completion: nil)
    }
}

extension WelcomeVC{
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
