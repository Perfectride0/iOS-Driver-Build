//
//  WebUnderMaintenanceVC.swift
//  GoferDeliverAll
//
//  Created by trioangle on 06/05/21.
//  Copyright © 2021 Balajibabu. All rights reserved.
//


import UIKit
import Alamofire
import MessageUI

class WebUnderMaintenanceVC: BaseVC,UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var webUnderMaintenanceView : WebUnderMaintenanceView!
    
    var webUnderMaintenanceVM : WebUnderMaintenanceVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- initWithStory
    class func initWithStory() -> WebUnderMaintenanceVC {
        let view : WebUnderMaintenanceVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.webUnderMaintenanceVM = WebUnderMaintenanceVM()
        return view
    }
    
    
    
    func wsToGetStart() {
        var param = JSON()
        if let lang : String = UserDefaults.value(for: .default_language_option){
          param["language"] = lang
        }

        self.webUnderMaintenanceVM.getStart(param: param) { (result) in
            switch result {
            case .success(let json):
                if json.isSuccess {
                    print("alert")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.makeSplashView(isFirstTime: false)
                } else {
                    print("No Luck Try Again Some Times")
                }
            // Fallback on earlier versions
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
}
