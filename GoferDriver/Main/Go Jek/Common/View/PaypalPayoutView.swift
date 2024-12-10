//
//  PaypalPayoutView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 03/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire

class PaypalPayoutView: BaseView {
    
    var viewController: PaypalPayoutVC!
    @IBOutlet weak var paypalTableView: CommonTableView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationView : HeaderView!
    @IBOutlet weak var pickerHolderView: TopCurvedView!
    @IBOutlet weak var payPalEmailIDTF: CommonTextField!
    @IBOutlet weak var submit: PrimaryButton!
    @IBOutlet weak var paypalButonBottomCurve: TopCurvedView!
    @IBOutlet weak var titleLable : SecondaryHeaderLabel!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    @IBOutlet weak var submitBtn: PrimaryButton!
    
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var paypalMailView: SecondaryView!
    @IBOutlet weak var countryPickerView: CommonPickerView!
    
    override
    func darkModeChange() {
        super.darkModeChange()
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
        self.paypalButonBottomCurve.customColorsUpdate()
        self.titleLable.customColorsUpdate()
        self.navigationView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.paypalTableView.customColorsUpdate()
        self.pickerHolderView.customColorsUpdate()
        self.payPalEmailIDTF.customColorsUpdate()
        self.paypalMailView.customColorsUpdate()
        self.countryPickerView.customColorsUpdate()
        self.paypalTableView.reloadData()
    }
    
    var paypalParams = Parameters()
     var selectedCoutry = String()
     
     var tempParams = JSON()
    var countries = [CountryList]()
    var enteredContent : [String:String] = [:]
    var content_titles = [LangCommon.address, LangCommon.addressTwo, LangCommon.city.capitalized, LangCommon.state.capitalized, LangCommon.postalCode.capitalized,LangCommon.country.capitalized]
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? PaypalPayoutVC
//        self
        self.initLanguage()
        self.initView()
        self.darkModeChange()
    }
    //Mark:- initlanguage
       func initLanguage(){
           content_titles = [LangCommon.address1.capitalized, LangCommon.address2.capitalized, LangCommon.city.capitalized, LangCommon.state.capitalized, LangCommon.postalCode.capitalized,LangCommon.country.capitalized]
       }
       //MARK: initializers
    func initView(){
        //        self.pickerHolderView.backgroundColor = UIColor.SecondaryColor.withAlphaComponent(0.5)
        self.paypalTableView.delegate = self
        self.paypalTableView.dataSource = self
        self.payPalEmailIDTF.cornerRadius = 15
        self.payPalEmailIDTF.border(1, .TertiaryColor)
        self.titleLable.text = LangCommon.payouts.capitalized
        self.payPalEmailIDTF.delegate = self
        self.payPalEmailIDTF.placeholder = "Paypal " + LangCommon.emailID
        self.submitBtn.setTitle(LangCommon.submit.capitalized, for: .normal)
        self.submit.setTitle(LangCommon.submit.capitalized, for: .normal)
        // self.paypalTableView.tableFooterView = footer_btn
        self.pickerHolderView.frame = CGRect(x: 0, y: self.frame.height - 200, width: self.frame.width, height: 200)
        self.pickerHolderView.isHidden = true
        self.contentHolderView.addSubview(self.paypalMailView)
        self.paypalMailView.setSpecificCornersForTop(cornerRadius: 40)
        self.paypalMailView.anchor(toView: self.contentHolderView,
                                   leading: 0,
                                   trailing: 0,
                                   top: 0,
                                   bottom: 0)
        self.contentHolderView.bringSubviewToFront(self.paypalMailView)
        self.paypalMailView.isHidden = true
        if let payout = self.viewController.payoutValue{
            self.tempParams = JSON()
            self.tempParams[LangCommon.address1.capitalized] = payout.payoutData?.address1
            self.tempParams[LangCommon.address2.capitalized] = payout.payoutData?.address2
            
            self.tempParams[LangCommon.city.capitalized] = payout.payoutData?.city
            self.tempParams[LangCommon.state.capitalized] = payout.payoutData?.state
            
            self.tempParams[LangCommon.postalCode.capitalized] = payout.payoutData?.postalCode
            
            self.payPalEmailIDTF.text = payout.payoutData?.paypalEmail
            if let country =  payout.payoutData?.country {
                self.selectedCoutry = country
            }
            self.paypalTableView.reloadData()
        }
        self.bottomView.isHidden = !self.viewController.isNewRecord
        self.submitBtn.isHidden = !self.viewController.isNewRecord
    }
    
        @IBAction func submitStage1Data(_ sender : UIButton){
           
            for key in self.content_titles {
                if let content = self.enteredContent[key] {
                    if content.isEmpty {
                        appDelegate.createToastMessage(LangCommon.pleaseEnter + " " + key)
                        return
                    }
                } else {
                    appDelegate.createToastMessage(LangCommon.pleaseEnter + " " + key)
                    return
                }
            }
            self.paypalParams = self.enteredContent
            self.paypalMailView.isHidden = false
        }
        @IBAction func submitPhase2(_ sender: Any) {
            self.endEditing(true)
            guard let email = self.payPalEmailIDTF.text, !email.isEmpty,isValidMail(mail: email) else{
    //            appDelegate.createToastMessage("Please enter valid mail id".localize, bgColor: .black, textColor: .white)
                appDelegate.createToastMessage(LangCommon.pleaseEnterValidEmail, bgColor: .black, textColor: .white)
                return
            }
            self.endEditing(true)
            var params = Parameters()
            params["address1"] = self.paypalParams[LangCommon.address1.capitalized]
            params["address2"] = self.paypalParams[LangCommon.address2.capitalized]
            params["city"] = self.paypalParams[LangCommon.city.capitalized]
            params["state"] = self.paypalParams[LangCommon.state.capitalized]
            params["postal_code"] = self.paypalParams[LangCommon.postalCode.capitalized]
            params["country"] = self.selectedCoutry
            params["email"] = email
            params["payout_method"] = "paypal"
            params["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
            let uberSupport = UberSupport()
            uberSupport.showProgressInWindow(showAnimation: true)
            params["payout_method"] = "paypal"
            PaymentInteractor.instance.addPayout(withDetails: params) { (val) in
                
                uberSupport.removeProgressInWindow()
                if val{
                    self.backAction(nil)
                }
            }
            
        }
    
    //MARK:Actions
       @IBAction func backAction(_ sender: Any?) {
           if !self.paypalMailView.isHidden,sender != nil{
               self.paypalMailView.isHidden = true
               return
           }
        if self.viewController.isPresented(){
            self.viewController.dismiss(animated: true, completion: nil)
           }else{
            self.viewController.navigationController?.popViewController(animated: true)
           }
       }
       @IBAction func pickAction(_ sender: Any) {
           
       }

}
extension PaypalPayoutView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content_titles.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return self.viewController.isNewRecord ? 70 : 0
        return 0
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer_btn = UIButton()
        footer_btn.frame = CGRect(x: 8,
                                  y: 15,
                                  width: self.paypalTableView.frame.width - 16,
                                  height: 40)
        footer_btn.backgroundColor = .PrimaryColor
        footer_btn.setTitleColor(.PrimaryTextColor, for: .normal)
        footer_btn.setTitle(LangCommon.submit.capitalized, for: .normal)
        footer_btn.isClippedCorner = true
        
        footer_btn.addTarget(self, action: #selector(self.submitStage1Data(_:)), for: .touchUpInside)
        let footerView = UIView()
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            footerView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
            footerView.backgroundColor = .SecondaryColor
        }
        footerView.addSubview(footer_btn)
        return footerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaypalPayoutCell") as! PaypalPayoutCell
         cell.countries = self.countries
        let title = self.content_titles[indexPath.row]
       
        cell.title.setTextAlignment()
        cell.textField.setTextAlignment()
        cell.textField.setLeftPaddingPoints(5)
//        cell.textField.placeholder = self.content_titles.value(atSafe: indexPath.row)
        cell.textField.setRightPaddingPoints(15)
        cell.textField.setLeftPaddingPoints(15)
        cell.textField.accessibilityHint = self.content_titles.value(atSafe: indexPath.row)
        cell.textField.addTarget(self, action: #selector(self.textfieldDidChangeInField(sender:)), for: .editingChanged)
        cell.countryPickerView.reloadAllComponents()
        if title == self.content_titles.last,
           !self.selectedCoutry.isEmpty,
            let index = self.countries
                .find(includedElement: {$0.countryCode == self.selectedCoutry}),
            let country = self.countries.value(atSafe: index){
            cell.selectedRow = index
            cell.textField.text = country.countryName
        }
        else{
            cell.selectedRow = 0
        }
        if !self.tempParams.string(title).isEmpty{
            cell.setCell(withTitle: title, value: tempParams.string(title), delegate: self)
        }else{
            cell.setcell(WithTitle: title,delegate: self)
        }
        cell.parentVC = self.viewController
        cell.isUserInteractionEnabled = self.viewController.isNewRecord
        cell.ThemeChange()
        return cell
    }
    
    
    @objc
    func textfieldDidChangeInField(sender: UITextField) {
        if let key = sender.accessibilityHint,
           let content = sender.text {
            self.enteredContent[key] = content
        }
    }
    
}

extension PaypalPayoutView : UpdatePaypalDataDelegate{
    func update(value: String, for key: String) {
        print("∂\(key) : \(value)")
        self.tempParams[key] = value
        self.enteredContent[key] = value
    }
    
    
}
extension PaypalPayoutView : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.payPalEmailIDTF{
            self.endEditing(true)
        }
        return true
    }
}
