//
//  CancelRideView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 26/10/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class CancelRideView: BaseView {
    
    //------------------------------
    //  MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var tblCancelList: CommonTableView!
    @IBOutlet weak var btnSave: PrimaryButton!
    @IBOutlet weak var btnCanceReason: UIButton!
    @IBOutlet weak var viewHolder: SecondaryView!
    @IBOutlet weak var txtViewCancel: CommonTextView!
    @IBOutlet weak var lblPlaceHolder: InactiveRegularLabel!
    @IBOutlet weak var arrow: PrimaryImageView!
    @IBOutlet weak var cancelRideTitle: SecondaryHeaderLabel!
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var contentHolderView: SecondaryView!
    @IBOutlet weak var curvedHondentHolderView: TopCurvedView!
    @IBOutlet weak var headerView: HeaderView!
    
    //------------------------------
    //  MARK: Local Variables
    //------------------------------
    
    var viewController : CancelRideVC!
    var cancelReasons = [CancelReason]()
    var arrCancelReason = [String]()
    var strCancelReason = ""
    let dropImage = UIImage(named: "drop_down_filled")?.withRenderingMode(.alwaysTemplate)
    var rotatedArrow: UIImage?
    
    //------------------------------
    // MARK: Life Cycle
    //------------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? CancelRideVC
        self.initView()
        self.initLanguage()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.bottomView.customColorsUpdate()
        self.curvedHondentHolderView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.tblCancelList.customColorsUpdate()
        self.viewHolder.customColorsUpdate()
        self.txtViewCancel.customColorsUpdate()
        self.lblPlaceHolder.customColorsUpdate()
        self.cancelRideTitle.customColorsUpdate()
        self.btnCanceReason.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor , for: .normal)
        self.arrow.tintColor = self.isDarkStyle ? .DarkModeTextColor  :.SecondaryTextColor
        self.tblCancelList.reloadData()
    }
    //------------------------------------
    // MARK: Actions
    // MARK: When User Press Back Button
    //------------------------------------
    
    @IBAction func chooseCancelDropDown(_ sender:UIButton!) {
        self.endEditing(true)
        self.arrow.image = rotatedArrow?.withRenderingMode(.alwaysTemplate)
        self.tblCancelList.isHidden = !self.tblCancelList.isHidden
        self.txtViewCancel.isHidden = !self.txtViewCancel.isHidden
        if tblCancelList.isHidden {
            self.lblPlaceHolder.isHidden = self.txtViewCancel.text.count > 0
            self.arrow.image = UIImage(named: "drop_down_filled")?.withRenderingMode(.alwaysTemplate)
        } else {
            self.lblPlaceHolder.isHidden = true
        }
    }
    //------------------------------------
    // MARK: When User Press Back Button
    //------------------------------------
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.viewController.exitScreen(animated: true)
    }
    
    @IBAction func onCancelTripTapped(_ sender:UIButton!){
        self.endEditing(true)
        btnSave.isUserInteractionEnabled = false
        if viewController.isManualBooking{
            self.viewController.cancelRequestProcess()
        } else {
            self.viewController.cancelJobProcess()
        }
    }
    
    //------------------------------------
    // MARK: - Inital Functions
    //------------------------------------
    
    func initView() {
        self.arrCancelReason =  [LangGofer.riderNoShow.capitalized,
                                 LangGofer.riderRequestedCancel.capitalized,
                                 LangCommon.wrongAddressShown.capitalized,
                                 LangCommon.involvedInAnAccident,
                                 LangGofer.doNotChargeRider]
        self.checkSaveButtonStatus()
        self.btnCanceReason.setTextAlignment()
        self.btnCanceReason.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.btnCanceReason.titleLabel?.font = .BoldFont(size: 15)
        self.txtViewCancel.keyboardType = .asciiCapable
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentHolderView.cornerRadius = 20
            self.contentHolderView.elevate(4)
            self.viewHolder.cornerRadius = 20
            self.viewHolder.elevate(4)
        }
        self.txtViewCancel.setTextAlignment()
        
        //DataSource and Delegation Setting
        self.txtViewCancel.delegate = self
        self.tblCancelList.dataSource = self
        self.tblCancelList.delegate = self
        self.arrow.image = self.dropImage
        self.rotatedArrow = self.dropImage?.rotate(radians: .pi).withRenderingMode(.alwaysTemplate)
        self.tblCancelList.isHidden = true
        self.txtViewCancel.isHidden = false
    }
    
     func initLanguage(){
        self.cancelRideTitle.text = LangHandy.cancelYourJob
        self.btnCanceReason.setTitle(LangCommon.cancelReason, for: .normal)
        self.lblPlaceHolder.text = LangCommon.writeYourComment
        self.btnSave.setTitle(LangHandy.cancelJob.uppercased(), for: .normal)
     }
    //------------------------------------
    // MARK: - Local Functions
    //------------------------------------
    
    func checkSaveButtonStatus() {
        let isActive = btnCanceReason.titleLabel?.text != LangCommon.cancelReason
        self.btnSave.isUserInteractionEnabled = isActive
        self.btnSave.backgroundColor = isActive ? .PrimaryColor : .TertiaryColor
    }
}


//-----------------------------------------------
// MARK: - tblCancelReason DataSource
//-----------------------------------------------

extension CancelRideView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cancelReasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellEarnItems = tblCancelList.dequeueReusableCell(withIdentifier: "CellEarnItems")! as! CellEarnItems
        cell.lblTitle?.text = cancelReasons[indexPath.row].description
        cell.lblTitle.setTextAlignment()
        cell.checkBoxIV.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        cell.checkBoxIV.image = (strCancelReason == cell.lblTitle.text) ? UIImage(named: "checkbox_selected") : UIImage(named: "checkbox_unselected")
        cell.lblTitle.customColorsUpdate()
        cell.setTheme()
        return cell
    }
    
}

//-----------------------------------------------
// MARK: - tblCancelReason Delegate
//-----------------------------------------------

extension CancelRideView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.strCancelReason = self.cancelReasons[indexPath.row].description
        self.viewController.usertype = self.cancelReasons[indexPath.row].cancelled_by.description
        self.viewController.cancelReasonId = self.cancelReasons[indexPath.row].id.description
        self.btnCanceReason.setTitle(self.strCancelReason,for:.normal)
        self.tblCancelList.isHidden = true
        self.txtViewCancel.isHidden = false
        self.lblPlaceHolder.isHidden = self.txtViewCancel.text.count > 0
        let againRotate = self.rotatedArrow?.rotate(radians: .pi).withRenderingMode(.alwaysTemplate)
        self.arrow.image = againRotate
        self.tblCancelList.reloadData()
        self.checkSaveButtonStatus()
    }
}

//-----------------------------------------------
// MARK: - txtCancelReason Delegate
//-----------------------------------------------

extension CancelRideView : UITextViewDelegate {
    //MARK: - TEXTVIEW DELEGATE METHOD
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceHolder.isHidden = (txtViewCancel.text.count > 0) 
        checkSaveButtonStatus()
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
}
