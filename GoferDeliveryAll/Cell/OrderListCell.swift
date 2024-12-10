//
//  OrderListCell.swift
//  GoferHandyProvider
//
//  Created by trioangle on 28/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {

    @IBOutlet weak var nameLblText: SecondaryHeaderLabel!
    @IBOutlet weak var orderIdLbl: InactiveExtraSmallLabel!
    @IBOutlet weak var deliveryLocLbl: SecondaryExtraSmallLabel!
    @IBOutlet weak var estimationLbl: UILabel!
    @IBOutlet weak var outerView: SecondaryView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // corner radius
        outerView.layer.cornerRadius = 10
        outerView.elevate(2.5)

        // border
       // outerView.layer.borderWidth = 1.0
        //outerView.layer.borderColor = UIColor.themes
        //self.outerView.layer.borderColor = UIColor.ThemeMain.cgColor

        /*// shadow
        outerView.layer.shadowColor = UIColor(red:252/255, green:130/255, blue:0/255, alpha: 1).cgColor
        outerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        outerView.layer.shadowOpacity = 0.7
        outerView.layer.shadowRadius = 1.0*/
        
        self.darkModeChnages()
        
    }
    
    func darkModeChnages() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        nameLblText.customColorsUpdate()
        orderIdLbl.customColorsUpdate()
        deliveryLocLbl.customColorsUpdate()
        outerView.customColorsUpdate()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
