//
//  ViewProfileView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import Photos
import AVFoundation

class ViewProfileView: BaseView,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var editImgBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var changeImgBtn: PrimaryTintButton!
    @IBOutlet weak var postalCodeLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var cityTF: CommonTextField!
    @IBOutlet weak var address2TF: CommonTextView!
    @IBOutlet weak var address2Lbl: SecondarySubHeaderLabel!
    @IBOutlet weak var address1TF: CommonTextView!
    @IBOutlet weak var address1Lbl: SecondarySubHeaderLabel!
    @IBOutlet weak var mobileTF: CommonTextField!
    @IBOutlet weak var firstNameLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var serviceDescLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var stateTF: CommonTextField!
    @IBOutlet weak var stateLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var postalCodeTF: CommonTextField!
    @IBOutlet weak var cityLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var countryCode: SecondaryTextFieldTypeLabel!
    @IBOutlet weak var firstNameTF: CommonTextField!
    @IBOutlet weak var serviceDescTV: CommonTextView!
    @IBOutlet weak var lastNameLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var mobileLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var lastNameTF: CommonTextField!
    @IBOutlet weak var emailLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var countryLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var emailTF: CommonTextField!
    @IBOutlet weak var updateBtn: SecondaryButton!
    @IBOutlet weak var changePasswordBtn: PrimaryButton!
    @IBOutlet weak var fieldsView: SecondaryView!
    @IBOutlet weak var address1Val: SecondaryTextFieldTypeLabel!
    @IBOutlet weak var address2Val: SecondaryTextFieldTypeLabel!
    @IBOutlet weak var serviceDescVal: SecondaryTextFieldTypeLabel!
    @IBOutlet weak var scrollObjHolder: UIScrollView!
    @IBOutlet weak var mobileStackView: UIStackView!
    @IBOutlet weak var address1TvOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var address2TVOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var serviceTVOuter: InactiveBorderSecondaryView!
    
    @IBOutlet weak var topContentCurveView: TopCurvedView!
    @IBOutlet weak var bgView: SecondaryView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var contentBgView: SecondaryView!
    @IBOutlet weak var profileBgView: SecondaryView!
    @IBOutlet weak var contentHolderView: SecondaryView!
    @IBOutlet weak var bottomView: TopCurvedView!
    
    @IBOutlet weak var genderStack: UIStackView!
    
    @IBOutlet weak var genderLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var maleLbl: SecondarySubHeaderLabel!
    
    @IBOutlet weak var imgMale: PrimaryImageView!
    
    @IBOutlet weak var femaleLbl: SecondarySubHeaderLabel!
    
    @IBOutlet weak var imgFemale: PrimaryImageView!
    override func darkModeChange() {
        super.darkModeChange()
        self.titleText.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.topContentCurveView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.bgView.customColorsUpdate()
        self.contentBgView.customColorsUpdate()
        self.profileBgView.customColorsUpdate()
        self.postalCodeLbl.customColorsUpdate()
        self.cityTF.customColorsUpdate()
        self.cityTF.font = .lightFont(size: 14)
        self.address2TF.customColorsUpdate()
        self.address2TF.font = .lightFont(size: 14)
        self.address2Lbl.customColorsUpdate()
        self.address1TF.customColorsUpdate()
        self.address1TF.font = .lightFont(size: 14)
        self.address1Lbl.customColorsUpdate()
        self.mobileTF.customColorsUpdate()
        self.mobileTF.font = .lightFont(size: 14)
        self.firstNameLbl.customColorsUpdate()
        self.serviceDescLbl.customColorsUpdate()
        self.stateTF.customColorsUpdate()
        self.stateTF.font = .lightFont(size: 14)
        self.stateLbl.customColorsUpdate()
        self.postalCodeTF.customColorsUpdate()
        self.postalCodeTF.font = .lightFont(size: 14)
        self.cityLbl.customColorsUpdate()
        self.countryCode.customColorsUpdate()
        self.countryCode.font = .lightFont(size: 14)
        self.firstNameTF.customColorsUpdate()
        self.firstNameTF.font = .lightFont(size: 14)
        self.serviceDescTV.customColorsUpdate()
        self.serviceDescTV.font = .lightFont(size: 14)
        self.lastNameLbl.customColorsUpdate()
        self.mobileLbl.customColorsUpdate()
        self.lastNameTF.customColorsUpdate()
        self.lastNameTF.font = .lightFont(size: 14)
        self.emailLbl.customColorsUpdate()
        self.countryLbl.customColorsUpdate()
        self.emailTF.customColorsUpdate()
        self.emailTF.font = .lightFont(size: 14)
        self.fieldsView.customColorsUpdate()
        self.address1Val.customColorsUpdate()
        self.address1Val.font = .lightFont(size: 14)
        self.address2Val.customColorsUpdate()
        self.address2Val.font = .lightFont(size: 14)
        self.serviceDescVal.customColorsUpdate()
        self.serviceDescVal.font = .lightFont(size: 14)
        self.address1TvOuter.customColorsUpdate()
        self.address2TVOuter.customColorsUpdate()
        self.serviceTVOuter.customColorsUpdate()
        
        
        self.firstNameOuter.customColorsUpdate()
        self.lastNameOuter.customColorsUpdate()
        self.mobileOuter.customColorsUpdate()
        self.serviceDescOuter.customColorsUpdate()
        self.stateOuter.customColorsUpdate()
        self.postalCodeOuter.customColorsUpdate()
        self.cityOuter.customColorsUpdate()
        self.address2Outer.customColorsUpdate()
        self.address1Outer.customColorsUpdate()
        self.countryOuter.customColorsUpdate()
        self.emailOuter.customColorsUpdate()
        
        self.genderLbl.customColorsUpdate()
        self.maleLbl.customColorsUpdate()
        self.maleLbl.font = .lightFont(size: 14)
        self.femaleLbl.customColorsUpdate()
        self.femaleLbl.font = .lightFont(size: 14)
        self.imgMale.customColorsUpdate()
        self.imgFemale.customColorsUpdate()
        
        
        if self.editingButtonState == .updateProfile {
            self.updatingView(isEnabled: true, borderColor: .TertiaryColor, Constraint: 10.0)
            self.updateBtn.backgroundColor = UIColor.TertiaryColor
        } else {
            self.updatingView(isEnabled: false, borderColor: .clear, Constraint: 0.0)
            if #available(iOS 12.0, *) {
                let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
                self.updateBtn.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    
    var arrTitle = [String]()
    var arrProfileValues = [String]()
    var arrDummyValues = [String]()
    var imagePicker = UIImagePickerController()
    var countryModel :  CountryModel?
    var strUserName = ""
    var strFirstName = ""
    var strLastName = ""
    var strMobileNumber = ""
    var strEmailId = ""
    var strAddress1 = ""
    var strAddress2 = ""
    var strCity = ""
    var strPostalCode = ""
    var strState = ""
    var strUserImgUrl = ""
    //Gofer split start [Remove in all array]
    var strServiceDesc = ""
    //Gofer split end
    var strGender = ""
    var editingButtonState:EditingState = .editProfile
    
    @IBOutlet weak var titleText: SecondaryHeaderLabel!
    @IBOutlet weak var firstNameOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var lastNameOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var mobileOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var serviceDescOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var stateOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var postalCodeOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var cityOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var address2Outer: InactiveBorderSecondaryView!
    @IBOutlet weak var address1Outer: InactiveBorderSecondaryView!
    @IBOutlet weak var countryOuter: InactiveBorderSecondaryView!
    @IBOutlet weak var emailOuter: InactiveBorderSecondaryView!
    
    @IBOutlet var trailingConstraints: [NSLayoutConstraint]!
    @IBOutlet var leadingConstraints: [NSLayoutConstraint]!
    
    var viewController:ViewProfileVC!
    //MARK:- Life Cycles
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? ViewProfileVC
        self.countryModel = CountryModel(forDialCode: nil,
                                         withCountry: self.viewController.menuPresenter.driverProfile?.country_code ?? "US")
        self.setUserProfileInfo()
        checkSaveButtonStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNewPhoneNo), name: NSNotification.Name.phonenochanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.initLanguage()
        self.titleText.text = LangCommon.myProfile
        setDelegateForTF()
        
        isRTLLanguage ? self.force(Direction: .right) : self.force(Direction: .left)
        
        profileImg.addTap { //
            self.changeImageAction()
        }
        AppUtilities().updateMainQueue {
            self.updatingView(isEnabled: false, borderColor: .clear, Constraint: 0.0)
        }
        self.initView()
        self.darkModeChange()
        hideForStoreOwnDriver()
    }
    
    func hideForStoreOwnDriver(){
        if !Shared.instance.isStoreDriver{
            self.updateBtn.isHidden = false
        }else{
            self.updateBtn.isHidden = true
        }
    }
    
    
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        //MARK: - Auther : Karuppasamy
        //MARK: - Reason : It Changes the text of the Update Btn, When Return from the camera 
        
        //self.initLanguage()
        self.updatingFields()
        
        if self.editingButtonState == .updateProfile {
            self.updatingView(isEnabled: true, borderColor: .TertiaryColor, Constraint: 10.0)
        } else {
            self.updatingView(isEnabled: false, borderColor: .clear, Constraint: 0.0)
        }
        
        
        
    }
    override func didAppear(baseVC: BaseVC) {
        super.didAppear(baseVC: baseVC)
    }
    override func didLayoutSubviews(baseVC: BaseVC){
        super.didLayoutSubviews(baseVC: baseVC)
    }
    
    
    func initView() {
        self.profileImg.cornerRadius = 15
        self.updateBtn.cornerRadius = 15
        self.updateBtn.elevate(2)
    }
    
    /// This Function allows you to change all the field in direction Like RTL or LTR
    /// - Parameter Direction: Warning Don't Choose other than Right or Left
    /// - Usage : example force(Direction: .right) or force(Direction: .left)
    func force(Direction : NSTextAlignment) {
        
        // Title
        self.titleText.textAlignment = Direction

        // First Name
        self.firstNameTF.textAlignment = Direction
        self.firstNameLbl.textAlignment = Direction

        // Last Name
        self.lastNameTF.textAlignment = Direction
        self.lastNameLbl.textAlignment = Direction

        // Mobile
        self.mobileLbl.textAlignment = Direction
        self.mobileTF.textAlignment = Direction

        // Country
        self.countryLbl.textAlignment = Direction

        // Email
        self.emailTF.textAlignment = Direction
        self.emailLbl.textAlignment = Direction

        // Address 1
        self.address1TF.textAlignment = Direction
        self.address1Lbl.textAlignment = Direction
        self.address1Val.textAlignment = Direction

        // Address 2
        self.address2TF.textAlignment = Direction
        self.address2Lbl.textAlignment = Direction
        self.address2Val.textAlignment = Direction

        // City
        self.cityTF.textAlignment = Direction
        self.cityLbl.textAlignment = Direction

        // Postal
        self.postalCodeTF.textAlignment = Direction
        self.postalCodeLbl.textAlignment = Direction

        // State
        self.stateTF.textAlignment = Direction
        self.stateLbl.textAlignment = Direction

        // Service Description
        self.serviceDescLbl.textAlignment = Direction
        self.serviceDescVal.textAlignment = Direction
        self.serviceDescTV.textAlignment = Direction
    }
    //Edit Profile
    
    func updatingView(isEnabled: Bool, borderColor: UIColor, Constraint: CGFloat) {
        self.firstNameTF.isUserInteractionEnabled = isEnabled
        self.lastNameTF.isUserInteractionEnabled = isEnabled
        self.emailTF.isUserInteractionEnabled = isEnabled
        //self.mobileTF.isUserInteractionEnabled = isEnabled
        self.address1TF.isUserInteractionEnabled = isEnabled
        self.address2TF.isUserInteractionEnabled = isEnabled
        self.cityTF.isUserInteractionEnabled = isEnabled
        self.postalCodeTF.isUserInteractionEnabled = isEnabled
        self.stateTF.isUserInteractionEnabled = isEnabled
        self.serviceDescTV.isUserInteractionEnabled = isEnabled
        self.mobileStackView.isUserInteractionEnabled = isEnabled
        self.changeImgBtn.isUserInteractionEnabled = isEnabled
        self.profileImg.isUserInteractionEnabled = isEnabled
        self.changeImgBtn.isHidden = !isEnabled
        if isEnabled{
            goToMobileValidationVC()
        }
        for element in leadingConstraints{
            element.constant = Constraint
        }
        for element in trailingConstraints{
            element.constant = Constraint
        }
        self.firstNameOuter.borderColor = borderColor
        self.lastNameOuter.borderColor = borderColor
        self.emailOuter.borderColor = borderColor
        self.countryOuter.borderColor = borderColor
        self.mobileOuter.borderColor = borderColor
        self.address1Outer.borderColor = borderColor
        self.address2Outer.borderColor = borderColor
        self.cityOuter.borderColor = borderColor
        self.postalCodeOuter.borderColor = borderColor
        self.stateOuter.borderColor = borderColor
        self.serviceDescOuter.borderColor = borderColor
        self.address1TvOuter.borderColor = borderColor
        self.address2TVOuter.borderColor = borderColor
        self.serviceTVOuter.borderColor = borderColor
        
        self.address1Val.isHidden = isEnabled
        self.address1Outer.isHidden = isEnabled
        self.address2Val.isHidden = isEnabled
        self.address2Outer.isHidden = isEnabled
        self.serviceDescVal.isHidden = isEnabled
        self.serviceDescOuter.isHidden = isEnabled
        
        self.address1TF.isHidden = !isEnabled
        self.address2TF.isHidden = !isEnabled
        self.serviceDescTV.isHidden = !isEnabled
        self.address1TvOuter.isHidden = !isEnabled
        self.address2TVOuter.isHidden = !isEnabled
        self.serviceTVOuter.isHidden = !isEnabled
        
        self.layoutIfNeeded()
    }
    //Hide keyboards
    @objc func keyboardWillShow(notification: NSNotification)
    {
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
    }
    // set the profile data from the api
    func setUserProfileInfo() { //img set
        guard let profileModel = self.viewController.menuPresenter.driverProfile else{return}
        profileImg?.sd_setImage(with: NSURL(string: profileModel.user_thumb_image)! as URL,
                                placeholderImage:UIImage(named:"user_dummy"))
        strUserName = ""
        strFirstName = profileModel.first_name
        strLastName = profileModel.last_name
        strMobileNumber = profileModel.mobile_number
        strEmailId = profileModel.email_id
        strAddress1 = profileModel.address_line1
        strAddress2 = profileModel.address_line2
        strServiceDesc = profileModel.serviceDesc
        strCity = profileModel.city
        strPostalCode = profileModel.postal_code
        strState = profileModel.state
        strUserImgUrl = profileModel.user_thumb_image
        strGender = profileModel.gender
        arrProfileValues = [strFirstName, strLastName, strEmailId, strMobileNumber, strAddress1, strAddress2, strCity, strPostalCode, strState,strServiceDesc,strGender]
        arrDummyValues = arrProfileValues
        self.countryModel = CountryModel(forDialCode: nil,
                                         withCountry: profileModel.country_code)
        if strGender == "" {
            self.genderStack.isHidden = true
        } else {
            self.genderStack.isHidden = false
        }
    }
    //MARK:- init Language
    func initLanguage(){
        self.serviceDescLbl.text = LangCommon.serviceDescription.capitalized
        self.countryLbl.text = LangCommon.country.capitalized
        self.mobileLbl.text = LangCommon.mobile.capitalized
        self.updateBtn.setTitle(LangCommon.editProfile, for: .normal)
        self.changePasswordBtn.setTitle(LangCommon.changePassword, for: .normal)
        self.maleLbl.text = LangCommon.male
        self.femaleLbl.text = LangCommon.female
        arrTitle = [LangCommon.firstName.capitalized,
                    LangCommon.lastName.capitalized,
                    LangCommon.email.capitalized,
                    LangCommon.phoneNumber.capitalized,
                    LangCommon.addressOne.capitalized,
                    LangCommon.addressTwo.capitalized,
                    LangCommon.city.capitalized,
                    LangCommon.postalCode.capitalized,
                    LangCommon.state.capitalized,
                    LangCommon.gender.capitalized]
        
    }
    // Update the phone no
    @objc
    func updateNewPhoneNo(notification: Notification) {
        let viewControllers: [UIViewController] = self.viewController.navigationController!.viewControllers as [UIViewController]
        for i in 0 ..< viewControllers.count {
            let obj = viewControllers[i]
            if obj is ViewProfileVC {
                self.viewController.navigationController?.popToViewController(obj, animated: true)
            }
        }
        
        let str2 = notification.userInfo
        let strPhoneNo = str2?["phone_no"] as? String ?? String()
        strMobileNumber = strPhoneNo
        arrProfileValues = [strFirstName,
                            strLastName,
                            strEmailId,
                            strMobileNumber,
                            strAddress1,
                            strAddress2,
                            strCity,
                            strPostalCode,
                            strState,
                            strServiceDesc,strGender]
        self.makeTickButton()
    }
    
    func setDelegateForTF() {
        self.firstNameTF.delegate = self
        self.lastNameTF.delegate = self
        self.emailTF.delegate = self
        self.mobileTF.delegate = self
        self.address1TF.delegate = self
        self.address2TF.delegate = self
        self.cityTF.delegate = self
        self.postalCodeTF.delegate = self
        self.stateTF.delegate = self
        self.serviceDescTV.delegate = self
        
        self.firstNameTF.autocorrectionType = .no
        self.lastNameTF.autocorrectionType = .no
        self.emailTF.autocorrectionType = .no
        self.mobileTF.autocorrectionType = .no
        self.address1TF.autocorrectionType = .no
        self.address2TF.autocorrectionType = .no
        self.cityTF.autocorrectionType = .no
        self.postalCodeTF.autocorrectionType = .no
        self.stateTF.autocorrectionType = .no
        self.serviceDescTV.autocorrectionType = .no
        
        self.firstNameTF.spellCheckingType = .no
        self.lastNameTF.spellCheckingType = .no
        self.emailTF.spellCheckingType = .no
        self.mobileTF.spellCheckingType = .no
        self.address1TF.spellCheckingType = .no
        self.address2TF.spellCheckingType = .no
        self.cityTF.spellCheckingType = .no
        self.postalCodeTF.spellCheckingType = .no
        self.stateTF.spellCheckingType = .no
        self.serviceDescTV.spellCheckingType = .no
        
        
    }
    @IBAction func updateProfileBtnAction(_ sender: Any) {
        self.endEditing(true)
        
        if self.editingButtonState == .editProfile {
            UIView.animate(withDuration: 1,
                           delay: 0,
                           options: [.beginFromCurrentState,.layoutSubviews,.allowAnimatedContent],
                           animations: {
                            self.updatingView(isEnabled: true, borderColor: .TertiaryColor, Constraint: 10.0)
                            self.titleText.text = LangCommon.editProfile
                            self.updateBtn.setTitle(LangCommon.updateInformation, for: .normal)
                            self.editingButtonState = .updateProfile
                            self.updateBtn.setTitleColor(UIColor.PrimaryTextColor, for: .normal)
                            self.updateBtn.borderColor = .TertiaryColor
                            self.updateBtn.backgroundColor = UIColor.TertiaryColor
                            self.changePasswordBtn.isHidden = true
                            self.updateBtn.isUserInteractionEnabled = false
                            self.layoutIfNeeded()
                            
                           }, completion: nil)
            
        }else{
            self.onSaveProfileTapped() // Update Profile API Calling
        }
    }
    
    func changeImageAction(){
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.beginFromCurrentState,.layoutSubviews,.allowAnimatedContent],
                       animations: {
                        self.updatingView(isEnabled: true, borderColor: .TertiaryColor, Constraint: 10.0)
                        self.titleText.text = LangCommon.editProfile
                        self.updateBtn.setTitle(LangCommon.updateInformation, for: .normal)
                        self.editingButtonState = .updateProfile
                        self.updateBtn.setTitleColor(UIColor.PrimaryTextColor, for: .normal)
                        self.updateBtn.backgroundColor = UIColor.TertiaryColor
                        self.updateBtn.borderColor = .TertiaryColor
                        // commented By Karuppasamy
//                        self.changePasswordBtn.isHidden = true
                        self.updateBtn.isUserInteractionEnabled = false
                        self.layoutIfNeeded()
                        
                       }, completion: nil)
        
        
        
        let alert = UIAlertController(title: LangCommon.selectAPhoto.capitalized, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: LangCommon.takePhoto.capitalized, style: .default, handler: { _ in
            AVCaptureDevice.authorizeVideo(completion: { (status) in        //authorization for access camera
                if (status == AVCaptureDevice.AuthorizationStatus.justAuthorized || status == AVCaptureDevice.AuthorizationStatus.alreadyAuthorized){
                    //                    showProgress()
                    AppUtilities().updateMainQueue {
                        self.toOpenCamera()
                    }
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: LangCommon.chooseFromLibrary.capitalized, style: .default, handler: { _ in
            PHPhotoLibrary.authorizePhotoLibrary(completion: { (status) in      //authorization for access gallery
                if (status == PHPhotoLibrary.AuthorizationStatus.justAuthorized || status == PHPhotoLibrary.AuthorizationStatus.alreadyAuthorized){
                    //                    showProgress()
                    AppUtilities().updateMainQueue {
                        self.toOpenGallery()
                    }
                }
            })
        }))
        
        alert.addAction(UIAlertAction.init(title: LangCommon.cancel, style: .cancel, handler: { (action) in
            self.checkSaveButtonStatus()
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    @IBAction func changeImgBtnAction(_ sender: Any) {
        self.changeImageAction()
        
    }
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        self.endEditing(true)
        
        let changePasswordVC = ChangePasswordVC.initWithStory()
        changePasswordVC.modalPresentationStyle = .overCurrentContext
        
        // self.viewController.navigationController?.pushViewController(changePasswordVC, animated: true)
        self.viewController.present(changePasswordVC, animated: true, completion: nil)
        //self.viewController.presentInFullScreen(mobileValidationVC, animated: true, completion: nil)
        //        self.viewController.mobileValidationPurpose = .forgotPassword
        
        
    }
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        if arrProfileValues == arrDummyValues {
            self.viewController.exitScreen(animated: true)
        }else{
            self.viewController.commonAlert.setupAlert(alert: LangCommon.message,
                                                       alertDescription:
                                                        //LangCommon.discardProfile,
                                                       "Your changes are discarded",
                                                       okAction: "Discard",cancelAction: LangCommon.cancel
                                                        //LangCommon.discardProfile
            )
            self.viewController.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                self.viewController.exitScreen(animated: true)
            }
            self.viewController.commonAlert.addAdditionalCancelAction(customAction: {
            })
        }
        
//        self.viewController.navigationController?.popViewController(animated: true)
    }
    // MARK: *** Updating the values for Text fields ***
    
    func updatingFields()
    {
        
        //First name and Last name
        if arrProfileValues.count > 0{
            self.firstNameLbl.text = arrTitle[0]
            self.firstNameTF.text = arrProfileValues[0]
            self.firstNameTF.placeholder = arrTitle[0]
            self.firstNameTF.tag = 0
            self.lastNameLbl.text = arrTitle[1]
            self.lastNameTF.text = arrProfileValues[1]
            self.lastNameTF.tag = 1
            self.lastNameTF.placeholder = arrTitle[1]
            //mobile
            let country = self.countryModel ?? CountryModel()
            self.mobileTF.text = strMobileNumber
            self.countryCode.text = country.dial_code
            let url = URL(string: country.flag)
            self.flagImg.sd_setImage(with: url, completed: nil)
            
            // email
            self.emailLbl.text = arrTitle[2]
            self.emailTF.text = arrProfileValues[2]
            self.emailTF.placeholder = arrTitle[2]
            emailTF.tag = 2
            
            cityTF.tag = 6
            address1TF.tag = 4
            address2TF.tag = 5
            stateTF.tag = 8
            postalCodeTF.tag = 7
            serviceDescTV.tag = 9
            
            
            self.address1Lbl.text = arrTitle[4]
            self.address2Lbl.text = arrTitle[5]
            self.cityLbl.text = arrTitle[6]
            self.cityTF.text = arrProfileValues[6]
            self.cityTF.placeholder = arrTitle[6]
            self.postalCodeLbl.text = arrTitle[7]
            self.postalCodeTF.text = arrProfileValues[7]
            self.postalCodeTF.placeholder = arrTitle[7]
            self.stateLbl.text = arrTitle[8]
            self.stateTF.text = arrProfileValues[8]
            self.stateTF.placeholder = arrTitle[8]
            self.genderLbl.text = arrTitle[9]
//            if arrProfileValues[10] != "" {
            if arrProfileValues.value(atSafe: 10) != nil && arrProfileValues.value(atSafe: 10) != ""{

                self.imgMale.image = strGender == "Male" ? UIImage(named: "radio_on") : UIImage(named: "radio_off")
                self.imgFemale.image = strGender == "Female"  ? UIImage(named: "radio_on") : UIImage(named: "radio_off")
            }
            self.imgMale.tintColor = .PrimaryColor
            self.imgFemale.tintColor = .PrimaryColor
            //Gofer split start
            if arrProfileValues[9] != ""
            {
                self.serviceDescTV.text = arrProfileValues[9]
//                self.serviceDescTV.textColor = .black
                self.serviceDescVal.text = arrProfileValues[9]
//                self.serviceDescVal.textColor = .black
            }
            else{
                self.serviceDescVal.text = LangCommon.serviceDescription
                self.serviceDescVal.textColor = .TertiaryColor
            }
            //Gofer split end
            if arrProfileValues[4] != ""
            {
                self.address1TF.text = arrProfileValues[4]
                self.address1Val.text = arrProfileValues[4]
//                self.address1TF.textColor = .black
//                self.address1Val.textColor = .black
            }
            else{
                self.address1Val.text = LangCommon.addressLineFirst.capitalized
                self.address1Val.textColor = .TertiaryColor
            }
            if arrProfileValues[5] != ""
            {
                self.address2TF.text = arrProfileValues[5]
                self.address2Val.text = arrProfileValues[5]
//                self.address2TF.textColor = .black
//                self.address2Val.textColor = .black
            }
            else{
                self.address2Val.text = LangCommon.addressLineSecond.capitalized
                self.address2Val.textColor = .TertiaryColor
            }
        }
    }
    
    func goToMobileValidationVC()
    {
        //self.mobileStackView.isUserInteractionEnabled = true
        self.mobileStackView.addAction(for: .tap) { //[weak self] in
            let mobileValidationVC = MobileValidationVC.initWithStory(usign: self,
                                                                      for: .changeNumber)
            self.viewController.presentInFullScreen(mobileValidationVC, animated: true, completion: nil)
            self.viewController.mobileValidationPurpose = .changeNumber
        }
        
        
    }
    func setupShareAppViewAnimationWithView(_ view:UIView)
    {
        //           viewMediaHoder.isHidden = false
        view.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.allowUserInteraction, animations:
                        {
                            view.transform = CGAffineTransform.identity
                            view.alpha = 1.0;
                        },  completion: { (finished: Bool) -> Void in
                        })
    }
    // MARK: - ****** Uploading Proifle Picture Operation ******
    func uploadProfileImage(displayPic:UIImage) {
        var paramDict = JSON()
        guard let imageData = displayPic.jpegData(compressionQuality: 0.8) else {return}
        paramDict["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        ConnectionHandler.shared.uploadPost(wsMethod: APIEnums.uploadProfileImage.rawValue,
                                            paramDict: paramDict,
                                            imgsData: [imageData] ,
                                            viewController: self.viewController,
                                            isToShowProgress: true,
                                            isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                if responseDict["image_url"] != nil {
                    self.strUserImgUrl = responseDict.string("image_url")
                    self.makeTickButton()
                }
            }else {
                AppDelegate.shared.createToastMessage(LangCommon.uploadFailed, bgColor: UIColor.black, textColor: UIColor.white)
                self.profileImg?.sd_setImage(with: NSURL(string: self.strUserImgUrl)! as URL,
                                             placeholderImage:UIImage(named:"user_dummy"))
                AppDelegate.shared.createToastMessage(CommonError.server.localizedDescription, bgColor: UIColor.black, textColor: UIColor.white)
            }
        }
        
    }
    func generateBoundaryString() -> String {
        
        return "Boundary-\(NSUUID().uuidString)"
    }
    // MARK: Profile image upload end
    
    // MARK: - TextField Delegate Method
    
    // MARK: - TextField Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
        print("å: textField \(textField.tag)")
        if editingButtonState == .editProfile {
            return false
        } else {
            return true
        }
            

       
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if range.location == 0 && (string == " ") {
            return false
        }
        if (string == "") {
            return true
        }
        //            else if (string == " ") {
        //                return false
        //            }
        else if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        if  textField == firstNameTF || textField == lastNameTF {
            do {
                                          let regex = try NSRegularExpression(pattern: ".*[^A-Za-z].*", options: [])
                                          if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                                              return false
                                          }
                                      }
                                      catch {
                                          print("ERROR")
                                      }
                                  return true
        }
        if textField == emailTF{
            let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@_."
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                  let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
                  return (string == filtered)
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextField = self.viewWithTag(textField.tag + 1) as? UITextField
        if textField.tag == 2 {
            self.address1TF.becomeFirstResponder()
            textField.resignFirstResponder()
            return true
        }
        //Gofer split start
        else if textField.tag == 8 {
            self.serviceDescTV.becomeFirstResponder()
            textField.resignFirstResponder()
            return true
        }
        //Gofer split end
        else {
            nextField?.becomeFirstResponder()
            textField.resignFirstResponder()
            return true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let nextTextFieldView = self.viewWithTag(textView.tag + 1) as? UITextView
        
        if textView.tag == 9 {
            
            if text == "\n" {
                textView.resignFirstResponder()
            }
            
            return textView.text.count + (text.count - range.length) <= 500
        }
        
        if textView.tag == 4   {
            strAddress1 = address1TF.text
            
            if text == "\n" {
                textView.resignFirstResponder()
                nextTextFieldView?.becomeFirstResponder()
            }
            
            
        }else if textView.tag == 5{
            
            strAddress2 = address2TF.text
            if text == "\n" {
                textView.resignFirstResponder()
                cityTF.becomeFirstResponder()
            }
            
        }
        //Gofer split start
        else if textView.tag == 9{
            
            
            strServiceDesc = serviceDescTV.text
            
        }
        //Gofer split end
        arrProfileValues = [strFirstName, strLastName, strEmailId, strMobileNumber, strAddress1, strAddress2, strCity, strPostalCode, strState,strServiceDesc,strGender]
        
        checkSaveButtonStatus()
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 4   {
            strAddress1 = address1TF.text
        }else if textView.tag == 5{
            strAddress2 = address2TF.text
        }
        //Gofer split start
        else if textView.tag == 9{
            strServiceDesc = serviceDescTV.text
        }
        //Gofer split end
        arrProfileValues = [strFirstName, strLastName, strEmailId, strMobileNumber, strAddress1, strAddress2, strCity, strPostalCode, strState,strServiceDesc,strGender]
        
        checkSaveButtonStatus()
    }
    @IBAction private func textFieldDidChange(textField: UITextField)
    {
//        textField.keyboardType = .asciiCapable
        var indexPath = IndexPath(row: (textField.tag == 1) ? 0 : (textField.tag == 3) ? 2 : textField.tag, section: (textField.tag > 3) ? 1 : 0)
        
        if (textField.tag == 0 || textField.tag == 1)
        {
            if textField.tag == 0   // USER NAME
            {
                strFirstName = firstNameTF.text!
            }
            else if textField.tag == 1   // USER NAME
            {
                strLastName = lastNameTF.text!
            }
            arrProfileValues = [strFirstName, strLastName, strEmailId, strMobileNumber, strAddress1, strAddress2, strCity, strPostalCode, strState,strServiceDesc,strGender]
            
            checkSaveButtonStatus()
            return
        }
        else
        {
            if (textField.tag > 3)
            {
                indexPath = IndexPath(row: textField.tag-4, section: 1)
            }
            else
            {
                let row = (textField.tag == 3) ? 2 : (textField.tag == 2) ? 1 : textField.tag
                indexPath = IndexPath(row: row, section: 0)
            }
        }
        
        if textField.tag == 2   // EMAIL ID
        {
            strEmailId = emailTF.text!
        }
        else if textField.tag == 3   // MOBILE NUMBER
        {
            strMobileNumber = mobileTF.text!
        }
        else if textField.tag == 4   // ADDRESS LINE 1
        {
            strAddress1 = address1TF.text!
        }
        else if textField.tag == 5   // ADDRESS LINE 2
        {
            strAddress2 = address2TF.text!
        }
        else if textField.tag == 6   // CITY
        {
            strCity = cityTF.text!
        }
        else if textField.tag == 7   // POSTAL CODE
        {
            strPostalCode = postalCodeTF.text!
        }
        else if textField.tag == 8   // STATE
        {
            strState = stateTF.text!
        }
        else if textField.tag == 9   // Service Description
        {
            strServiceDesc = serviceDescTV.text!
        }
        arrProfileValues = [strFirstName, strLastName, strEmailId, strMobileNumber, strAddress1, strAddress2, strCity, strPostalCode, strState,strServiceDesc,strGender]
        
        checkSaveButtonStatus()
    }
    
    func checkSaveButtonStatus()
    {
        //            else
        if self.editingButtonState == .editProfile{
            updateBtn.isUserInteractionEnabled = true
            updateBtn.setTitleColor(UIColor.ThemeTextColor, for: .normal)
            updateBtn.borderColor = .PrimaryColor
            
        }
        else if self.editingButtonState == .updateProfile {
            if arrProfileValues == arrDummyValues
            {
                
                updateBtn.isUserInteractionEnabled = false
                updateBtn.setTitleColor(.PrimaryTextColor, for: .normal)
                updateBtn.backgroundColor = UIColor.TertiaryColor
                updateBtn.borderColor = .TertiaryColor
            }
            else
            {
                updateBtn.isUserInteractionEnabled = false
                //                updateBtn.setTitle("3", for: .normal)
                //                updateBtn.titleLabel?.text = "3"
                updateBtn.setTitleColor(UIColor.TertiaryColor, for: .normal)
                makeTickButton()
            }
        }
        else
        {
            updateBtn.isUserInteractionEnabled = false
            //                updateBtn.setTitle("3", for: .normal)
            //                updateBtn.titleLabel?.text = "3"
            updateBtn.setTitleColor(UIColor.TertiaryColor, for: .normal)
            makeTickButton()
        }
    }
    func makeTickButton() {
        updateBtn.isUserInteractionEnabled = true
        updateBtn.setTitleColor(UIColor.PrimaryTextColor,
                                for: .normal)
        updateBtn.backgroundColor = UIColor.PrimaryColor
    }
    
    //MARK - API CALL -> SAVE PROFILE INFORMATION
    /*
     UPDATING USER INFORMATION TO SERVER
     */
    func onSaveProfileTapped() {
        var dicts = JSON()
        dicts["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["first_name"] = arrProfileValues[0]
        dicts["last_name"] = arrProfileValues[1]
        dicts["email_id"] = arrProfileValues[2]
        dicts["mobile_number"] = arrProfileValues[3]
        dicts["address_line1"] = arrProfileValues[4]
        dicts["address_line2"] = arrProfileValues[5]
        dicts["city"] = arrProfileValues[6]
        dicts["postal_code"] = arrProfileValues[7]
        dicts["state"] = arrProfileValues[8]
        let country = self.countryModel ?? CountryModel()
        dicts["country_code"] = country.country_code
        dicts["service_description"] = arrProfileValues[9]
        dicts["profile_image"] = strUserImgUrl
        
        if UberSupport.shared.isValidEmail(testStr: dicts["email_id"] as! String){
            UberSupport.shared.showProgressInWindow(showAnimation: true)
            self.viewController.onSaveProfileApiCall(params: dicts)
            self.layoutIfNeeded()
        }else{
            AppUtilities().customCommonAlertView(titleString: LangCommon.alert, messageString: LangCommon.pleaseEnterValidEmail)
        }
        
    }
    
    // UPDATE PROFILE INFO SUCCESS
    func updateProfileModel()
    {
       
        strUserImgUrl = ""
        //            self.onBackTapped(nil)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.beginFromCurrentState,.layoutSubviews,.allowAnimatedContent],
                       animations: {
                        self.updatingView(isEnabled: false, borderColor: .clear, Constraint: 0.0)
                        
                        self.updateBtn.setTitle(LangCommon.editProfile, for: .normal)
                        self.editingButtonState = .editProfile
                        self.titleText.text = LangCommon.myProfile
                        self.updateBtn.setTitleColor(UIColor.ThemeTextColor, for: .normal)
                        if #available(iOS 12.0, *) {
                            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
                            self.updateBtn.backgroundColor = self.isDarkStyle ? .DarkModeBackground : UIColor.SecondaryColor
                        } else {
                            // Fallback on earlier versions
                        }
                        self.changePasswordBtn.isHidden = false
                        self.setUserProfileInfo()
                        self.updatingFields()
                        self.layoutIfNeeded()
                        
                       }, completion: nil)
    }
    //MARK: - UIImagePicker
    func toOpenCamera() {             // To open camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.viewController.present(imagePicker, animated: true, completion: nil)
            }
            
            //               hideProgress()
        }
        else {

            
                //TRVicky
            self.viewController.commonAlert.setupAlert(alert: LangCommon.error.uppercased(),
                                                           alertDescription: LangCommon.deviceHasNoCamera,
                                                           okAction: LangCommon.ok.uppercased())

                self.viewController.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
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
                }
            
            //               hideProgress()
        }
    }
    
    func toOpenGallery() {        // To open gallery
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.modalPresentationStyle = .fullScreen
                self.viewController.present(imagePicker, animated: true, completion: nil)
            }
            
            //               hideProgress()
        }
        else
        {
            //TRVicky
            self.viewController.commonAlert.setupAlert(alert: LangCommon.warning.uppercased(),
                                                           alertDescription: LangCommon.pleaseGivePermission,
                                                           okAction: LangCommon.ok.uppercased())

                
            
        }
    }
    
    //Image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let uploadImage : UIImage? =  info[.editedImage] as? UIImage ?? (info[.originalImage] as? UIImage)
        let _ : Float = Float((uploadImage?.size.width)! / (uploadImage?.size.height)!)
        if let toImage = uploadImage {
            
            profileImg.image = toImage
            self.uploadProfileImage(displayPic:toImage)
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
extension ViewProfileView : MobileNumberValiadationProtocol{
    func verified(number: MobileNumber) {
        
        switch self.viewController.mobileValidationPurpose {
        case .changeNumber:
            self.countryModel = number.flag
            self.strMobileNumber = number.number
            self.arrProfileValues = [self.strFirstName, self.strLastName, self.strEmailId, self.strMobileNumber, self.strAddress1, self.strAddress2, self.strCity, self.strPostalCode, self.strState,self.strServiceDesc]
            self.makeTickButton()
            self.updatingFields()
        case .forgotPassword:
            let otpView = ResetPasswordVC.initWithStory()
            otpView.strMobileNo = number.number
            otpView.countryModel = number.flag
            self.viewController.navigationController?.pushViewController(otpView, animated: true)
        default:
            break
        }
        
    }
    
    
}

extension ViewProfileView : CountryListDelegate{
    func countryCodeChanged(countryCode: String, dialCode: String, flagImg: String) {
        self.countryModel = CountryModel(forDialCode: nil, withCountry: countryCode)
    }
    
    
}


