//
//  ProviderMarkerView.swift
//  GoferHandy
//
//  Created by trioangle on 12/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import SDWebImage

class ProviderMarkerView: UIView {

    @IBOutlet weak var markerIV : UIImageView!
    @IBOutlet weak var providerIV : UIImageView!
    @IBOutlet weak var providerView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setTheme()
    }
    func setTheme()
    {
        self.markerIV.tintColor =  .PrimaryColor
    }
    static func getView(withUserImage image : String,using frame : CGRect) -> ProviderMarkerView{
          let nib = UINib(nibName: "ProviderMarkerView", bundle: nil)
          let view = nib.instantiate(withOwner: nil, options: nil)[0] as! ProviderMarkerView
          view.frame = frame
          view.setImage(image)
          return view
      }
    func setImage(_ strURL : String){
        self.markerIV.isRoundCorner = true
        self.providerIV.sd_setImage(with: URL(string: strURL),
                                    placeholderImage: UIImage(named: "user_dummy"),
                                    options: .highPriority,
                                    completed: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.markerIV.layer.cornerRadius = self.markerIV.bounds.width * 0.5
            self.markerIV.clipsToBounds = true
            self.markerIV.contentMode = .scaleAspectFill
            self.backgroundColor = .clear
            self.markerIV.isRoundCorner = true
            self.providerView.isRoundCorner = true
            
        }
    }
}
