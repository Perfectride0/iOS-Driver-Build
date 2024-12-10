//
//  WebUnderMaintenanceView.swift
//  GoferHandy
//
//  Created by trioangle on 03/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit
import MessageUI

class WebUnderMaintenanceView: BaseView {
    
    // MARK: ----> Outlets <------
    @IBOutlet weak var siteTitleLbl: PrimarySubHeaderThemeLabel!
    @IBOutlet weak var siteContentTxtView: UITextView!
    @IBOutlet weak var tryAgainMainView: UIView!
    @IBOutlet weak var tryAgainBtn: PrimaryButton!
    
    
    // MARK: ----> Local Variable <------
    var webUnderMaintenanceVC : WebUnderMaintenanceVC!
    var email = "sales@trioangle.com"
    var currentVersion : String {
        if let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            print("currentVersion",currentVersion)
            return currentVersion
        }
        return ""
    }
    
    // MARK: ----> Life Cycle <------
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.webUnderMaintenanceVC = baseVC as? WebUnderMaintenanceVC
        self.initView()
        self.deinitNotification()
        self.initNotification()
        self.addInfoToTextView()
    }
    
    override func darkModeChange() {
        super.darkModeChange()
        self.addInfoToTextView()
        self.siteTitleLbl.customColorsUpdate()
        self.tryAgainBtn.customColorsUpdate()
    }
    
    // MARK: ----> Initalisation <------
    
    func initView() {
        self.webUnderMaintenanceVC.navigationController?.navigationBar.isHidden = true
        self.tryAgainMainView.elevate(3.0)
        self.tryAgainMainView.cornerRadius = 10
        self.webUnderMaintenanceVC.tabBarController?.tabBar.isHidden = true
    }
    
    func initNotification() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(logOutUser),
                                               name: Notification.Name("k_LogoutUser"),
                                               object: nil)
    }
    
    func deinitNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name("k_LogoutUser"),
                                                  object: nil)

    }
    
    // MARK: -----> Button Action <------
    @IBAction func tryAgainBtnAction(_ sender: Any) {
        self.webUnderMaintenanceVC.wsToGetStart()
    }
    
    // MARK: ----> Local Function <------
    
    @objc
    func logOutUser() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(false, forKey: "isLogin")
        AppDelegate.shared.logOutDidFinish()
        self.webUnderMaintenanceVC.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func addInfoToTextView()  {
        let attributedString = NSMutableAttributedString(string: "We will right back once development completed, Please contact us through \(email) for more details.")
        let strName = "We will right back once development completed, Please contact us through \(email) for more details."
        let string_to_color2 = email
        _ = NSMutableAttributedString(string:strName)
        let range2 = (strName as NSString).range(of: string_to_color2)
        print(range2)
        attributedString.addAttribute(NSAttributedString.Key.link, value: "mailto:", range: range2)
        self.siteContentTxtView.text = LangDeliveryAll.support_txt
        self.siteContentTxtView.attributedText = attributedString
        self.siteContentTxtView.linkTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(hex: "2bcb7b"), NSAttributedString.Key.underlineStyle:NSNumber(value: 0)]
        let isDarkStyle = traitCollection.userInterfaceStyle == .dark
        self.siteContentTxtView.textColor = isDarkStyle ? .DarkModeTextColor : .DarkModeBackground
        self.siteContentTxtView.textAlignment = .center
        self.siteContentTxtView.isEditable = false
        self.siteContentTxtView.dataDetectorTypes = UIDataDetectorTypes.all
        self.siteContentTxtView.delegate = self
    }
}

extension WebUnderMaintenanceView : UITextViewDelegate {
    @available(iOS, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        if (url.scheme?.contains("mailto"))! && characterRange.location > 55{
            openMFMail()
        }
        return false
    }
    
    //For iOS 10
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if (url.scheme?.contains("mailto"))! && characterRange.location > 55{
            openMFMail()
        }
        return false
    }
    func openMFMail(){
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["\(email)"])
        mailComposer.setSubject("Website Under Maintenance Be right back")
        mailComposer.setMessageBody("Please share your problem.", isHTML: false)
        self.webUnderMaintenanceVC.present(mailComposer,
                                           animated: true,
                                           completion: nil)
    }
}

extension WebUnderMaintenanceView : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
