//
//  AcceptOrderCell.swift
//  GoferHandyProvider
//
//  Created by trioangle on 22/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit


class AcceptOrderCell: UITableViewCell {
    
    @IBOutlet weak var acceptStack: UIStackView!
    
    @IBOutlet weak var outerView: SecondaryView!
    
    
    @IBOutlet weak var quantityTableView: CommonTableView!
    @IBOutlet weak var heightOfQuantityTV: NSLayoutConstraint!
    
    
    @IBOutlet weak var userNameLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var orderIdLbl: InactiveRegularLabel!
    
    @IBOutlet weak var acceptOrderOutlet: UIButton!
    @IBOutlet weak var acceptView: SecondaryView!
    
    @IBOutlet weak var closeView: SecondaryView!
    @IBOutlet weak var closeOrderOutlet: UIButton!
    
    @IBOutlet weak var acceptedLbl: SecondaryExtraSmallLabel!
    
    private let quantityCellHight = 30
    private let addonCellHight = 20
    
    var orderItem: [Order_item]!
    var isFood : Bool = true
    //@IBOutlet weak var acceptedLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       /* // corner radius
        outerView.layer.cornerRadius = 10

        // border
        outerView.layer.borderWidth = 1.0
        outerView.layer.borderColor = UIColor.ThemeMain.cgColor
        
        // shadow
        outerView.layer.shadowColor = UIColor(red:252/255, green:130/255, blue:0/255, alpha: 1).cgColor
        outerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        outerView.layer.shadowOpacity = 0.7
        outerView.layer.shadowRadius = 1.0*/
        outerView.cornerRadius = 15.0
        outerView.elevate(2.5)
        themeChange()
        self.initSetup()
      
    }
    
    func setValue(orderDetail: Order_details,
                  isFood: Bool) {
        self.userNameLbl.text = orderDetail.user_name
        self.orderIdLbl.text = "\(LangDeliveryAll.orderId) \(orderDetail.order_id!)"
        let status = orderDetail.is_picked
        self.userNameLbl.setTextAlignment()
        self.orderIdLbl.setTextAlignment()
        self.acceptedLbl.text = LangDeliveryAll.accepted
        self.acceptedLbl.textColor = UIColor(hex: "#4E930B")
        self.acceptView.isHidden = status == "1"
        self.closeView.isHidden = status == "1"
        self.acceptedLbl.isHidden = !(status == "1")
        
        if let model = orderDetail.order_item {
            var height = model.count * quantityCellHight
            self.orderItem = model
            let counts = model.compactMap({$0.modifiers?.count})
            for count in counts {
                height = (count * quantityCellHight) + height
            }
            self.heightOfQuantityTV.constant = CGFloat(height)
            self.layoutIfNeeded()
            self.initSetup()
        }
        self.isFood = isFood
    }
    
    func initSetup() {
        self.quantityTableView.dataSource = self
        self.quantityTableView.delegate = self
        self.layoutIfNeeded()
    }
    
    
    func themeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        outerView.customColorsUpdate()
        userNameLbl.customColorsUpdate()
        orderIdLbl.customColorsUpdate()
        acceptView.customColorsUpdate()
        closeView.customColorsUpdate()
        self.quantityTableView.customColorsUpdate()
        self.quantityTableView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension AcceptOrderCell : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView,
//                   heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}

extension AcceptOrderCell : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let orderItem = orderItem else { return 0 }
        return orderItem.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuantityStackTVC", for: indexPath) as! QuantityStackTVC
        guard let orderItem = orderItem,
              let model = orderItem.value(atSafe: indexPath.row) else { return cell }
        cell.quantityLbl.text = "\(model.quantity?.description ?? "")X"
        cell.productName.text = model.name
        cell.productImg.isHidden = !(self.isFood)
        cell.productImg.image = UIImage(named: "pickOrder")?.withRenderingMode(.alwaysTemplate)
        cell.productImg.tintColor = (model.isVeg) ? .CompletedStatusColor : .CancelledStatusColor
        if let modifier = model.modifiers {
            cell.modifiers = modifier
            cell.initSetup()
        }
        cell.darkModeChange()
        return cell
    }
}

class QuantityStackTVC : UITableViewCell {
    private let addOnCellHeight = 30
    var modifiers: [Modifiers]!
    
    @IBOutlet weak var heightOfquantityCell: NSLayoutConstraint!
    @IBOutlet weak var quantityLblStack: UIStackView!
    @IBOutlet weak var quantityLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var productName: SecondarySmallHeaderLabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var addOnTableView: CommonTableView!
    @IBOutlet weak var heightOfaddOnTV: NSLayoutConstraint!
    
    func initSetup() {
        if let modifiers = modifiers {
            self.heightOfaddOnTV.constant = CGFloat(modifiers.count * addOnCellHeight)
        } else {
            self.heightOfaddOnTV.constant = 0
        }
        DispatchQueue.main.async {
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.darkModeChange()
        self.addOnTableView.dataSource = self
        self.addOnTableView.delegate = self
        self.layoutIfNeeded()
    }
    
    func darkModeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.quantityLbl.customColorsUpdate()
        self.productName.customColorsUpdate()
        self.addOnTableView.customColorsUpdate()
        self.addOnTableView.reloadData()
    }
    
}

extension QuantityStackTVC : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView,
//                   heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}

extension QuantityStackTVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let modifiers = modifiers else { return 0 }
        self.initSetup()
        return modifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddOnStackTVC", for: indexPath) as! AddOnStackTVC
        guard let modifiers = modifiers,
              let model = modifiers.value(atSafe: indexPath.row) else { return cell }
        cell.addonNameLbl.text = model.name
        cell.addonQuantityLbl.text = "\(model.count?.description ?? " ")X"
        cell.addOnImage.isHidden = true
        cell.darkModeChange()
        return cell
    }
    
    
}

class AddOnStackTVC : UITableViewCell {
    
    @IBOutlet weak var addOnStack: UIStackView!
    @IBOutlet weak var addonQuantityLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var addonNameLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var addOnImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.darkModeChange()
    }
    
    func darkModeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.addonQuantityLbl.customColorsUpdate()
        self.addonNameLbl.customColorsUpdate()
    }
}
