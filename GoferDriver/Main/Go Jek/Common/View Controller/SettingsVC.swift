//
//  SettingsVC.swift
//  GoferDriver
//
//  Created by trioangle on 01/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsVC: BaseVC, MobileNumberValiadationProtocol {
    func verified(number: MobileNumber) {
        print("")
    }
    //MARK:- IBOutlet
    
    @IBOutlet var settingView: settingsView!
    //@IBOutlet weak var backBtn : UIButton!

    
    //MARK:- LocalVariables
    var menuPresenter : MenuPresenter!
    lazy var appDelegate = AppDelegate.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.settingView.settingTableView.reloadData()
    }
    //MARK:- initializers
    func initView(){
        self.settingView.titleLbl.text = LangCommon.settings.capitalized
        //self.backBtn.setTitle(self.lang.isRTLLanguage() ? "I" : "e", for: .normal)
    }

    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    class func initWithStory(with presenter : MenuPresenter) -> SettingsVC{
        let vc : SettingsVC = UIStoryboard.gojekCommon.instantiateViewController()
        vc.menuPresenter = presenter
        return vc
    }
    //MARK:- Actions
    @IBAction func backAction(_ sender : UIButton){
        if self.isPresented(){
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    //MARK:- webService
    func wsCallLogoutAPI(){
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared.getRequest(for: .logout, params: [:], showLoader: true)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.isSuccess{
                    let userDefaults = UserDefaults.standard
                    userDefaults.set("", forKey:"getmainpage")
                    let firebaseAuth = Auth.auth()
                    do {
                      try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                      print ("Error signing out: %@", signOutError)
                    }
                    userDefaults.synchronize()
                    PushNotificationManager.shared?.stopObservingProvider()
                    UserDefaults.removeValue(for: .default_language_option)
                    
                    (UIApplication.shared.delegate as! AppDelegate).logOutDidFinish()
                }else{
                    //TRVicky
                    self.commonAlert.setupAlert(alert:LangCommon.message.capitalized,alertDescription: json.status_message, okAction: LangCommon.ok.uppercased())
                    
                    
                }
                
                
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                
                //TRVicky
                self.commonAlert.setupAlert(alert:LangCommon.message.capitalized,alertDescription:error, okAction: LangCommon.ok.uppercased())
                
            })
        
    }
    
    
    func wsCallDeleteAccountAPI(isChecked:String){
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        var params = [String: Any]()
        params["is_checked"] = isChecked
        ConnectionHandler.shared.getRequest(for: .deleteAccount, params: params, showLoader: true)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.isSuccess{
                    if isChecked == "0"{
                        self.presentAlertWithTitle(title: LangCommon.doyouwantdelete, message: LangCommon.pleasemakesuredelete, options: LangCommon.yes, LangCommon.no) {
                            (optionss) in
                            switch optionss {
                            case 0:
                                self.wsCallDeleteAccountAPI(isChecked: "1")
                            case 1:
                             self.dismiss(animated: true, completion: nil)
                            default:
                                break
                            }
                        }
                    }else{
                        let vc = MobileValidationVC.initWithStory(usign: self, for: .register)
                        vc.isFromDelete = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    self.commonAlert.setupAlert(alert:"",alertDescription: json.status_message, okAction: LangCommon.ok.uppercased())
                }
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                self.commonAlert.setupAlert(alert:LangCommon.message.capitalized,alertDescription:error, okAction: LangCommon.ok.uppercased())
                
            })
        
    }
    
    
}

//MARK:- currencyListDelegate
extension SettingsVC : currencyListDelegate{
    func onCurrencyChanged(currencyCode: String, symbol: String) {
        self.menuPresenter.driverProfile?.currency_code = currencyCode
        self.menuPresenter.driverProfile?.currency_symbol = symbol
        //strCurrency = String(format:"%@ %@", str[0],str[1])
        self.settingView.settingTableView.reloadData()
    }
        
}
