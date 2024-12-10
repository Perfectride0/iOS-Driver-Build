//
//  ViewProfileVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ViewProfileVC: BaseVC {

    var menuPresenter: MenuPresenter!
    var mobileValidationPurpose:  NumberValidationPurpose!
    var accViewModel : AccountViewModel!
    @IBOutlet var viewProfileView: ViewProfileView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
     //MARK:- initWithStory
        class func initWithStory(with presenter : MenuPresenter) -> ViewProfileVC{
            let view : ViewProfileVC = UIStoryboard.gojekAccount.instantiateViewController()
            view.menuPresenter = presenter
            view.accViewModel = AccountViewModel()
            return view
        }

    func onSaveProfileApiCall(params: [AnyHashable: Any]){
        self.accViewModel.profileVCApiCall(parms: params){(result) in
            switch result{
            case .success(let val):
                self.menuPresenter.driverProfile = val
                self.viewProfileView.updateProfileModel()
            case .failure(let error):
                //AppDelegate.shared.createToastMessage(error.localizedDescription)
                UberSupport.shared.removeProgressInWindow()
            }
            
        }
    }
    
    func getCountryList(){
        self.accViewModel.getCountryList(){ result in
            switch result{
            case .success(let countries):
                Shared.instance.countryList.removeAll()
                Shared.instance.countryList = countries.country_list
                self.viewProfileView.setUserProfileInfo()
            case .failure(let error):
                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
            
        }
    }
}
