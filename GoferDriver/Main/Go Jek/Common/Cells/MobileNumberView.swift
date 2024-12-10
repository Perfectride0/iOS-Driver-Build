//
//  MobileNumberView.swift
//  Gofer
//
//  Created by trioangle on 11/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit
class MobileNumberView : UIView{
    
    @IBOutlet weak var countryHolderView : SecondaryView!
    @IBOutlet weak var countryIV : UIImageView!
    @IBOutlet weak var countyCodeLbl : SecondaryTextFieldTypeLabel!
    @IBOutlet weak var numberHolderView : SecondaryView!
    @IBOutlet weak var numberTF : CommonTextField!
    
    var flag : CountryModel?{
        didSet{
            if let _flag = self.flag{
                self.setCountry(_flag)
            }
        }
    }
    
    func ThemeChange() {
        self.countryHolderView.customColorsUpdate()
        self.countyCodeLbl.customColorsUpdate()
        self.numberHolderView.customColorsUpdate()
        self.numberTF.customColorsUpdate()
    }
    
    var number : String?{return numberTF.text}
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func initLayers(){
        self.numberHolderView.cornerRadius = 15
        self.countryHolderView.cornerRadius = 15
        self.numberHolderView.border(1, .TertiaryColor)
        self.countryHolderView.border(1, .TertiaryColor)
        self.numberTF.setTextAlignment()
    }
    func clear(){
        self.numberTF.text = ""
    }
    private func setCountry(_ flag : CountryModel){
        let url = URL(string: flag.flag)
        self.countryIV.sd_setImage(with: url, completed: nil)
        self.countyCodeLbl.text = flag.dial_code
    }
    static func getView(with frame : CGRect) -> MobileNumberView{
        let nib = UINib(nibName: "MobileNumberView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! MobileNumberView
        view.frame = frame
        view.initLayers()
        view.flag = CountryModel()
        return view
    }
}
