//
//  NewVehicleATVC.swift
//  GoferDriver
//
//  Created by trioangle on 06/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

class NewVehicleATVC : UITableViewCell{
   
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var placeHolderLbl : InactiveRegularLabel!
    @IBOutlet weak var textField : CommonTextField!
    @IBOutlet weak var dropDownIV : SecondaryTintImageView!
    @IBOutlet weak var holderView: UIView!
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.placeHolderLbl.isHidden = textField.text?.count == 0
        self.setTheme()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        //self.placeHolderLbl.isHidden = textField.text?.count == 0
    }
    func setPlaceHolder(text : String){
        self.textField.placeholder = text
        self.placeHolderLbl.text = text
        
    }
    func setTheme() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.placeHolderLbl.customColorsUpdate()
        self.placeHolderLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .black
        self.textField.customColorsUpdate()
        self.dropDownIV.customColorsUpdate()
        self.lineLbl.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
    }
    
    func setValue(_ text : String?){
        self.textField.text = text
        //self.placeHolderLbl.isHidden = textField.text?.count == 0
       
    }
    @IBAction private func textFieldDidChange(textField: UITextField) {
        //self.placeHolderLbl.isHidden = textField.text?.count == 0
     }
}

class NewVehicleBTVC : UITableViewCell{

   @IBOutlet weak var descroptionLbl : SecondaryRegularLabel!
   @IBOutlet weak var checkIV : SecondaryTintImageView!
     
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setTheme()
    }
    
    func setTheme() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.descroptionLbl.customColorsUpdate()
        self.checkIV.customColorsUpdate()
    }
}



class NewVehicleCTVC : UITableViewCell {
    
    @IBOutlet weak var elevatedView : SecondaryView!
    @IBOutlet weak var mainView : SecondaryView!
    @IBOutlet weak var mainTitleLbl : SecondaryRegularBoldLabel!
    @IBOutlet weak var mainSubTitleLbl : SecondaryRegularLabel!
    @IBOutlet weak var mainChecIV : SecondaryTintImageView!
    @IBOutlet weak var secondaryView : SecondaryView!
    @IBOutlet weak var secSubTitleLbl : SecondaryRegularLabel!
    @IBOutlet weak var secCheckIV : SecondaryTintImageView!
    
    var hideSecondary = false
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setTheme()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.initLayer()
        }
    }
    
    func initLayer() {
        self.elevatedView.cornerRadius = 10
        self.elevatedView.elevate(2)
    }
    
    func setTheme() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.elevatedView.customColorsUpdate()
        self.mainView.customColorsUpdate()
        self.mainTitleLbl.customColorsUpdate()
        self.mainSubTitleLbl.customColorsUpdate()
        self.mainChecIV.customColorsUpdate()
        self.secondaryView.customColorsUpdate()
        self.secSubTitleLbl.customColorsUpdate()
        self.secCheckIV.customColorsUpdate()
    }
    
    func populate(withVehicle  vehicle : VehicleType){
        self.mainTitleLbl.text = vehicle.type
        self.mainSubTitleLbl.text = vehicle.location
        self.mainSubTitleLbl.isHidden = vehicle.location == ""
        self.isSelected(vehicle.isSelected)
        self.layoutIfNeeded()
        //        self.mainSubTitleLbl.text = "Enable share ride"
    }
    func isSelected(_ selected : Bool){
        let name = selected ? "checked" : "unchecked"
        self.mainChecIV.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
    }
}

class NewVehicleDTVC : UITableViewCell {
    
    @IBOutlet weak var optionTitleLbl : SecondaryRegularLabel!
    @IBOutlet weak var checkboxIV : SecondaryTintImageView!
    @IBOutlet weak var contentHolderView: SecondaryView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setTheme()
    }
    func setTheme() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentHolderView.customColorsUpdate()
        self.checkboxIV.customColorsUpdate()
        self.optionTitleLbl.customColorsUpdate()
    }
    func populate(with Option: RequestOption) {
        self.optionTitleLbl.text = Option.name
        self.isSelected(Option.isSelected)
    }
    func isSelected(_ selected : Bool){
        let name = selected ? "checked" : "unchecked"
        self.checkboxIV.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
    }
}
