//
//  AddPayoutView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 03/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class AddPayoutView: BaseView {
    var viewController: AddPayoutVC!
    //MARK: Outlets
    @IBOutlet weak var doneButton: TransparentPrimaryButton!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var stripTableView: CommonTableView!
    @IBOutlet weak var pickerView: CommonPickerView!
    @IBOutlet weak var pageTitle: SecondaryHeaderLabel!
    @IBOutlet weak var pickerHolder: SecondaryView!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    //    let pickerView = UIPickerView()
    @IBOutlet weak var submitButton: PrimaryButton!
    @IBOutlet weak var footerView: TopCurvedView!
    @IBOutlet weak var imgUserThumb: UIImageView!
    @IBOutlet weak var footerViewHeightConstraint: NSLayoutConstraint!
    
    
    override func darkModeChange() {
        super.darkModeChange()
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
            self.backgroundColor = .SecondaryColor
        }
        self.headerView.customColorsUpdate()
        self.pageTitle.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.stripTableView.customColorsUpdate()
        self.pickerView.customColorsUpdate()
        self.pickerHolder.customColorsUpdate()
        self.footerView.customColorsUpdate()
        self.doneButton.setTitle(LangCommon.done, for: .normal)
        self.stripTableView.reloadData()
    }
    
    enum Country : String {
        case Australia = "Australia"
        case Canada = "Canada"
        case Mexico = "Mexico"
        case NewZealand = "New Zealand"
        case USA = "United States"
        case Singapore = "Singapore"
        case Brazil = "Brazil"
        case UK = "United Kingdom"
        case HongKong = "Hong Kong"
        case Japan = "Japan"
        case others = "Others"
    }
    var isLegal = false
    var toReloadCountries = false
    var pickerCloseButtonOutlet = UIBarButtonItem(title:LangCommon.done, style: .plain, target: self, action: #selector(closeAction));
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var imagePicker = UIImagePickerController()
    var stripeArrayDataDict = [String:String]()
    var stripeTitleArray = [String]()
    var AddressKana = [String]()
    var AddressKanji = [String]()
    var curencypicker = [String]()
    var countryNamepicker = [String]()
    var countryIdpicker = [String]()
    var countryCodepicker = [String]()
    var genderPicker = [LangCommon.male,LangCommon.female]
    //    var genderPicker = ["Male".localize,"Female".localize]
    var countryDicts : NSMutableArray = NSMutableArray()
    var countries = [CountryList]()
    var selectedCountry = String()
    var selectedCountryCode = ""
    var selectedCurrency = ""
    var selectedGender = ""
    let triggerTF = UITextField()
    var type = ""
    var user_id = ""
    var updateimg = ""
    var imgName = ""
    var selectedCell : StripeCell!
    var uploadImage : UIImage?
    var uploadImageData : Data?
    var uploadImage_additional : UIImage?
    var uploadImageData_additional : Data?
    var updateimg_additional = ""
    var imgName_additional = ""

    
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? AddPayoutVC
        
        self.initView()
        self.viewController.getCountryName()
        genderPicker = [LangCommon.male.capitalized,LangCommon.female.capitalized]
        self.darkModeChange()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let address2 = LangCommon.addressTwo.capitalized
        //        let address2 = "Address2".localize
        for title in stripeTitleArray{
            if title != address2 ||  title != address2{
                if (stripeArrayDataDict["\(title)"]?.count == 0) || stripeArrayDataDict["\(title)"] == nil  {
                    appDelegate.createToastMessage(LangCommon.pleaseEnter.capitalized+" \(title)", bgColor: .black, textColor: .white)
                    
                    return
                }
            }
            
        }
        self.viewController.uploadPayoutDetails()
        
        //
        
    }
    //MARK: initializers
    func initView(){
        self.stripTableView.delegate = self
        self.stripTableView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.footerView.isHidden = !self.viewController.isNewRecord
        self.submitButton.isHidden = !self.viewController.isNewRecord
        self.pageTitle.text = LangCommon.payouts.capitalized
        
        self.submitButton.setTitle(LangCommon.submit.capitalized, for: .normal)
        
        
        
        
        self.pickerHolder.isHidden = true
        stripeArrayDataDict = [LangCommon.country.capitalized:"",
                               LangCommon.currency.capitalized:"",
                               LangCommon.ibanNumber.capitalized:"",
                               LangCommon.accountHolderName.capitalized:"",
                               LangCommon.addressOne.capitalized:"",
                               LangCommon.addressTwo.capitalized:"",
                               LangCommon.city.capitalized:"",
                               LangCommon.state.capitalized:"",
                               LangCommon.postalCode.capitalized:""]
        stripeTitleArray = [LangCommon.country.capitalized,
                            LangCommon.currency.capitalized,
                            LangCommon.ibanNumber.capitalized,
                            LangCommon.accountHolderName.capitalized,
                            LangCommon.addressOne.capitalized,
                            LangCommon.addressTwo.capitalized,
                            LangCommon.city.capitalized,
                            LangCommon.state.capitalized,
                            LangCommon.postalCode.capitalized]
        stripTableView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    func setup(stripDetails : PayoutItemModel) {
        guard let payoutData = stripDetails.payoutData else { return }
        if let country = countries.filter({$0.countryCode == payoutData.country}).first {
            self.selectedCountry = country.countryName
            self.curencypicker = country.currencyCode ?? []
            self.selectedCurrency = country.currencyCode?.first ?? ""
        }
        // Document name From Api
        imgName = payoutData.document
        
        self.setDetailsArrayBasedOnCountry(CountryName: self.selectedCountry, PayoutDetails: stripDetails)
    }
    
    func setDetailsArrayBasedOnCountry(CountryName:String,PayoutDetails: PayoutItemModel) {
        guard let payoutData = PayoutDetails.payoutData else { return }
        var tempStripDetails:[String:String] = [:]
        var tempTitleArray:[String] = []
        let commonLang = LangCommon
        
        let country:Country = Country.init(rawValue: CountryName) ?? .others
        
        // Common Details update
        tempStripDetails[commonLang.country.capitalized] = self.selectedCountry
        tempStripDetails[commonLang.currency.capitalized] = self.selectedCurrency

        if country != .others && country != .Mexico {
            tempStripDetails[commonLang.accountNumber.capitalized] = payoutData.accountNumber
        }

        tempStripDetails[commonLang.accountHolderName.capitalized] = payoutData.holderName
        tempStripDetails[commonLang.addressOne.capitalized] = payoutData.address1
        tempStripDetails[commonLang.addressTwo.capitalized] = payoutData.address2
        tempStripDetails[commonLang.city.capitalized] = payoutData.city
        tempStripDetails[commonLang.state.capitalized] = payoutData.state
        tempStripDetails[commonLang.postalCode.capitalized] = payoutData.postalCode
        
        // Common Title Update
        tempTitleArray.append(commonLang.country.capitalized)
        tempTitleArray.append(commonLang.currency.capitalized)
        
        
        
        switch country {
        
        case .Australia:
            
            // Inituals For Australia
            tempStripDetails[commonLang.bsb.uppercased()] = payoutData.routingNumber // bsb Details
            
            // Title Order For Australia
            tempTitleArray.append(commonLang.bsb.uppercased())
            tempTitleArray.append(commonLang.accountNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)
            
        case .Canada:
            
            // Inituals For Canada
            tempStripDetails[commonLang.transitNumber.capitalized] = "" // transit number
            tempStripDetails[commonLang.institutionNumber.capitalized] = "" // instution Number
            
            // Title Order For Canada
            tempTitleArray.append(commonLang.transitNumber.capitalized)
            tempTitleArray.append(commonLang.institutionNumber.capitalized)
            tempTitleArray.append(commonLang.accountNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)
        case .Mexico:
            // Inituals For Canada
            tempStripDetails[commonLang.clabe.capitalized] = "" // clabe
            // Title Order For Canada
            tempTitleArray.append(commonLang.clabe.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)

        case .NewZealand:
            
            // Inituals For New Zealand
            tempStripDetails[commonLang.rountingNumber.capitalized] = payoutData.routingNumber // rountingNumber number
            
            // Title Order For New Zealand
            tempTitleArray.append(commonLang.rountingNumber.capitalized)
            tempTitleArray.append(commonLang.accountNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)
            
        case .USA:
            
            // Individual For USA
            tempStripDetails[commonLang.rountingNumber.capitalized] = payoutData.routingNumber
            tempStripDetails[commonLang.ssnLastDigit] = payoutData.ssnLast4 // ssn Last Digit
            
            // Title Order For USA
            tempTitleArray.append(commonLang.rountingNumber.capitalized)
            tempTitleArray.append(commonLang.ssnLastDigit)
            tempTitleArray.append(commonLang.accountNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)
            
        case .Singapore:
            
            // Individual For Singapore
            tempStripDetails[commonLang.bankCode.capitalized] = "" // bank Code
            tempStripDetails[commonLang.branchCode.capitalized] = payoutData.branchCode
            
            // Title Order For Singapore
            tempTitleArray.append(commonLang.bankCode.capitalized)
            tempTitleArray.append(commonLang.branchCode.capitalized)
            tempTitleArray.append(commonLang.accountNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)
        case .Brazil:
            
            // Individual For Singapore
            tempStripDetails[commonLang.bankCode.capitalized] = "" // bank Code
            tempStripDetails[commonLang.branchCode.capitalized] = payoutData.branchCode
            
            // Title Order For Singapore
            tempTitleArray.append(commonLang.bankCode.capitalized)
            tempTitleArray.append(commonLang.branchCode.capitalized)
            tempTitleArray.append(commonLang.accountNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)
        case .UK:
            
            // Individual For UK
            tempStripDetails[commonLang.sortCode.capitalized] = payoutData.routingNumber // sort Code
            
            // Title Order For UK
            tempTitleArray.append(commonLang.sortCode.capitalized)
            tempTitleArray.append(commonLang.accountNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)
            
        case .HongKong:
            
            // Individual For HongKong
            tempStripDetails[commonLang.clearingCode.capitalized] = payoutData.routingNumber
                .components(separatedBy: "-").first // clearing Code
            tempStripDetails[commonLang.branchCode.capitalized] = payoutData.routingNumber
                .components(separatedBy: "-").last //  branch Code
            
            // Title Order For HongKong
            tempTitleArray.append(commonLang.clearingCode.capitalized)
            tempTitleArray.append(commonLang.branchCode.capitalized)
            tempTitleArray.append(commonLang.accountNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)
            
        case .Japan:
            
            // Individual For Japan
            tempStripDetails[commonLang.bankName.capitalized] = payoutData.bankName // bank Name
            tempStripDetails[commonLang.branchName.capitalized] = payoutData.branchName
            tempStripDetails[commonLang.bankCode.capitalized] = "" // bank Code
            tempStripDetails[commonLang.branchCode.capitalized] = payoutData.branchCode
            tempStripDetails[commonLang.accountOwnerName.capitalized] = "" // accountOwner Name
            tempStripDetails[commonLang.phoneNumber.capitalized] = payoutData.phoneNumber
            tempStripDetails[commonLang.gender.capitalized] = selectedGender // gender
            tempStripDetails[commonLang.kanaAddress1.capitalized] = ""
            tempStripDetails[commonLang.kanaAddress2.capitalized] = ""
            tempStripDetails[commonLang.kanaCity.capitalized] = ""
            tempStripDetails[commonLang.kanaState.capitalized] = ""
            tempStripDetails[commonLang.kanaPostal.capitalized] = ""
            
            // Title Order For Japan
            
            tempTitleArray.append(commonLang.bankName.capitalized)
            tempTitleArray.append(commonLang.branchName.capitalized)
            tempTitleArray.append(commonLang.bankCode.capitalized)
            tempTitleArray.append(commonLang.branchCode.capitalized)
            tempTitleArray.append(commonLang.accountNumber.capitalized)
            tempTitleArray.append(commonLang.accountOwnerName.capitalized)
            tempTitleArray.append(commonLang.phoneNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.gender.capitalized)
            
            if AddressKana.isEmpty {
                AddressKana
                    .append(contentsOf: [commonLang.addressOne.capitalized,
                                         commonLang.addressTwo.capitalized,
                                         commonLang.city.capitalized,
                                         commonLang.state.capitalized,
                                         commonLang.postalCode.capitalized])}
            if AddressKanji.isEmpty {
                AddressKanji
                    .append(contentsOf: [commonLang.kanaAddress1.capitalized,
                                         commonLang.kanaAddress2.capitalized,
                                         commonLang.kanaCity.capitalized,
                                         commonLang.kanaState.capitalized,
                                         commonLang.kanaPostal.capitalized])}
            
        case .others:
            
            // Individual For Other Country
            tempStripDetails[commonLang.ibanNumber.capitalized] = payoutData.accountNumber
            
            // Common Title Array For Other Countries
            tempTitleArray.append(commonLang.ibanNumber.capitalized)
            tempTitleArray.append(commonLang.accountHolderName.capitalized)
            tempTitleArray.append(commonLang.addressOne.capitalized)
            tempTitleArray.append(commonLang.addressTwo.capitalized)
            tempTitleArray.append(commonLang.city.capitalized)
            tempTitleArray.append(commonLang.state.capitalized)
            tempTitleArray.append(commonLang.postalCode.capitalized)
        }
        
        stripeTitleArray = tempTitleArray
        stripeArrayDataDict = tempStripDetails
    }
    
}


extension AddPayoutView: UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        _ = sender.tag
        pickerHolder.isHidden = true
        
        var tempStripeDataDict = [String:String]()
        //        curencypicker = self.countries[tagVal].currencyCode
        //        curencypicker = countries.filter({$0.countryName == self.selectedCountry}).first?.currencyCode ?? countries[0].currencyCode
        //        let listModel = self.countryDicts[tagVal] as? PayoutPerferenceModel
        
        
        //(listModel?.currency_code) as! [String]
        
        switch type{
        case "gender":
            if selectedGender == String(){
                selectedGender = genderPicker[0]
            }
                self.stripeArrayDataDict[LangCommon.gender.capitalized] = selectedGender
                self.stripTableView.reloadData()
            
        case "currency":
            if selectedCurrency == String(){
                selectedCurrency = curencypicker[0]
            }
                self.stripeArrayDataDict[LangCommon.currency.capitalized] = selectedCurrency
                self.stripTableView.reloadData()
            
        default:
            if selectedCountry == String(){
                toReloadCountries = true
                let modelTemp = countryNamepicker[0]
                let modele = countryCodepicker[0]
                selectedCountry = modelTemp
                selectedCountryCode = modele
                stripeArrayDataDict[LangCommon.country.capitalized] = modele
                //            stripeArrayDataDict["Country".localize] = modelTemp as? String ?? String()//modele as? String ?? String()
                curencypicker = countries[0].currencyCode ?? [String]()
            }
        }
        if toReloadCountries{
            toReloadCountries = false
            switch selectedCountry {
            case "Australia":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.bsb.uppercased():"",
                                      LangCommon.accountNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.bsb.uppercased(),
                                    LangCommon.accountNumber.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
                
            case "Canada":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.transitNumber.capitalized:"",
                                      LangCommon.institutionNumber.capitalized:"",
                                      LangCommon.accountNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.transitNumber.capitalized,
                                    LangCommon.institutionNumber.capitalized,
                                    LangCommon.accountNumber.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
            case "Mexico":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.clabe.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.clabe.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
                
            case "New Zealand":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.rountingNumber.capitalized:"",
                                      LangCommon.accountNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.rountingNumber.capitalized,
                                    LangCommon.accountNumber.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
                
            case "United States":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.rountingNumber.capitalized:"",
                                      LangCommon.ssnLastDigit:"",
                                      LangCommon.accountNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.rountingNumber.capitalized,
                                    LangCommon.ssnLastDigit,
                                    LangCommon.accountNumber.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
                
            case "Singapore":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.bankCode.capitalized:"",
                                      LangCommon.branchCode.capitalized:"",
                                      LangCommon.accountNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.bankCode.capitalized,
                                    LangCommon.branchCode.capitalized,
                                    LangCommon.accountNumber.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
            case "Brazil":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.bankCode.capitalized:"",
                                      LangCommon.branchCode.capitalized:"",
                                      LangCommon.accountNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.bankCode.capitalized,
                                    LangCommon.branchCode.capitalized,
                                    LangCommon.accountNumber.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
                
            case "United Kingdom":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.sortCode.capitalized:"",
                                      LangCommon.accountNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.sortCode.capitalized,
                                    LangCommon.accountNumber.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
            case "Hong Kong":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.clearingCode.capitalized:"",
                                      LangCommon.branchCode.capitalized:"",
                                      LangCommon.accountNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.clearingCode.capitalized,
                                    LangCommon.branchCode.capitalized,
                                    LangCommon.accountNumber.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
            case "Japan":
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.bankName.capitalized:"",
                                      LangCommon.branchName.capitalized:"",
                                      LangCommon.bankCode.capitalized:"",
                                      LangCommon.branchCode.capitalized:"",
                                      LangCommon.accountNumber.capitalized:"",
                                      LangCommon.accountOwnerName.capitalized:"",
                                      LangCommon.phoneNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.gender.capitalized:selectedGender,
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:"",
                                      LangCommon.kanaAddress1:"",
                                      LangCommon.kanaAddress2:"",
                                      LangCommon.kanaCity:"",
                                      LangCommon.kanaState:"",
                                      LangCommon.kanaPostal:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.bankName.capitalized,
                                    LangCommon.branchName.capitalized,
                                    LangCommon.bankCode.capitalized,
                                    LangCommon.branchCode.capitalized,
                                    LangCommon.accountNumber.capitalized,
                                    LangCommon.accountOwnerName.capitalized,
                                    LangCommon.phoneNumber.capitalized,
                                    LangCommon.accountHolderName,
                                    LangCommon.gender]
                
                AddressKana = [LangCommon.addressOne.capitalized,
                               LangCommon.addressTwo.capitalized,
                               LangCommon.city.capitalized,
                               LangCommon.state.capitalized,
                               LangCommon.postalCode.capitalized]
                
                AddressKanji = [LangCommon.kanaAddress1,
                                LangCommon.kanaAddress2,
                                LangCommon.kanaCity,
                                LangCommon.kanaState,
                                LangCommon.kanaPostal]
            default:
                
                tempStripeDataDict = [LangCommon.country.capitalized:selectedCountryCode,
                                      LangCommon.currency.capitalized:selectedCurrency,
                                      LangCommon.ibanNumber.capitalized:"",
                                      LangCommon.accountHolderName.capitalized:"",
                                      LangCommon.addressOne.capitalized:"",
                                      LangCommon.addressTwo.capitalized:"",
                                      LangCommon.city.capitalized:"",
                                      LangCommon.state.capitalized:"",
                                      LangCommon.postalCode.capitalized:""]
                
                stripeTitleArray = [LangCommon.country.capitalized,
                                    LangCommon.currency.capitalized,
                                    LangCommon.ibanNumber.capitalized,
                                    LangCommon.accountHolderName.capitalized,
                                    LangCommon.addressOne.capitalized,
                                    LangCommon.addressTwo.capitalized,
                                    LangCommon.city.capitalized,
                                    LangCommon.state.capitalized,
                                    LangCommon.postalCode.capitalized]
                
            }
            for key in tempStripeDataDict.keys {
                if stripeArrayDataDict.keys.contains(key) {
                    
                    if ["gender", "currency"].contains(type){
                        if (![LangCommon.country.capitalized,LangCommon.currency.capitalized,LangCommon.gender.capitalized].contains(key)){
                            tempStripeDataDict[key] = ""//stripeArrayDataDict[key]
                        }
                    }else {
                        if (![LangCommon.country.capitalized].contains(key)){
                            tempStripeDataDict[key] = ""//stripeArrayDataDict[key]
                            self.selectedGender = String()
                            self.selectedCurrency = String()
                        }
                    }
                }
            }
            stripeArrayDataDict = tempStripeDataDict
            stripTableView.reloadData()
            
        } else {
            
            stripeArrayDataDict[LangCommon.country.capitalized] = selectedCountryCode//countryNamepicker.first
        }
        
        
    }
    //MARK: PICKER VIEW DELEGATE AND DATA SOURCE
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if type == "currency" {
            return curencypicker.count
        }  else if type == "gender" {
            return genderPicker.count
        } else if type == "country"  {
            return countryNamepicker.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if type == "currency" {
            return curencypicker[row]
        } else if type == "country" {
            return countryNamepicker[row]
        } else if type == "gender"{
            return genderPicker[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if type == "currency" {
            let modelTemp = curencypicker[row]
            selectedCurrency = modelTemp
            stripeArrayDataDict[LangCommon.currency.capitalized] = modelTemp
            //            stripeArrayDataDict["Currency".localize] = modelTemp
            
        }
        else if type == "gender" {
            let modelTemp = genderPicker[row]
            selectedGender = modelTemp
            stripeArrayDataDict[LangCommon.gender.capitalized] = modelTemp
            //            stripeArrayDataDict["Gender".localize] = modelTemp
            
        }
        else{
            let modelTemp = countryNamepicker[row]
            let modele = countryCodepicker[row]
            if modelTemp == selectedCountry {
                toReloadCountries = false
            }else{
                toReloadCountries = true
                selectedCountry = modelTemp //as? String ?? String()
                selectedCountryCode = modele //as? String ?? String()
                //            stripeArrayDataDict[LangCommon.country] = modelTemp as? String ?? String()//modele as? String ?? String()
                //            stripeArrayDataDict["Country".localize] = modelTemp as? String ?? String()//modele as? String ?? String()
                curencypicker = countries[row].currencyCode ?? [String]()
                pickerCloseButtonOutlet.tintColor = .PrimaryColor
                pickerCloseButtonOutlet = UIBarButtonItem(title:LangCommon.done.capitalized, style: .plain, target: self, action: #selector(closeAction))
                pickerCloseButtonOutlet.tag = row
            }
            
            
        }
        //        self.closeAction(pickerCloseButtonOutlet)
        
    }
    
    @IBAction func onTableRowTapped(_ sender:UIButton!)  {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        selectedCell = stripTableView.cellForRow(at: indexPath) as? StripeCell
        if sender.tag==0
        {
            self.endEditing(true)
            type = "country"
            pickerHolder.isHidden = false
            pickerView.reloadAllComponents()
            
            self.bringSubviewToFront(self.pickerHolder)
            //            if stripeArrayDataDict["Country".localize]?.count == 0 {
            if stripeArrayDataDict[LangCommon.country.capitalized]?.count == 0 {
                stripeArrayDataDict[LangCommon.country.capitalized] = countryCodepicker[0]
                //                stripeArrayDataDict["Country".localize] = countryNamepicker[0]//countryCodepicker[0]
                pickerView.selectRow(0, inComponent: 0, animated: true)
            }
            else {
                
                pickerView.selectRow(countryNamepicker.firstIndex(of: selectedCountry) ?? 0, inComponent: 0, animated: true)
            }
            stripeArrayDataDict[LangCommon.currency.capitalized] = ""
            //            stripeArrayDataDict["Currency".localize] = ""
            
        }
        
        else if sender.tag==1
        {
            guard (stripeArrayDataDict[LangCommon.country.capitalized]?.count)! > 0 else {
                return
            }
            self.endEditing(true)
            type = "currency"
            pickerHolder.isHidden = false
            pickerView.reloadAllComponents()
            if stripeArrayDataDict[LangCommon.currency.capitalized]?.count == 0,!curencypicker.isEmpty {
                stripeArrayDataDict[LangCommon.currency.capitalized] = curencypicker[0]
                pickerView.selectRow(0, inComponent: 0, animated: true)
            }
            else {
                pickerView.selectRow(curencypicker.firstIndex(of: selectedCurrency) ?? 0, inComponent: 0, animated: true)
            }
        }
        else if sender.tag==10 // japan only
        {
            guard (stripeArrayDataDict[LangCommon.country.capitalized]?.count)! > 0 else {
                return
            }
            self.endEditing(true)
            type = "gender"
            pickerHolder.isHidden = false
            pickerView.reloadAllComponents()
            if stripeArrayDataDict[LangCommon.gender.capitalized]?.count == 0 {
                stripeArrayDataDict[LangCommon.gender.capitalized] = genderPicker[0]
                pickerView.selectRow(0, inComponent: 0, animated: true)
            }
            else {
                pickerView.selectRow(genderPicker.firstIndex(of: selectedGender) ?? 0, inComponent: 0, animated: true)
            }
        }
        else
        {
            selectedCell.txtPayouts?.inputView = nil
            selectedCell.txtPayouts?.keyboardType = (sender.tag==4) ? UIKeyboardType.asciiCapable : UIKeyboardType.asciiCapable
            pickerHolder.isHidden = true
            selectedCell.txtPayouts?.becomeFirstResponder()
        }
        pickerView.reloadAllComponents()
    }
}


extension AddPayoutView : UITableViewDelegate,UITableViewDataSource{
    // MARK: TABLE VIEW DELEGATE AND DATA SOURCE ADDED
    
    @objc func fieldValueUpdate(sender: UITextField) {
        guard let hint = sender.accessibilityHint else { return }
        self.stripeArrayDataDict[hint] = sender.text
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedCountry == "Japan"{
            return 4
        }
        else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if countryNamepicker.count != 0 {
            switch section{
            case 0:
                return stripeTitleArray.count
            case 1 where selectedCountry == "Japan":
                return AddressKana.count
            case 2 where selectedCountry == "Japan":
                return AddressKanji.count
            default:
                return 2
            }
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (stripTableView.frame.size.width) ,height: 40)
        let lblRoomName : UILabel = UILabel()
        if selectedCountry == "Japan" {
            if section == 0 {
                lblRoomName.text = LangCommon.stripeDetails.capitalized
            } else if section == 1 {
                lblRoomName.text = LangCommon.addressKana.capitalized
            } else if section == 2 {
                lblRoomName.text = LangCommon.addressKanji.capitalized
            } else {
                lblRoomName.text = ""
            }
        } else {
            lblRoomName.text = LangCommon.stripeDetails.capitalized
            if section == 0 {
                lblRoomName.text = LangCommon.stripeDetails.capitalized
            } else {
                lblRoomName.text = ""
            }
        }
        viewHolder.backgroundColor = .clear
        lblRoomName.textAlignment = .center
        viewHolder.addSubview(lblRoomName)
        lblRoomName.anchor(toView: viewHolder,
                           leading: 10,
                           trailing: -10,
                           top: 10,
                           bottom: -10)
        return viewHolder
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectedCountry == "Japan" {
            return (section == 1 || section == 2 || section == 0) ? 65 : 0
        } else {
            return section == 0 ? 65 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCountry == "Japan" {
            return indexPath.section == 3 ? 124 : 105
        } else {
            return indexPath.section == 1 ? 124 : 105
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedCountry == "Japan" {
            if indexPath.section==0{
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "StripeCell") as! StripeCell
                cell.txtPayouts?.autocorrectionType = .no
                //cell.txtPayouts?.textAlignment = .natural
                cell.txtPayouts?.setLeftPaddingPoints(15)
                cell.txtPayouts?.setRightPaddingPoints(15)
                cell.lblDetails?.text = stripeTitleArray[indexPath.row]
                cell.txtPayouts?.delegate = self
                cell.btnDetails?.tag = indexPath.row
                cell.additionalTitle.isHidden = true
                cell.lblDetails?.isHidden = false
                cell.btnDetails?.isHidden = (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 10) ? false : true
                cell.btnDetails?.addTarget(self, action: #selector(self.onTableRowTapped), for: UIControl.Event.touchUpInside)
//                cell.txtPayouts?.accessibilityHint = cell.txtPayouts?.placeholder
                cell.txtPayouts?.addTarget(self, action: #selector(fieldValueUpdate(sender:)), for: .editingChanged)
                cell.btnDetails?.isUserInteractionEnabled = true
                if indexPath.row == 0 {
                    cell.txtPayouts?.text = selectedCountry
                }
                else{
                    cell.txtPayouts?.text = stripeArrayDataDict[(cell.lblDetails?.text)!]
                    cell.txtPayouts?.placeholder = stripeTitleArray[indexPath.row]
                    cell.txtPayouts?.accessibilityHint = stripeTitleArray[indexPath.row]
                    cell.txtPayouts?.addTarget(self, action: #selector(fieldValueUpdate(sender:)), for: .editingChanged)
                }
                cell.isUserInteractionEnabled = self.viewController.isNewRecord
                cell.setTheme()
                cell.txtPayouts?.setTextAlignment()
                return cell
            } else if indexPath.section==1 {
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "StripeCell") as! StripeCell
                cell.txtPayouts?.setLeftPaddingPoints(15)
                cell.txtPayouts?.setRightPaddingPoints(15)
                cell.txtPayouts?.autocorrectionType = .no
                cell.lblDetails?.text = AddressKana[indexPath.row]
                cell.additionalTitle.isHidden = true
                cell.lblDetails?.isHidden = false
                cell.txtPayouts?.text = stripeArrayDataDict[(cell.lblDetails?.text)!]
//                cell.txtPayouts?.placeholder = AddressKana[indexPath.row]
                cell.txtPayouts?.accessibilityHint = AddressKana[indexPath.row]
                cell.txtPayouts?.addTarget(self, action: #selector(fieldValueUpdate(sender:)), for: .editingChanged)
                cell.btnDetails?.isHidden = true
                cell.isUserInteractionEnabled = self.viewController.isNewRecord
                cell.txtPayouts?.setTextAlignment()
                cell.setTheme()
                return cell
            } else if indexPath.section==2 {
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "StripeCell") as! StripeCell
                cell.txtPayouts?.autocorrectionType = .no
                cell.txtPayouts?.setLeftPaddingPoints(15)
                cell.txtPayouts?.setRightPaddingPoints(15)
                let title = [LangCommon.addressOne.capitalized,LangCommon.addressTwo.capitalized,LangCommon.city.capitalized,LangCommon.state.capitalized,LangCommon.postalCode.capitalized]
                cell.additionalTitle.isHidden = false
                cell.lblDetails?.isHidden = true
                cell.lblDetails?.text = AddressKanji[indexPath.row] as String
                cell.additionalTitle?.text = title[indexPath.row] as String
                cell.txtPayouts?.text = stripeArrayDataDict[(cell.lblDetails?.text)!]
//                cell.txtPayouts?.placeholder = title[indexPath.row]
                cell.txtPayouts?.accessibilityHint = AddressKanji[indexPath.row] as String
                cell.txtPayouts?.addTarget(self, action: #selector(fieldValueUpdate(sender:)), for: .editingChanged)
                cell.btnDetails?.isHidden = true
                cell.isUserInteractionEnabled = self.viewController.isNewRecord
                cell.txtPayouts?.setTextAlignment()
                cell.setTheme()
                return cell
            } else {
                if indexPath.row == 0 {
                    let cell = stripTableView.dequeueReusableCell(withIdentifier: "legalCellTVC") as! legalCellTVC
                    cell.legalDocTitleLbl.text = LangCommon.legalDocuments
                    cell.legalDocTitleLbl.textAlignment = .natural
                    cell.choosecamerabutton.tag = indexPath.row
                    cell.choosecamerabutton.clipsToBounds = true
                    cell.choosecamerabutton.cornerRadius = 10
                    cell.choosecamerabutton.addTarget(self, action: #selector(self.openPhotoAccess), for: UIControl.Event.touchUpInside)
                    cell.updateimgNameLabel.text = imgName
                    cell.choosecamerabutton.translatesAutoresizingMaskIntoConstraints = false
                    cell.updateimgNameLabel.isHidden = (imgName == "")
                    cell.chooseBtnWidthConst.constant = (imgName == "") ?  cell.docmentHolderStack.bounds.width : 100
                    cell.choosecamerabutton.setTitle(imgName == "" ? LangCommon.add.capitalized : LangCommon.update.capitalized, for: .normal)
                    cell.isUserInteractionEnabled = self.viewController.isNewRecord
                    cell.setTheme()
                    return cell

                }else{
                    let cell = stripTableView.dequeueReusableCell(withIdentifier: "legalCellTVC") as! legalCellTVC
                    cell.legalDocTitleLbl.text = LangCommon.additionalDocuments
                    cell.legalDocTitleLbl.textAlignment = .natural
                    cell.choosecamerabutton.tag = indexPath.row
                    cell.choosecamerabutton.clipsToBounds = true
                    cell.choosecamerabutton.cornerRadius = 10
                    cell.choosecamerabutton.addTarget(self, action: #selector(self.openPhotoAccess), for: UIControl.Event.touchUpInside)
                    cell.updateimgNameLabel.text = imgName_additional
                    cell.chooseBtnWidthConst.constant = (imgName_additional == "") ?  cell.docmentHolderStack.bounds.width : 100
                    cell.choosecamerabutton.translatesAutoresizingMaskIntoConstraints = false
                    cell.updateimgNameLabel.isHidden = (imgName_additional == "")
                    cell.choosecamerabutton.setTitle(imgName_additional == "" ? LangCommon.add.capitalized : LangCommon.update.capitalized, for: .normal)
                    cell.isUserInteractionEnabled = self.viewController.isNewRecord
                    cell.setTheme()
                    return cell

                }
            }
        } else {
            if indexPath.section==0 {
                let cell = stripTableView.dequeueReusableCell(withIdentifier: "StripeCell") as! StripeCell
                cell.lblDetails?.text = stripeTitleArray[indexPath.row]
                cell.btnDetails?.tag = indexPath.row
                cell.additionalTitle.isHidden = true
                cell.lblDetails?.isHidden = false
                cell.btnDetails?.isHidden = (indexPath.row == 0 || indexPath.row == 1) ? false : true
                cell.btnDetails?.addTarget(self, action: #selector(self.onTableRowTapped), for: UIControl.Event.touchUpInside)
                cell.btnDetails?.isUserInteractionEnabled = true
                cell.txtPayouts?.delegate = self
                cell.txtPayouts?.setLeftPaddingPoints(15)
                cell.txtPayouts?.setRightPaddingPoints(15)
                if indexPath.row == 0 {
                    cell.txtPayouts?.text = selectedCountry
//                    cell.txtPayouts?.placeholder = stripeTitleArray[indexPath.row]
                    cell.txtPayouts?.accessibilityHint = stripeTitleArray[indexPath.row]
                    cell.txtPayouts?.addTarget(self, action: #selector(fieldValueUpdate(sender:)), for: .editingChanged)
                }
                else{
//                    cell.txtPayouts?.placeholder = stripeTitleArray[indexPath.row]
                    cell.txtPayouts?.text = stripeArrayDataDict[(cell.lblDetails?.text)!]
                    cell.txtPayouts?.accessibilityHint = stripeTitleArray[indexPath.row]
                    cell.txtPayouts?.addTarget(self, action: #selector(fieldValueUpdate(sender:)), for: .editingChanged)
                    cell.txtPayouts?.setLeftPaddingPoints(15)
                    cell.txtPayouts?.setRightPaddingPoints(15)
                }
                cell.isUserInteractionEnabled = self.viewController.isNewRecord
                cell.txtPayouts?.setTextAlignment()
                cell.setTheme()
                return cell
            } else {
                if indexPath.row == 0 {
                    let cell = stripTableView.dequeueReusableCell(withIdentifier: "legalCellTVC") as! legalCellTVC
                    cell.legalDocTitleLbl.text = LangCommon.legalDocuments
                    cell.legalDocTitleLbl.textAlignment = .natural
                    cell.choosecamerabutton.tag = indexPath.row
                    cell.choosecamerabutton.clipsToBounds = true
                    cell.choosecamerabutton.cornerRadius = 10
                    cell.choosecamerabutton.addTarget(self, action: #selector(self.openPhotoAccess), for: UIControl.Event.touchUpInside)
                    cell.updateimgNameLabel.text = imgName
                    cell.choosecamerabutton.translatesAutoresizingMaskIntoConstraints = false
                    cell.updateimgNameLabel.isHidden = (imgName == "")
                    cell.chooseBtnWidthConst.constant = (imgName == "") ?  cell.docmentHolderStack.bounds.width : 100
                    cell.choosecamerabutton.setTitle(imgName == "" ? LangCommon.add.capitalized : LangCommon.update.capitalized, for: .normal)
                    cell.isUserInteractionEnabled = self.viewController.isNewRecord
                    cell.setTheme()
                    return cell
                } else {
                    let cell = stripTableView.dequeueReusableCell(withIdentifier: "legalCellTVC") as! legalCellTVC
                    cell.legalDocTitleLbl.text = LangCommon.additionalDocuments
                    cell.legalDocTitleLbl.textAlignment = .natural
                    cell.choosecamerabutton.tag = indexPath.row
                    cell.choosecamerabutton.clipsToBounds = true
                    cell.choosecamerabutton.cornerRadius = 10
                    cell.choosecamerabutton.addTarget(self, action: #selector(self.openPhotoAccess), for: UIControl.Event.touchUpInside)
                    cell.updateimgNameLabel.text = imgName_additional
                    cell.choosecamerabutton.translatesAutoresizingMaskIntoConstraints = false
                    cell.updateimgNameLabel.isHidden = (imgName_additional == "")
                    cell.chooseBtnWidthConst.constant = (imgName_additional == "") ?  cell.docmentHolderStack.bounds.width : 100
                    cell.choosecamerabutton.setTitle(imgName_additional == "" ? LangCommon.add.capitalized : LangCommon.update.capitalized, for: .normal)
                    cell.isUserInteractionEnabled = self.viewController.isNewRecord
                    cell.setTheme()
                    return cell
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AddPayoutView :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func openPhotoAccess(sender: UIButton){
        self.endEditing(true)
        self.isLegal = (sender.tag == 0) ? true : false
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet
            .addAction(
                UIAlertAction(title: LangCommon.takePhoto.capitalized,
                              style: .default,
                              handler: { (_) in
                                //                                actionSheet.dismiss(animated: false) {
                                //                                    self.checkTakePhotoAuthorization()
                                //                                }
                                actionSheet.dismiss(animated: false, completion: nil)
                                DispatchQueue
                                    .performAsync(on: .main,
                                                  withDelay: .now() + 0.1) {
                                        self.checkTakePhotoAuthorization()
                                    }
                                
                              }))
        actionSheet
            .addAction(UIAlertAction(title: LangCommon.choosePhoto.capitalized,
                                     style: .default,
                                     handler: { (_) in
                                        //                                        actionSheet.dismiss(animated: false) {
                                        //                                            self.choosePhoto()
                                        //                                        }
                                        actionSheet.dismiss(animated: false, completion: nil)
                                        DispatchQueue
                                            .performAsync(on: .main,
                                                          withDelay: .now() + 0.1) {
                                                self.choosePhoto()
                                            }
                                     }))
        actionSheet.addAction(UIAlertAction(title: LangCommon.cancel.capitalized,
                                            style: .destructive,
                                            handler: { (_) in
                                                actionSheet.dismiss(animated: true, completion: nil)
                                            }))
        self.viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func takePhoto(){
        DispatchQueue.performAsync(on: .main, withDelay: .now()) { [weak self] in
            guard let welf = self else{return}
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                welf.imagePicker = UIImagePickerController()
                welf.imagePicker.delegate = welf
                welf.imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                welf.imagePicker.allowsEditing = true
                UIImagePickerController.isSourceTypeAvailable(.camera)
                welf.viewController.present(welf.imagePicker, animated: true, completion: nil)
            }
            else
            {
                //TRVicky
                welf.viewController.commonAlert.setupAlert(alert: LangCommon.error.capitalized,
                                                           alertDescription: LangCommon.deviceHasNoCamera.capitalized,
                                                           okAction: LangCommon.ok.capitalized)
                
                
            }
        }
        
    }
    func checkTakePhotoAuthorization(){
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            self.takePhoto()
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    // User granted
                    self.takePhoto()
                } else {
                    //TRVicky
                    self.viewController.commonAlert.setupAlert(alert: LangCommon.alert.capitalized,
                                                               alertDescription: LangCommon.cameraAccess,
                                                               okAction: LangCommon.allowCamera.capitalized,cancelAction: LangCommon.cancel)
                    self.viewController.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                        if let url = URL(string: UIApplication.openSettingsURLString){
                            UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey:Any](), completionHandler: { (val) in
                            })
                            
                        }
                    }
                    
                }
            })
        }
        
        
    }
    func choosePhoto()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.viewController.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            
        }
        
    }
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if (info[.originalImage] as? UIImage) != nil {
            let pickedImageEdited: UIImage? = (info[.editedImage] as? UIImage)
            if isLegal{
                self.uploadImage = pickedImageEdited
                let imageData:NSData = pickedImageEdited!.pngData()! as NSData as NSData
                self.uploadImageData = pickedImageEdited!.pngData()
                updateimg = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                let date = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                let seconds = calendar.component(.second, from: date)
                imgName = "IMG_\(hour)\(minutes)\(seconds).png"
            }else{
                self.uploadImage_additional = pickedImageEdited
                let imageData:NSData = pickedImageEdited!.pngData()! as NSData as NSData
                self.uploadImageData_additional = pickedImageEdited!.pngData()
                updateimg_additional = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                let date = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                let seconds = calendar.component(.second, from: date)
                imgName_additional = "IMG_\(hour)\(minutes)\(seconds).png"
            }
            stripTableView.reloadData()

        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension AddPayoutView : UITextFieldDelegate{
    // MARK:- TEXT DELEGATE METHOD
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        guard let string = textField.text else {return}
        let cell: StripeCell = textField.superview!.superview as! StripeCell
        stripeArrayDataDict[(cell.lblDetails?.text)!] = string
    }
}
