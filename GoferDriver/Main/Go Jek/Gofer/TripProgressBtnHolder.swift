//
//  TripProgressBtnHolder.swift
//  Goferjek Driver
//
//  Created by Trioangle on 09/11/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class TripProgressBtnHolder : UIView {
   
    @IBOutlet weak var tripProgressBtn : ProgressButton!
    @IBOutlet weak var barView : UIView!
    @IBOutlet weak var holderStack : UIStackView!
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func darkModeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.tripProgressBtn.backgroundColor = .PrimaryColor
        self.tripProgressBtn.setTitleColor(.PrimaryTextColor, for: .normal)
        self.tripProgressBtn.titleLabel?.font = .MediumFont(size: 15)
    }
    
    func setFrame(_ parentFrame: CGRect) -> CGRect{
        let frame = CGRect(x: 0, y: 0, width: parentFrame.width, height:  parentFrame.height)
        return frame
    }
  
    class func initViewFromXib(width : CGFloat)-> TripProgressBtnHolder{
        let nib = UINib(nibName: "TripProgressBtnHolder", bundle: nil)
        let view = nib.instantiate(withOwner: nil,
                                   options: nil)[0] as! TripProgressBtnHolder
        view.frame.size.width = width
        return view
    }
}
