//
//  NewPayoutListVC.swift
//  GoferDriver
//
//  Created by trioangle on 10/02/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class NewPayoutListVC: BaseVC {
   @IBOutlet var listPayoutView: ListPayoutView!
   
   let viewModel = PayoutVM()
    
    var preference = UserDefaults.standard
    //MARK:- Outlet
    
    //MARK:- variables
    lazy var appDelegate : AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
   
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalValueForAddOnData()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        self.wsToGetPayoutList(for: .fetch)
    }
    
    //MARK:- initwithStory
    class func initWithStory() -> NewPayoutListVC{
        let newPayoutListVC : NewPayoutListVC = UIStoryboard.gojekCommon.instantiateViewController()
        return newPayoutListVC
    }
    //MARK:- webservice
    func wsToGetPayoutList(for option : PayoutFetchOption){
        var param = JSON()

        switch option {
        case .fetch:
            param.removeAll()
        case .setDefault(id: let id):
            param["type"] = "default"
            param["payout_id"] = id
        case .delete(id: let id):
            param["type"] = "delete"
            param["payout_id"] = id
        }
        self.viewModel.getPayoutList(params: param) { (modelList) in
            self.listPayoutView.payouts = modelList
            self.listPayoutView.payoutTableView.reloadData()
        }
        
        
        
    }
}

extension NewPayoutListVC {
    
    func handleAddAction(for item : PayoutItemModel){
        switch item.key {
        case "bank_transfer":
            let vc = PayoutBankDetailViewController.initWithStory()
            vc.bankDetails = BankDetails(from: item)
            vc.isNewRecord = (item.id == 0)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case "paypal":
            let paypalVC = PaypalPayoutVC.initWithStory()
            paypalVC.payoutValue = item
            paypalVC.isNewRecord = (item.id == 0)
            self.navigationController?.pushViewController(paypalVC, animated: true)
        case "stripe":

            let vc = AddPayoutVC.initWithStory()
            vc.payoutModelForStripe = item
            vc.isNewRecord = (item.id == 0)
            self.navigationController?.pushViewController(vc, animated: true)
        case "flutterwave":
            let storyboard = UIStoryboard(name: "Flutter", bundle: Bundle(identifier: "com.trioangle.goferjekdriver.FlutterWave"))
            let vc = storyboard.instantiateViewController(withIdentifier: "FlutterPayoutVC")
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func setLocalValueForAddOnData(){
        let token = preference.string(forKey: USER_ACCESS_TOKEN)
        UserDefaults.standard.set(token, forKey: "FlutterToken")
        UserDefaults.standard.set(APIUrl, forKey: "ApiUrl")
        saveImage()
    }
    
    
    func saveImage() {
        guard let data = UIImage(named: "Back_Btn")?.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: "BAckIcon")
    }
    
    
}
extension NewPayoutListVC : BankDetailsProtocolo{
    func getBankDetails() {
        self.wsToGetPayoutList(for: .fetch)
    }
    
    
}
