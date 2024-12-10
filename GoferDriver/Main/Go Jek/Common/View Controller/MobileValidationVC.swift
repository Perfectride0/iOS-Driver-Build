//
//  MobileValidationVC.swift
//  GoferDriver
//
//  Created by trioangle on 13/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol MobileNumberValiadationProtocol {
    func verified(number : MobileNumber)
}
enum NumberValidationPurpose{
      case forgotPassword
      case register
      case changeNumber
  }
/**
    MobileNumberValidation Screen States
       - States:
           - mobileNumber
           - OTP
    */
   enum ScreenState{
       case mobileNumber
       case OTP
   }
/**
 Mobile number validation using OTP
 
 - Warning: Caller must implement MobileNumberValiadationProtocol
 - Author: Abishek Robin
 */
class MobileValidationVC: BaseVC{
    
    //MARK:- outlets
    @IBOutlet var mobileValidationView: MobileValidationView!
    var accViewModel : AccountViewModel!
    //MARK:- variables
    var validationDelegate : MobileNumberValiadationProtocol?
    var purpose : NumberValidationPurpose!
    //MARK:- View life cycle
    var isFromDelete = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if isFromDelete{
            self.mobileValidationView.currentScreenState = .OTP
        }
        
    }
    
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    /**
     Static function to initialize MobileValidationVC
     - Author: Abishek Robin
     - Parameters:
     - delegate: MobileNumberValiadationProtocol to be parsed
     - purpose: forgotPassword,register,changeNumber
     - Returns: MobileValidationVC object
     - Warning: Purpose must be parsed properly
     */
    class func initWithStory(usign delegate : MobileNumberValiadationProtocol,
                             for purpose : NumberValidationPurpose)-> MobileValidationVC{
        let view : MobileValidationVC = UIStoryboard.gojekAccount.instantiateIDViewController()
        
        view.purpose = purpose
        view.validationDelegate = delegate
        view.accViewModel = AccountViewModel()
        return view
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    //MARK:- Webservices
    func wsToVerifyNumberApiCall(params: [AnyHashable: Any]){
        self.accViewModel.wsToVerifyNumberApiCall(parms: params){(result) in
            
            switch result{
            case .success(let res):
                if res.verified{
                    if Shared.instance.otpEnabled{
                        if self.mobileValidationView.currentScreenState  != .OTP{//if already not in otp screen
                            self.mobileValidationView.aniamateView(for: .OTP)
                        }
                        self.mobileValidationView.otpFromAPI = res.otp
                        self.mobileValidationView.currentScreenState = .OTP
                        print("otp\(self.mobileValidationView.otpFromAPI ?? "")")
                        ///un comment to show otp toast
                        //                        appDelegate.createToastMessage("OTP \(res.otp ?? "")")
                        self.mobileValidationView.removeProgress()
                    } else {
                        self.mobileValidationView.onSuccess()
                    }
                    
                }
                else{
                    self.mobileValidationView.otpFromAPI = nil
                    self.mobileValidationView.endEditing(true)
                    self.mobileValidationView.showError(res.message!)
                    self.mobileValidationView.removeProgress()
                }
            case .failure(let err):
                UberSupport.shared.removeProgressInWindow()
                self.mobileValidationView.endEditing(true)
                AppDelegate.shared.createToastMessage(err.localizedDescription)
                self.mobileValidationView.removeProgress()
            }
        }
    }
    
    func wsToVerifyOTP(param:JSON) {
        self.accViewModel.wsToVerifyOTP(parms: param) { (response) in
            switch response {
            case .success(let result):
                if result {
                    self.mobileValidationView.onSuccess()
                } else {
                    self.mobileValidationView.endEditing(true)
                    self.mobileValidationView.customOtpView.invalidOTP()
                }
            case .failure(let err):
                self.mobileValidationView.endEditing(true)
                AppDelegate.shared.createToastMessage(err.localizedDescription)
                
            }
        }
    }
    
    
    func wsToVerifyDeleteOTP(param:JSON) {
        self.accViewModel.wsToVerifyDeleteOTP(parms: param) { (response) in
            switch response {
            case .success(let result):
                print(result)
                if result.status_code == 1{
                    
                    let userDefaults = UserDefaults.standard
                    UserDefaults.set(false,for: .InitiatedTheme)
                    userDefaults.set("", forKey:"getmainpage")
                    userDefaults.set("", forKey: USER_ONLINE_STATUS)
                    userDefaults.synchronize()
                    let firebaseAuth = Auth.auth()
                    do {
                      try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                      print ("Error signing out: %@", signOutError)
                    }
                    UserDefaults.removeValue(for: .default_language_option)
                    PushNotificationManager.shared?.stopObservingProvider()
                    (UIApplication.shared.delegate as! AppDelegate).logOutDidFinish()
                    AppDelegate.shared.createToastMessage(LangCommon.accountdeletion)
                }else{
                    
                }
            case .failure(let err):
                self.mobileValidationView.endEditing(true)
                AppDelegate.shared.createToastMessage(err.localizedDescription)
                
            }
        }
    }
    
    
}
