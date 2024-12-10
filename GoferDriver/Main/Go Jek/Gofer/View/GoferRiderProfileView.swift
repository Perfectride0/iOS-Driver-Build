//
//  GoferRiderProfileView.swift
//  Goferjek Driver
//
//  Created by Trioangle on 26/10/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import UIKit
import SinchRTC
import OSLog

class GoferRiderProfileView : BaseView {
    
    //------------------------------------------------
    // MARK: - Outlets
    //------------------------------------------------
    
    @IBOutlet weak var pickupView: SecondaryView!
    @IBOutlet weak var tblRiderProfile: CommonTableView!
    @IBOutlet weak var lblUserName: SecondarySubHeaderLabel!
    @IBOutlet weak var lblRiderAddress: SecondaryRegularBoldLabel!
    @IBOutlet weak var lblVehicleName: InactiveRegularLabel!
    @IBOutlet weak var lblRiderRating: UILabel!
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var viewTopHeader: HeaderView!
    @IBOutlet weak var viewDotLine: UIView!
    @IBOutlet weak var imgRiderThumb: UIImageView!
    @IBOutlet weak var btnCancel: PrimaryButton!
    @IBOutlet weak var btnCall: SecondaryButton!
    @IBOutlet weak var btnMessage: PrimaryButton!
    @IBOutlet weak var car_image : UIImageView!
    @IBOutlet weak var pickupLbl : SecondarySubHeaderLabel!
    @IBOutlet weak var contentView: SecondaryView!
    @IBOutlet weak var pageTitlelbl: SecondaryHeaderLabel!
    @IBOutlet weak var barOneView: UIView!
    @IBOutlet weak var barTwoView: UIView!
    @IBOutlet weak var locationIconLbl : UILabel!
    
    //------------------------------------------------
    // MARK: - Local Variables
    //------------------------------------------------
    
    private var goferRiderProfileVC : GoferRiderProfileVC!
    
    //------------------------------------------------
    // MARK: - View Life cycle
    //------------------------------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.goferRiderProfileVC = baseVC as? GoferRiderProfileVC
        self.initView()
        self.setDesign()
        self.initLangugage()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.locationIconLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.pickupView.customColorsUpdate()
        self.tblRiderProfile.customColorsUpdate()
        self.tblRiderProfile.reloadData()
        self.lblUserName.customColorsUpdate()
        self.lblRiderAddress.customColorsUpdate()
        self.lblVehicleName.customColorsUpdate()
        self.viewTopHeader.customColorsUpdate()
        self.pickupLbl.customColorsUpdate()
        self.pickupLbl.textColor = .CompletedStatusColor
        self.contentView.customColorsUpdate()
        self.pageTitlelbl.customColorsUpdate()
        self.btnCancel.cornerRadius = 10
        self.btnCall.customColorsUpdate()
        self.btnCall.cornerRadius = 10
        self.btnCall.elevate(2)
        self.btnMessage.customColorsUpdate()
        self.btnMessage.cornerRadius = 10
    }
    
    
    
    //------------------------------------------------
    // MARK: - Button Actions
    //------------------------------------------------
    
    @IBAction
    func backBtnClicked() {
        self.goferRiderProfileVC.exitScreen(animated: true) {
            print("Successfully Rider Profile Exited")
        }
    }
    
    @IBAction
    func callBtnClicked() {
        guard let trip = self.goferRiderProfileVC.tripDetailDataModel.getCurrentTrip() else { return }
        if trip.bookingType != .manualBooking {
            if trip.id != 0 {
                AppDelegate.shared.callKitMediator.call(userId: trip.id.description) { (
                                                          result: Result<SinchCall, Error>) in
                                                       if case let .success(call) = result {
                                                                       self.transitionTo(call: call)
                                   
                                   
                                                       } else if case let .failure(error) = result {
                                           //              os_log("Call failed failed: %{public}@", log: self.customLog,
                                           //                     type: .error, error.localizedDescription)
                                                       }
                                                     }
//                do {
//                    try CallManager.instance.callUser(withID: trip.id.description)
//                } catch let error {
//                    debug(print: error.localizedDescription)
//                }
            }
        } else {
            if let phoneCallURL:NSURL = NSURL(string:"tel://\(trip.mobileNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL as URL)) {
                    application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    private func transitionTo(call: SinchCall) {
           lazy var callVC : AudioCall = .initWithStory()
           callVC.callKitMediator = AppDelegate.shared.callKitMediator
           callVC.call = call
           callVC.attach(with: .fullScreen)
   //          let sboard = UIStoryboard(name: "GoJek_Common", bundle: nil)
   //          guard let callVC = sboard.instantiateViewController(withIdentifier: "AudioCall") as? AudioCall else {
   //            preconditionFailure("Error AudioCall is expected")
   //          }
   //            callVC.callKitMediator = AppDelegate.shared.callKitMediator
   //          callVC.call = call
   //           // self.viewcontroller.present(callVC, animated: true)
   //            self.viewcontroller.navigationController?.pushViewController(callVC, animated: true)
           }
    @IBAction
    func messageBtnClicked() {
        guard let trip = self.goferRiderProfileVC.tripDetailDataModel.getCurrentTrip() else{
            return
        }
        let chatVC = ChatVC.initWithStory(withTripId: trip.jobID.description,
                                          ridereID: trip.id,
                                          riderRating: Double(trip.rating) ,
                                          imageURL: trip.image,
                                          name: trip.name,
                                          typeCon: .u2d)
        self.goferRiderProfileVC.navigationController?.pushViewController(chatVC,
                                                             animated: true)
    }
    
    @IBAction
    func onCancelTapped() {
        if self.goferRiderProfileVC.tripDetailDataModel.users.first?.jobStatus == .scheduled{
                  self.alertFunction()
        }else{
            let propertyView = CancelRideVC.initWithStory(businessType: .Ride)
            propertyView.strTripId = self.goferRiderProfileVC.tripDetailDataModel.getCurrentTrip()?.jobID.description  ?? "0"
            self.goferRiderProfileVC.navigationController?.pushViewController(propertyView,
                                                                              animated: true)
        }
    }
    
    //------------------------------------------------
    // MARK: - Iniatl Functions
    //------------------------------------------------
    
    func initView() {
        self.viewDot.layer.cornerRadius = self.viewDot.frame.size.width/2
        if self.goferRiderProfileVC.isTripStarted {
            self.btnCancel.backgroundColor = UIColor.TertiaryColor
            self.btnCancel.isUserInteractionEnabled = false
        }
        if let trip = self.goferRiderProfileVC.tripDetailDataModel.getCurrentTrip() {
            self.btnMessage.isHidden = trip.bookingType == .manualBooking
        }
    }
    
    func initLangugage() {
        self.pageTitlelbl.text = LangCommon.enRoute.capitalized
        self.btnCancel.setTitle(LangCommon.cancel.capitalized,
                                for: .normal)
        self.pickupLbl.text = LangCommon.pickUp.uppercased()
        self.btnCall.setTitle(LangCommon.call.capitalized,
                              for: .normal)
        self.btnMessage.setTitle(LangCommon.message.capitalized,
                                 for: .normal)
    }
    
    func setDesign() {
        self.pickupView.cornerRadius = 15
        self.pickupView.elevate(3)
        self.imgRiderThumb.cornerRadius = 10
        self.tblRiderProfile.showsVerticalScrollIndicator = false
        self.tblRiderProfile.showsHorizontalScrollIndicator = false
    }
    
    
    //------------------------------------------------
    // MARK: - Local Functions
    //------------------------------------------------
    func setRiderInfo() {
        guard let currentTrip = self.goferRiderProfileVC.tripDetailDataModel.getCurrentTrip() else{return}
        lblUserName.text = currentTrip.name
//        let width = UberSupport().onGetStringWidth(lblUserName.frame.size.width, strContent: lblUserName.text! as NSString, font: lblUserName.font)
//        
//        var rectLblName = lblUserName.frame
//        if width > self.frame.size.width - 100 - rectLblName.origin.x - 60 {
//            rectLblName.size.width = self.frame.size.width /*- 100*/ - rectLblName.origin.x - 60
//        } else {
//            rectLblName.size.width = width
//        }
//        lblUserName.frame = rectLblName
//        @Karuppasamy
//        self.car_image.sd_setImage(with:
//                                    URL(string : self.goferRiderProfileVC.tripDetailDataModel.carActiveImage)
//        )
//        var rectLblRating = lblRiderRating.frame
//        rectLblRating.origin.x = rectLblName.size.width + rectLblName.origin.x + 4
//        lblRiderRating.frame = rectLblRating
        
        if currentTrip.rating == 0 {
            lblRiderRating.isHidden = true
            lblRiderRating.text = ""
        } else {
            lblRiderRating.isHidden = true//false
            let textAtt =  NSMutableAttributedString(string: "★ \(currentTrip.rating.description)")
            textAtt.setColorForText(textToFind: "\(currentTrip.rating.description)",
                                    withColor:self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            textAtt.setColorForText(textToFind: "★",
                                    withColor: .ThemeYellow)
            lblRiderRating.attributedText = textAtt
        }
        lblRiderAddress.text = currentTrip.pickup
        lblVehicleName.text =  currentTrip.vehicleName
        imgRiderThumb.sd_setImage(with: NSURL(string: currentTrip.image)! as URL,
                                  placeholderImage:UIImage(named:"user_dummy"))
        imgRiderThumb.contentMode = .scaleToFill
    }
}

//----------------------------------
// MARK: - UITableView Datasource
//----------------------------------

extension GoferRiderProfileView :  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CellGoferRiderInfo = tblRiderProfile.dequeueReusableCell(withIdentifier: "CellGoferRiderInfo") as! CellGoferRiderInfo
        guard let trip = self.goferRiderProfileVC.tripDetailDataModel.getCurrentTrip() else {
            print("Trip is Missing")
            return UITableViewCell() }
        cell.viewDot.layer.cornerRadius = cell.viewDot.frame.size.width / 2
        cell.viewDot.layer.borderColor = UIColor.red.cgColor
        cell.viewDot.layer.borderWidth = 2.0
        cell.dropView.cornerRadius = 15
        cell.dropView.elevate(3)
        cell.dropTitleLbl.text = LangCommon.dropOff.uppercased()
        cell.lblRiderName.text = trip.drop
        cell.darkModeChange()
        return cell
    }
}

//----------------------------------
// MARK: - UITableView Delegate
//----------------------------------

extension GoferRiderProfileView : UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
    }
}

class CellGoferRiderInfo: UITableViewCell {
    @IBOutlet weak var lblRiderName: SecondaryRegularBoldLabel!
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var dropView: SecondaryView!
    @IBOutlet weak var dropTitleLbl : SecondarySubHeaderLabel!
    
    override
    func awakeFromNib() {
        super.awakeFromNib()
        self.darkModeChange()
    }
    
    func darkModeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.lblRiderName.customColorsUpdate()
        self.dropView.customColorsUpdate()
        self.dropTitleLbl.customColorsUpdate()
        self.dropTitleLbl.textColor = .CancelledStatusColor
    }
}


extension GoferRiderProfileView {
    func alertFunction(){
         let alert = UIAlertController(title: appName, message: self.goferRiderProfileVC.tripDetailDataModel.users.first?.cancel_warning , preferredStyle: .alert)
         
         let yesAction = UIAlertAction(title: LangCommon.yes, style: .default){_ in
             let propertyView = CancelRideVC.initWithStory(businessType: .Ride)
             propertyView.strTripId = self.goferRiderProfileVC.tripDetailDataModel.getCurrentTrip()?.jobID.description  ?? "0"
             self.goferRiderProfileVC.navigationController?.pushViewController(propertyView,
                                                                               animated: true)
         }
         let noAction = UIAlertAction(title: LangCommon.no, style: .cancel)
         
         alert.addAction(noAction)
         alert.addAction(yesAction)
         self.goferRiderProfileVC.present(alert, animated: true)
         
     }
}
