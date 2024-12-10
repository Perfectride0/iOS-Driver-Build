//
//  splashView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 30/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit

class splashView: BaseView {

    //MARK:
    
    @IBOutlet var imgAppIcon: UIImageView!
    @IBOutlet var button: UIButton!
    
    var viewController = SplashVC()
    
    override func didLoad(baseVC: BaseVC) {
    
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as! SplashVC
      //  self.imgAppIcon.cornerRadius = 30
        self.darkModeChange()
    }
    override func darkModeChange() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        
    }
    
    
}
