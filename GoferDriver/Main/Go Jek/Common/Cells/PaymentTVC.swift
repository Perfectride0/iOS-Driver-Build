
//
//  PaymentTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 28/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class PaymentTVC: BaseTableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var rate: SecondarySubHeaderLabel!
    @IBOutlet weak var currencySymbol: SecondarySubHeaderLabel!
    @IBOutlet weak var serviceItem: SecondarySubHeaderLabel!
    @IBOutlet weak var dropDownImg: CommonColorImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setTheme()
    }
    func setTheme() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        
        self.rate.customColorsUpdate()
        self.currencySymbol.customColorsUpdate()
        self.serviceItem.customColorsUpdate()
        self.dropDownImg.customColorsUpdate()
        self.borderView.backgroundColor = .clear
        self.outerView.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
