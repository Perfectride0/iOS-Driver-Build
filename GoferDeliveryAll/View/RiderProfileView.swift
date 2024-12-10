//
//  RiderProfileView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 29/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

class RiderProfileView: BaseView {
    
    //MARK: - OUTLETS
    @IBOutlet weak var headerLbl: SecondaryHeaderLabel!
    @IBOutlet weak var tblRiderProfile: CommonTableView!
    @IBOutlet weak var lblUserName: SecondaryHeaderLabel!
    @IBOutlet weak var lblRiderAddress: SecondaryExtraSmallLabel!
    @IBOutlet weak var lblVehicleName: SecondaryExtraSmallLabel!
    @IBOutlet weak var lblRiderRating: SecondaryExtraSmallLabel!
    //@IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var viewTopHeader: HeaderView!
    //@IBOutlet weak var viewDotLine: UIView!
    @IBOutlet weak var imgRiderThumb: UIImageView!
    @IBOutlet weak var car_image : UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var chatBtn: SecondaryButton!
    @IBOutlet weak var cancelBtn: PrimaryButton!
    @IBOutlet weak var callBtn: SecondaryButton!
    @IBOutlet weak var pickupView: SecondaryView!
    @IBOutlet weak var curvedView: TopCurvedView!
    
    //MARK: - LOCAL VARIABLES
    var rideVC:RiderProfileVC!
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.rideVC = baseVC as? RiderProfileVC
        self.initialize()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.curvedView.customColorsUpdate()
        self.viewTopHeader.customColorsUpdate()
        self.cancelBtn.customColorsUpdate()
        self.cancelBtn.cornerRadius = 10
        self.callBtn.customColorsUpdate()
        self.chatBtn.customColorsUpdate()
        if let vc = self.rideVC {
            if vc.isTripStarted {
                self.cancelBtn.alpha = 0.5
            }
        }
        self.headerLbl.customColorsUpdate()
        self.locationLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.tblRiderProfile.customColorsUpdate()
        self.pickupView.cornerRadius = 10
        pickupView.elevate(2.5)
        
        self.pickupView.customColorsUpdate()
        self.lblUserName.customColorsUpdate()
        self.lblRiderAddress.customColorsUpdate()
        self.lblVehicleName.customColorsUpdate()
        self.lblRiderRating.customColorsUpdate()
        //self.pickupLbl.customColorsUpdate()
    }
    
    func initialize() {
        self.curvedView.elevate(2.5)
        self.callBtn.cornerRadius = 10
        self.callBtn.elevate(1)
        self.cancelBtn.cornerRadius = 10
        self.cancelBtn.elevate(1)
        self.chatBtn.cornerRadius = 10
        self.chatBtn.elevate(1)
        
        //self.viewDot.layer.cornerRadius = viewDot.frame.size.width/2
        self.lblRiderRating.layer.cornerRadius = 4
        self.lblRiderRating.clipsToBounds = true
        if self.rideVC.isTripStarted {
            self.cancelBtn.alpha = 0.5
            self.cancelBtn.isUserInteractionEnabled = false
        }
        if rideVC.tripDetailDataModel != nil {
            self.setDeliveryAllInfo()
        }
        self.initLangugage()
    }
    
    //MARK:- initLanguage
    func initLangugage(){
        self.headerLbl.text = LangCommon.enRoute.capitalized
        self.callBtn.setTitle(LangCommon.call.capitalized, for: .normal)
        self.chatBtn.setTitle(LangCommon.message.capitalized, for: .normal)
        self.cancelBtn.setTitle(LangCommon.cancel.capitalized, for: .normal)
    }
    
    
    //SETTING RIDER INFO FROM END TRIP API CALL
    func setDeliveryAllInfo() {
        let isUser = self.rideVC.tripDetailDataModel.getStatus().isDelOrderStarted
        self.lblUserName.text = isUser ? self.rideVC.tripDetailDataModel.eaterName.description :  self.rideVC.tripDetailDataModel.storeName.description
        let width = UberSupport().onGetStringWidth(lblUserName.frame.size.width, strContent: lblUserName.text! as NSString, font: lblUserName.font)
        var rectLblName = lblUserName.frame
        if width > self.rideVC.view.frame.size.width - 100 - rectLblName.origin.x - 60 {
            rectLblName.size.width = self.rideVC.view.frame.size.width /*- 100*/ - rectLblName.origin.x - 60
        } else {
            rectLblName.size.width = width
        }
        lblUserName.frame = rectLblName
        
        var vehicleType = ""
        vehicleType = rideVC.tripDetailDataModel.vehicleType
        
        if vehicleType == "Car" {
            self.car_image.image = UIImage(named: "car01")
        } else if vehicleType == "Bike" {
            self.car_image.image = UIImage(named: "bike")
        } else {
            self.car_image.image = UIImage(named: "car01")
        }
      
        
//        var rectLblRating = lblRiderRating.frame
//        rectLblRating.origin.x = rectLblName.size.width + rectLblName.origin.x + 4
//        lblRiderRating.frame = rectLblRating
        
//  666      if tripDetailDataModel.ratingValue == "0" || tripDetailDataModel.ratingValue == "0.0" || tripDetailDataModel.ratingValue == "0.00" || tripDetailDataModel.ratingValue == ""
        if true {
            lblRiderRating.isHidden = true
            lblRiderRating.text = ""
        } else {
            lblRiderRating.isHidden = true//false
/*       666     let strUberName = UberSupport().createAttributUserNameStar(originalText: String(format:"%@ i",tripDetailDataModel.ratingValue) as NSString, normalText: String(format:"%@ i",tripDetailDataModel.ratingValue) as NSString, textColor: UIColor.white, boldText: "i", fontSize: 14.0)
            lblRiderRating.attributedText = strUberName*/
        }
        if self.rideVC.tripDetailDataModel.getStatus().isTripStarted {
            //self.pickupLbl.text = LangCommon.dropOff.uppercased()
            var address = ""
            if !rideVC.tripDetailDataModel.flatNumber.isEmpty{
                address = "\(rideVC.tripDetailDataModel.flatNumber),\n"
            }
            address.append(rideVC.tripDetailDataModel.dropLocation)
            self.lblRiderAddress.text = address
        } else {
            if rideVC.tripDetailDataModel.multipleDelivery == "Yes" {
               // self.pickupLbl.text = LangCommon.dropOff.uppercased()
                var address = ""
                if !rideVC.tripDetailDataModel.flatNumber.isEmpty{
                    address = "\(rideVC.tripDetailDataModel.flatNumber),\n"
                }
                address.append(rideVC.tripDetailDataModel.dropLocation)
                self.lblRiderAddress.text = address
            } else {
                //self.pickupLbl.text = LangCommon.pickUp.uppercased()//LangDeliveryAll.pickUp.uppercased()
                self.lblRiderAddress.text = rideVC.tripDetailDataModel.pickupLocation
            }
        }
        if self.rideVC.tripDetailDataModel.getStatus().isTripStarted &&
            !self.rideVC.tripDetailDataModel.deliveryNote.isEmpty{
//            self.deliveryView.isHidden = false
//            self.deliveryViewHeight.constant = 60
//            self.deliveryTitleLbl.text = LangDeliveryAll.deliveryInstructions.uppercased()
//            self.deliveryNotesLbl.text = self.tripDetailDataModel.deliveryNote
        }else{
//            self.deliveryView.isHidden = true
//            self.deliveryViewHeight.constant = 0
//            self.deliveryTitleLbl.text = ""
//            self.deliveryNotesLbl.text = ""
        }
        //lblVehicleName.text = LangDeliveryAll.orderId.uppercased()+" #"+tripDetailDataModel.orderID.description
        lblVehicleName.text = "\(LangDeliveryAll.orderId.uppercased()) #\(rideVC.tripDetailDataModel.orderID.description)"
        imgRiderThumb.sd_setImage(with: NSURL(string: rideVC.tripDetailDataModel.getTargetUserDetails.image)! as URL, placeholderImage:UIImage(named:"user_dummy"))
        DispatchQueue.main.async {
            self.imgRiderThumb.clipsToBounds = true
            self.imgRiderThumb.isRounded = true
        }
    }
    
    //MARK: - NAVIGATE TO RIDER CONTACT VC
    @IBAction
    func onCallTapped() {
        if self.rideVC.tripDetailDataModel.userID != 0 &&
            self.rideVC.tripDetailDataModel.storeID != 0 {
            do {
                try CallManager.instance.callUser(withID: self.rideVC.tripDetailDataModel.getStatus().isDelOrderStarted ? self.rideVC.tripDetailDataModel.userID.description : self.rideVC.tripDetailDataModel.storeID.description )
            } catch let error {
                debug(print: error.localizedDescription)
            }
        } else {
            print("------------- User ID is Missing ----------")
        }
    }
    
    //-----------------------------------------
    // MARK: - When User Press Message button
    //-----------------------------------------
    
    @IBAction
    func onMessageTapped() {
        let isUser = self.rideVC.tripDetailDataModel.getStatus().isDelOrderStarted
        let chatVC = ChatVC.initWithStory(withTripId: self.rideVC.tripDetailDataModel.orderID.description,
                                          ridereID: isUser ?
                                          self.rideVC.tripDetailDataModel.userID :  self.rideVC.tripDetailDataModel.storeID ,
                                          riderRating: Double(isUser ? self.rideVC.tripDetailDataModel.userRating.description :  self.rideVC.tripDetailDataModel.storeRating.description) ,
                                          imageURL: isUser ? self.rideVC.tripDetailDataModel.eaterThumbImage.description :  self.rideVC.tripDetailDataModel.storeThumbImage.description ,
                                          name: isUser ? self.rideVC.tripDetailDataModel.eaterName.description :  self.rideVC.tripDetailDataModel.storeName.description,
                                          typeCon: isUser ? .u2d : .s2d)
        self.rideVC.presentInFullScreen(chatVC,
                                        animated: true,
                                        completion: nil)
    }

    //MARK: - NAVIGATE TO CANCEL TRIP
    @IBAction func onCancelTapped() {
//        let propertyView = CancelRideVC.initWithStory()
////        let propertyView = self.storyboard?.instantiateViewController(withIdentifier: "CancelRideVC") as! CancelRideVC
//        propertyView.strTripId = tripDetailDataModel.getCurrentTrip()?.id.description  ?? "0"
//        self.navigationController?.pushViewController(propertyView, animated: true)
        
        let propertyView = CancelRideVC.initWithStory(businessType: .DeliveryAll)
        propertyView.strTripId = "\(self.rideVC.tripDetailDataModel.orderID)"
        propertyView.requestID = self.rideVC.tripDetailDataModel.requestID
        self.rideVC.navigationController?.pushViewController(propertyView, animated: true)
    }

    //------------------------------------
    // MARK: When User Press Back Button
    //------------------------------------
    
    @IBAction
    func onBackTapped(_ sender:UIButton!) {
        self.rideVC.navigationController?.popViewController(animated: true)
    }
    
}

//------------------------------------
// MARK: - UITableView Delegate
//------------------------------------

extension RiderProfileView : UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
    }
}

//------------------------------------
// MARK: - UITableView Datasource
//------------------------------------

extension RiderProfileView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellRiderInfo = tblRiderProfile.dequeueReusableCell(withIdentifier: "CellRiderInfo") as! CellRiderInfo
        cell.viewDot.layer.cornerRadius = cell.viewDot.frame.size.width / 2
        cell.viewDot.layer.borderColor = UIColor.red.cgColor
        cell.viewDot.layer.borderWidth = 2.0
        cell.dropTitleLbl.text = LangCommon.dropOff.uppercased()
        cell.lblRiderName.text = rideVC.tripDetailDataModel.dropLocation
        return cell
    }
}

//-------------------------------------
// MARK: - TABLEVIEW CELL
//-------------------------------------

class CellRiderInfo: UITableViewCell {
    @IBOutlet weak var dropView: SecondaryView!
    @IBOutlet var lblRiderName: SecondaryExtraSmallLabel!
    @IBOutlet var viewDot: SecondaryView!
    @IBOutlet weak var dropTitleLbl : SecondaryExtraSmallLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.setTheme()
    }

    func setTheme() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.dropView.customColorsUpdate()
        self.lblRiderName.customColorsUpdate()
        self.viewDot.customColorsUpdate()
        self.dropTitleLbl.customColorsUpdate()
       
    }
}
