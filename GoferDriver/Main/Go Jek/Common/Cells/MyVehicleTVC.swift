//
//  MyVehicleTVC.swift
//  GoferDriver
//
//  Created by trioangle on 22/04/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

class MyVehicleTVC : UITableViewCell{
    @IBOutlet weak var iconIV : UIImageView!
    @IBOutlet weak var statusLbl : SecondarySmallBoldLabel!
    @IBOutlet weak var nameLbl : SecondaryRegularBoldLabel!
    @IBOutlet weak var valueLbl : InactiveRegularLabel!
    @IBOutlet weak var vehicleLbl : SecondaryRegularLabel!
    @IBOutlet weak var deleteBtn : TransparentPrimaryButton!
    @IBOutlet weak var editDocumentBtn : TransparentPrimaryButton!
    @IBOutlet weak var editVehicleBtn : TransparentPrimaryButton!
    @IBOutlet weak var iconLbl : UILabel!
    @IBOutlet weak var elevateView : SecondaryView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setTheme()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.initLayer()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setTheme() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.statusLbl.customColorsUpdate()
        self.nameLbl.customColorsUpdate()
        self.nameLbl.customColorsUpdate()
        self.valueLbl.customColorsUpdate()
        self.deleteBtn.customColorsUpdate()
        self.vehicleLbl.customColorsUpdate()
        self.editVehicleBtn.customColorsUpdate()
        self.editDocumentBtn.customColorsUpdate()
        self.elevateView.customColorsUpdate()
        
        if Shared.instance.isStoreDriver{
            self.deleteBtn.isHidden = true
        }else{
            self.deleteBtn.isHidden = false
        }
        
    }
    func initLayer() {
        self.elevateView.cornerRadius = 10
        self.elevateView.elevate(2)
    }
}
