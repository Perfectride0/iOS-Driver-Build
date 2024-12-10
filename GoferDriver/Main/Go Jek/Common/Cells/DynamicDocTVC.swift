//
//  DynamicDocTVC.swift
//  GoferDriver
//
//  Created by trioangle on 01/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

class DynamicDocTVC : UITableViewCell{
    
    @IBOutlet weak var nameLbl : SecondarySmallHeaderLabel!
    @IBOutlet weak var statusLbl : SecondaryRegularLabel!
    @IBOutlet weak var waringBtn : UIButton!
    @IBOutlet weak var dropBtn : PrimaryTintButton!
    @IBOutlet weak var updateBtn : PrimaryButton!
    @IBOutlet weak var viewImageBtn : PrimaryButton!
    
    @IBOutlet weak var topBgView: SecondaryView!
    @IBOutlet weak var bgView: SecondaryView!
    @IBOutlet weak var docActionStack : UIStackView!
    
    func ThemeUpdate() {
        
        self.dropBtn.customColorsUpdated()
        self.topBgView.customColorsUpdate()
        self.nameLbl.customColorsUpdate()
        self.statusLbl.customColorsUpdate()
        self.bgView.customColorsUpdate()
        if #available(iOS 12.0, *) {
            let isDarkstyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.dropBtn.tintColor = self.isDarkStyle ? .white : .darkGray
        }else{
            self.dropBtn.tintColor = .darkGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.waringBtn.setImage(UIImage(named: "ic_error")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.waringBtn.tintColor = .ErrorColor
        self.ThemeUpdate()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    func populate(wihtDoc document : DynamicDocumentModel){
        
        self.nameLbl.text = document.name
        self.statusLbl.textColor = .ThemeTextColor
        self.nameLbl.setTextAlignment()
        self.statusLbl.setTextAlignment()
        self.statusLbl.isHidden = false
        if document.urlString.isEmpty{
            self.statusLbl.text = LangCommon.uploadDoc.capitalized
        }else{
            switch document.status {
                
            case 0://pending
                
                self.statusLbl.text = LangCommon.pendingStatus.capitalized
            case 1: // approved
                
                self.statusLbl.text = LangCommon.approved.capitalized
                self.statusLbl.textColor = UIColor(hex: "41A422")
            case 2: // rejected
                
                
                self.statusLbl.text = LangCommon.rejected.capitalized
            default:
                break
            }
        }
        
        let docIsAvailable = !document.urlString.isEmpty
        self.updateBtn.setTitle( !docIsAvailable  ? LangCommon.uploadDoc.capitalized : LangCommon.update.capitalized, for: .normal)
        self.viewImageBtn.isHidden = !docIsAvailable
        self.waringBtn.isHidden = true//document.status == 1
    }
}
