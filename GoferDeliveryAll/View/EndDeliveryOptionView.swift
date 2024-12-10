//
//  EndDeliveryOptionView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 16/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire
import Photos
import UIKit

class EndDeliveryOptionView: BaseView,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //MARK: - OUTLETS
    //Outlets:
    @IBOutlet weak var addAddtionalReasonBtn : SecondaryButton!
    @IBOutlet weak var addAddtionalReasonBtnHolderView : UIView!
    @IBOutlet weak var navView : HeaderView!
//    @IBOutlet weak var backButtn : CustomBackBtn!
    
    @IBOutlet weak var titleLbl: SecondaryHeaderLabel!
    
    @IBOutlet weak var topCurveView: TopCurvedView!
    
    @IBOutlet weak var commentTextView : CommonTextView!
    @IBOutlet weak var commentFooterView : SecondaryView!
    @IBOutlet weak var commentTitleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var commentTitleHolderView : SecondaryView!
    
    @IBOutlet weak var optionTable : CommonTableView!
    
    @IBOutlet weak var nextBtn : PrimaryButton!
    
    @IBOutlet weak var issueHolderView : SecondaryView!
    @IBOutlet weak var issueCollection : CommonCollectionView!
    
    @IBOutlet weak var bottomCurveView: TopCurvedView!
    
//    @IBOutlet var backscrollview: UIScrollView!
//    @IBOutlet var scrollheight: NSLayoutConstraint!
    
//    @IBOutlet weak var secView: SecondaryView!
    
    
    //MARK: - LOCAL VARIABLES
    //Variables:
    var hideTextView : Bool = true
    var endDelVC:EndDeliveryOptionVC!
    var options : [DropoffOption] = []
    var reasons : [OrderDeliveryIssue] = []
    var selectedOption : DropoffOption? = nil
    var contactlesssImgSelected = false
    var contactlessImg = UIImage()
    var liked : Bool? = nil
    var selectedIssue : OrderDeliveryIssue? = nil
    var heightforcontactless = 320
//MARK: - NECESSARY CLASS FUNCTIONS
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        endDelVC = baseVC as? EndDeliveryOptionVC
        loadDataView()
    }
    func loadDataView() {
        self.initView()
        self.initLanguage()
        self.initGestures()
        self.darkModeChange()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.initLayer()
        }
        self.endDelVC.wsToGetDeliveryOptions()
        // Theme Changes
        self.optionTable.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    func initView(){
        self.commentTextView.isHidden = self.hideTextView
        self.optionTable.register(UINib(nibName: "LikeTVC",
                                        bundle: nil),
                                  forCellReuseIdentifier: "LikeTVC")
        self.optionTable.delegate = self
        self.optionTable.dataSource = self
        
        self.commentTextView.delegate = self
        self.optionTable.reloadData()
        
        self.issueCollection.delegate = self
        self.issueCollection.dataSource = self
        self.addAddtionalReasonBtn.isCurvedCorner = true
        self.addAddtionalReasonBtn.elevate(2)
    }
    
    
    override func darkModeChange() {
        super.darkModeChange()
        optionTable.customColorsUpdate()
        topCurveView.customColorsUpdate()
        navView.customColorsUpdate()
        
        titleLbl.customColorsUpdate()
        commentTextView.customColorsUpdate()
        commentFooterView.customColorsUpdate()
        commentTitleLbl.customColorsUpdate()
        
        commentTitleHolderView.customColorsUpdate()
        nextBtn.customColorsUpdate()
        issueHolderView.customColorsUpdate()
        self.addAddtionalReasonBtn.customColorsUpdate()
        issueCollection.customColorsUpdate()
//        secView.customColorsUpdate()
        bottomCurveView.customColorsUpdate()
        optionTable.reloadData()
        issueCollection.reloadData()
        if self.commentTextView.text == LangDeliveryAll.leaveAdditionalDetails.uppercased() {
            self.commentTextView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
    }

    func initLanguage(){
        self.commentTextView.text = LangDeliveryAll.leaveAdditionalDetails.uppercased()
        self.commentTitleLbl.text = LangDeliveryAll.leaveAdditionalDetails.uppercased()
        self.nextBtn.setTitle(LangDeliveryAll.next.capitalized,
                              for: .normal)
        self.addAddtionalReasonBtn.setTitle(LangDeliveryAll.leaveAdditionalDetails, for: .normal)
//        self.backButtn.setTitle(self.language.getBackBtnText(), for: .normal)
    }
    func initLayer(){
        
        self.commentTitleHolderView.border(0.5, .black)
        self.commentTitleHolderView.isRoundCorner = true
        self.commentTitleHolderView.elevate(2.0)
//        self.nextBtn.mainThemeCorner()
        self.nextBtn.isRoundCorner = true
        self.nextBtn.setTitleColor(.PrimaryTextColor, for: .normal)
        self.nextBtn.backgroundColor = .PrimaryColor
        self.nextBtn.secodaryThemeCorner()
        
        nextBtn.elevate(3.0)
        nextBtn.cornerRadius = 10
        
        commentTextView.layer.cornerRadius = 5
        commentTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        commentTextView.layer.borderWidth = 0.5
        commentTextView.clipsToBounds = true
        
        
//        self.nextBtn.elevate(2)
        self.layoutIfNeeded()
    }
    func initGestures(){
        self.commentTitleLbl.addAction(for: .tap) { [weak self] in
            self?.commentTextView.becomeFirstResponder()
        }
    }
    //MARK: - BUTTON ACTIONS
    @IBAction
    func addAddtionalReasonBtnTapped(_ sender : UIButton) {
        self.hideTextView = !self.hideTextView
        self.commentTextView.isHidden = self.hideTextView
        self.addAddtionalReasonBtnHolderView.isHidden = !self.hideTextView
        self.optionTable.reloadData()
    }
    
    @IBAction
    func backAction(_ sender : UIButton?){
        self.endDelVC.backAction()
    }
    @IBAction
    func nextAction(_ sender : UIButton?){
        if self.endDelVC.currentScreen == .deliverdToWhom || self.endDelVC.currentScreen == .contactless{
            self.endDelVC.currentScreen = .rateDelivery
            self.optionTable.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.optionTable.layoutIfNeeded()
                self.optionTable.setContentOffset(.zero, animated: false)
                self.layoutIfNeeded()
            }
            if self.commentTextView.text == LangDeliveryAll.leaveAdditionalDetails.uppercased() {
                self.commentTextView.text = nil
            }
        }else{
            self.endDelVC.wsToSubmitDelivery()
        }
        
    }
    @IBAction func addImageBtn(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: .video) { (enable) in
            if enable {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    DispatchQueue.main.async {
                        let myPickerController = UIImagePickerController()
                        myPickerController.delegate = self
                        myPickerController.sourceType = .camera
                        myPickerController.allowsEditing = false
                        self.endDelVC.presentInFullScreen(myPickerController, animated: true, completion: nil)
                    }
                }
                else {
                    print("This device does not have camera!!")
                }
            }else {
                DispatchQueue.main.async {
                    print("Camera permissin is disable")
                    self.endDelVC.presentCameraSettings()
                }
            }
        }
    }
    
    func openImageOptionsPromt() {
        let alert = UIAlertController(title: LangCommon.selectAPhoto.capitalized,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: LangCommon.takePhoto.capitalized, style: .default, handler: { _ in
            AVCaptureDevice.authorizeVideo(completion: { (status) in        //authorization for access camera
                if (status == AVCaptureDevice.AuthorizationStatus.justAuthorized || status == AVCaptureDevice.AuthorizationStatus.alreadyAuthorized) {
                    AppUtilities().updateMainQueue {
                        self.toOpenCamera()
                    }
                }
            })
        }))
        alert.addAction(
            UIAlertAction(
                title: LangCommon.chooseFromLibrary.capitalized,
                style: .default,
                handler: { _ in
                    PHPhotoLibrary.authorizePhotoLibrary(completion: { (status) in      //authorization for access gallery
                        if (status == PHPhotoLibrary.AuthorizationStatus.justAuthorized || status == PHPhotoLibrary.AuthorizationStatus.alreadyAuthorized){
                            AppUtilities().updateMainQueue {
                                self.toOpenGallery()
                            }
                        }
                    })
                }))
        alert.addAction(
            UIAlertAction
                .init(title: LangCommon.cancel,
                      style: .cancel,
                      handler: { (action) in
                          
                      }))
        self.endDelVC.present(alert,
                              animated: true,
                              completion: nil)
    }
    //MARK: - UIImagePicker
    // To open camera
    func toOpenCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.endDelVC.present(imagePicker,
                                      animated: true,
                                      completion: nil)
            }
        } else {
            self.endDelVC.commonAlert.setupAlert(alert:LangCommon.error.uppercased(),
                                                 alertDescription: LangCommon.deviceHasNoCamera,
                                                 okAction: LangCommon.ok.uppercased())
            self.endDelVC.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
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
        }
    }
    
    // To open gallery
    func toOpenGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.modalPresentationStyle = .fullScreen
                self.endDelVC.present(imagePicker,
                                      animated: true,
                                      completion: nil)
            }
        } else {
            self.endDelVC.commonAlert.setupAlert(alert: LangCommon.warning.uppercased(),
                                                 alertDescription: LangCommon.pleaseGivePermission,
                                                 okAction: LangCommon.ok.uppercased())
        }
    }
    
    

    // MARK:- Camera Handler
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        self.contactlesssImgSelected = false
        self.endDelVC.dismiss(animated: true, completion: nil)
    }
//     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let uploadImage : UIImage? =  info[.editedImage] as? UIImage ?? (info[.originalImage] as? UIImage)

//        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
        if let toImage = uploadImage {
            self.contactlessImg = toImage
            print("my image is \(String(describing: uploadImage))")
            self.contactlesssImgSelected = true
        }
        else {
            print("something went wrong")
            self.contactlesssImgSelected = false
           
        }
        
       

        let ratio = self.contactlessImg.size.width / self.contactlessImg.size.height
      
        let newHeight = self.optionTable.frame.width / ratio
      
        heightforcontactless = Int(newHeight)
        
        self.optionTable.reloadData()
        self.endDelVC.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
       
        optionTable.layer.removeAllAnimations()
        
        print("self.promoDetailTableView.contentSize.height",self.optionTable.contentSize.height)
//               self.backscrollview.contentSize = CGSize(width: self.frame.width, height: self.optionTable.contentSize.height)
//               self.scrollheight.constant = self.backscrollview.contentSize.height
        
        
        UIView.animate(withDuration: 0.5) {
            self.endDelVC.updateViewConstraints()
        }
        }
    
}

//MARK:- UITableViewDataSource
extension EndDeliveryOptionView : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if self.endDelVC.currentScreen == .deliverdToWhom{
            return 60
        } else if self.endDelVC.currentScreen == .contactless {
            return UITableView.automaticDimension //return CGFloat(heightforcontactless)
        } else {
            return UITableView.automaticDimension//return 150
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
     
        
            let label = SecondaryHeaderLabel()
            label.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.frame.width,
                                 height: 50)
        

        var text = "\(LangDeliveryAll.step.uppercased()) "
        
        if self.endDelVC.currentScreen == .deliverdToWhom
        {
            text.append("Step \(1)/2 ")
            text.append(": \(LangDeliveryAll.selectRecipient)")

        }
        else if self.endDelVC.currentScreen == .contactless
        {
            text.append("\(1)/2 ")
            text.append(": \(LangDeliveryAll.takePhoto)".uppercased())
        }
        
        else
        {
            text.append("\(2)/2 ")
            
            //text.append(": RATING".uppercased())//\(LangDeliveryAll.rating)
            text.append(": \(LangDeliveryAll.rating)".uppercased())
            
        }
        
        
        label.text = text
        label.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        label.setSpecificCornersForTop(cornerRadius: 15)
            label.textAlignment = .center
            label.textColor = .black
            return label
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.checkStatus()
        if self.endDelVC.currentScreen == .deliverdToWhom{
            return self.options.count
        }
        
        
        else{
            return 1
        }
            
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.endDelVC.currentScreen == .deliverdToWhom{
            let cell : RecepientTVC = tableView.dequeueReusableCell(for: indexPath)
            guard let data = self.options.value(atSafe: indexPath.row) else {
                return cell
            }
            cell.reasonsStack.isHidden = false
            cell.contactlessview.isHidden = true
            cell.populate(with: data, isSelected: data == self.selectedOption)
            cell.themeChange()
            return cell
        } else if self.endDelVC.currentScreen == .contactless {
            let cell : RecepientTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.contactlessview.isHidden = false
            cell.reasonsStack.isHidden = true
            cell.contactlesstitleLbl.text = LangDeliveryAll.placeOrderNearDoor
            cell.cameraTextLbl.text = contactlesssImgSelected ? LangCommon.tapToChange.capitalized : LangCommon.tapToAdd.capitalized
            cell.contactlessImage.image = contactlesssImgSelected ? self.contactlessImg : UIImage(named: "contactless")
            cell.changeimageview.isHidden = true
            
            DispatchQueue.main.async {
//                cell.contactlessImage.contentMode = .scaleAspectFit
            }
            
            cell.contactlessImage.addAction(for: .tap) {
                self.openImageOptionsPromt()
            }
            
            cell.addimageview.addAction(for: .tap) {
                self.openImageOptionsPromt()
            }
            cell.themeChange()
            return cell
        } else {
            let cell : LikeTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.refTitlLbl.text = LangDeliveryAll.howDidTheDeliveryGo
            cell.onAction { (liked) in
                self.liked = liked
                tableView.reloadData()
            }
            cell.themeChange()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if self.endDelVC.currentScreen == .deliverdToWhom{
            return 150
        }
        
        if self.endDelVC.currentScreen == .contactless{
            return 150
        }
        
        else if let likeValue = liked,!likeValue{
            return 200
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.endDelVC.currentScreen == .deliverdToWhom{
            return self.commentFooterView
        }
        
        if self.endDelVC.currentScreen == .contactless{
            return self.commentFooterView
        }
        
        
        else if let likeValue = liked,!likeValue{
            return self.issueHolderView
        }else{
            return nil
        }
    }
    
    
    
}
//MARK:- UITableViewDelegate
extension EndDeliveryOptionView : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.endDelVC.currentScreen == .deliverdToWhom else{return}
        self.selectedOption = self.options.value(atSafe: indexPath.row)
        self.optionTable.reloadData()
    }
}
//MARK:- CheckStatusProtocol
extension EndDeliveryOptionView : CheckStatusProtocol{
    func checkStatus() {
        if endDelVC.currentScreen == .deliverdToWhom{
            //self.nextBtn.isActive_LT = self.selectedOption != nil
            self.nextBtn.btnOperations(to: self.selectedOption != nil ? .on : .off)
        }
        
        else if endDelVC.currentScreen == .contactless{
            //self.nextBtn.isActive_LT = self.contactlesssImgSelected
            self.nextBtn.btnOperations(to: self.contactlesssImgSelected ? .on : .off)
        }
        
        else{
          //  self.nextBtn.isActive_LT = self.liked != nil
            self.nextBtn.btnOperations(to: self.liked != nil ? .on : .off)
        }
    }
    
    
}
//MARK:- UITextViewDelegate
extension EndDeliveryOptionView : UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        self.endEditing(true)
        if textView.text.isEmpty {
            textView.text = LangDeliveryAll.leaveAdditionalDetails.uppercased()
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == LangDeliveryAll.leaveAdditionalDetails.uppercased() {
            textView.text = nil
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == LangDeliveryAll.leaveAdditionalDetails.uppercased() {
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        } else {
            textView.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        }
    }
}
//MARK:- UICollectionViewDataSource
extension EndDeliveryOptionView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ReasonCVC = collectionView.dequeueReusableCell(for: indexPath)
        guard let data = self.reasons.value(atSafe: indexPath.row) else{return cell}
        cell.populate(with: data,isSelected: data == self.selectedIssue)
        cell.themeChange()
        return cell
    }
    
    
}
//MARK:- UICollectionViewDelegate
extension EndDeliveryOptionView : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIssue = self.reasons.value(atSafe: indexPath.row)
        self.issueCollection.reloadData()
        self.checkStatus()
    }
}
