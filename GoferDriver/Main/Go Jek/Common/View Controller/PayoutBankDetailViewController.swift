//
//  PayoutBankDetailViewController.swift
//  GoferDriver
//
//  Created by trioangle on 18/05/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit

protocol BankDetailsProtocolo {
    func getBankDetails()
}

class PayoutBankDetailViewController: BaseVC {
    
    @IBOutlet var payoutBankDetailView: PayoutBankDetailView!
    var delegate:BankDetailsProtocolo?
    var bankDetails : BankDetails?
    var isNewRecord : Bool = false
    let viewModel = PayoutVM()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
      
        // Do any additional setup after loading the view.
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
   class func initWithStory() -> PayoutBankDetailViewController {
    let stroy : PayoutBankDetailViewController = UIStoryboard.gojekCommon.instantiateViewController()
        return stroy
    }
    
    
    func updatePayoutData(_ param:JSON) {
        
        self.viewModel.addBankDetails(param) { (result) in
            switch result {
            case .success( _):
                self.delegate?.getBankDetails()
                self.navigationController?.popViewController(animated: false)
            case .failure(let error) :
                print(error.localizedDescription)
            }
            
            
        }
    }
    

   
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}






extension UILabel {
    func defaultColor() {
        self.backgroundColor = .lightGray
    }
    func changeColor() {
        self.backgroundColor = UIColor.PrimaryColor
    }
}
