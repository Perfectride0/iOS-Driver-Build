//
//  DocumentDetailView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 08/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire

class DocumentDetailView: BaseView,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //MARK: - Outlets
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var takeAphotoOfYourLbl: SecondaryRegularLabel!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var desBgView: SecondaryView!
    @IBOutlet weak var contentBgView: SecondaryView!
    @IBOutlet weak var optionsBGView : TopCurvedView!
    @IBOutlet weak var pleseMakeSureMsg: SecondarySmallLabel!
    @IBOutlet weak var exipiryView : SecondaryView!
    @IBOutlet weak var exipiryTitleLbl : SecondarySmallHeaderLabel!
    @IBOutlet weak var exipiryTextField : UITextField!
    @IBOutlet weak var btnChange: PrimaryButton!
    @IBOutlet weak var lblSelectPhoto: SecondaryHeaderLabel!
    @IBOutlet weak var btnTakePhoto: PrimaryButton!
    @IBOutlet weak var contentBGViews: TopCurvedView!
    @IBOutlet weak var btnLibrary: PrimaryButton!
    @IBOutlet weak var lblChange: PrimaryButtonTypeLabel!
    @IBOutlet weak var imgCertificate: PrimaryImageView!
    @IBOutlet weak var lblDescription: SecondarySmallHeaderLabel!
    @IBOutlet weak var viewChange: SecondaryView!
    @IBOutlet weak var viewMediaHoder: UIView!
    @IBOutlet weak var btnCancel: SecondaryButton!
    @IBOutlet weak var submitBtn : PrimaryButton!
    @IBOutlet weak var pageTitleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var downArrowIV: UIImageView!
    
    var imageToUpload : UIImage?
    var expiryDate : Date?
    var arrTitle = [String]()
    var imagePicker = UIImagePickerController()
    var viewController: DocumentDetailVC!
    
    
    override func darkModeChange() {
        super.darkModeChange()
        self.btnCancel.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.downArrowIV.tintColor = isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.contentBGViews.customColorsUpdate()
        self.optionsBGView.customColorsUpdate()
        self.contentBgView.customColorsUpdate()
        self.desBgView.customColorsUpdate()
        self.takeAphotoOfYourLbl.customColorsUpdate()
        self.takeAphotoOfYourLbl.font = UIFont(name: G_RegularFont, size: 18)
        self.pleseMakeSureMsg.customColorsUpdate()
        self.pleseMakeSureMsg.font = UIFont(name: G_RegularFont, size: 16)
        self.exipiryView.customColorsUpdated()
        self.exipiryTitleLbl.customColorsUpdate()
        self.lblSelectPhoto.customColorsUpdate()
        self.lblDescription.customColorsUpdate()
        self.lblDescription.font = UIFont(name: G_BoldFont, size: 18)
        self.viewChange.customColorsUpdate()
        self.pageTitleLbl.customColorsUpdate()
        self.bottomView.customColorsUpdate()
    }
    
    
    //MARK: - Life Cycles
    
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? DocumentDetailVC
        self.viewMediaHoder.frame = self.frame
        self.addSubview(self.viewMediaHoder)
        self.bringSubviewToFront(self.viewMediaHoder)
        if isRTLLanguage{
            //                 self.backBtn?.setTitle("I", for: .normal)
            self.lblChange.textAlignment = NSTextAlignment.right
            self.lblSelectPhoto.textAlignment = NSTextAlignment.right
            self.exipiryTextField.textAlignment = .right
            self.exipiryTextField.tintColor = UIColor.clear
        }else{
            //                 self.backBtn?.setTitle("e", for: .normal)
            self.exipiryTextField.textAlignment = .left
            self.exipiryTextField.tintColor = UIColor.clear
        }
        
        self.takeAphotoOfYourLbl.text = LangCommon.takeYourPhoto
        self.pleseMakeSureMsg.text = LangCommon.readAllDetails
        self.lblDescription.text = self.viewController.documet.name.capitalized
        self.pageTitleLbl.text = self.viewController.documet.name.capitalized
        self.exipiryView.isHidden = !self.viewController.documet.expiryRequired
        viewMediaHoder.isHidden = true
        var image =  UIImage()
        switch self.viewController.purpose {
        case .forDriver(id: _):
            image = UIImage(named: "driveid")!
        case .forVehicle(id: _):
            image = UIImage(named: "insurance")!
        default:
            break
        }
        imgCertificate.image = image
        viewChange.isHidden = true
        
        viewChange.isHidden = false
        
        if let url = URL(string: self.viewController.documet.urlString){
            imgCertificate.sd_setImage(with: url, placeholderImage:image)
        }
        
        
        btnCancel.setTitle(LangCommon.cancel.uppercased(), for: .normal)
        
        self.initLanguage()
        self.setupTF()
        self.checkStatus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.initLayer()
            self.checkStatus()
        }
        self.darkModeChange()
        self.isForStoreDriver()
    }
    
    func isForStoreDriver(){
        if Shared.instance.isStoreDriver{
            self.btnChange.isUserInteractionEnabled = false
            self.exipiryTextField.isUserInteractionEnabled = false
        }else{
            self.exipiryTextField.isUserInteractionEnabled = true
            self.btnChange.isUserInteractionEnabled = true
           
        }
            
    }
    
    
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        self.viewController.viewDidLayoutSubviews()
        self.viewController.navigationController?.isNavigationBarHidden = true
    }
    override func didAppear(baseVC: BaseVC) {
        super.didAppear(baseVC: baseVC)
        
    }
    
    //MARK: - Initializers
    func setupTF(){
        // Create a UIDatePicker object and assign to inputView
        self.exipiryTextField.placeholder = "YYYY-MM-DD"
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        
        datePicker.datePickerMode = .date //2
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier: "en")
        if #available(iOS 13.4, *) {
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            } // Replace .inline with .compact
        }
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.dateFormat = "YYYY-MM-dd"
        if !self.viewController.documet.exipryDate.isEmpty,
           let date = apiDateFormatter.date(from: self.viewController.documet.exipryDate){
            datePicker.date = date
            //            apiDateFormatter.dateFormat = "dd-MMM-YYYY"
            self.exipiryTextField.text = apiDateFormatter.string(from: date)
        }
        
        self.exipiryTextField.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: LangCommon.cancel.capitalized, style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: LangCommon.done.capitalized, style: .plain, target: target, action: #selector(didPickDate)) //7
        toolBar.tintColor = .PrimaryColor
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.exipiryTextField.inputAccessoryView = toolBar //9
    }
    
    
    //MARK: - Init Language
    func initLanguage(){
        self.submitBtn.setTitle(LangCommon.submit.capitalized, for: .normal)
        lblSelectPhoto.text = LangCommon.selectAPhoto
        btnTakePhoto.setTitle(LangCommon.takePhoto, for: .normal)
        btnLibrary.setTitle(LangCommon.chooseFromLibrary, for: .normal)
        self.lblChange.text = ((self.imageToUpload == nil && self.viewController.documet.urlString.isEmpty) ? LangCommon.tapToAdd.capitalized : LangCommon.tapToChange).capitalized
        arrTitle = [LangCommon.licenseBack,LangCommon.licenseFront,LangCommon.licenseInsurance,LangCommon.licenseRC,LangCommon.licensePermit]
        self.exipiryTitleLbl.text = LangCommon.expiryDate.capitalized
    }
    func initLayer(){
        self.btnCancel.border(0.5,UIColor.TertiaryColor.withAlphaComponent(0.5))
        self.btnCancel.cornerRadius = 10
    }
    
    func setupShareAppViewAnimationWithView(_ view:UIView)
    {
        viewMediaHoder.isHidden = false
        view.transform = CGAffineTransform(translationX: 0, y: self.frame.size.height)
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.allowUserInteraction, animations:
                        {
                            view.transform = CGAffineTransform.identity
                            view.alpha = 1.0;
                        },  completion: { (finished: Bool) -> Void in
                        })
    }
    // MARK: When User Press Back Button
    
    @objc func tapCancel() {
        self.resignFirstResponder()
        self.checkStatus()
    }
    @objc func didPickDate(){
        if let datePicker = self.exipiryTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "YYYY-MM-dd"
            //            dateformatter.dateStyle = .medium // 2-3
            self.exipiryTextField.text = dateformatter.string(from: datePicker.date) //2-4
            self.expiryDate = datePicker.date
        }
        
        self.exipiryTextField.resignFirstResponder() // 2-5
        self.checkStatus()
    }
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.viewController.viewDidLayoutSubviews()
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddPhotoTapped(_ sender:UIButton!)
    {
        self.endEditing(true)
        setupShareAppViewAnimationWithView(viewMediaHoder)
    }
    @IBAction func submitAction(_ sender : UIButton?){
        guard self.canEditDetails() else{return}
        self.photoSave(self.imageToUpload, expiryDate: expiryDate)
    }
    
    
    // MARK: Navigating to Email field View
    /*
     */
    //  action sheect delegate methods
    @IBAction func onAlertTapped(_ sender:UIButton!)
    {
        if sender.tag == 11
        {
            takePhoto()
        }
        else if sender.tag == 22
        {
            choosePhoto()
        }
        viewMediaHoder.isHidden = true
    }
    
    func takePhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.viewController.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            //TRVicky
            self.viewController.commonAlert.setupAlert(alert:LangCommon.error,alertDescription: LangCommon.deviceHasNoCamera, okAction: LangCommon.ok.uppercased())
            
        }
    }
    
    func choosePhoto()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.viewController.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            //TRVicky
            self.viewController.commonAlert.setupAlert(alert:LangCommon.warning,alertDescription: LangCommon.pleaseGivePermission, okAction: LangCommon.ok.uppercased())
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let pickedImage = info[.editedImage] as? UIImage
        self.imageToUpload = pickedImage
        imgCertificate.image = pickedImage
        self.viewController.dismiss(animated: true, completion: nil)
        self.lblChange.text = ((self.imageToUpload == nil && self.viewController.documet.urlString.isEmpty) ? LangCommon.tapToAdd.capitalized : LangCommon.tapToChange).capitalized
        self.checkStatus()
    }
    func canEditDetails() -> Bool{
        
        if DriverTripStatus.default == .Trip {//|| !UserDefaults.isNull(for: .rider_user_id)
            self.viewController.presentAlertWithTitle(title: appName,
                                                      message: LangCommon.inTripComplete.capitalized,
                                                      options: LangCommon.ok.capitalized) { (_) in
                
            }
            return false
        }
        return true
    }
    // MARK: - Uploading Proifle Picture Operation
    func photoSave(_ photoImage : UIImage?,expiryDate : Date? = nil)
    {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        let urlString = APIUrl + "update_document"
        let imageUpload = photoImage?.jpegData(compressionQuality: 1.0)
        
        var params : [String : String] = [
            "document_id": self.viewController.documet.id.description
        ]
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        if let expiry = expiryDate{
            let strExpiry = formatter.string(from: expiry)
            params["expired_date"] = strExpiry
        }
        switch self.viewController.purpose {
        case .forDriver(id: _):
            // Handy Splitup Start
            switch AppWebConstants.businessType {
            case .DeliveryAll:
                fallthrough
            case .Ride:
                params["type"] = "Driver"
            default:
                // Handy Splitup End
                params["type"] = "Provider"
                // Handy Splitup Start
            }
            // Handy Splitup End
        //                params["type"] = "Driver"
        case .forVehicle(id: let vehicle):
            params["type"] = "Vehicle"
            params["vehicle_id"] = "\(vehicle)"
        default:
            break
        }
        
        params["token"] = UserDefaults.value(for: .access_token) ?? ""
        AF.upload(multipartFormData: { (multipartFormData) in
            if let imgDate = imageUpload{
                let date = Date().timeIntervalSince1970 * 1000
                let fileName = String(date) + "Image.jpg"
                multipartFormData.append(imgDate, withName: "document_image", fileName: fileName, mimeType: "image/jpg")
            }
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, to: urlString).response { resp in
            UberSupport.shared.removeProgressInWindow()
            switch resp.result {
            case .success(let data):
                do {
                    if let result = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers) as? [String:Any] {
                        if result["status_code"] as? String ?? String() == "1" {
                            
                            if let json = result as? JSON,
                               let url = result["document_url"] as? String
                            {
                                self.viewController.documet.urlString = url
                                self.viewController.documet.status = json.int("document_status")
                                if let expiry = expiryDate{
                                    let strExpiry = formatter.string(from: expiry)
                                    self.viewController.documet.exipryDate = strExpiry
                                }
                                self.viewChange.isHidden = false
                                self.onBackTapped(self.backBtn)
                                //                                self.strUserImgUrl = result["document_url"] as? String ?? String()
                            }
                            if result["driver_document_count"] != nil
                            {
                                //                                self.strTotalCount = UberSupport().checkParamTypes(params: result as! NSDictionary, keys:"driver_document_count") as String
                            }
                            
                        }
                        else{
                            let msg = result["status_message"] as? String
                            self.viewController.presentProjectError(message: msg ?? "")
                        }
                    }
                } catch {
                    self.viewController.presentProjectError(message: LangCommon.internalServerError)
                    print("Something went wrong")
                }
                break
            case .failure(let error):
                self.viewController.presentProjectError(message: error.errorDescription ?? "")
                print("Error in upload: \(error.localizedDescription)")
                UberSupport().removeProgress(viewCtrl: self.viewController)
                break
            }
        }
        
        
        
    }
    func checkStatus(){
        
        
        var expiryCanSubmit =  true
        if self.viewController.documet.expiryRequired{
            if self.viewController.documet.exipryDate.isEmpty && self.expiryDate == nil{
                expiryCanSubmit = false
            }else if !self.viewController.documet.exipryDate.isEmpty && self.expiryDate == nil{
                expiryCanSubmit = false
            }
        }else{
            expiryCanSubmit = false
        }
        var canSubmit =  expiryCanSubmit
        if self.viewController.documet.urlString.isEmpty {//no image and no upload
            if self.imageToUpload == nil{
                canSubmit = false
            }else{
                canSubmit = true && (!self.viewController.documet.expiryRequired || (!self.viewController.documet.exipryDate.isEmpty || self.expiryDate != nil))
            }
        }else if !self.viewController.documet.urlString.isEmpty{// has image
            if self.imageToUpload != nil{//uploaded image
                
                canSubmit = true && (!self.viewController.documet.expiryRequired || (!self.viewController.documet.exipryDate.isEmpty || self.expiryDate != nil))
                //!documet.exipryDate.isEmpty || self.expiryDate != nil
            }else{//no upload
                canSubmit = expiryCanSubmit
            }
        }
        if canSubmit{
            self.submitBtn.backgroundColor = .PrimaryColor
            self.submitBtn.isUserInteractionEnabled = true
        }else{
            self.submitBtn.backgroundColor = .TertiaryColor
            self.submitBtn.isUserInteractionEnabled = false
            
        }
        
        
    }
    
}
