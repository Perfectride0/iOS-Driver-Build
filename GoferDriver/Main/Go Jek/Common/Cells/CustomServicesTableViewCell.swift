//
//  CustomServicesTableViewCell.swift
//  Goferjek Driver
//
//  Created by trioangle on 02/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class CustomServicesTableViewCell: UITableViewCell {

        @IBOutlet weak var bgView: SecondaryView!
        @IBOutlet weak var icon: SecondaryTintImageView!
        @IBOutlet weak var titleLbl: SecondaryRegularLabel!
        @IBOutlet weak var checkBoxHolderView: UIView!
        @IBOutlet weak var checkBoxImg: SecondaryTintImageView!
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            self.selectionStyle = .none
            self.setTheme()
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }

        func setTheme() {
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.bgView.customColorsUpdate()
            self.titleLbl.customColorsUpdate()
            self.checkBoxImg.customColorsUpdate()
            self.icon.customColorsUpdate()
        }
        
    }
    

