//
//  AddPayoutVC.swift
//  GoferDriver
//
//  Created by Trioangle Technologies on 24/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import IQKeyboardManagerSwift
protocol AddStripePayoutDelegate
{
    func payoutStripeAdded()
}
class AddPayoutVC:BaseVC {
    //MARK: Actions
    
    var payoutModelForStripe: PayoutItemModel?
    
    @IBAction func backAction(_ sender: Any) {
        self.exitScreen(animated: true)
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    @IBOutlet var addPayoutView: AddPayoutView!
    let viewModel = PayoutVM()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var isNewRecord : Bool = false
    
    
    func getParams() -> JSON{
        let stripeArrayDataDict = self.addPayoutView.stripeArrayDataDict
        var genderVal = ""
        genderVal = checkNilValue(value:stripeArrayDataDict[LangCommon.gender.capitalized])
        genderVal = genderVal.lowercased()
        var tokenDict = Parameters()
        let country = checkNilValue(value:stripeArrayDataDict[LangCommon.country.capitalized])
        var iban = checkNilValue(value:stripeArrayDataDict[LangCommon.ibanNumber.capitalized])
        var payout = ""
        if country == "MX" {
            iban = checkNilValue(value:stripeArrayDataDict[LangCommon.clabe.capitalized])
        }
        if country == "JP"{
            payout = country
        }
        tokenDict = ["country" :  checkNilValue(value:stripeArrayDataDict[LangCommon.country.capitalized]),
                     "currency" : checkNilValue(value:stripeArrayDataDict[LangCommon.currency.capitalized]),
                     "iban" : iban,
                     "payout_country" : payout,
                     "bsb" : checkNilValue(value:stripeArrayDataDict[LangCommon.bsb.uppercased()]),
                     "ssn_last_4" : checkNilValue(value:stripeArrayDataDict[LangCommon.ssnLastDigit]),
                     "sort_code" : checkNilValue(value:stripeArrayDataDict[LangCommon.sortCode.capitalized]),
                     "clearing_code" : checkNilValue(value:stripeArrayDataDict[LangCommon.clearingCode.capitalized]),
                     "transit_number" : checkNilValue(value:stripeArrayDataDict[LangCommon.transitNumber.capitalized]),
                     "institution_number": checkNilValue(value:stripeArrayDataDict[LangCommon.institutionNumber.capitalized]),
                     "account_number" : checkNilValue(value:stripeArrayDataDict[LangCommon.accountNumber.capitalized]),
                     "routing_number": checkNilValue(value:stripeArrayDataDict[LangCommon.rountingNumber.capitalized]),
                     "bank_name" : checkNilValue(value:stripeArrayDataDict[LangCommon.bankName.capitalized]),
                     "branch_name": checkNilValue(value:stripeArrayDataDict[LangCommon.branchName.capitalized]),
                     "bank_code" : checkNilValue(value:stripeArrayDataDict[LangCommon.bankCode.capitalized]),
                     "branch_code": checkNilValue(value:stripeArrayDataDict[LangCommon.branchCode.capitalized]),
                     "account_holder_name" : checkNilValue(value:stripeArrayDataDict[LangCommon.accountHolderName.capitalized]),
                     "account_owner_name" : checkNilValue(value:stripeArrayDataDict[LangCommon.accountOwnerName.capitalized]),
                     "phone_number" : checkNilValue(value:stripeArrayDataDict[LangCommon.phoneNumber.capitalized]),
                     "address1" : checkNilValue(value:stripeArrayDataDict[LangCommon.addressOne.capitalized]),
                     "address2" : checkNilValue(value:stripeArrayDataDict[LangCommon.addressTwo.capitalized]),
                     "city" : checkNilValue(value:stripeArrayDataDict[LangCommon.city.capitalized]),
                     "state" : checkNilValue(value:stripeArrayDataDict[LangCommon.state.capitalized]),
                     "postal_code" : checkNilValue(value:stripeArrayDataDict[LangCommon.postalCode.capitalized]),
                     "kanji_address1" : checkNilValue(value:stripeArrayDataDict[LangCommon.kanaAddress1]),
                     "kanji_address2" : checkNilValue(value:stripeArrayDataDict[LangCommon.kanaAddress2]),
                     "kanji_city" : checkNilValue(value:stripeArrayDataDict[LangCommon.kanaCity]),
                     "kanji_state" : checkNilValue(value:stripeArrayDataDict[LangCommon.kanaState]),
                     "kanji_postal_code" : checkNilValue(value:stripeArrayDataDict[LangCommon.kanaPostal]),
                     "payout_method" : "stripe",
                     "gender" : genderVal,
                     "token" : Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)]
        return tokenDict
    }
    
    var delegate: AddStripePayoutDelegate?
    //MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override
    func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    func uploadPayoutDetails() {
        var tokenDict = self.getParams()
        
        //        "document" : updateimg,???
        if let image2Upload = self.addPayoutView.uploadImage,let imageUpload = self.addPayoutView.uploadImage_additional {
            
            self.addPayoutView.submitButton.isUserInteractionEnabled = false
            
            
            
            tokenDict["payout_method"] = "stripe"
            
            
            self.viewModel.updatePayoutDetails(requestParams: tokenDict, legalData: image2Upload.pngData() ?? Data(), legalImageName: "document",additionalData: imageUpload.pngData() ?? Data(), additionalImageName: "additional_document") { (result) in
            
                switch result {
                
                case .success( _):
                    self.addPayoutView.submitButton.isUserInteractionEnabled = true
                    self.navigationController?.popViewController(animated: true)
                case .failure( let error):
//                    self.appDelegate.createToastMessageForAlamofire(error.localizedDescription, bgColor: .black, textColor: .white, forView: self.view)
                    self.appDelegate.createToastMessage(error.localizedDescription, bgColor: .black, textColor: .white)
                    print(error.localizedDescription)
                    
                    self.addPayoutView.submitButton.isUserInteractionEnabled = true
                    
                }
                
            }
            
        }
        else{
            appDelegate.createToastMessage(self.addPayoutView.uploadImage_additional == nil ? LangCommon.pleaseUpdateAdditionalDocument : LangCommon.pleaseUpdateDocument, bgColor: .black, textColor: .white)
        }
            }
 //   }
    //MARK: initwithStory
    class func initWithStory() -> AddPayoutVC{
        let view : AddPayoutVC = UIStoryboard.gojekCommon.instantiateViewController()
        return view
    }
    
    func checkNilValue(value:String?) -> String {
        if value == nil {
            return ""
        }
        else {
            return value!
        }
    }
    
    
    func getCountryName()
    {
        if !UberSupport().checkNetworkIssue(self, errorMsg: "")
        {
            return
        }
        viewModel.getCountryNameList { (countryList) in
            print(countryList)
            self.addPayoutView.countries = countryList
            if let payoutModelForStripe = self.payoutModelForStripe {
                self.addPayoutView.setup(stripDetails: payoutModelForStripe)
            }
            self.addPayoutView.countryNamepicker = countryList.compactMap({$0.countryName})
            self.addPayoutView.countryCodepicker = countryList.compactMap({$0.countryCode})
            self.addPayoutView.stripTableView.reloadData()
            self.addPayoutView.pickerView.reloadAllComponents()
        }
        
    }
}



class legalCellTVC :UITableViewCell{
    
    @IBOutlet weak var updateimgNameLabel: SecondarySubHeaderLabel!
    @IBOutlet weak var choosecamerabutton: UIButton!
    @IBOutlet weak var legalDocTitleLbl : SecondarySubHeaderLabel!
    
    @IBOutlet weak var docmentHolderStack: UIStackView!
    @IBOutlet weak var chooseBtnWidthConst: NSLayoutConstraint!
    @IBOutlet weak var documentBgView: SecondaryView!
    func setTheme() {
        if #available(iOS 12.0, *) {
            let isDarkMode = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = isDarkMode ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = isDarkMode ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.documentBgView.customColorsUpdate()
        self.legalDocTitleLbl.customColorsUpdate()
        self.updateimgNameLabel.customColorsUpdate()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.documentBgView.clipsToBounds = true
        self.documentBgView.cornerRadius = 15
        self.documentBgView.border(1, .TertiaryColor)
        self.updateimgNameLabel.setTextAlignment()
        self.legalDocTitleLbl?.setTextAlignment()
        self.setTheme()
    }
}
class StripeCell : UITableViewCell,UITextFieldDelegate {
    @IBOutlet var txtPayouts: CommonTextField?
    @IBOutlet var lblDetails: SecondarySubHeaderLabel?
    @IBOutlet var btnDetails: UIButton?
    @IBOutlet weak var additionalTitle: UILabel!
    
    func setTheme() {
        if #available(iOS 12.0, *) {
            let isDarkMode = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = isDarkMode ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = isDarkMode ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.lblDetails?.customColorsUpdate()
        self.txtPayouts?.customColorsUpdate()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtPayouts?.delegate = self
        self.txtPayouts?.clipsToBounds = true
        self.txtPayouts?.cornerRadius = 15
        self.txtPayouts?.border(1, .TertiaryColor)
        self.lblDetails?.setTextAlignment()
        self.additionalTitle?.setTextAlignment()
        self.setTheme()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
