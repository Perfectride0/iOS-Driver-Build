//
//  settingsView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 23/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit


class settingsView: BaseView, MobileNumberValiadationProtocol {
    func verified(number: MobileNumber) {
        print("Bareeth")
    }
    

//MARK: common variables and outlets

    var viewController = SettingsVC()
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var CurvedContentholderView: TopCurvedView!
    @IBOutlet weak var contentHolderView: UIView!
    @IBOutlet weak var settingTableView : CommonTableView!
    
    enum SettingSection : Int{
        case docAndPayout = 0
        case currencyAndLanguage
        case logout
        
        var rows : Int{
            return self == .logout ? 1 : 2
        }
    }

    override func darkModeChange() {
        super.darkModeChange()
        self.headerView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.CurvedContentholderView.customColorsUpdate()
        self.settingTableView.customColorsUpdate()
        self.settingTableView.reloadData()
    }
    
    
    
//MARK: Functions and delegates
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as! SettingsVC
        self.titleLbl.text = LangCommon.settings.capitalized
        self.settingTableView.dataSource = self
        self.settingTableView.delegate = self
        self.settingTableView.tableFooterView = UIView()
        self.darkModeChange()
    }
    
}

//MARK:- UITableViewDataSource
extension settingsView : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingSection(rawValue: section)?.rows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SettingSection(rawValue: indexPath.section) ?? .logout {
        case .docAndPayout:
            if !Shared.instance.isStoreDriver{
                let cell : SettingATVC = tableView.dequeueReusableCell(for: indexPath)
                if indexPath.row == 0{ //Documents
                    if self.viewController.menuPresenter.driverProfile?.driverDocuments.allSatisfy({$0.urlString.isEmpty}) ?? false{
                        cell.titleLbl.text = LangCommon.addDocument.capitalized
                         }else{
                            cell.titleLbl.text = LangCommon.manageDocuments.capitalized
                         }
                    cell.iconIV.image = UIImage(named: "Manage Document")?.withRenderingMode(.alwaysTemplate)
                }else { //payout
                    cell.titleLbl.text = LangCommon.addPayouts.capitalized
                    cell.iconIV.image = UIImage(named: "Manage Payout")?.withRenderingMode(.alwaysTemplate)
                }
                cell.rightLbl.text = isRTLLanguage ? "f" : "p"
                cell.ThemeUpdate()
                return cell
            }else{
                print("Store Own driver")
            }
            return UITableViewCell()
            
            
        case .currencyAndLanguage:
            let cell : SettingBTVC = tableView.dequeueReusableCell(for: indexPath)
            
            let isLangOrCurre = indexPath.row == 1
            cell.iconIV.image = UIImage(named: isLangOrCurre ? "Language" : "Currency")
            cell.titleLbl.text = isLangOrCurre
                ? LangCommon.language.capitalized
                : LangCommon.currency
            let currencySymbol = self.viewController.menuPresenter.driverProfile?.currency_symbol ?? "$"
            let currencyString = self.viewController.menuPresenter.driverProfile?.currency_code ?? "USD"
            
            cell.rightLbl.text = isLangOrCurre ? currentLanguage.lang : "\(currencySymbol) \(currencyString)"
            cell.ThemeUpdate()
            return cell
        case .logout:
            let cell : SettingCTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLbl.text = LangCommon.signOut
            cell.ThemeUpdate()
            cell.titleLbl.addTap {
                self.viewController.presentAlertWithTitle(title: appName, message: LangCommon.rUSureToLogOut, options: LangCommon.ok,LangCommon.cancel, completion: {
                               (optionss) in
                               switch optionss {
                               case 0:
                                self.viewController.wsCallLogoutAPI()
                               case 1:
                                self.viewController.dismiss(animated: true, completion: nil)
                               default:
                                   break
                               }
                           })
            }
            cell.deleteAccBTn.addTap {
                self.viewController.wsCallDeleteAccountAPI(isChecked: "0")
            }
            return cell
        }
    }
    
    
}
//MARK:- UITableViewDelegate
extension settingsView : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch SettingSection(rawValue: indexPath.section) ?? .logout {
        case .logout :
            return 150
        case .docAndPayout:
            if !Shared.instance.isStoreDriver{
                return indexPath.row == 0 ? 0 : 50
            }
            else {
                return indexPath.row == 0 ? 0 : 0
            }
           
        default :
            return 50
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? 0 : 30
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch SettingSection(rawValue: indexPath.section) ?? .logout {
        case .docAndPayout:
            
            if !Shared.instance.isStoreDriver{
                if indexPath.row == 0 { //Documents
                    let driverID = Int(UserDefaults.value(for: .user_id) ?? "") ?? 0
                    let dynamicDocVC = DynamicDocumentVC
                        .initWithStory(for: .forDriver(id: driverID),
                                       using: self.viewController.menuPresenter.driverProfile?.driverDocuments ?? [], menuPresenter: self.viewController.menuPresenter)
                    self.viewController.navigationController?.pushViewController(dynamicDocVC, animated: true)
                }else { //payout
                    let vc = NewPayoutListVC.initWithStory()// ListPayoutsVC.initWithStory()
                    self.viewController.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                print("Store Own driver")
            }
            
            
            
        case .currencyAndLanguage:
            if indexPath.row == 0{//cuurrency
                let locView = CurrencyPopupVC.initWithStory()
                locView.modalPresentationStyle = .overCurrentContext
                locView.delegate = self.viewController
                self.viewController.present(locView,
                                            animated: true,
                                            completion: nil)
                
            }else{//lang
                let view = SelectLanguageVC.initWithStory()
                view.modalPresentationStyle = .overCurrentContext
                view.tabBar = self.viewController.tabBarController?.tabBar
                self.viewController.present(view,
                                            animated: true,
                                            completion: nil)
                
            }
        case .logout:
           print("Logout (or) Delete Account")
        }
    }
}
