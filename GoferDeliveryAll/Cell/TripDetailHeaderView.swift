//
//  TripDetailHeaderView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 10/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class TripDetailHeaderView: UITableViewCell {

    @IBOutlet weak var mapView: SecondaryView!
    @IBOutlet weak var tripIdlbl: PrimarySubHeaderThemeLabel!
    @IBOutlet weak var imgMapRoot : SecondaryImageView!
    @IBOutlet weak var imgUserThumb : UIImageView!
    @IBOutlet weak var paymentTypeLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var lblPickUpLoc : SecondaryTextFieldTypeLabel!
    @IBOutlet weak var lblDropLoc : SecondaryTextFieldTypeLabel!
    @IBOutlet weak var lblTripTime: SecondarySmallBoldLabel!
    @IBOutlet weak var NoofSeats: SecondarySmallBoldLabel!
    @IBOutlet weak var lblCost: PrimaryHeaderLabel!
    @IBOutlet weak var lblTripStatus: SecondarySmallBoldLabel!
    @IBOutlet weak var lblDriverName: SecondaryTextFieldTypeLabel!
    @IBOutlet weak var boxImg: UIImageView!
    @IBOutlet weak var circleImg: UIImageView!
    @IBOutlet weak var dottedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setTheme()
    }

    
    func setTheme() {
        mapView.elevate(2.5)
        mapView.customColorsUpdate()
        mapView.cornerRadius = 20
        imgUserThumb.layer.cornerRadius = 10
        imgUserThumb.clipsToBounds = true
        self.dottedView.backgroundColor = .clear
        self.dottedView.addDashedBorder(view: self.dottedView,strokeColor: self.isDarkStyle ? .white : .lightGray)
        self.boxImg.image = UIImage(named: isDarkStyle ? "box_white" : "box")
        self.circleImg.image = UIImage(named: isDarkStyle ? "circle_white" : "circle")
        self.tripIdlbl.customColorsUpdate()
        self.lblPickUpLoc.customColorsUpdate()
        self.lblDropLoc.customColorsUpdate()
        self.lblTripTime.customColorsUpdate()
        self.NoofSeats.customColorsUpdate()
        self.lblCost.customColorsUpdate()
        self.lblTripStatus.customColorsUpdate()
        self.lblDriverName.customColorsUpdate()
        self.imgMapRoot.customColorsUpdate()
        self.paymentTypeLbl.customColorsUpdate()
    }
}
