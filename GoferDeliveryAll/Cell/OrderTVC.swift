//
//  OrderTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle on 16/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

import UIKit

class OrderTVH : UIView {
    @IBOutlet weak var acceptIV : UIImageView!
    @IBOutlet weak var cancelIV : UIImageView!
    @IBOutlet weak var recepientNameLbl : SecondaryExtraSmallLabel!
    @IBOutlet weak var orderIDLbl : InactiveExtraSmallLabel!
    private var action : Closure<Bool>?
    class func getView() -> OrderTVH {
        let nib = UINib(nibName: "OrderTVH", bundle: nil)
        let orderHeaderView = nib.instantiate(withOwner: nil, options: nil).first as! OrderTVH
        orderHeaderView.themeChange()
        return orderHeaderView
    }
    
    func setRecepient(name : String,andOrderID orderId : Int){
        self.recepientNameLbl.text = name
        self.orderIDLbl.text = "ORDER ID #"+orderId.description//"\(LanguageEnum.default.object.orderID.uppercased()) #"+orderId.description
        
    }
    
    func themeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.recepientNameLbl.customColorsUpdate()
        self.orderIDLbl.customColorsUpdate()
    }
    
    func hightLight(option : Bool?){
        self.acceptIV.tintColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        self.cancelIV.tintColor = .TertiaryColor
        if let choosed = option {
            self.acceptIV.tintColor = choosed ? .PrimaryColor : UIColor.TertiaryColor.withAlphaComponent(0.5)
            self.cancelIV.tintColor = !choosed ? .PrimaryColor : UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
    }


}

class OrderTVC: UITableViewCell {

    @IBOutlet weak var countLbl : SecondaryExtraSmallLabel!
    @IBOutlet weak var itemNameLbl : SecondaryExtraSmallLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.darkModeTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func darkModeTheme() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.countLbl.customColorsUpdate()
        self.itemNameLbl.customColorsUpdate()
    }

    func populate(with item : FoodItem) {
        self.countLbl.text = item.counter
        self.itemNameLbl.text = item.name
        self.itemNameLbl.textColor = item.isMainItem ? isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor : .TertiaryColor
    }
}

