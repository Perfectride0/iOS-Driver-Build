//
//  CustomClasses.swift
//  GoferHandyProvider
//
//  Created by trioangle on 16/02/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class CurvedView: UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.isCurvedCorner = true
        self.clipsToBounds = true
        self.elevate(2)
    }
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}

class TopCurvedView: UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.elevate(4,
                     shadowColor: isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
    }
    func removeSpecificCorner(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 0
        self.layer.maskedCorners = [] //
    }
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}

class BottomCurvedView: UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        self.elevate(4)
    }
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}

class HeaderView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class CustomBackBtn : UIButton {
    func customColorsUpdate() {
        self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class CommonColorImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    override
    func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class TransperentIndicatorButton: UIButton {
    func customColorsUpdate() {
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
        self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.titleLabel?.font = .BoldFont(size: 15)
    }
    override
    func awakeFromNib() {
        self.customColorsUpdate()
    }
}
// MARK:- ****** TextField *********
class CommonTextField: UITextField {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }

        self.font = .MediumFont(size: 16)
        self.tintColor = .PrimaryColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
// MARK:- ****** TableView *********
class CommonTableView : UITableView {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.tintColor = .PrimaryColor
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}


// MARK:- ****** SearchBar *********
class CommonSearchBar : UISearchBar {
    func customColorsUpdate() {
        self.barTintColor = .PrimaryColor
        self.backgroundColor = .PrimaryColor
        self.searchBarStyle = .minimal
        if #available(iOS 13.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.searchTextField.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
//            self.searchTextField.textColor = isdarkStyle ? .DarkModeTextColor : .SecondaryTextColor
            self.searchTextField.font = .MediumFont(size: 14)
            self.searchTextField.tintColor = .PrimaryColor
        } else {
            if let textfield = self.value(forKey: "searchField") as? UITextField {
//                textfield.textColor = .SecondaryTextColor
                textfield.backgroundColor = .SecondaryColor
                textfield.tintColor = .PrimaryColor
                textfield.font = .MediumFont(size: 14)
            }
        }
    }
        override func awakeFromNib() {
            super.awakeFromNib()
            self.customColorsUpdate()
        }
    }
// MARK:- ****** TextView *********
class CommonTextView : UITextView {
    func customColorsUpdate() {
        self.tintColor = .PrimaryColor
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 14) //.BoldFont(size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
// MARK:- ****** PageControl *********
class CommonPageControl : UIPageControl {
    func customColorsUpdate() {
        self.currentPageIndicatorTintColor = .PrimaryColor
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .TertiaryColor

        } else {
            // Fallback on earlier versions
        }
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


// MARK:- ****** View *********
/**
 - note:
 - Type                ->      View
 - Background    ->     Theme Color
 - Border            ->      Default
            
 */
class PrimaryView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
/**
 - note:
 - Type                ->      View
 - Background    ->     White Color
 - Border            ->      Default
            
 */
class SecondaryView : UIView {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func customColorsUpdates() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.elevate(4,shadowColor: isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
    }
    
    func customColorsUpdated() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
//        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.elevate(4,shadowColor: isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      View
 - Background    ->     Black To White Color
 */

class SecondaryInvertedView : UIView {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .SecondaryColor : .DarkModeBackground
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

/**
 - note:
 - Type                ->      View
 - Background    ->     White Color
 - Border            ->      Inactive
            
 */
class InactiveBorderSecondaryView : UIView {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.border(1, .TertiaryColor)
            self.cornerRadius = 15
        } else {
            // Fallback on earlier versions
        }
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

// MARK:- ****** Button *********
class PrimaryButton: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
        self.setTitleColor(.PrimaryTextColor, for: .normal)
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.clipsToBounds = true
        self.cornerRadius = 15
        self.titleLabel?.font = .BoldFont(size: 15)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class InactiveButton : UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .TertiaryColor
        self.setTitleColor(.PrimaryTextColor, for: .normal)
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.clipsToBounds = true
        self.cornerRadius = 15
        self.titleLabel?.font = .BoldFont(size: 15)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class PrimaryFontButton: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .PrimaryColor
        self.setTitleColor(.PrimaryTextColor, for: .normal)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondaryFontButton: UIButton {
    func customColorsUpdate() {
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondaryButton: UIButton {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
            self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.titleLabel?.font = .BoldFont(size: 15)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class TransparentPrimaryButton: UIButton {
    func customColorsUpdate() {
        self.setTitleColor(.ThemeTextColor, for: .normal)
        self.titleLabel?.font = .BoldFont(size: 15)
        self.tintColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


class ThemeBtnTxt: UIButton {
    func customColorsUpdate() {
        self.backgroundColor = .ThemeTextColor
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .BoldFont(size: 15)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondaryThemeBorderedButton: UIButton {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor

        } else {
            // Fallback on earlier versions
        }
        self.clipsToBounds = true
        self.cornerRadius = 15
        self.border(1, .PrimaryColor)
        self.setTitleColor(.ThemeTextColor, for: .normal)
        self.titleLabel?.font = .BoldFont(size: 15)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryInactiveBorderedButton: UIButton {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.borderColor = self.isDarkStyle ? .DarkModeBorderColor : .TertiaryColor

        } else {
            // Fallback on earlier versions
        }
        //self.borderColor = .PrimaryColor
        self.setTitleColor(.SecondaryColor, for: .normal)
        self.titleLabel?.font = .BoldFont(size: 15)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
   
}
class PrimaryTintButton: UIButton {
    func customColorsUpdate() {
        self.imageView?.tintColor = .PrimaryColor
    }
    func customColorsUpdated() {
        if #available(iOS 12.0, *) {
            let isDarkstyle = self.traitCollection.userInterfaceStyle == .dark
            self.imageView?.tintColor = self.isDarkStyle ? .white : .darkGray
        }
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondaryTintButton: UIButton {
    func customColorsUpdate() {
        self.imageView?.tintColor = .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryBorderedButton : UIButton {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor, for: .normal)
        self.borderColor = .TertiaryColor
        self.titleLabel?.font = .BoldFont(size: 16)
        self.borderWidth = 1
        self.clipsToBounds = true
        self.cornerRadius = 15

    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

// MARK:- ****** Label *********
class PrimaryHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = .BoldFont(size: 18)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryHeaderLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 18)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class TimerHeaderLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 20)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryWelcomeLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 37)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryInvertedRegularLabel : UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .SecondaryTextColor : .DarkModeTextColor
        self.font = UIFont(name: G_RegularFont, size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryInvertedSmallLabel : UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .SecondaryTextColor : .DarkModeTextColor
        self.font = UIFont(name: G_RegularFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryInvertedImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = self.isDarkStyle ? .SecondaryTextColor : .DarkModeTextColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondarySubWelcomeLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 25)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class PrimarySubHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = UIFont(name: G_BoldFont, size: 26)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class PrimarySubHeaderThemeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = UIFont(name: G_BoldFont, size: 16)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class PrimaryButtonTypeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = UIFont(name: G_BoldFont, size: 16)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryTextFieldTypeLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondarySubHeaderLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 16)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ThemeSubHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = UIFont(name: G_BoldFont, size: 16)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class InactiveSubHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .InactiveTextColor
        self.font = UIFont(name: G_BoldFont, size: 16)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class PrimarySmallHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = UIFont(name: G_BoldFont, size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondarySmallHeaderLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}


class smallHeaderLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .SecondaryTextColor : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class PrimaryRegularLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = UIFont(name: G_RegularFont, size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryRegularLargeLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = .lightFont(size: 20)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryRegularLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_RegularFont, size: 16)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryRegularBoldLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.font = UIFont(name: G_BoldFont, size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class ThemeButtonTypeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = UIFont(name: G_BoldFont, size: 15)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ThemeRegularLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = UIFont(name: G_RegularFont, size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class InactiveRegularLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .InactiveTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_RegularFont, size: 14)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class PrimarySmallLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = UIFont(name: G_RegularFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class PrimaryExtraSmallHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = UIFont(name: G_BoldFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryExtraSmallLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_MediumFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondaryExtraNavigateLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_MediumFont, size: 10)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class InactiveExtraSmallLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .InactiveTextColor
        self.font = UIFont(name: G_MediumFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondarySmallLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_RegularFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class smallLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_RegularFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondarySmallBoldLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_BoldFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondarySmallMediumLabel: UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
        self.font = UIFont(name: G_MediumFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ThemeExtraSmallHeaderLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = UIFont(name: G_MediumFont, size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ReferalLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
        self.font = .BoldFont(size: 35)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ThemeSmallLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryColor
        self.font = .BoldFont(size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class RatingLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .RatingColor
        self.font = .BoldFont(size: 35)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ThemeLargeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = .BoldFont(size: 35)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryLargeLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.font = .MediumFont(size: 35)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ThemeMixLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = .BoldFont(size: 18)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ThemeMinimumLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
        self.font = .BoldFont(size: 20)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class InactiveSmallLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .InactiveTextColor
        self.font = .lightFont(size: 12)
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class ErrorLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .ErrorColor
        self.font = .BoldFont(size: 13)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
class PrimaryFontBasedLabel : UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryTextColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
class SecondaryFontBasedLabel : UILabel {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        } else {
            // Fallback on earlier versions
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
class PayStatementFontLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PayStatementColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
class PayStatementLabel: UILabel {
    func customColorsUpdate() {
        self.textColor = .PrimaryColor
        self.font = .BoldFont(size: 35)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
class ThemeFontBasedLabel : UILabel {
    func customColorsUpdate() {
        self.textColor = .ThemeTextColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
class InactiveFontBasedLabel : UILabel {
    func customColorsUpdate() {
        self.textColor = .InactiveTextColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
// MARK:- ****** Image View *********

class PrimaryImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class SecondaryImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = .SecondaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
class SecondaryTintImageView : UIImageView {
    func customColorsUpdate() {
        self.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class PrimaryBorderedImageView : UIImageView {
    func customColorsUpdate() {
        self.borderColor = .PrimaryColor
        self.tintColor = .PrimaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}

class InactiveBorderedImageView : UIImageView {
    func customColorsUpdate() {
        self.borderColor = .TertiaryColor
        self.tintColor = .TertiaryColor
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
//MARK:- ***** SegmentedControl *****
class CommonSegmentControl : UISegmentedControl {
    func customColorsUpdate() {
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor

        } else {
            // Fallback on earlier versions
        }
        self.borderColor = .PrimaryColor
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = .PrimaryColor
        } else {
            // Fallback on earlier versions
            self.tintColor = .PrimaryColor
        }
    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
//MARK:- ***** CollectionView *****
class CommonCollectionView: UICollectionView {
    func customColorsUpdate() {
        self.tintColor = .PrimaryColor
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        if #available(iOS 12.0, *) {
            let isdarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor

        } else {
            // Fallback on earlier versions
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}
//MARK:- ***** CollectionView *****
class CommonPickerView: UIPickerView {
    func customColorsUpdate() {
        self.backgroundColor =  self.isDarkStyle ? UIColor.TertiaryColor.withAlphaComponent(0.1) : UIColor.SecondaryColor.withAlphaComponent(0.5)
        self.tintColor = .PrimaryColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customColorsUpdate()
    }
}


class PrimaryBorderedButton : UIButton {
    func customColorsUpdate() {
        self.backgroundColor = self.isDarkStyle ? .SecondaryColor : .DarkModeBackground
        self.setTitleColor(self.isDarkStyle ? .SecondaryTextColor : .DarkModeTextColor, for: .normal)
        self.borderColor = .TertiaryColor
        self.titleLabel?.font = .BoldFont(size: 16)
        self.borderWidth = 1
        self.clipsToBounds = true
        self.cornerRadius = 15

    }
    override func awakeFromNib() {
        self.customColorsUpdate()
    }
}
