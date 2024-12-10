//
//  MenuView.swift
//  Handyman
//
//  Created by trioangle1 on 10/08/20.
//  Copyright © 2020 trioangle. All rights reserved.
//

import UIKit
import FirebaseAuth
//import DriverWallet

protocol MenuResponseProtocol {
    func routeToView(_ view : UIViewController)
    func refreshVehcileView()
    func callAdminForManualBooking()
    func openThemeActionSheet()
    func openFontActionSheet()
    func openBusinessTypeChooser()
}

class MenuView: BaseView {
    @IBOutlet weak var helloLbl: InactiveSubHeaderLabel!
    @IBOutlet weak var contentBgView: SecondaryView!
    @IBOutlet weak var sideMenuHolderView : UIView!
    @IBOutlet weak var profileHeaderView : HeaderView!
    @IBOutlet weak var avatarImage : PrimaryBorderedImageView!
    @IBOutlet weak var avatarName : SecondaryHeaderLabel!
    @IBOutlet weak var menuTable : CommonTableView!
    @IBOutlet weak var bottomView : UIView!
    @IBOutlet weak var bottomContentView: PrimaryView!
    @IBOutlet weak var driverAppVersionLbl : PrimaryButtonTypeLabel!
    @IBOutlet weak var logoutIV: SecondaryImageView!
//    @IBOutlet weak var settingIcon: UIImageView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var closeBtn: SecondaryButton!
    @IBOutlet weak var headerView: UIView!
    var menuItems = [MenuItemModel]()
    let gojekhomeVM = GojekHomeVM()
    var listService : [GojekService]!
    @IBOutlet weak var bottomLogoutView: UIStackView!
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.contentBgView.customColorsUpdate()
        self.profileHeaderView.customColorsUpdate()
        self.helloLbl.customColorsUpdate()
        self.helloLbl.font = self.isDarkStyle ? .lightFont(size: 16) : .MediumFont(size: 16)
        self.avatarName.customColorsUpdate()
        self.menuTable.customColorsUpdate()
        self.menuTable.reloadData()
        self.closeBtn.customColorsUpdate()
    }
    
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        viewController = baseVC as? MenuVC
        self.initView()
        self.initGestures()
        self.initTableDataSources()
        self.darkModeChange()
    }

    var viewController: MenuVC!
    
//MARK:- initializers
    func initView(){
        let text = LangCommon.hello
        if text.isEmpty || text == " " {
            self.helloLbl.text = "Hello"
        } else {
            self.helloLbl.text = LangCommon.hello.capitalized
        }
        self.bottomContentView.cornerRadius = 15
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        self.driverAppVersionLbl.text = LangCommon.logout
        self.avatarImage.isCurvedCorner = true
        self.menuTable.tableHeaderView = self.headerView
        self.menuTable.tableFooterView = self.bottomView
        self.menuTable.layoutIfNeeded()
    }
    func initGestures(){
        self.menuTable.addAction(for: .tap) {
            
        }
        self.bottomLogoutView.addAction(for: .tap) {
            self.viewController.presentAlertWithTitle(title: appName, message: LangCommon.rUSureToLogOut, options: LangCommon.ok.capitalized,LangCommon.cancel.capitalized, completion: {
                (optionss) in
                switch optionss {
                case 0:
                    self.wsCallLogoutAPI()
                case 1:
                    self.hideMenuAndDismiss()
//                    self.viewController.dismiss(animated: false, completion: nil)
                default:
                    break
                }
            })
        }
        self.profileHeaderView.addAction(for: .tap) {
            print("Don't Dismiss Your Self")
        }
        self.sideMenuHolderView.addAction(for: .tap) {
            self.hideMenuAndDismiss()
        }
        self.menuTable.addTap {
            print("Don't Do Stupid Thing")
        }
        self.addAction(for: .tap) {
            self.hideMenuAndDismiss()
        }
        self.bottomView.addAction(for: .tap) {
            /**
             -Reason : Gofer Functionality to call Driver Application but not Needed For Handy and It Producing Various Results
             */
//            self.callDriverApp()
        }
        
        // MARK: ---------->  Views Having Same Guesture Menu Fun <-------
        let views = [avatarImage,
                     avatarName]
        views.forEach { (view) in
            if let view = view {
                view.addAction(for: .tap) {
                    let propertyView : ViewProfileVC  = .initWithStory(with: self.viewController.menuPresenter)
                    self.viewController.menuDelegate?.routeToView(propertyView)
                    self.viewController.dismiss(animated: false, completion: nil)
                }
            }
        }
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleMenuPan(_:)))
        self.sideMenuHolderView.addGestureRecognizer(panGesture)
        self.sideMenuHolderView.isUserInteractionEnabled = true
    }
    
    func wsCallLogoutAPI(){
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared.getRequest(for: .logout, params: [:], showLoader: true)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.isSuccess{
                    let userDefaults = UserDefaults.standard
                    UserDefaults.set(false,for: .InitiatedTheme)
                    userDefaults.set("", forKey:"getmainpage")
                    userDefaults.set("", forKey: USER_ONLINE_STATUS)
                    userDefaults.synchronize()
                    let firebaseAuth = Auth.auth()
                    do {
                      try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                      print ("Error signing out: %@", signOutError)
                    }
                    UserDefaults.removeValue(for: .default_language_option)
                    PushNotificationManager.shared?.stopObservingProvider()
                    
                    (UIApplication.shared.delegate as! AppDelegate).logOutDidFinish()
                }else{

                    AppDelegate.shared.createToastMessage(json.status_message)

                }
                
                
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()

                //AppDelegate.shared.createToastMessage(error)
            })
        
    }
    //MARK:- initTableDataSources
    func initTableDataSources() {
        if !isSingleApplication {
            let businessType = MenuItemModel(
                withTitle:  LangCommon.businessType,
                icon: "Your Job-1",
                VC: nil)
            self.menuItems.append(businessType)
        }
        
        let tripItem = MenuItemModel(withTitle: LangHandy.yourJobs.capitalized,
                                     icon: "Your Job-1",
                                     VC: HandyTripHistoryVC.initWithStory())
        self.menuItems.append(tripItem)
        
        
        let ratingItem = MenuItemModel(withTitle: LangCommon.ratings.capitalized,
                                       icon: "Rider Feedback",
                                       VC: RatingsVC.initWithStory())
       // self.menuItems.append(ratingItem)
        
        let referral = MenuItemModel(withTitle: LangCommon.referral.capitalized,
                                     icon: "Referral-1",
                                     VC: ReferalVC.initWithStory())
        //self.menuItems.append(referral)

        //Deliveryall splitup start
        //Handy_NewSplitup_Start
        //Deliveryall_Newsplitup_start
//        if Shared.instance.is_driver_wallet == true{
//            
//            let driverwallet = MenuItemModel(withTitle: LangCommon.wallet.capitalized,
//                                         icon: "Referral-1",
//                                             VC: self.calldriverwallet())
//            self.menuItems.append(driverwallet)
            
//        }else{
            //Deliveryall splitup End
//            let payToGoferVC =  PayToGoferVC.initWithStory()
//            if self.viewController.menuPresenter.driverProfile?.isCompanyDriver ?? false {
//                payToGoferVC.companyID = Int(self.viewController.menuPresenter.driverProfile?.company_id ?? "0")
//            }
//            let payToGoferItem = MenuItemModel(withTitle: LangCommon.payTo + " \(appName)",
//                                               icon: "My Wallet",
//                                               VC: payToGoferVC)
//            if !Shared.instance.isStoreDriver{
//                self.menuItems.append(payToGoferItem)
//            }
//        }
        //Deliveryall_Newsplitup_end
        //Handy_NewSplitup_End
            //Deliveryall splitup start

        
        //Deliveryall splitup End
     

        
        let themes = MenuItemModel(withTitle:  LangCommon.theme,
                                   icon: "supportIcon",
                                   VC: nil)
        
        let font = MenuItemModel(withTitle:  LangCommon.font,
                                 icon: "supportIcon",
                                 VC: nil)
        
        let settingVC = MenuItemModel(withTitle: LangCommon.settings.capitalized,
                                      icon: "setting",
                                      VC: SettingsVC.initWithStory(with: self.viewController.menuPresenter))
        
        let docString : String
        if self.viewController.menuPresenter.driverProfile?.driverDocuments.allSatisfy({$0.urlString.isEmpty}) ?? false{
            docString = LangCommon.addDocument.capitalized
        }else{
            docString = LangCommon.manageDocuments.capitalized
        }
        
        let vehicleString : String
        if self.viewController.menuPresenter.driverProfile?.vehicles.isEmpty ?? false{
            vehicleString = LangCommon.addVehicle.capitalized
        }else{
            vehicleString = LangCommon.manageVehicle.capitalized
        }
        let chooseCar = MenuItemModel(withTitle: vehicleString,
                                      icon: "http://gofer.trioangledemo.com/images/car_image/gofergo.png",
                                      VC: ChangeCarVC.initWithStory(withPresenter:  self.viewController.menuPresenter))
        self.menuItems.append(chooseCar)
        
        
        let driverID = Int(UserDefaults.value(for: .user_id) ?? "") ?? 0
        let dynamicDocVC = DynamicDocumentVC
            .initWithStory(for: .forDriver(id: driverID),
                              using: self.viewController.menuPresenter.driverProfile?.driverDocuments ?? [], menuPresenter: self.viewController.menuPresenter)
        
        let documentManage = MenuItemModel(withTitle: docString,
                                           icon: "Manage Document",
                                           VC: dynamicDocVC)
        self.menuItems.append(documentManage)
        
        let earningsView = MenuItemModel(withTitle: LangCommon.earnings.capitalized,
                                         icon: "Earnings-1",
                                         VC: EarningsVC.initWithStory())
        self.menuItems.append(earningsView)
        
        
//        if Shared.instance.is_driver_wallet == true{
//            self.menuItems.append(driverwallet)
//        }else{
//            if !(self.viewController.menuPresenter.driverProfile?.isCompanyDriver ?? false){
//                self.menuItems.append(payToGoferItem)
//            }
//        }
        //Gofer splitup start
        //New_Delivery_splitup_Start
        //Laundry splitup start
        //Instacart splitup start
        //Deliveryall_Newsplitup_start
        if AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.Services) {
            // Laundry_NewSplitup_start
            let vm = HandyHomeViewModel()
            vm.profileModel = self.viewController.menuPresenter.driverProfile
            // Laundry_NewSplitup_start
            // InstaCart_NewSplitup_end
        }
        if Shared.instance.is_company == true {
            print("PaytoAdmin and wallet hidden")
        } else {
            if Shared.instance.is_driver_wallet == true{
                let driverwallet = MenuItemModel(withTitle: LangCommon.wallet.capitalized,
                                             icon: "Referral-1",
                                                 VC: self.calldriverwallet())
                self.menuItems.append(driverwallet)
            }else{
                let payToGoferVC =  PayToGoferVC.initWithStory()
                if self.viewController.menuPresenter.driverProfile?.isCompanyDriver ?? false {
                    payToGoferVC.companyID = Int(self.viewController.menuPresenter.driverProfile?.company_id ?? "0")
                }
                let payToGoferItem = MenuItemModel(withTitle: LangCommon.payTo + " \(appName)",
                                                   icon: "My Wallet",
                                                   VC: payToGoferVC)
                if !Shared.instance.isStoreDriver{
                    self.menuItems.append(payToGoferItem)
                }
                
            }

        }
        //New_Delivery_splitup_End
        //Laundry splitup end
        //Instacart splitup end
        //Deliveryall_Newsplitup_end

        // Handy Splitup Start
        
        //Gofer splitup end
        //Delivery splitup End

        

        // Handy Splitup End
        
        
//        if !Env.isLive() {
//            self.menuItems.append(font)
//        }
        self.menuItems.append(ratingItem)
        if Shared.instance.is_company == true {
            print("Referral removed !!")
        } else {
            if !(self.viewController.menuPresenter.driverProfile?.isCompanyDriver ?? false){
                self.menuItems.append(referral)
            }
        }
        
//        if !Env.isLive() {
//            self.menuItems.append(themes)
//        }
        
        self.menuItems.append(settingVC)
        let supportVC = SupportVC.initWithStory()
        let supportItem = MenuItemModel(withTitle: LangCommon.support,
                                        icon: "Support",
                                        VC: supportVC)
        if Shared.instance.supportArray?.count != 0 {
            self.menuItems.append(supportItem)
        }
        self.menuTable.reloadData()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.hideMenuAndDismiss()
    }
    
    func calldriverwallet()-> UIViewController{
        let storyboard = UIStoryboard(name: "Driverwallet", bundle: Bundle(identifier: "com.trioangle.DriverWallet"))
        let vc = storyboard.instantiateViewController(withIdentifier: "DriverWalletVC")
        let nav = UINavigationController(rootViewController: vc)
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(nav, animated: true, completion: nil)
//        let key = Bundle.main.localizedString(forKey: "key_b", value: nil, table: "Language")
//        print(key)
       // print(localizedString(forKey: "key_b"))
return vc
    }
    //MARK:- UDF
    func setUserData(){
        guard let userData = self.viewController.menuPresenter.driverProfile else{return}
        self.avatarImage.sd_setImage(with: URL(string: userData.user_thumb_image),
                                     placeholderImage: UIImage(named:"user_dummy"),
                                     options: .highPriority,
                                     progress: nil,
                                     completed: nil)
        self.avatarName.text = userData.user_name
        
    }
    func callDriverApp(){
        let instagramUrl = URL(string: "\(DriveriTunes().appName)://")
        if UIApplication.shared.canOpenURL(instagramUrl!)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"\(DriveriTunes().appName)://")!)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL(string:"\(DriveriTunes().appName)://")!)
            }
        } else {
            if let url = URL(string: "https://itunes.apple.com/us/app/\(DriveriTunes().appStoreDisplayName)/\(DriveriTunes().appID)?mt=8")
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                    // Fallback on earlier versions
                }
            }
        }
    }
   
    private var animationDuration : Double = 1.0
    private let aniamteionWaitTime : TimeInterval = 0.15
    private let animationVelocity : CGFloat = 5.0
    private let animationDampning : CGFloat = 2.0
    private let viewOpacity : CGFloat = 0.3
    func showMenu(){
        let isRTL = isRTLLanguage
        let rtlValue : CGFloat = isRTL ? 1 : -1
        let width = self.frame.width
        self.sideMenuHolderView.transform = CGAffineTransform(translationX: rtlValue * width,
                                                              y: 0)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
                        self.sideMenuHolderView.transform = .identity
                        self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
        }, completion: nil)
    }
    func hideMenuAndDismiss(){
        let isRTL = isRTLLanguage
        let rtlValue : CGFloat = isRTL ? 1 : -1
        let width = self.frame.width
        while animationDuration > 1.6{
            animationDuration = animationDuration * 0.1
        }
        UIView.animate(withDuration: animationDuration,
                       delay: aniamteionWaitTime,
                       usingSpringWithDamping: animationDampning,
                       initialSpringVelocity: animationVelocity,
                       options: [.curveEaseOut,.allowUserInteraction],
                       animations: {
                        self.sideMenuHolderView.transform = CGAffineTransform(translationX: width * rtlValue,
                                                                              y: 0)
                        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { (val) in
          
            self.viewController.dismiss(animated: false, completion: nil)
        }
        
        
    }
    @objc func handleMenuPan(_ gesture : UIPanGestureRecognizer){
        let isRTL = isRTLLanguage
//        let rtlValue : CGFloat = isRTL ? 1 : -1
        let translation = gesture.translation(in: self.sideMenuHolderView)
        let xMovement = translation.x
//        guard abs(xMovement) < self.view.frame.width/2 else{return}
        var opacity = viewOpacity * (abs(xMovement * 2)/(self.frame.width))
        opacity = (1 - opacity) - (self.viewOpacity * 2)
        print("~opcaity : ",opacity)
        switch gesture.state {
        case .began,.changed:
            guard (isRTL && xMovement > 0) || (!isRTL && xMovement < 0) else {return}
            self.sideMenuHolderView.transform = CGAffineTransform(translationX: xMovement, y: 0)
            self.backgroundColor = UIColor.black.withAlphaComponent(opacity)
        default:
            let velocity = gesture.velocity(in: self.sideMenuHolderView).x
            self.animationDuration = Double(velocity)
                if abs(xMovement) <= self.frame.width * 0.25{//show
                    self.sideMenuHolderView.transform = .identity
                    self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpacity)
                }else{//hide
                    self.hideMenuAndDismiss()
                }
            
        }
    }
    
}
extension MenuView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:MenuTCell.identifier ) as! MenuTCell
        cell.lblName?.text = self.menuItems[indexPath.row].title
        cell.lblName?.textAlignment = isRTLLanguage ? .right : .left
        if let image = self.menuItems[indexPath.row].icon {
            cell.menuIcon?.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
            cell.menuIcon?.clipsToBounds = true
            cell.menuIcon?.contentMode = .scaleAspectFit
        }else{
            cell.menuIcon?.image = nil
        }
        cell.menuIcon.isHidden = true
                
        cell.contentView.addAction(for: .tap) {
            self.viewController.dismiss(animated: false, completion: {
                let _selectedItem = self.menuItems[indexPath.row]
                if let vc = _selectedItem.viewController {
                    self.viewController.menuDelegate?.routeToView(vc)
                } else {
                    if (cell.lblName?.text == LangCommon.font) {
                        self.viewController.menuDelegate?.openFontActionSheet()
                    } else if (cell.lblName?.text ==  LangCommon.theme) {
                        self.viewController.menuDelegate?.openThemeActionSheet()
                    } else if (cell.lblName?.text ==  LangCommon.businessType) {
                        self.viewController.menuDelegate?.openBusinessTypeChooser()
                    }
                }
            })
           
        }
        cell.holderView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        cell.ThemeUpdate()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MenuTCell else {return}
        cell.holderView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        cell.holderView.cornerRadius = 15
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MenuTCell else {return}
        cell.holderView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
        cell.holderView.cornerRadius = 15
    }
    
}
    
class MenuTCell: UITableViewCell {
    @IBOutlet weak var menuIcon: PrimaryImageView!
    @IBOutlet var lblName: SecondarySmallHeaderLabel?
    @IBOutlet weak var holderView: UIView!
    static let identifier = "MenuTCell"
    
    func ThemeUpdate() {
        self.lblName?.customColorsUpdate()
        self.lblName?.font = UIFont(name: G_BoldFont, size: 18)
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
       
    }
    
}
