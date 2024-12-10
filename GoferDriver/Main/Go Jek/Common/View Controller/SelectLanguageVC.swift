//
//  SelectLanguageVC.swift
//  GoferDriver
//
//  Created by trioangle on 20/04/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit


class SelectLanguageVC: BaseVC {
   
    @IBOutlet var selectLanguageView: SelectLanguageView!
    var tabBar : UITabBar?
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar?.isHidden = true
        self.view.backgroundColor = .clear
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBar?.isHidden = false
    }
    override func viewDidLayoutSubviews() {
        self.selectLanguageView.oldOrgin = self.selectLanguageView.hoverView.frame.origin
        self.selectLanguageView.oldSize = self.selectLanguageView.hoverView.frame.size
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    class func initWithStory() -> SelectLanguageVC{
        return UIStoryboard.gojekCommon.instantiateViewController()
    }
   
    func update(language : Language){
        var dicts = JSON()
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        dicts["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["language"] = language.key
        ConnectionHandler.shared.getRequest(
                for: APIEnums.updateLanguage,
                params: dicts,showLoader: true).responseJSON({ (json) in
            UberSupport.shared.removeProgressInWindow()
            if json.isSuccess{
                language.saveLanguage()
                AppDelegate.shared.makeSplashView(isFirstTime: false)
            }else{
                AppDelegate.shared.createToastMessage(json.status_message)
            }
        }).responseFailure({ (error) in
        UberSupport.shared.removeProgressInWindow()
            //AppDelegate.shared.createToastMessage(error)
        })
      
    }
}

