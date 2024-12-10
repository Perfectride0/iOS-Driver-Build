//
//  LikeTVC.swift
//  GoferGroceryDriver
//
//  Created by trioangle on 04/04/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation

import UIKit
class LikeTVC : UITableViewCell{
    
    @IBOutlet weak var refTitlLbl : SecondaryExtraSmallLabel!
    @IBOutlet weak var likeBtn : UIButton!
    @IBOutlet weak var disLikeBtn : UIButton!
    
    var action : Closure<Bool>? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        self.themeChange()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.likeBtn.cornerRadius = 15
            self.likeBtn.border(1, .TertiaryColor)
            self.disLikeBtn.cornerRadius = 15
            self.disLikeBtn.border(1, .TertiaryColor)
        }
        self.likeBtn.setImage(UIImage(named: "thumb_like")?
            .withRenderingMode(.alwaysTemplate),
                              for: .normal)
        self.disLikeBtn.setImage(UIImage(named: "thumb_unlike")?
            .withRenderingMode(.alwaysTemplate),
                              for: .normal)
        
        self.likeBtn.tintColor = .TertiaryColor
        self.disLikeBtn.tintColor = .TertiaryColor
    }
    
    func themeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.likeBtn.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.disLikeBtn.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        refTitlLbl.customColorsUpdate()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    func onAction(_ closue : @escaping Closure<Bool>){
        self.action = closue
    }
    @IBAction
    func likeAction(_ sender : UIButton?){
        self.action?(true)
        self.likeBtn.tintColor = .CompletedStatusColor
        self.disLikeBtn.tintColor = .TertiaryColor
    }
    
    @IBAction
    func disLikeAction(_ sender : UIButton?){
        self.action?(false)
        self.likeBtn.tintColor = .TertiaryColor
        self.disLikeBtn.tintColor = .CancelledStatusColor
        
    }
}
