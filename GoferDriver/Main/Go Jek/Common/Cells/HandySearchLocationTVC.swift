//
//  HandySearchLocationTVC.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandySearchLocationTVC: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var lblTitle: SecondaryRegularLabel!
    @IBOutlet weak var lblSubTitle: InactiveRegularLabel!
    @IBOutlet weak var lblIcon: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.setTheme()
    }
    func setTheme()
    {
        if #available(iOS 12.0, *) {
            let isDarkMode = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = isDarkMode ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = isDarkMode ? .DarkModeBackground : .SecondaryColor
            self.lblIcon.textColor = isDarkMode ? .DarkModeTextColor : .IndicatorColor
        } else {
            // Fallback on earlier versions
        }
        self.lblTitle.customColorsUpdate()
        self.lblSubTitle.customColorsUpdate()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
