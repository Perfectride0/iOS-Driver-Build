//
//  ExtraTripFareView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 21/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class ExtraTripFareView: BaseView {
    
    //------------------------------------------
    // MARK: - Screen State Enum
    //------------------------------------------
    
    enum ScreenState {
        case shouldApply
        case onApply
    }
    
    //------------------------------------------
    // MARK: - Outlets
    //------------------------------------------
    
    @IBOutlet weak var amountHolderView: UIView!
    @IBOutlet weak var optionHolderView: UIView!
    @IBOutlet weak var holderView : TopCurvedView!
    @IBOutlet weak var headerTitleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var headerView : SecondaryView!
    @IBOutlet weak var contentView : SecondaryView!
    @IBOutlet weak var amountARTF : ARTextField!
    @IBOutlet weak var optionARTF : ARTextField!
    @IBOutlet weak var otherFeeTitleLbl : InactiveRegularLabel!
    @IBOutlet weak var reasonView : SecondaryView!
    @IBOutlet weak var commentTextView : CommonTextView!
    @IBOutlet weak var footerView : SecondaryView!
    @IBOutlet weak var applyBtn : PrimaryButton!
    @IBOutlet weak var cancelBtn : SecondaryThemeBorderedButton!

    //------------------------------------------
    // MARK: - Local Variables
    //------------------------------------------
    
    var extraTripFareVC : ExtraTripFareVC!
    var dropDown : DropDown<ExtraFareOption>?
    var fareOptions = [ExtraFareOption]()
    var screenState : ScreenState?
    var selectionOption : ExtraFareOption? = nil
    
    //------------------------------------------
    // MARK: - View Controller Life Cycle
    //------------------------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.extraTripFareVC = baseVC as? ExtraTripFareVC
        self.initView()
        self.renderView(to : .shouldApply)
        self.extraTripFareVC.getExtraFeeOptions()
        self.initLanguage()
        self.initGestures()
        self.initLayers()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.dropDown?.setTheme()
        self.holderView.customColorsUpdate()
        self.headerTitleLbl.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.contentView.customColorsUpdate()
        self.amountARTF.setTheme()
        if let _ = self.amountARTF.textField,
           let _ = self.optionARTF.textField {
            self.amountARTF.setColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            self.amountARTF.bar.isHidden = true
            self.amountARTF.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.optionARTF.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.optionARTF.setColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            self.optionARTF.bar.isHidden = true
        }
        self.optionARTF.setTheme()
        self.otherFeeTitleLbl.customColorsUpdate()
        self.reasonView.customColorsUpdate()
        self.commentTextView.customColorsUpdate()
        self.footerView.customColorsUpdate()
        self.cancelBtn.customColorsUpdate()
    }
    
    //------------------------------------------
    // MARK:- initializers
    //------------------------------------------
    
    func initView(){
        ARTextField
            .initilazieTextField(on: &self.amountARTF,
                                 "\(LangCommon.amount) \(Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash) )")
        ARTextField
            .initilazieTextField(on: &self.optionARTF,
                                 LangCommon.selectExtraFee)
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action: #selector(self.doneButtonAction))
        
        toolbarDone.items = [barBtnDone] // You can even add cancel button too
        self.amountARTF.textField.inputAccessoryView = toolbarDone
        self.commentTextView.inputAccessoryView = toolbarDone
        self.amountHolderView.cornerRadius = 10
        self.amountHolderView.border(0.5, UIColor.TertiaryColor.withAlphaComponent(0.5))
        self.optionHolderView.cornerRadius = 10
        self.optionHolderView.border(0.5, UIColor.TertiaryColor.withAlphaComponent(0.5))
        self.reasonView.cornerRadius = 10
        self.reasonView.border(0.5, UIColor.TertiaryColor.withAlphaComponent(0.5))
        self.extraTripFareVC.listen2Keyboard(withView: self.holderView)
        self.amountARTF.textField.keyboardType = .decimalPad
        self.optionARTF.textField.isUserInteractionEnabled = false
        self.dropDown = DropDown(self.extraTripFareVC)
    }
    
    
    @objc
    func doneButtonAction() {
        self.endEditing(true)
    }
    
    func initLanguage(){
        self.applyBtn.setTitle(LangCommon.yes.uppercased(), for: .normal)
        self.cancelBtn.setTitle(LangCommon.no.uppercased(), for: .normal)
        self.amountARTF.arTFDelegate = self
        self.optionARTF.arTFDelegate = self
        self.amountARTF.setTitle(LangCommon.amount.capitalized + " \(UserDefaults.value(for: .user_currency_symbol_org) ?? "$")")
        self.optionARTF.setTitle(LangCommon.selectExtraFee)
        self.headerTitleLbl.text = LangCommon.applyExtraFee.capitalized
        self.otherFeeTitleLbl.text = LangCommon.enterExtraFee
        self.amountARTF.textField.setTextAlignment()
        self.optionARTF.textField.setTextAlignment()
    }
    
    func initGestures() {
        self.optionARTF.addAction(for: .tap) {
            [weak self] in
            self?.showDropDown()
        }
        self.addAction(for: .tap) {
            [weak self] in
            self?.endEditing(true)
        }
        self.holderView.addAction(for: .tap) {
            [weak self] in
            self?.endEditing(true)
        }
    }
    
    func initLayers(){
        
    }
    
    //------------------------------------------
    // MARK: - Button Actions
    //------------------------------------------
    
    @IBAction
    func applyAction(_ sender: UIButton) {
        self.endEditing(true)
        switch self.screenState ?? .shouldApply {
        case .shouldApply:
            self.renderView(to: .onApply)
            self.darkModeChange()
        case .onApply:
            guard self.validateInputs() else{return}
            if let strAmount = self.amountARTF.getText(),
            let amount = Double(strAmount),
                let option = self.selectionOption{
                option.comment = self.commentTextView.text
                option.amount = amount
                self.extraTripFareVC.extraTripFareDelegate?.extraTripFareApplied(option)
            }
            self.backAction()
        }
        self.layoutIfNeeded()
    }
    
    @IBAction
    func cancelAction(_ sender : UIButton) {
        self.endEditing(true)
        switch self.screenState ?? .shouldApply {
        case .shouldApply:
            self.extraTripFareVC.extraTripFareDelegate?.extraTripFareCancelled()
            self.backAction()
        case .onApply:
            self.amountARTF.setValue("")
            self.optionARTF.setValue("")
            self.selectionOption = nil
            self.renderView(to: .shouldApply)
            self.darkModeChange()
        }
        self.dropDown?.dropTable.removeFromSuperview()
        self.layoutIfNeeded()
    }
    
    //------------------------------------------
    // MARK: - Local Function
    //------------------------------------------
    
    func showDropDown() {
        self.endEditing(true)
        let data = self.dropDown?.attach(on: self.optionARTF,
                                         with: self.fareOptions)
        data?.subscribe({ (selected) in
            self.selectionOption = selected
            if let _selected = selected{
                self.optionARTF.setValue(_selected.description)
                self.renderView(to: .onApply)
            }else{
                self.optionARTF.setValue("")
            }
        })
    }
    
    func renderView(to state : ScreenState){
        UIView.animate(withDuration: 0.5, animations: {
            switch state {
            case .shouldApply:
                self.extraTripFareVC.contentViewHeightConstraint.constant = 5
                self.contentView.isHidden = true
                self.applyBtn.setTitle(LangCommon.yes.uppercased(),
                                       for: .normal)
                self.cancelBtn.setTitle(LangCommon.no.uppercased(),
                                        for: .normal)
            case .onApply:
                self.applyBtn.setTitle(LangCommon.apply.uppercased(),
                                       for: .normal)
                self.cancelBtn.setTitle(LangCommon.cancel.uppercased(),
                                        for: .normal)
                let applyingReason = self.selectionOption != nil
                    ? self.selectionOption!.commentable
                    : false
                self.extraTripFareVC.contentViewHeightConstraint.constant = applyingReason ? 260 : 160
                self.extraTripFareVC.reasonViewHeight.constant = applyingReason ? 110 : 0
                self.reasonView.isHidden = !applyingReason
                self.contentView.isHidden = false
                self.layoutIfNeeded()
            }
            self.layoutIfNeeded()
        }) { (completed) in
            if completed{
                self.screenState = state
            }
        }
    }
    
    func backAction(){
        self.endEditing(true)
        self.extraTripFareVC.dismiss(animated: true,
                                     completion: nil)
    }
    
    func validateInputs() -> Bool {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard ScreenState.onApply == self.screenState else{return false}
        guard let strAmount = self.amountARTF.textField.text,
            let amount = Double(strAmount),
            !amount.isZero else{
                self.amountARTF.showError(LangCommon.pleaseEnterExtraFare)
                return false
        }
        guard let option = self.selectionOption  else{
            self.optionARTF.showError(LangCommon.pleaseSelectAnOption)
            return false
        }
        guard option.commentable else{return true}
        guard let comment = self.commentTextView.text,!comment.isEmpty else{
            appDelegate?.createToastMessage(LangCommon.pleaseEnterYourComment)
            return false
        }
        return true
    }
}

extension ExtraTripFareView : ARTFDelegate {
    func onValueSet(_ textField: UITextField, value: String) {
        
    }
}
