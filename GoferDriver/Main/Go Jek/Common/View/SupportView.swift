//
//  SupportView.swift
//  GoferHandy
//
//  Created by trioangle on 17/11/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SupportView: BaseView,UITableViewDataSource,UITableViewDelegate{

    var supportVC : SupportVC!
    @IBOutlet weak var supportTable: CommonTableView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var holderview: TopCurvedView!
    @IBOutlet weak var titleLabel: SecondaryHeaderLabel!

    //MARK:- Outlets
    override func darkModeChange() {
        super.darkModeChange()
        self.titleLabel.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.supportTable.customColorsUpdate()
        self.holderview.customColorsUpdate()
        self.supportTable.reloadData()
    }
    //MARK:- life cycle
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.supportVC = baseVC as? SupportVC
        self.supportTable.delegate = self
        self.supportTable.dataSource = self
        self.titleLabel.text = LangCommon.support
        self.darkModeChange()
    }
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.supportVC.navigationController?.popViewController(animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shared.instance.supportArray?.count ?? 0
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SupportTCell = tableView.dequeueReusableCell(for: indexPath)
        guard let supportModel = Shared.instance.supportArray?.value(atSafe: indexPath.row) else{
            return cell
        }
        cell.menuIcon.sd_setImage(with: NSURL(string: supportModel.image)! as URL, completed: nil)
        cell.titleLbl.text = supportModel.name
        cell.ThemeUpdate()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
       guard let supportModel = Shared.instance.supportArray?.value(atSafe: indexPath.row) else{
               return
       }
       if supportModel.id == 1 {
           if supportModel.is_numeric == true {
               if let phoneCallURL = URL(string:"tel://\(supportModel.link)") {
                   let application:UIApplication = UIApplication.shared
                   if (application.canOpenURL(phoneCallURL)) {
                       application.open(phoneCallURL,
                                        options: [:],
                                        completionHandler: nil)
                   }
               }
           } else {
               let phoneNumber = supportModel.link
   //            let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=")!
   //            let usefullWhere: String = "whatsapp://?app"//
               let usefullWhere: String = "whatsapp://send?phone=\(phoneNumber)&text=hi"
               let url : URL = NSURL(string: usefullWhere)! as URL
               if UIApplication.shared.canOpenURL(url) {
                   if #available(iOS 10.0, *) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                   }
                   else {
                       UIApplication.shared.openURL(url)
                   }
               } else {
                   // WhatsApp is not installed

                       let appURL = URL(string: "https://apps.apple.com/in/app/whatsapp-messenger/id310633997")!
   //                let appURL = URL(string: "https://www.whatsapp.com")!
                   if UIApplication.shared.canOpenURL(appURL) {
                           if #available(iOS 10.0, *) {
                               UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                           } else {
                               UIApplication.shared.openURL(appURL)
                           }
                       }

               }
           }
       }else if supportModel.id == 2 {
           if supportModel.is_numeric == true {
               if let phoneCallURL = URL(string:"tel://\(supportModel.link)") {
                   let application:UIApplication = UIApplication.shared
                   if (application.canOpenURL(phoneCallURL)) {
                       application.open(phoneCallURL,
                                        options: [:],
                                        completionHandler: nil)
                   }
               }
           } else {
               let skype: NSURL = NSURL(string: String(format: "skype:" + supportModel.link + "?chat"))! //add object skype like this
               if UIApplication.shared.canOpenURL(skype as URL) {
                   UIApplication.shared.open(skype as URL)
                }
               else {
               // skype not Installed in your Device
                   let skypeUrl: NSURL = NSURL(string: String(format: "https://itunes.apple.com/in/app/skype/id304878510?mt=8"))!
                   UIApplication.shared.open(skypeUrl as URL)
               }
           }
           
           
       }else{
           
           if let _ = Int(supportModel.link.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")) {
               // Phone Number
               
               UIApplication.shared.open(URL(string: "telprompt://\(supportModel.link.replacingOccurrences(of: " ", with: ""))")!, options: [:], completionHandler: nil)
               
           } else {
               // Not a Phone Number
               guard let otherUrl: NSURL = NSURL(string: String(format: supportModel.link)) else {
                   self.supportVC.presentAlertWithTitle(title: appName.capitalized,
                                                        message: LangCommon.notAValidData,
                                              options: LangCommon.ok) { (_) in
                                               
                   }
                   return
               }
               if UIApplication.shared.canOpenURL(otherUrl as URL) {
                   UIApplication.shared.open(otherUrl as URL)
               }else{
                   let otherUrl: NSURL = NSURL(string: String(format: "http://" + supportModel.link))!
                   if UIApplication.shared.canOpenURL(otherUrl as URL) {
                       UIApplication.shared.open(otherUrl as URL)
                   }else{
                       self.supportVC.presentAlertWithTitle(title: LangCommon.appName.capitalized,
                                                            message: LangCommon.notAValidData,
                                                  options: LangCommon.ok) { (_) in
                                                   
                       }
                   }
               }
           }
       }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
class SupportTCell: UITableViewCell
{
    @IBOutlet weak var outerView: SecondaryView!
    @IBOutlet weak var titleLbl: SecondaryRegularLabel!
    @IBOutlet weak var menuIcon: UIImageView!
    static let identifier = "SupportTCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.outerView.cornerRadius = 15
        self.outerView.elevate(2)
        self.ThemeUpdate()
    }
    
    func ThemeUpdate() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.outerView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
    }
}
