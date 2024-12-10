//
//  PayoutItemTVC.swift
//  GoferDriver
//
//  Created by trioangle on 10/02/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import SDWebImage

class PayoutItemTVC: UITableViewCell {

    @IBOutlet weak var titleLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var valueLbl : InactiveRegularLabel!
    @IBOutlet weak var defaultLbl : ThemeButtonTypeLabel!
    @IBOutlet weak var iconIV : UIImageView!
    @IBOutlet weak var bgView: SecondaryView!
    
    func ThemeChange() {
        if #available(iOS 12.0, *) {
            let isDarkstyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
        self.bgView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.valueLbl.customColorsUpdate()
        self.defaultLbl.customColorsUpdate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.clipsToBounds = true
        self.bgView.cornerRadius = 15
        self.bgView.border(1, UIColor.TertiaryColor.withAlphaComponent(0.3))
        self.ThemeChange()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func populateCell(with item : PayoutItemModel){
        self.defaultLbl.isHidden = !item.isDefault
        self.titleLbl.text = item.value
        self.iconIV.sd_setImage(with: URL(string: item.icon), completed: nil)
        self.defaultLbl.text = LangCommon.defaults.capitalized
        if item.id == 0{
//            self.valueLbl.text = "Add your \(item.value) Data"
            self.valueLbl.text = LangCommon.add + " \(item.value) " + LangCommon.payout
        }else{
            self.valueLbl.text = item.key.contains("bank") ? item.payoutData?.accountNumber : item.payoutData?.paypalEmail
        }
    }
}
