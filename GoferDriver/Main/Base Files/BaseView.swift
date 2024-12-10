//
//  BaseView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 18/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class BaseView: UIView {

    @IBOutlet weak var backBtn : UIButton?
    
    var parentVC: BaseVC!
    
    func didLoad(baseVC : BaseVC){
        self.parentVC = baseVC
        
        self.backBtn?.setImage(UIImage(named: "Back_Btn"), for: .normal)
        self.backBtn?.setTitle(nil, for: .normal)
        self.backBtn?.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        UITextField.appearance().tintColor = .PrimaryColor
        UITextView.appearance().tintColor = .PrimaryColor
        //UITextField.appearance().leftView
        
        self.backBtn?.transform = isRTLLanguage
            ? CGAffineTransform(rotationAngle: .pi)
            : .identity
        
//        self.backBtn?.addTarget(self, action: #selector(self.onBackTapped(sender:)), for: .touchUpInside)
        
//         self.backBtn?.setTitle(self.language.getBackBtnText(), for: .normal)
        
        self.darkModeChange()
    }
    
//   @objc func onBackTapped(sender:UIButton) {
//        self.parentVC.exitScreen(animated: true)
//    }
    func getPlaceholderLbl(for scrollView : UIScrollView) -> UILabel{
        let label = UILabel()
        label.textColor = .ThemeTextColor
        label.frame = scrollView.bounds
        label.textAlignment = .center
        label.numberOfLines = 0
        
        
        label.font = .MediumFont(size: 15)
        return label
    }
    func darkModeChange(){
        UIView.animate(withDuration: 0.3) {
            self.parentVC.setNeedsStatusBarAppearanceUpdate()
        }
//        UIApplication.shared.statusBarView?.backgroundColor = self.isDarkStyle ? .darkBackgroundColor : .SecondaryColor
        self.backBtn?.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backBtn?.titleLabel?.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backBtn?.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backBtn?.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        UITextField.appearance().keyboardAppearance = self.isDarkStyle ? .dark : .light
        UISearchBar.appearance().keyboardAppearance = self.isDarkStyle ? .dark : .light
    }
    func willAppear(baseVC : BaseVC){}
    func didAppear(baseVC : BaseVC){}
    func didLayoutSubviews(baseVC: BaseVC){}
    func willDisappear(baseVC: BaseVC){}
    func didDisappear(baseVC : BaseVC){}
}
