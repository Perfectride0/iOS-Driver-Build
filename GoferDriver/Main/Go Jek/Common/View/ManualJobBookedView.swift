//
//  ManualJobBookedView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 05/05/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class ManualJobBookedView: BaseView {
    
    //------------------------------------
    // MARK: - Outlets
    //------------------------------------
    
    @IBOutlet weak var imageHolderView: UIView!
    @IBOutlet weak var mainHolderView: SecondaryView!
    @IBOutlet weak var subHolderView: SecondaryView!
    @IBOutlet weak var serviceIV: UIImageView!
    @IBOutlet weak var serviceNameLbl: SecondaryHeaderLabel!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var nameField: ManualStackContentV!
    @IBOutlet weak var phoneField: ManualStackContentV!
    @IBOutlet weak var locationField: ManualStackContentV!
    @IBOutlet weak var timeField: ManualStackContentV!
    @IBOutlet weak var buttonHolderStack: UIStackView!
    @IBOutlet weak var acceptBtn: PrimaryButton!
    @IBOutlet weak var reqServiceBtn: PrimaryButton!
        
    //------------------------------------
    // MARK: - Local Variables
    //------------------------------------
    
    var manualJobBookedVC : ManualJobBookedVC?
    
    //------------------------------------
    // MARK: - ViewController Config
    //------------------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.manualJobBookedVC = baseVC as? ManualJobBookedVC
        self.setUpUserDetails()
        self.initView()
        self.darkModeChange()
    }
    
    //------------------------------------
    // MARK: - Dark Mode
    //------------------------------------
    
    override
    func darkModeChange() {
        self.mainHolderView.customColorsUpdate()
        self.subHolderView.customColorsUpdate()
        self.serviceNameLbl.customColorsUpdate()
        self.nameField.customColorUpdate()
        self.phoneField.customColorUpdate()
        self.timeField.customColorUpdate()
        self.locationField.customColorUpdate()
    }
    
    //------------------------------------
    // MARK: - Initalisation
    //------------------------------------
    
    func initView() {
        self.acceptBtn.isCurvedCorner = true
        self.mainHolderView.cornerRadius = 5
    }
    
    //------------------------------------
    // MARK: - Set Up Useer Details
    //------------------------------------
    
    func setUpUserDetails() {
        guard let vc = self.manualJobBookedVC,
              let job = vc.requestJob else { return }
        
        self.nameField.setView(withName: job.userName,
                               image: Images.account)
        self.phoneField.setView(withName: job.displayNumber,
                                image: Images.phone)
        self.locationField.setView(withName: job.pickUpAddress,
                                   image: Images.mapMarker)
        self.timeField.setView(withName: job.displayTime,
                               image: Images.clockOutline)
        self.serviceIV.sd_setImage(with: URL(string: job.serviceIcon), completed: nil)
        // Handy Splitup Start
        self.imageHolderView.isHidden = self.manualJobBookedVC?.businessType == .Delivery
        // Handy Splitup End
        if job.isManualBooking{
            self.serviceNameLbl.text = AppWebConstants.currentBusinessType == .Ride ? "\(LangGofer.ridemanualBook)" : "\(LangHandy.manualBookedFor)\(job.serviceName)" // "\(LangHandy.manualBookedFor)\(job.serviceName)"
        }else{
            self.serviceNameLbl.text = AppWebConstants.currentBusinessType == .Ride ? "\(LangGofer.ridescheduleBook)" : "\(LangHandy.scheduleBookedFor)\(job.serviceName)" // "\(LangHandy.scheduleBookedFor)\(job.serviceName)"
        }
//        self.serviceNameLbl.text = " \(job.isManualBooking ? LangHandy.manualBookedFor : LangHandy.scheduleBookedFor) \(job.serviceName)"
    }
    
    //------------------------------------
    // MARK: - Actions
    //------------------------------------
    
    @IBAction func acceptBtnClicked(_ sender: Any) {
        self.manualJobBookedVC?.exitScreen(animated: true, {
            // Handy Splitup Start
            if let businessType = self.manualJobBookedVC?.businessType {
                AppWebConstants.currentBusinessType = businessType
            } else {
                AppWebConstants.currentBusinessType = .Services
            }
            // Handy Splitup End
            NotificationCenter.default.post(name: NSNotification.Name.JobHistory,
                                            object: self, userInfo: nil)
        })
    }
    
    @IBAction func reqSeerviceBtnClicked(_ sender: Any) {
       
    }
    
}
class ManualStackContentV : UIView{
    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var placeImage : UIImageView!
    override func awakeFromNib() {
        self.customColorUpdate()
    }
    func setView(withName name : String,image : String){
        self.label.text = name
        self.setImage(withName: image)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.isCurvedCorner = true
//            self.backgroundColor = UIColor(hex: "F6F6F6")
        }
    }
    func customColorUpdate() {
        self.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.3)
    }
    func setImage(withName name: String){
        let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        self.placeImage.image = image
        self.placeImage.tintColor = .PrimaryColor
    }
    
}
