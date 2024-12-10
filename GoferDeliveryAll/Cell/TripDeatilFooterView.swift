//
//  TripDeatilFooterView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 10/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class TripDeatilFooterView: UITableViewCell {

    @IBOutlet weak var footerOuterView: HeaderView!
    @IBOutlet weak var durationTitleLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var durationValueLbl: ThemeMixLabel!
    @IBOutlet weak var distanceTitleLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var distanceValueLbl: ThemeMixLabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTheme() {
         self.footerOuterView.isCurvedCorner = true
         self.footerOuterView.elevate(1)
        self.footerOuterView.customColorsUpdate()
        self.durationTitleLbl.customColorsUpdate()
        self.durationValueLbl.customColorsUpdate()
        self.distanceTitleLbl.customColorsUpdate()
        self.distanceValueLbl.customColorsUpdate()
    }
    
}
