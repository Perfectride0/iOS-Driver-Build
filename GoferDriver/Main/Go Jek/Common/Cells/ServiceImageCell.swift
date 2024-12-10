//
//  ServiceImageCell.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 21/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class ServiceImageCell: BaseCollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outerView: SecondaryView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ThemeChange()
    }
    
    func ThemeChange() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.outerView.customColorsUpdate()
    }
}
