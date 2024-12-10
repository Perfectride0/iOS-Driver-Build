//
//  countryListView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 26/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit

class countryListView: BaseView, UITextFieldDelegate {

    //MARK: ***** Outlets and Variable declarations *****
    
    @IBOutlet weak var searchIV: SecondaryTintImageView!
    @IBOutlet weak var tblCountryList : CommonTableView!
    @IBOutlet weak var txtFldSearch:CommonTextField!
    @IBOutlet weak var searchBGView: SecondaryView!
    @IBOutlet weak var selectCountryLabel: SecondaryHeaderLabel!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var contentCurvedHolderView: TopCurvedView!
    
    override func darkModeChange() {
        super.darkModeChange()
        self.headerView.customColorsUpdate()
        self.selectCountryLabel.customColorsUpdate()
        self.contentCurvedHolderView.customColorsUpdate()
        self.searchBGView.customColorsUpdate()
        self.tblCountryList.customColorsUpdate()
        self.txtFldSearch.customColorsUpdate()
        self.tblCountryList.reloadData()
        self.searchIV.customColorsUpdate()
        
    }
    
    //ViewController
    
    var countryVC = CountryListVC()
    
    // Country DataSources
    
    var keys = [String]()
    var countries : [String : [CountryCodeList]] = [:]
    var filteredKeys = [String]()
    var filteredCountries : [String : [CountryCodeList]] = [:]
    
    //MARK: ***** load and appear functions *****
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.countryVC = baseVC as! CountryListVC
        self.initView()
        self.initLanguage()
        self.darkModeChange()
    }
    
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        self.countryVC.navigationController?.isNavigationBarHidden = true
    }
    
    override func didAppear(baseVC: BaseVC) {
        let uberLoader = UberSupport()
        uberLoader.showProgressInWindow(showAnimation: true)
        DispatchQueue.main.async { [weak self] in
            self?.generateDataSource()
            uberLoader.removeProgressInWindow()
        }

    }
    func initView() {
        self.searchBGView.cornerRadius = 10
        self.searchBGView.elevate(2)
    }
    
    func initLanguage(){
        self.backgroundColor = .PrimaryColor
        selectCountryLabel.text = LangCommon.selectCountry
        txtFldSearch.placeholder = LangCommon.search
        txtFldSearch.setTextAlignment()
     }
    
    //MARK:- ***** Generate datasource *****
    func generateDataSource(){
        
        let countriesArray = self.countryVC.countryList
     
        
        self.countries = [:]
        for country in countriesArray{
            let nameFirstChar = "\(country.name.first ?? "#")"
            var internalArray = self.countries[nameFirstChar] ?? [CountryCodeList]()
            internalArray.append(country)
            self.countries[nameFirstChar] = internalArray
        }
        self.keys = self.countries.keys.sorted(by: {$0 < $1})
        self.tblCountryList.reloadData()
    }
    

 //MARK:- ***** Filter and Update country *****
 func filterCountries(for strSearchText:String) {
     
    let countriesArray : [CountryCodeList] = self.countryVC.countryList
        .filter({$0.name.lowercased().hasPrefix(strSearchText.lowercased())})
     
        
        self.filteredCountries = [:]
        self.filteredKeys.removeAll()
        for country in countriesArray{
            let nameFirstChar = "\(country.name.first ?? "#")"
            var internalArray = self.filteredCountries[nameFirstChar] ?? [CountryCodeList]()
            internalArray.append(country)
            self.filteredCountries[nameFirstChar] = internalArray
        }
        self.filteredKeys = self.filteredCountries.keys.sorted(by: {$0 < $1})
        self.tblCountryList.reloadData()
 }
    //MARK: ***** TextField Delegate Method *****
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        return true
    }
    //MARK:-  ***** Actions *****
    @IBAction func testFieldDidChanged(_ textField: UITextField) {
        DispatchQueue.main.async { [weak self] in
            self?.filterCountries(for: textField.text ?? "")
        }
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        self.endEditing(true)
        if self.countryVC.isPresented(){
            self.countryVC.dismiss(animated: true, completion: nil)
        }else{
            self.countryVC.navigationController!.popViewController(animated: true)
        }
    }

 
}
//MARK: ***** Tableview delegate and datasource  Extentions *****

extension countryListView :  UITableViewDataSource  {
    //MARK: Table view Datasource
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
//        if isForFilter{
//            return self.filteredKeys
//        }else{
//            return self.keys
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        
        if isForFilter{
            return self.filteredKeys.count
        }else{
            return self.keys.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        if isForFilter{
            let key = self.filteredKeys.value(atSafe: section) ?? "#"
            return self.filteredCountries[key]?.count ?? 0
        }else{
            let key = self.keys.value(atSafe: section) ?? "#"
            return self.countries[key]?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.cornerRadius = 10
        lbl.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        lbl.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.2)
        lbl.font = .MediumFont(size: 16)
        lbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        if isForFilter {
            lbl.text = "    " + (self.filteredKeys.value(atSafe: section) ?? "#")
        }else{
            lbl.text = "    " + (self.keys.value(atSafe: section) ?? "#")
        }
        return lbl
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellCountry = tblCountryList.dequeueReusableCell(withIdentifier: "CellCountry")! as! CellCountry
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        if isForFilter{
            if let key = self.filteredKeys.value(atSafe: indexPath.section),
                let country = self.filteredCountries[key]?.value(atSafe: indexPath.row){
                    cell.populateCell(with: country)
                
                if Constants().GETVALUE(keyname: USER_COUNTRY_CODE) == country.country_code {
                    cell.holderView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
                    cell.holderView.cornerRadius = 15
                }
            }
        }else{
            if let key = self.keys.value(atSafe: indexPath.section),
                let country = self.countries[key]?.value(atSafe: indexPath.row){
                cell.populateCell(with: country)
                if Constants().GETVALUE(keyname: USER_COUNTRY_CODE) == country.country_code {
                    cell.holderView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
                    cell.holderView.cornerRadius = 15
                }
            }
        }
        return cell
    }
    
  
   
    
}
extension countryListView : UITableViewDelegate{
    //MARK:- ***** TableView Delegate *****
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isForFilter = (txtFldSearch?.text?.count) ?? 0 > 0
        if isForFilter{
            if let key = self.filteredKeys.value(atSafe: indexPath.section),
                let country = self.filteredCountries[key]?.value(atSafe: indexPath.row){
                self.countryVC.delegate?.countryCodeChanged(countryCode:country.country_code,
                                             dialCode:country.dial_code,
                                             flagImg:country.flag)
            }
        }else{
            if let key = self.keys.value(atSafe: indexPath.section),
                let country = self.countries[key]?.value(atSafe: indexPath.row){
                self.countryVC.delegate?.countryCodeChanged(countryCode:country.country_code,
                                             dialCode:country.dial_code,
                                             flagImg:country.flag)
            }
        }
  
        self.endEditing(true)
        
        if self.countryVC.isPresented(){
            self.countryVC.dismiss(animated: true, completion: nil)
        }else{
            self.countryVC.navigationController?.popViewController(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CellCountry else {return}
        cell.holderView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        cell.holderView.cornerRadius = 15
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CellCountry else {return}
        cell.holderView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
        cell.holderView.cornerRadius = 15
    }
}

//MARK: ***** Tableview cell *****
 
class CellCountry : UITableViewCell {
    @IBOutlet weak var lblTitle: SecondarySmallHeaderLabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var holderView: UIView!
    
    // Populate the Details using this func
    func populateCell(with flag : CountryCodeList){
        self.ThemeChange()
        self.lblTitle?.text = flag.name
        let url = URL(string: flag.flag)
        self.imgFlag.sd_setImage(with: url, completed: nil)
        self.imgFlag.tintColor = .clear
    }
    
    func ThemeChange(){
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.lblTitle.customColorsUpdate()
        self.holderView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    
}
