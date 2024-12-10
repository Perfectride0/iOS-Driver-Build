//
//  ReferalView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class ReferalView : BaseView {
    
    //MARK:- Outlets
    @IBOutlet weak var navView : HeaderView!
    @IBOutlet weak var headerView : SecondaryView!
    @IBOutlet weak var shareBtn : PrimaryTintButton!
    @IBOutlet weak var referalHolderView : UIView!
    @IBOutlet weak var referalDescription : InactiveRegularLabel!
    @IBOutlet weak var urRefcodeLbl : SecondaryRegularLabel!
    @IBOutlet weak var referalCodeValuelbl: ThemeButtonTypeLabel!
    @IBOutlet weak var pageTitle : SecondaryHeaderLabel!
    @IBOutlet weak var referealTextLBL : UILabel!
    @IBOutlet weak var referalTable : CommonTableView!
    @IBOutlet weak var copyBtn: PrimaryTintButton!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    

    var viewController : ReferalVC!
    
    override func darkModeChange() {
        super.darkModeChange()
        self.urRefcodeLbl.customColorsUpdate()
        self.urRefcodeLbl.font = UIFont(name: G_RegularFont, size: 18)
        self.headerView.customColorsUpdate()
        self.navView.customColorsUpdate()
        self.pageTitle.customColorsUpdate()
        self.referalTable.customColorsUpdate()
        self.referalTable.reloadData()
        self.referalDescription.customColorsUpdate()
        self.referalDescription.font = UIFont(name: G_RegularFont, size: 18)
        self.contentHolderView.customColorsUpdate()
        self.referalCodeValuelbl.font = UIFont(name: G_BoldFont, size: 18)
    }
    
    
    @IBAction func shareAction(_ sender : UIButton?){
        let urlString = self.viewController.appLink
        guard let url = NSURL(string: urlString) else {return}
        let text = LangCommon.signUpGet
        + LangCommon.useMyReferral
        + " "
        + self.viewController.referalCode
        + " "
        + LangCommon.startYourJourney
        + " "
        + LangCommon.appName
        + " "
        + LangCommon.fromHere
        + " "
        + "\(url)"
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self
        self.viewController.presentInFullScreen(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- Life cycle
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.viewController.exitScreen(animated: true)
    }
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? ReferalVC
        self.initView()
        self.initGestures()
        self.darkModeChange()
    }
    func setValue() {
        self.referalCodeValuelbl.text = self.viewController.referalCode
    }
    
    func initView(){
        self.referealTextLBL.text = ""
        self.referealTextLBL.backgroundColor = .TertiaryColor
        self.copyBtn.setTitle(nil, for: .normal)
        self.copyBtn.setImage(UIImage(named: "Copy")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.shareBtn.setImage(UIImage(named: "Share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.pageTitle.text = LangCommon.referral.capitalized
        self.urRefcodeLbl.text = LangCommon.yourInviteCode.capitalized
        self.referalTable.delegate = self
        self.referalTable.dataSource = self
//        self.referalTable.tableHeaderView = Shared.instance.isReferralEnabled()
//            ? self.headerView
//            : nil
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.headerView.isHidden = !Shared.instance.isReferralEnabled()
            self.headerView.cornerRadius = 15
            self.headerView.elevate(4)
        }
    }
    func initGestures(){
        self.referalHolderView.addAction(for: .tap) {[weak self] in
            guard let welf = self else{return}
            UIPasteboard.general.string = welf.viewController.referalCode//self.referalBC + " Use my Referral " +
            welf.viewController.appDelegate.createToastMessage(LangCommon.referralCodeCopied)
        }
        self.copyBtn.addAction(for:.tap){[weak self] in
            guard let welf = self else{return}
            UIPasteboard.general.string = welf.viewController.referalCode//self.referalBC + " Use my Referral " +
            welf.viewController.appDelegate.createToastMessage(LangCommon.referralCodeCopied)
        }
    }
}

extension ReferalView : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let referalVC = self.viewController else {
            return 0
        }
        referalVC.referalSections.removeAll()
        if !self.viewController.inCompleteReferals.isEmpty{
            self.viewController.referalSections.append(.inComplete)
        }
        if !self.viewController.completedReferals.isEmpty{
            self.viewController.referalSections.append(.completed)
        }
     
        if self.viewController.referalSections.isEmpty && !(Shared.instance.isLoading()){
            referalTable.alwaysBounceVertical = false
            let no_referal = UILabel()
            no_referal.text = LangCommon.noDataFound
            no_referal.font = .MediumFont(size: 15)
            no_referal.textColor = .ThemeTextColor
            no_referal.textAlignment = .center
            self.referalTable.backgroundView = no_referal
            return 0
        }else{
            self.referalTable.backgroundView = nil
            referalTable.alwaysBounceVertical = true
            
            return self.viewController.referalSections.count
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.frame.height * 0.08
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.frame.height * 0.08
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let holderView = SecondaryView(frame: CGRect(
                                        x: 0,
                                        y: headerView.frame.maxY,
                                        width: tableView.frame.width,
                                        height: self.frame.height * 0.08)
        )
        let label1Width = tableView.frame.width
        let label = SecondarySubHeaderLabel(frame: CGRect(
                                                x: 15,
                                                y: 0,
                                                width: label1Width - 30,
                                                height: self.frame.height * 0.08)
        )
        let label2 = SecondarySubHeaderLabel(frame: CGRect(
                                                x: label1Width + 15,
                                                y: 0,
                                                width: tableView.frame.width - label1Width - 5,
                                                height: self.frame.height * 0.08)
        )
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textAlignment = isRTLLanguage ? .right : .left
        label2.lineBreakMode = .byWordWrapping
        label2.numberOfLines = 1
        label2.textAlignment = isRTLLanguage ? .left : .right
        switch self.viewController.referalSections[section] {
        case .inComplete:
            label.text =  LangCommon.friendsIncomplete.capitalized
        case .completed:
            label.text = LangCommon.friendsCompleted.capitalized + "(\(LangCommon.earned) \(!self.viewController.totalEarning.isEmpty ? self.viewController.totalEarning : "0") )"
            label2.text =  LangCommon.earned + "\(!self.viewController.totalEarning.isEmpty ? self.viewController.totalEarning : "0") "
        }
        holderView.addSubview(label)
        holderView.customColorsUpdate()
        label.customColorsUpdate()
        label2.customColorsUpdate()
        holderView.layoutIfNeeded()
        return holderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewController.referalSections[section] {
        case .inComplete:
            return self.viewController.inCompleteReferals.count
        case .completed:
            return self.viewController.completedReferals.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReferalTCell.identifier) as! ReferalTCell
        let referal : ReferalModel
        if self.viewController.referalSections[indexPath.section] == .inComplete{
            referal = self.viewController.inCompleteReferals[indexPath.row]
        }else{
            referal = self.viewController.completedReferals[indexPath.row]
        }
        cell.ThemeUpdate()
        cell.setCell(referal)
        return cell
    }
}
