//
//  OrderStatusVcView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 23/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class OrderStatusVcView: BaseView  {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var outerView: TopCurvedView!
    @IBOutlet weak var likeBtnView: SecondaryView!
    @IBOutlet weak var dislikeView: SecondaryView!
    @IBOutlet weak var doneBtn: PrimaryButton!
    @IBOutlet weak var picker: UIPickerView!
 
    @IBOutlet weak var howDidThePickupGoTitleLbl: SecondarySmallHeaderLabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var disLikeBtn: UIButton!
    @IBOutlet weak var navview: SecondaryView!
    @IBOutlet weak var bottomView: TopCurvedView!
    
    
//    @IBOutlet weak var bckBtn: CustomBackBtn!
    
    
    
    //@IBOutlet var topview: UIView!
    
    //MARK: - LOCAL VARIABLES
    var liked = ""
    var resondID = ""
    var selectedReason = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var orderVC:OrderStatusVC!
    
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.darkModeChange()
        self.orderVC = baseVC as? OrderStatusVC
        self.initialize()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.navview.customColorsUpdate()
        self.doneBtn.customColorsUpdate()
        self.checkDoneBtnStatus()
        self.howDidThePickupGoTitleLbl.customColorsUpdate()
        self.outerView.customColorsUpdate()
        self.likeBtnView.customColorsUpdate()
        self.dislikeView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
    }
    
    
    
    
    func initialize() {
        
        disLikeBtn.setImage(UIImage(named: "thumb_unlike")?.withRenderingMode(.alwaysTemplate),
                            for: .normal)
        likeBtn.setImage(UIImage(named: "thumb_like")?.withRenderingMode(.alwaysTemplate),
                         for: .normal)
       // self.backgroundColor = .ThemeMain
        likeBtn.tintColor = .TertiaryColor
        disLikeBtn.tintColor = .TertiaryColor
        picker.delegate = self
        picker.dataSource = self
        howDidThePickupGoTitleLbl.text = LangDeliveryAll.howDidThePickupGo.capitalized
        
        /*likeBtnView.layer.cornerRadius = likeBtnView.frame.size.width/2
        likeBtnView.clipsToBounds = true
        likeBtnView.layer.borderColor = UIColor.gray.cgColor
        likeBtnView.layer.borderWidth = 1.0
        
        dislikeView.layer.cornerRadius = dislikeView.frame.size.width/2
        dislikeView.clipsToBounds = true
        dislikeView.layer.borderColor = UIColor.gray.cgColor
        dislikeView.layer.borderWidth = 1.0
         
        navview.backgroundColor = .ThemeMain*/
        
        likeBtnView.cornerRadius = 25.0
        likeBtnView.elevate(2.5)
        
        dislikeView.cornerRadius = 25.0
        dislikeView.elevate(2.5)
        
        doneBtn.elevate(3.0)
        doneBtn.cornerRadius = 10
        
        self.doneBtn.setTitle(LangCommon.done.capitalized,
                         for: .normal)
//        if orderVC.orderId == "" {
        self.checkDoneBtnStatus()
    }
    
    func checkDoneBtnStatus() {
        if self.liked == "" {
            doneBtn.backgroundColor = .TertiaryColor
            doneBtn.isUserInteractionEnabled = false
        } else {
            doneBtn.backgroundColor = .PrimaryColor
            doneBtn.isUserInteractionEnabled = true
        }
    }
    //MARK: - BUTTON ACTIONS
    
    @IBAction func orderAccepted(_ sender: Any) {
      liked = "1"
        disLikeBtn.tintColor = .TertiaryColor
        likeBtn.tintColor = .CompletedStatusColor
        picker.isHidden = true
        doneBtn.backgroundColor = .PrimaryColor
        doneBtn.isUserInteractionEnabled = true
    }
    
    
    @IBAction func disLikeAction(_ sender: Any) {
        liked = "0"
        disLikeBtn.tintColor = .CancelledStatusColor
        likeBtn.tintColor = .TertiaryColor
        orderVC.listReasonForDislike()
        doneBtn.backgroundColor = .PrimaryColor
        doneBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        if liked == "" {
            doneBtn.isHidden = false
            appDelegate.createToastMessage("Select status to update")
        } else {
            orderVC.wsToConfirmItemPickup()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {

        _ = orderVC.navigationController?.popViewController(animated: true)
      
    }
    
}

//MARK: - DELEGATE AND DATASOURCE
extension OrderStatusVcView : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if orderVC.reasonList.count > 0 {
            return orderVC.reasonList.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if orderVC.reasonList.count > 0 {
            selectedReason = orderVC.reasonList[row].issue!
            resondID = orderVC.reasonList[row].id!.description
        } else {
        }
        self.orderVC.view.endEditing(true)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if orderVC.reasonList.count > 0 {
            return orderVC.reasonList[row].issue!
        } else {
             return nil
        }
       
    }
    
}
//MARK: - EXTENSIONS
extension OrderStatusVcView {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.orderVC.view.frame.size.width/2 - 75, y: self.orderVC.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.orderVC.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }



