/**
* ResetPasswordVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
import MessageUI

class ResetPasswordVC : BaseVC
{
    //MARK: - Outlets
    @IBOutlet var resetPasswordView: ResetPasswordView!
    var accViewModel : AccountViewModel!

    //MARK:- Class Variables
    let userDefaults = UserDefaults.standard
    var strMobileNo = ""
    var countryModel = CountryModel.default
    var isFromProfile:Bool = false
    var isFromForgotPage:Bool = false
    
// MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
  
    //MARK:- init WithStoryBoard
    class func initWithStory() -> ResetPasswordVC{
        let view : ResetPasswordVC = UIStoryboard.gojekAccount.instantiateViewController()
        view.accViewModel = AccountViewModel()
        return view
    }
    func resetPasswordApiCall(params: [AnyHashable: Any]){
        accViewModel.resetPasswordApi(parms: params){(result) in
            switch result{
            case .success:
                self.resetPasswordView.showPage()
            case .failure(let error):
                self.resetPasswordView.lblErrorMsg.isHidden = false
                self.resetPasswordView.lblErrorMsg.text = error.localizedDescription
                self.resetPasswordView.removeProgress()
                AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        }
    }
}


