//
//  ReasonCVC.swift
//  GoferGroceryDriver
//
//  Created by trioangle on 04/04/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class ReasonCVC : UICollectionViewCell{
    
    @IBOutlet weak var holderView : SecondaryView!
    @IBOutlet weak var lbl : SecondaryRegularLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.themeChange()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func themeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.holderView.customColorsUpdate()
        self.lbl.customColorsUpdate()
    }
    
    func populate(with data : OrderDeliveryIssue,isSelected : Bool){
        self.lbl.text = data.issue
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.holderView.isRoundCorner = true
            self.holderView.border(1, .black)
            self.holderView.backgroundColor =  isSelected ? .CancelledStatusColor : (UIColor.TertiaryColor.withAlphaComponent(0.5))
        }
    }
}
