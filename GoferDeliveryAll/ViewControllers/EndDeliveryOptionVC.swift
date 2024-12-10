//
//  EndDeliveryOptionVC.swift
//  GoferGroceryDriver
//
//  Created by trioangle on 04/04/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import Alamofire

class EndDeliveryOptionVC: BaseVC  {
  
   
    enum ScrenPurposes{
        case deliverdToWhom
        case rateDelivery
        case contactless
        
    }
    //MARK:- Outlet
    @IBOutlet weak var endDelView:EndDeliveryOptionView!
    

    //MARK:- Variables
    var order : DeliveryOrderDetail!
    var currentScreen : ScrenPurposes = .deliverdToWhom
    var iscontactlessdelivery = false
    
    lazy var appDelegate : AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    //MARK:- initializers
    
    func backAction(){
        if self.isPresented(){
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK:- initWithStory
    class func initWithStory(forOrder order : DeliveryOrderDetail) -> EndDeliveryOptionVC{
        let view : EndDeliveryOptionVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
        view.order = order
        return view
    }
   
    //MARK:- WebServices
    func wsToGetDeliveryOptions(){
        
        ConnectionHandler.shared
                  .getRequest(for: .getDeliveryDropOptions,
                              params: ["order_id": self.order.orderID], showLoader: true)
                  .responseDecode(to: DropOptionHolder.self, { (response) in
                          
             if response.statusCode == "1"
            {
                self.endDelView.options = response.dropoffOptions
                self.endDelView.reasons = response.issues
                self.endDelView.optionTable.reloadData()
                self.view.layoutIfNeeded()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    self?.endDelView.optionTable.reloadData()
                }

            }else{
                                self.appDelegate.createToastMessage(response.statusMessage, bgColor: UIColor.black, textColor: UIColor.white)
            }})
    }
    func wsToSubmitDelivery(){
        
        var paramNew = [String:Any]()
        
        
        if self.iscontactlessdelivery
        {
            guard let liked = self.endDelView.liked  else{return}
            
            let param = [
                "order_id":self.order.orderID,
                "recipient": "",
                "is_thumbs": liked ? 1 : 0,
                "issues" : self.endDelView.selectedIssue?.id.description ?? "",
                "package_delivered_image":self.endDelView.contactlessImg.jpegData(compressionQuality: 0.8)!,
                "token":Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)] as [String : Any]
            
            paramNew = param

        }
        else
        {
            guard let recepient = self.endDelView.selectedOption,
                  let liked = self.endDelView.liked  else{return}
            
            let param = [
                "order_id":self.order.orderID,
                "recipient": recepient.id,
                "is_thumbs": liked ? 1 : 0,
                "issues" : self.endDelView.selectedIssue?.id.description ?? "",
                "token": Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)] as [String : Any]
            
            paramNew = param
        }
        
        
        submitDeliveryPost(paramDict: paramNew)
    }
    
    
    
    func submitDeliveryPost(paramDict: [String:Any])
    {
        var data = Data()
       
        if self.iscontactlessdelivery
        {
            guard let imageData = endDelView.contactlessImg.jpegData(compressionQuality: 0.8) else {return}
            data = imageData
        }
        print("receiptData",data  as Any)
       
        ConnectionHandler.shared.uploadPost(wsMethod: "drop_off_delivery", paramDict: paramDict, fileName: self.iscontactlessdelivery ? "package_delivered_image": "", imgsData: [data], viewController: self, isToShowProgress: true, isToStopInteraction: true) { responseDict in
            if responseDict.isSuccess {

                self.order.setStatus(.deliverdOrderDel)
                self.backAction()

            }else {
                self.appDelegate.createToastMessage(responseDict.status_message)
            }
        }
        
    }
    
    

    
    
    
    
    func presentCameraSettings() {
       
        let settingsActionSheet: UIAlertController = UIAlertController(title:LangDeliveryAll.appName, message: LangDeliveryAll.cameraAccessRequiredForCapturingPhotos, preferredStyle:UIAlertController.Style.alert)
            settingsActionSheet.addAction(
                UIAlertAction(title:LangDeliveryAll.ok.uppercased(), style:UIAlertAction.Style.cancel, handler:{(action) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsUrl)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                })
            )
            present(settingsActionSheet, animated:true, completion:nil)
        }
    
    
    
   
        
    }
    
    




