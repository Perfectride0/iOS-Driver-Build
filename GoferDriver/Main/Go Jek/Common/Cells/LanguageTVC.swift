//
//  LanguageTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class LanguageTVC : UITableViewCell {
    
    @IBOutlet weak var nameLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var radioBtn : PrimaryTintButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.ThemeChange()
        self.radioBtn.isUserInteractionEnabled = false
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func ThemeChange() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.nameLbl.customColorsUpdate()
    }
    
    func populate(with language : Language){
        
        self.nameLbl.text = language.lang
        let image = UIImage(named: language.key ==  currentLanguage.key ? "Radio_btn_selected" : "Radio_btn_unselected")?
            .withRenderingMode(.alwaysTemplate)
        self.radioBtn.setImage(image,
                               for: .normal)
        self.radioBtn.tintColor = .PrimaryColor
    }
}
