//
//  FeedbackTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class FeedbackTVC: BaseTableViewCell,NibLoadableView {

    @IBOutlet weak var dateLbl: SecondaryRegularLabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var parentView: SecondaryView!
    @IBOutlet weak var feedbackdescriptionLbl: SecondaryRegularLabel!
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var expandableImageView: CommonColorImageView!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var userNameLbl: SecondaryRegularLabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var thumbsIV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.parentView.cornerRadius = 15
        self.userProfileImageView.cornerRadius = 15
        self.parentView.elevate(2)
        // Initialization code
    }
    
    func ThemeUpdate() {
        if #available(iOS 12.0, *) {
            let isDarkstyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
        self.expandableImageView.customColorsUpdate()
        self.dateLbl.customColorsUpdate()
        self.parentView.customColorsUpdate()
        self.feedbackdescriptionLbl.customColorsUpdate()
        self.userNameLbl.customColorsUpdate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
protocol NibLoadableView: class {
    static var nib: UINib { get }
    static var reuseId: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
            
    }
    
    static var reuseId: String {
        return String(describing: self)
    }
}
