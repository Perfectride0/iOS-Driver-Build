//
//  SettingCell.swift
//  GoferDriver
//
//  Created by trioangle on 02/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
class SettingATVC : UITableViewCell{
    
    @IBOutlet weak var iconIV : PrimaryImageView!
    @IBOutlet weak var titleLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var rightLbl : UILabel!
    
    func ThemeUpdate() {
        self.contentView.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.iconIV.tintColor = isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.rightLbl.textColor = isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.titleLbl.customColorsUpdate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeUpdate()
        self.selectionStyle = .none
    }
}

class SettingBTVC : UITableViewCell{
    
    @IBOutlet weak var iconIV: PrimaryImageView!
    @IBOutlet weak var titleLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var rightLbl : SecondarySubHeaderLabel!
    
    func ThemeUpdate() {
        self.titleLbl.customColorsUpdate()
        self.rightLbl.customColorsUpdate()
        self.contentView.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.iconIV.tintColor = isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeUpdate()
        self.selectionStyle = .none
    }
}

class SettingCTVC : UITableViewCell{
    
    @IBOutlet weak var titleLbl : ThemeButtonTypeLabel!
    @IBOutlet weak var deleteAccBTn: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    func ThemeUpdate() {
        self.titleLbl.customColorsUpdate()
        self.titleLbl.backgroundColor = .PrimaryColor
        self.titleLbl.textColor = .PrimaryTextColor
        self.deleteAccBTn.borderColor = isDarkStyle ? .DarkModeBackground : .systemBackground
        self.deleteAccBTn.textColor = .red
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "\(LangCommon.deleteAccount)", attributes: underlineAttribute)
        deleteAccBTn.attributedText = underlineAttributedString
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeUpdate()
        self.titleLbl.cornerRadius = 15
        self.selectionStyle = .none
        if !Shared.instance.isStoreDriver{
            self.deleteAccBTn.isHidden = false
        }else{
            self.deleteAccBTn.isHidden = true
        }
    }
}
