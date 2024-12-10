//
//  ReferalTCell.swift
//  GoferHandyProvider
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class ReferalTCell : UITableViewCell{
    
    @IBOutlet weak var alertHolderView: UIView!
    @IBOutlet weak var nameLBL : SecondarySmallHeaderLabel!
    @IBOutlet weak var descriptionLBL: SecondarySmallLabel!
    @IBOutlet weak var profileIV : UIImageView!
    @IBOutlet weak var daysLeftBtn : PrimaryButton!
    @IBOutlet weak var holderView : SecondaryView!
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var borderView: UIView!
    
    func ThemeUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.borderView.backgroundColor = .TertiaryColor
        self.holderView.customColorsUpdate()
        self.nameLBL.customColorsUpdate()
        self.descriptionLBL.customColorsUpdate()
    }
     
    static let identifier = "ReferalTCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.nameLBL.textAlignment = .natural
        self.descriptionLBL.textAlignment = .natural
        self.ThemeUpdate()
    }
    func setCell(_ referal : ReferalModel){
        self.nameLBL.text = referal.name
        self.profileIV.sd_setImage(with: referal.profile_image_url,
                                   placeholderImage: UIImage(named: "user_dummy"),
                                   options: .highPriority,
                                   context: nil)
       // self.descriptionLBL.text = referal.getDesciptionText
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.profileIV.cornerRadius = 20
        }
        self.borderView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
        if isRTLLanguage {
            let text = referal.earnable_amount
            let strCurrency = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
            let editable = text.replacingOccurrences(of:strCurrency, with: "")
            self.daysLeftBtn.setTitle("  \(editable)  " + "\(strCurrency)  ", for: .normal)
        } else {
            self.daysLeftBtn.setTitle("  \(referal.earnable_amount)  ", for: .normal)
        }
        self.alertHolderView.isHidden = true
        self.daysLeftBtn.isUserInteractionEnabled = false
        if referal.default_status == .expired {
           // self.descriptionLBL.isHidden = false
            self.descriptionLBL.text = LangCommon.referralExpired.uppercased()
            self.descriptionLBL.textColor = .ErrorColor
        }else if referal.default_status == .completed{
          //  self.descriptionLBL.isHidden = false
            self.descriptionLBL.text = LangCommon.completed.uppercased()
            self.descriptionLBL.textColor = .ThemeTextColor
        }else {
           // self.descriptionLBL.isHidden = (referal.remaining_days == 0 || referal.remaining_trips == 0)
           // self.descriptionLBL.text = referal.defaultStatus.displayText
            self.descriptionLBL.text = referal.getDesciptionText
        }
        
    }
}
