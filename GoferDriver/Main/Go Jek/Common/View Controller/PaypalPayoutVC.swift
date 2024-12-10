//
//  PaypalPayoutVC.swift
//  GoferDriver
//
//  Created by Trioangle Technologies on 28/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

protocol UpdatePaypalDataDelegate : class{
    func update(value : String ,for key : String)
}
class PaypalPayoutVC: BaseVC {
    //MARK: Outlets
    
    @IBOutlet var paypalPayoutView: PaypalPayoutView!
    var payoutValue : PayoutItemModel?
    var isNewRecord : Bool = false
   let viewModel = PayoutVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCountries()
        
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
   
   
    class func initWithStory()->PaypalPayoutVC{
        return UIStoryboard.gojekCommon.instantiateViewController()
    }
   
    internal func getCountries(){
        self.viewModel.getAllcountryNameList { (countryList) in
            self.paypalPayoutView.countries = countryList
            self.paypalPayoutView.paypalTableView.reloadData()
        }
    }

}


 class PaypalPayoutCell : UITableViewCell,UITextFieldDelegate{
    @IBOutlet weak var bgView: SecondaryView!
    @IBOutlet weak var title: SecondarySubHeaderLabel!
    @IBOutlet weak var textField: CommonTextField!
    
    var pickerHolder : TopCurvedView = {
        let view = TopCurvedView()
        return view
    }()
    
    func ThemeChange() {
        if #available(iOS 12.0, *) {
            let isDarkMode = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = isDarkMode ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = isDarkMode ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.bgView.customColorsUpdate()
        self.title.customColorsUpdate()
        self.textField.customColorsUpdate()
    }
    let countryPickerView = UIPickerView()
    internal var countries = [CountryList]()
    var parentVC : PaypalPayoutVC!
    var selectedRow = -1
    weak var updateParamDelegate : UpdatePaypalDataDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.textField.clipsToBounds = true
        self.textField.cornerRadius = 15
        self.textField.border(1, .TertiaryColor)
        self.textField.delegate = self
        self.countryPickerView.delegate = self
        self.countryPickerView.dataSource = self
        self.countryPickerView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

    }
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        
        self.updateParamDelegate?
            .update(value: textField.text ?? "",
                    for: self.title.text ?? "")
    }
    
    func setcell(WithTitle title: String,delegate : UpdatePaypalDataDelegate){
        self.updateParamDelegate = delegate
        self.title.text = title
        self.setPicker(self.title.text?.lowercased() == LangCommon.country.lowercased())
    }
    func setCell(withTitle title : String,value : String?,delegate : UpdatePaypalDataDelegate){
        self.setcell(WithTitle: title,delegate: delegate)
        self.textField.text = value
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if self.title.text?
//            .replacingOccurrences(of: " ", with: "")
//            .lowercased() == LangCommon.postalCode.lowercased(){
//            self.parentVC.paypalTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
        
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.updateParamDelegate?
            .update(value: textField.text ?? "",
                    for: self.title.text ?? "")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if self.title.text?
//            .replacingOccurrences(of: " ", with: "")
//            .lowercased() == LangCommon.postalCode.lowercased(){
//            self.parentVC.paypalTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 0)
//        }
       return true
    }
    
    func setPicker(_ toSet : Bool){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .PrimaryColor
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: LangCommon.done.capitalized,
                                         style: UIBarButtonItem.Style.plain,
                                         target: self,
                                         action: #selector(self.donePicking))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = .PrimaryColor
        if toSet{
            self.textField.inputView = self.countryPickerView
            self.textField.inputAccessoryView = toolBar
            self.countryPickerView.delegate = self
            self.countryPickerView.dataSource = self
            self.countryPickerView.selectRow(self.selectedRow, inComponent: 0, animated: true)
        }else{
            self.textField.inputView = nil
            self.textField.inputAccessoryView = nil
            self.countryPickerView.delegate = nil
            self.countryPickerView.dataSource = nil
        }
    }
}
extension PaypalPayoutCell : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
//        self.parentVC.paypalTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 230, right: 0)
        if self.countries.count == 0  {
          
            return 0
        }
        else{
            return self.countries.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.countries[row].countryName
        //((arrCountryData[row] as AnyObject).value(forKey: "country_name") as? String ?? String())
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.selectedRow = row
    }
    @objc func donePicking(){
        self.parentVC.paypalPayoutView.paypalTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.selectedRow = self.countryPickerView.selectedRow(inComponent: 0)
        var country : CountryList?
        if self.countries.indices ~= self.selectedRow{
            country = self.countries[self.selectedRow]
        }else{
            country = self.countries.first
            //country = self.countries[0]
        }
//        self.countryPickerView.
        if let _country = country{
            self.textField.text = _country.countryName
            self.parentVC.paypalPayoutView.selectedCoutry = _country.countryCode
        }
        self.textField.resignFirstResponder()
    }
}
