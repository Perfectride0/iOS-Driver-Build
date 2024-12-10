//
//  MenuVC.swift
//  GoferDriver
//
//  Created by trioangle on 01/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit


class MenuVC: BaseVC {
  @IBOutlet var menuView: MenuView!
    var menuDelegate : MenuResponseProtocol?
    var menuPresenter : MenuPresenter!
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    //MARK:- initWithStory
    class func initWithStory(_ delegate : MenuResponseProtocol)-> MenuVC {
        let view : MenuVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.menuDelegate = delegate
        view.menuPresenter = MenuPresenter()
        return view
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.menuView.setUserData()
        self.menuView.showMenu()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }       
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
   
    
}


