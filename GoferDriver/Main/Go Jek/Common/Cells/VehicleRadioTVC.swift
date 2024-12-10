//
//  VehicleRadioTVC.swift
//  GoferDriver
//
//  Created by trioangle on 23/04/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
class VehicleRadioTVC : UITableViewCell{
    @IBOutlet weak var radioIV : PrimaryImageView!
    @IBOutlet weak var vehicleNameLbl : SecondaryRegularBoldLabel!
    @IBOutlet weak var numberLbl : SecondaryRegularLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setTheme()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setTheme() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.radioIV.customColorsUpdate()
        self.vehicleNameLbl.customColorsUpdate()
        self.numberLbl.customColorsUpdate()
    }
}
