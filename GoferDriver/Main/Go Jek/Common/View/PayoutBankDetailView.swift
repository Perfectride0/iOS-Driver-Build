//
//  PayoutBankDetailView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 03/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class PayoutBankDetailView: BaseView,UITextFieldDelegate {
    
    @IBOutlet weak var bankDetailsTitleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var submitButtonOutlet: PrimaryButton!
    @IBOutlet weak var accountHolderView: SecondaryView!
    @IBOutlet weak var holderLabel: SecondarySubHeaderLabel!
    @IBOutlet weak var holderTextField: CommonTextField!
    @IBOutlet weak var holderLineLabel: UILabel!
    
    @IBOutlet weak var accountNumberView: SecondaryView!
    @IBOutlet weak var numberLabel: SecondarySubHeaderLabel!
    @IBOutlet weak var numberTextField: CommonTextField!
    @IBOutlet weak var numberLineLabel: UILabel!
    
    @IBOutlet weak var bankNameView: SecondaryView!
    @IBOutlet weak var nameLabel: SecondarySubHeaderLabel!
    @IBOutlet weak var nameTextField: CommonTextField!
    @IBOutlet weak var nameLineLabel: UILabel!
    
    @IBOutlet weak var bankLocationView: SecondaryView!
    @IBOutlet weak var locationLabel: SecondarySubHeaderLabel!
    @IBOutlet weak var locationLineLabel: UILabel!
    @IBOutlet weak var locationTextField: CommonTextField!
    
    @IBOutlet weak var bankCodeView: SecondaryView!
    @IBOutlet weak var codeLabel: SecondarySubHeaderLabel!
    @IBOutlet weak var codeLineLabel: UILabel!
    @IBOutlet weak var codeTextField: CommonTextField!
    
    @IBOutlet weak var parentView: SecondaryView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var childView: SecondaryView!
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    @IBOutlet weak var headerView: HeaderView!
    
    
    override func darkModeChange() {
        super.darkModeChange()
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
        self.bankDetailsTitleLbl.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.accountHolderView.customColorsUpdate()
        self.holderLabel.customColorsUpdate()
        self.holderTextField.customColorsUpdate()
        self.accountNumberView.customColorsUpdate()
        self.numberTextField.customColorsUpdate()
        self.numberLabel.customColorsUpdate()
        self.childView.customColorsUpdate()
        self.parentView.customColorsUpdate()
        self.codeTextField.customColorsUpdate()
        self.codeLabel.customColorsUpdate()
        self.bankCodeView.customColorsUpdate()
        self.locationTextField.customColorsUpdate()
        self.locationLabel.customColorsUpdate()
        self.bankLocationView.customColorsUpdate()
        self.nameTextField.customColorsUpdate()
        self.nameLabel.customColorsUpdate()
        self.bankNameView.customColorsUpdate()
    }
    
    
    fileprivate let underLineColor = UIColor.blue
    var paramDict = [String:Any]()
    var selectedIndexPath:IndexPath!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    
    
    
    var viewController: PayoutBankDetailViewController!
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? PayoutBankDetailViewController
        self.initDataSource()
        self.initView()
        self.darkModeChange()
    }
    
    func initView() {
        self.bankDetailsTitleLbl.text = LangCommon.bankDetails
        let userInteractionEnabled = self.viewController.isNewRecord
        self.holderTextField.isUserInteractionEnabled = userInteractionEnabled
        self.numberTextField.isUserInteractionEnabled = userInteractionEnabled
        self.nameTextField.isUserInteractionEnabled = userInteractionEnabled
        self.codeTextField.isUserInteractionEnabled = userInteractionEnabled
        self.locationTextField.isUserInteractionEnabled = userInteractionEnabled
        self.bottomView.isHidden = !userInteractionEnabled
        self.submitButtonOutlet.isHidden = !userInteractionEnabled
        self.holderTextField.setLeftPaddingPoints(15)
        self.numberTextField.setLeftPaddingPoints(15)
        self.nameTextField.setLeftPaddingPoints(15)
        self.locationTextField.setLeftPaddingPoints(15)
        self.codeTextField.setLeftPaddingPoints(15)
        self.holderTextField.setRightPaddingPoints(15)
        self.numberTextField.setRightPaddingPoints(15)
        self.nameTextField.setRightPaddingPoints(15)
        self.locationTextField.setRightPaddingPoints(15)
        self.codeTextField.setRightPaddingPoints(15)
        self.holderTextField.cornerRadius = 15
        self.numberTextField.cornerRadius = 15
        self.nameTextField.cornerRadius = 15
        self.locationTextField.cornerRadius = 15
        self.codeTextField.cornerRadius = 15
        self.holderTextField.clipsToBounds = true
        self.numberTextField.clipsToBounds = true
        self.nameTextField.clipsToBounds = true
        self.locationTextField.clipsToBounds = true
        self.codeTextField.clipsToBounds = true
        self.holderTextField.border(1, .TertiaryColor)
        self.numberTextField.border(1, .TertiaryColor)
        self.nameTextField.border(1, .TertiaryColor)
        self.locationTextField.border(1, .TertiaryColor)
        self.codeTextField.border(1, .TertiaryColor)
        self.holderTextField.setTextAlignment()
        self.numberTextField.setTextAlignment()
        self.nameTextField.setTextAlignment()
        self.locationTextField.setTextAlignment()
        self.codeTextField.setTextAlignment()
        
    }
    
    func initDataSource() {
        let bankDetails = self.viewController.bankDetails
        self.addkeyBoardObserverLocal()
        submitButtonOutlet.setTitle(LangCommon.submit.capitalized, for: .normal)
        //        submitButtonOutlet.setTitle("Submit".localize, for: .normal)
        
        //        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        //        let accountHolderName = BankDetails(title: "Account Holder Name", placeHolder: "Account Holder Name")
        holderLabel.text = LangCommon.accountHolderName.capitalized
//        holderTextField.placeholder =  LangCommon.accountHolderName.capitalized
        holderLabel.setTextAlignment()
        holderLabel.setTextAlignment()
        holderTextField.setTextAlignment()
        holderLineLabel.backgroundColor = .TertiaryColor
        
        
        numberLabel.text = LangCommon.accountNumber.capitalized
//        numberTextField.placeholder = LangCommon.accountNumber.capitalized
        
        numberLabel.setTextAlignment()
        numberTextField.setTextAlignment()
        numberLineLabel.backgroundColor = .TertiaryColor
        
        
        nameLabel.text = LangCommon.bankName.capitalized
//        nameTextField.placeholder =  LangCommon.nameOfBank
        nameLabel.setTextAlignment()
        nameTextField.setTextAlignment()
        nameLineLabel.backgroundColor = .TertiaryColor
        
        
        locationLabel.text = LangCommon.bankLocation.capitalized
//        locationTextField.placeholder =  LangCommon.bankLocation.capitalized
        locationLabel.setTextAlignment()
        locationTextField.setTextAlignment()
        locationLineLabel.backgroundColor = .TertiaryColor
        
        
        codeLabel.text = LangCommon.swiftCode
//        codeTextField.placeholder = LangCommon.swiftCode
        codeLabel.setTextAlignment()
        codeTextField.setTextAlignment()
        codeLineLabel.backgroundColor = .TertiaryColor
        
        if isRTLLanguage{
            backBtn?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        //        numberTextField.keyboardType = .numberPad
        holderTextField.delegate = self
        numberTextField.delegate = self
        nameTextField.delegate = self
        locationTextField.delegate = self
        codeTextField.delegate = self
        
        holderTextField.setLeftPaddingPoints(5)
        numberTextField.setLeftPaddingPoints(5)
        nameTextField.setLeftPaddingPoints(5)
        locationTextField.setLeftPaddingPoints(5)
        codeTextField.setLeftPaddingPoints(5)
        
        holderTextField.border(1, .TertiaryColor)
        numberTextField.border(1, .TertiaryColor)
        nameTextField.border(1, .TertiaryColor)
        locationTextField.border(1, .TertiaryColor)
        codeTextField.border(1, .TertiaryColor)
        
        self.holderTextField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        self.numberTextField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        self.nameTextField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        self.locationTextField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        self.codeTextField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        
        
        holderTextField.text = bankDetails?.holder_name
        numberTextField.text = bankDetails?.account_number
        nameTextField.text = bankDetails?.bank_name
        locationTextField.text = bankDetails?.bank_location
        codeTextField.text = bankDetails?.code
        
        holderTextField.setTextAlignment()
        numberTextField.setTextAlignment()
        nameTextField.setTextAlignment()
        locationTextField.setTextAlignment()
        codeTextField.setTextAlignment()
        
        paramDict[BankParams.account_number.rawValue] = bankDetails?.account_number
        
        paramDict[BankParams.account_holder_name.rawValue] = bankDetails?.holder_name
        
        paramDict[BankParams.bank_name.rawValue] = bankDetails?.bank_name
        
        paramDict[BankParams.bank_location.rawValue] = bankDetails?.bank_location
        
        paramDict[BankParams.bank_code.rawValue] = bankDetails?.code
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.changeColor(textField: textField, isColorChange: true)
        return true
    }
    
    func changeColor(textField:UITextField,isColorChange:Bool) {
        numberLineLabel.defaultColor()
        holderLineLabel.defaultColor()
        codeLineLabel.defaultColor()
        locationLineLabel.defaultColor()
        nameLineLabel.defaultColor()
        if isColorChange {
            if textField == numberTextField {
                numberLineLabel.changeColor()
            }
            if textField == holderTextField {
                holderLineLabel.changeColor()
            }
            if textField == nameTextField {
                nameLineLabel.changeColor()
            }
            if textField == locationTextField {
                locationLineLabel.changeColor()
            }
            if textField == codeTextField {
                codeLineLabel.changeColor()
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.changeColor(textField: textField, isColorChange: false)
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldEditingChanged(sender: UITextField){
        if sender == numberTextField {
            paramDict[BankParams.account_number.rawValue] = sender.text!
        }
        if sender == holderTextField {
            paramDict[BankParams.account_holder_name.rawValue] = sender.text!
        }
        if sender == nameTextField {
            paramDict[BankParams.bank_name.rawValue] = sender.text!
        }
        if sender == locationTextField {
            paramDict[BankParams.bank_location.rawValue] = sender.text!
        }
        if sender == codeTextField {
            paramDict[BankParams.bank_code.rawValue] = sender.text!
        }
    }
    func addkeyBoardObserverLocal()
    {
        NotificationCenter.default.addObserver( self, selector: #selector(self.handleKeyboard(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(self.handleKeyboard(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //handle keyboard height dynamically
    @objc func handleKeyboard( note:NSNotification )
    {
        // read the CGRect from the notification (if any)
        if let keyboardFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            if self.scrollView.contentInset.bottom == 0  {
                let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
                self.scrollView.contentInset = edgeInsets
                self.scrollView.scrollIndicatorInsets = edgeInsets
            }
            else {
                let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.childView.frame.origin.y = 0
                self.scrollView.contentInset = edgeInsets
                self.scrollView.scrollIndicatorInsets = edgeInsets
            }
        }
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        let index = [self.checkParam(param: .account_holder_name),
                     self.checkParam(param: .account_number),
                     self.checkParam(param: .bank_name),
                     self.checkParam(param: .bank_location),
                     self.checkParam(param: .bank_code)]
        
        var isNeedtoHitAPI = true
        
        for param in index {
            if param.0 == false {
                self.viewController.presentAlertWithTitle(title: "\(param.1.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)" + " " + LangCommon.common4Required, message: "", options: LangCommon.ok) { (finished) in
                    
                    
                }
                isNeedtoHitAPI = false
                break
            }
        }
    
        
        if isNeedtoHitAPI {
            paramDict["payout_method"] = "bank_transfer"
            self.viewController.updatePayoutData(paramDict)
        }
        
        
        
        
    }
    
    func checkParam(param:BankParams) -> (Bool, BankParams) {
        guard let value = paramDict[param.rawValue] as? String,value.count > 0 else{
            
            return (false,param)
        }
        return (true, param)
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.viewController.navigationController?.popViewController(animated: true)
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}


enum BankParams:String {
    case account_holder_name
    case account_number
    case bank_name
    case bank_location
    case bank_code
}
