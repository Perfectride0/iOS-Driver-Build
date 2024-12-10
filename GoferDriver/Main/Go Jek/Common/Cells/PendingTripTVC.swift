//
//  PendingTripTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 24/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class PendingTripTVC: BaseTableViewCell {

    @IBOutlet weak var jobId: SecondarySmallHeaderLabel!
    @IBOutlet weak var jobDateTime: InactiveSmallLabel!
    @IBOutlet weak var jobLocationText: SecondarySmallLabel!
    @IBOutlet weak var jobLocation: SecondarySmallMediumLabel!
    @IBOutlet weak var pickupImg: UIImageView!
    @IBOutlet weak var barStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonStackHeight: NSLayoutConstraint!
    @IBOutlet weak var statusStackHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var dropStack: UIStackView!
    @IBOutlet weak var dropImg: UIImageView!
    @IBOutlet weak var dropLocationText: SecondarySmallLabel!
    @IBOutlet weak var acceptedJobBtn: PrimaryButton!
    @IBOutlet weak var declinedServicesBtn: PrimaryButton!
    @IBOutlet weak var dropLocation: SecondarySmallMediumLabel!
    @IBOutlet weak var buttonStackMain: UIStackView!
    
    @IBOutlet weak var statusTitleLbl: SecondarySmallLabel!
    @IBOutlet weak var requestedServiceButton: InactiveButton!
    @IBOutlet weak var statusStack: UIStackView!
    @IBOutlet weak var barStack: UIStackView!
    @IBOutlet weak var barLbl: UILabel!
    @IBOutlet weak var requestServiceStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setTheme()
    }
    func setTheme() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
        self.jobId.customColorsUpdate()
        self.jobDateTime.customColorsUpdate()
        self.jobLocationText.customColorsUpdate()
        self.jobLocation.customColorsUpdate()
        self.dropLocationText.customColorsUpdate()
        self.acceptedJobBtn.customColorsUpdate()
        self.declinedServicesBtn.customColorsUpdate()
        self.dropLocation.customColorsUpdate()
        self.statusTitleLbl.customColorsUpdate()
        self.barLbl.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        self.requestedServiceButton.customColorsUpdate()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func getNib() -> UINib{
        return UINib(nibName: "PendingTripTVC", bundle: nil)
    }
}
