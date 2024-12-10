//
//  ReferalVC.swift
//  GoferDriver
//
//  Created by Trioangle on 24/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.


/*import UIKit

class ReferalVC: BaseVC {
    //MARK:- Outlets
    @IBOutlet weak var referalView : ReferalView!
    
    //MARK:- Variables
    //lazy var lang = Language.default.object
    var accountViewModel : AccountViewModel!
  
//    lazy var language : LanguageProtocol = {
//           return Language.default.object
//       }()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
//  let referalBC = "SignUp & Get Paid For Every Referral Sign-up & Much More Bonus Awaits!".localize
   
    var referalCode = String()
    var totalEarning = String()
    var maxReferal = String()
    var appLink = String()
    var referalSections = [ReferalType]()
    var completedReferals = [ReferalModel]()
    var inCompleteReferals = [ReferalModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wsToGetReferals()
     
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wsToGetReferals()
    }

    //MARK:- Init with story
    
    class func initWithStory()->ReferalVC{
        let story = UIStoryboard.account
        let vc = story.instantiateViewController(withIdentifier: "ReferalVCID") as! ReferalVC
        vc.accountViewModel = AccountViewModel()
        return vc
    }
    //MARK:- WebServices
    func wsToGetReferals(){
        self.accountViewModel.getReferal {  (result) in
            switch result{
            case .success(let data):
                self.referalCode = data.referal
                self.appLink = data.appLink
                self.referalView.referealTextLBL.text = self.referalCode
                self.totalEarning = data.totalEarning.description
                self.maxReferal = data.maxReferal.description
                self.referalView.referalDescription.text = LangCommon.getUpto + " \(data.maxReferal) " + LangCommon.forEveryFriendJobs + " \(appName)"
                self.inCompleteReferals = data.incomplete
                self.completedReferals = data.complete
                self.referalView.referalTable.springReloadData()
            case .failure(let error):
                self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }
    }
}*/


import UIKit

class ReferalVC: BaseVC {
    //MARK:- Outlets
    @IBOutlet weak var referalView : ReferalView!
    
    //MARK:- Variables
    var accountViewModel : AccountViewModel!
  
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
//  let referalBC = "SignUp & Get Paid For Every Referral Sign-up & Much More Bonus Awaits!".localize
   
    var referalCode = String()
    var totalEarning = String()
    var maxReferal = String()
    var appLink = String()
    var referalSections = [ReferalType]()
    var completedReferals = [ReferalModel]()
    var inCompleteReferals = [ReferalModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wsToGetReferals()
     
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    //MARK:- Init with story
    
    class func initWithStory()->ReferalVC{
        let story = UIStoryboard.gojekCommon
        let vc = story.instantiateViewController(withIdentifier: "ReferalVCID") as! ReferalVC
        vc.accountViewModel = AccountViewModel()
        return vc
    }
    //MARK:- WebServices
    func wsToGetReferals(){
        self.accountViewModel.getReferal { (result) in
            switch result{
            case .success(let data):
                self.referalCode = data.referal
                self.appLink = data.appLink
                self.totalEarning = data.totalEarning.description
                self.maxReferal = data.maxReferal.description
                self.referalView.referalDescription.text = LangCommon.getUpto + " \(data.maxReferal) " + LangCommon.forEveryFriendJobs + " \(appName)"
                self.inCompleteReferals = data.incomplete
                self.completedReferals = data.complete
                self.referalView.referalTable.springReloadData()
                self.referalView.setValue()
            case .failure(let error):
                print("\(error.localizedDescription)")

               // self.appDelegate.createToastMessage(error.localizedDescription)
            }
        }
    }
}

