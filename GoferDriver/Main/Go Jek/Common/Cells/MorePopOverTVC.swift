//
//  MorePopOverTVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 31/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class MorePopOverTVC: UITableViewCell {

    @IBOutlet weak var contentBGView: SecondaryView!
    @IBOutlet weak var textLbl: SecondarySubHeaderLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setTheme()
    }
    func setTheme() {
        self.textLbl.customColorsUpdate()
        self.contentBGView.customColorsUpdate()
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
