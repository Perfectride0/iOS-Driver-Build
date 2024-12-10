//
//  RateYourRideView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 21/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class RateYourRideView: BaseView {
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var btnSubmit: PrimaryButton!
    @IBOutlet weak var lblPlaceHolder: InactiveRegularLabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtComments: CommonTextView!
    @IBOutlet weak var lblPageTitle: SecondaryHeaderLabel!
    @IBOutlet weak var contentHolderView: SecondaryView!
    @IBOutlet weak var userNameLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var topCurvedView: TopCurvedView!
    @IBOutlet weak var skipBtn: SecondaryButton!
    @IBOutlet weak var bottomView: TopCurvedView!
    
    override func darkModeChange() {
        super.darkModeChange()
        self.contentHolderView.customColorsUpdate()
        self.lblPlaceHolder.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.txtComments.customColorsUpdate()
        if self.txtComments.text == LangCommon.writeYourComment.capitalized {
            self.txtComments.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
        self.userNameLbl.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.topCurvedView.customColorsUpdate()
        self.lblPageTitle.customColorsUpdate()
        self.skipBtn.customColorsUpdate()
    }
    
    var viewController: RateYourRideVC!
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        viewController = baseVC as? RateYourRideVC
        self.initView()
        self.initLanguage()
        self.initObserver()
        self.initNotification()
        self.darkModeChange()
    }
    func initNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    // MARK:Actions
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!) {
        Shared.instance.resumeTripHitCount = 1
        self.endEditing(true)
        
        if self.viewController.navigationController?.viewControllers.contains(where: {$0 is HandyHomeMapVC}) ?? true{
            appDelegate.onSetRootViewController(viewCtrl: self.viewController)
        }
        else {
            self.viewController.navigationController?.popViewController(animated: true)
        }
    }
    // MARK: When User Press Submit Button
    @IBAction func onSubmitTapped(_ sender:UIButton!) {
        self.endEditing(true)
        if Int(self.floatRatingView.rating) == 0 {
            let settingsActionSheet: UIAlertController = UIAlertController(title:LangCommon.message, message: LangCommon.pleaseGiveRating, preferredStyle:UIAlertController.Style.alert)
            settingsActionSheet.addAction(UIAlertAction(title:LangCommon.ok.capitalized, style:UIAlertAction.Style.cancel, handler:{ action in
            }))
            self.viewController.present(settingsActionSheet, animated:true, completion:nil)
            
            return
        }
        if txtComments.text == LangCommon.writeYourComment.capitalized {
            txtComments.text = nil
        }
        self.viewController.updateRatingToApi(floatRating: Int(self.floatRatingView.rating), comments: txtComments.text ?? String())
    }
    
    
    func initView() {
        // Comment textView Customisation
        self.txtComments.keyboardType = .asciiCapable
        self.txtComments.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        self.txtComments.layer.borderWidth = 2.0
        self.txtComments.layer.cornerRadius = 8
        self.btnSubmit.layer.cornerRadius = 18
        self.txtComments.delegate = self
        self.txtComments.text = LangCommon.writeYourComment.capitalized
        self.txtComments.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action: #selector(self.doneButtonAction))
        
        toolbarDone.items = [barBtnDone] // You can even add cancel button too
        self.txtComments.inputAccessoryView = toolbarDone
        // Floating Rating View Customisation
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 0
        self.floatRatingView.rating = 0.0
        self.floatRatingView.editable = true
        
        // Temp Place Holder For Comments Text View
        var lblFrame = lblPlaceHolder.frame
        lblFrame.origin.y = txtComments.frame.origin.y+8
        lblFrame.origin.x = txtComments.frame.origin.x+5
        lblPlaceHolder.frame = lblFrame
        self.lblPlaceHolder.isHidden = true
        // Commented by rathna for Design issue based on Android UI
        imgUser.isCurvedCorner = true//imgUser.frame.size.width / 2
        imgUser.clipsToBounds = true
        
        self.txtComments.setTextAlignment()
        
        /** Note: With the exception of contentMode, all of these
         properties can be set directly in Interface builder **/
      
    }
    func initObserver() {
        
       
    }
    //MARK:- initializers
    func initLanguage(){
        self.lblPageTitle.text = LangHandy.rateYourRide.capitalized
        self.btnSubmit.setTitle(LangCommon.submit.uppercased(), for: .normal)
        self.lblPlaceHolder.text = LangCommon.writeYourComment.capitalized
        self.skipBtn.setTitle(LangCommon.skip.capitalized, for: .normal)
    }
    
    @IBAction func skipBtnClicked(_ sender: Any) {
        Shared.instance.resumeTripHitCount = 1
        self.viewController.gotoHome()
    }
    
    
    
    //Dissmiss keyboard
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let height = notification.getKeyboardHeight(){
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.transform = CGAffineTransform(translationX: 0, y: -(height - (UIDevice.current.hasNotch ? 39 : 0)))
            } completion: { isComplted in }
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.transform = .identity
        } completion: { isComplted in }
    }
    
    @objc
    func doneButtonAction() {
        self.txtComments.resignFirstResponder()
    }
    
    func setDisplayData(_ data : JobDetailModel){
        let str = data.getCurrentTrip()?.image ?? ""
        let url = URL(string: str)
        imgUser.sd_setImage(with: url,
                            placeholderImage:UIImage(named:"user_dummy"))
        self.userNameLbl.text = data.getCurrentTrip()?.name ?? ""
    }
}
extension RateYourRideView: FloatRatingViewDelegate {
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        self.endEditing(true)
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        let strRating = NSString(format: "%.2f", self.floatRatingView.rating) as String
        floatRatingView.rating = Float(strRating)!
    }
}

extension RateYourRideView : UITextViewDelegate {
    //MARK: - TEXTVIEW DELEGATE METHOD
    func textViewDidChange(_ textView: UITextView) {
//        lblPlaceHolder.isHidden = (txtComments.text.count > 0) ? true : false
        if textView.text == LangCommon.writeYourComment.capitalized {
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        } else {
            textView.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 0 && (text == " ") {
            return false
        }
        if (text == "") {
            return true
        }
        else if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == LangCommon.writeYourComment.capitalized {
            textView.text = nil
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LangCommon.writeYourComment.capitalized
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
    }
    
    
}
