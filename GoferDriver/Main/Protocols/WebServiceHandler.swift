//
//  WebServiceHandler.swift
//   GoferDriver
//
//  Created by Vignesh Palanivel on 16/10/18.
//  Copyright © 2018 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire

class WebServiceHandler: NSObject {

    static var sharedInstance = WebServiceHandler()
   let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func getWebPostService(wsMethod:String,
                           paramDict: [String:Any],
                           viewController:UIViewController,
                           isToShowProgress:Bool,
                           isToStopInteraction:Bool,
                           complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToShowProgress {
            UberSupport().showProgress(viewCtrl: viewController, showAnimation: true)
        }
        else if isToStopInteraction {
            viewController.view.isUserInteractionEnabled = false
         //   UIApplication.shared.beginIgnoringInteractionEvents()
        }
        AF.request("\(APIUrl)\(wsMethod)", method: .post, parameters: paramDict)
            .validate()
            .responseJSON { response in
                if isToShowProgress {
                    UberSupport().removeProgress(viewCtrl: viewController)
                }
                else {
//                    UIApplication.shared.endIgnoringInteractionEvents()
                    viewController.view.isUserInteractionEnabled = true
                }
                switch response.result {
                case .success(let value):
                    print("Validation Successful")
                    print(value)
                    complete(value as! [String : Any])
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getWebService(wsMethod:String, paramDict: [String:Any], viewController:UIViewController, isToShowProgress:Bool, isToStopInteraction:Bool, complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToShowProgress {
            UberSupport().showProgress(viewCtrl: viewController, showAnimation: true)
        }
        else if isToStopInteraction {
            viewController.view.isUserInteractionEnabled = false
//            UIApplication.shared.beginIgnoringInteractionEvents()
        }
//        Alamofire.request
        AF.request("\(APIUrl)\(wsMethod)", method: .get, parameters: paramDict)
            .validate()
                .responseJSON { response in
                    
                    
                    print(response.request?.url ?? "NO URL")
                    if isToShowProgress {
                        UberSupport().removeProgress(viewCtrl: viewController)
                    }
                    else {
//                        UIApplication.shared.endIgnoringInteractionEvents()
                        viewController.view.isUserInteractionEnabled = true
                    }
                    switch response.result {
                    case .success(let value):
                        print("Validation Successful")
                        print(response.request?.url! as Any)
                        print(value)
                        complete(value as! [String : Any])
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    func postWebService(wsMethod:String, paramDict: [String:Any], viewController:UIViewController, isToShowProgress:Bool, isToStopInteraction:Bool, complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToShowProgress {
            UberSupport().showProgress(viewCtrl: viewController, showAnimation: true)
        }
        else if isToStopInteraction {
            viewController.view.isUserInteractionEnabled = false
//            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        //        Alamofire.request
        AF.request("\(APIUrl)\(wsMethod)", method: .post, parameters: paramDict)
            .validate()
            .responseJSON { response in
                
                print(response.request?.url ?? "No URL")
                if isToShowProgress {
                    UberSupport().removeProgress(viewCtrl: viewController)
                }
                else {
//                    UIApplication.shared.endIgnoringInteractionEvents()
                    viewController.view.isUserInteractionEnabled = true
                }
                switch response.result {
                case .success(let value):
                    print("Validation Successful")
                    print(response.request?.url! as Any)
                    print(value)
                    complete(value as! [String : Any])
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getThridPartyWebService(wsMethod:String, paramDict: [String:Any], viewController:UIViewController, isToShowProgress:Bool, isToStopInteraction:Bool, complete:@escaping (_ response: [String:Any]) -> Void) {
        
        if isToShowProgress {
            UberSupport().showProgressInWindow(showAnimation: true)
        }
        if isToStopInteraction {
            viewController.view.isUserInteractionEnabled = false
           // UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
        AF.request("\(wsMethod)", method: .get, parameters: paramDict)
            .validate()
            .responseJSON { response in
                if isToShowProgress {
                     UberSupport().removeProgressInWindow()
                }
                if isToStopInteraction {
                    viewController.view.isUserInteractionEnabled = true
                    //UIApplication.shared.endIgnoringInteractionEvents()
                }
              //  print(response.request?.url!)
                switch response.result {
                case .success(let value):
                    print("Validation Successful")
                    print(value)
                    complete(value as! [String : Any])
                case .failure(let error):
                    print(error)
                    if error._code == 4 {
//                        self.appDelegate.createToastMessageForAlamofire("We are having trouble fetching the menu. Please try again.", bgColor: .black, textColor: .white, forView: viewController.view)
                        
                    }
                    else {
//                        self.appDelegate.createToastMessageForAlamofire(error.localizedDescription, bgColor: .black, textColor: .white, forView: viewController.view)
                    }
                }
        }
    }
}
