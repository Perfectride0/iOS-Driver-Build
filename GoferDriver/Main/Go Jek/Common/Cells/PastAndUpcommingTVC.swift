//
//  PastAndUpcommingTVC.swift
//  Gofer
//
//  Created by trioangle on 27/03/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class PastAndUpcommingTVC: UITableViewCell {

 //   lazy var language = Language.default.object
    
    /// Whole Stacks
    @IBOutlet weak var bgHolderStack: UIStackView!
    @IBOutlet weak var headerStack: UIStackView!
    @IBOutlet weak var contentStack: UIStackView!
    
    /// Normal Trips Stacks (Begin Job,Pending,End Job)
    @IBOutlet weak var tripStatusBgStack: UIStackView!
    @IBOutlet weak var tripIdBgView: UIStackView!
    
    /// Schedule trip Stacks
    @IBOutlet weak var scheduleBgView: UIView!
    @IBOutlet weak var scheduleRideStack: UIStackView!
    @IBOutlet weak var scheduleTimeStack: UIStackView!
    
    
    /// location and map
    @IBOutlet weak var locStack: UIStackView!
    @IBOutlet weak var mapBgView: UIView!
    @IBOutlet weak var numberSeatsView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var jobStatusLbl: SecondarySmallBoldLabel!
    @IBOutlet weak var amountLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var tripIdLbl: smallLabel!
    @IBOutlet weak var vehicleTypeLbl: ThemeSmallLabel!
    @IBOutlet weak var mapIV: UIImageView!
    @IBOutlet weak var pinBgView: UIView!
    @IBOutlet weak var dropIV: UIImageView!
    @IBOutlet weak var pickupIV: UIImageView!
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var pickLocLbl: smallLabel!
    @IBOutlet weak var dropLocLbl: smallLabel!
    @IBOutlet weak var addressStack: UIStackView!
    @IBOutlet weak var schduleTripLbl: ThemeSmallLabel!
    @IBOutlet weak var scheduleTimeLbl: smallLabel!
    @IBOutlet weak var schedulePriceLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var numberOfSeats: smallLabel!
    @IBOutlet weak var editTimeBtn: UIButton!
    @IBOutlet weak var cancelRideBtn: UIButton!
    @IBOutlet weak var lineLbl: UILabel!
    
    
    func setDesign() {
        self.editTimeBtn.setTitleColor(.PrimaryColor, for: .normal)
        self.cancelRideBtn.setTitleColor(.PrimaryColor, for: .normal)
        self.cancelRideBtn.setTitle(LangCommon.cancelTrip, for: .normal)
        let isDarkStyle = traitCollection.userInterfaceStyle == .dark
        self.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.bgHolderStack.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.dropIV.image = UIImage(named: isDarkStyle ? "box_white" : "box")
        self.pickupIV.image = UIImage(named: isDarkStyle ? "circle_white" : "circle")
        self.jobStatusLbl.customColorsUpdate()
        self.jobStatusLbl.font = UIFont(name: G_BoldFont, size: 16)
        self.amountLbl.customColorsUpdate()
        self.amountLbl.font = UIFont(name: G_BoldFont, size: 16)
        self.tripIdLbl.customColorsUpdate()
        self.tripIdLbl.font = UIFont(name: G_BoldFont, size: 16)
        self.pickLocLbl.customColorsUpdate()
        self.dropLocLbl.customColorsUpdate()
        self.scheduleTimeLbl.customColorsUpdate()
        self.schedulePriceLbl.customColorsUpdate()
        self.numberOfSeats.customColorsUpdate()
        self.schduleTripLbl.customColorsUpdate()
        self.vehicleTypeLbl.customColorsUpdate()
        self.vehicleTypeLbl.font = UIFont(name: G_BoldFont, size: 16)
        self.vehicleTypeLbl.setTextAlignment(aligned: .left)
        self.vehicleTypeLbl.textColor = .PrimaryColor
        self.schduleTripLbl.textColor = .PrimaryColor
        self.amountLbl.setTextAlignment(aligned: .right)
        self.lineLbl.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        //self.dottedView.backgroundColor = isDarkStyle ? .white : .lightGray
        self.dottedView.addDashedBorder(view: self.dottedView, strokeColor: isDarkStyle ? .white : .lightGray)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.setDesign()
    }

    class func getNib() -> UINib{
        return UINib(nibName: "PastAndUpcommingTVC", bundle: nil)
    }
    func populateCell(_ trip : DataModel, type:String){
        self.scheduleTimeStack.isHidden = true
        self.scheduleBgView.isHidden = true
        self.numberSeatsView.isHidden = true
        self.tripIdLbl.text = "\(LangDeliveryAll.orderId): \(trip.jobID)"
        self.jobStatusLbl.text =  (TripStatus(rawValue: trip.status.localizedString.capitalized) ?? .pending).localizedString
        let curr = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        self.amountLbl.text = "\(curr) \(trip.totalFare)"
        self.mapIV.cornerRadius = 15
        if self.isDarkStyle{
            if let url = URL(string: trip.mapImageDark){
                self.mapIV.sd_setImage(with: url, placeholderImage: UIImage(named: "map_static"))
            }
        }else{
            if let url = URL(string: trip.mapImage){
                self.mapIV.sd_setImage(with: url, placeholderImage: UIImage(named: "map_static"))
            }
        }
        
        self.dropLocLbl.text = trip.pickup
        self.pickLocLbl.text = trip.drop
        
        self.vehicleTypeLbl.text = trip.vehicleType
        self.vehicleTypeLbl.isHidden = true
        if trip.mapImage.isEmpty || type == "pending"{
            self.locStack.isHidden = false
            self.mapBgView.isHidden = true
        }else{
            self.locStack.isHidden = true
            self.mapBgView.isHidden = false
        }
        
    }
  
    func populateRiderCell(_ trip : DataModel, type:String){
        self.scheduleTimeStack.isHidden = false
        self.scheduleBgView.isHidden = false
        self.schedulePriceLbl.isHidden = true
        self.tripIdLbl.text = "\(LangGofer.tripId): " + (trip.jobID.description)
        self.jobStatusLbl.text =  trip.status.localizedString.capitalized
        let curr = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        self.amountLbl.text = "\(curr) \(trip.totalFare )"
        self.mapIV.cornerRadius = 15
        if self.isDarkStyle{
            if let url = URL(string: trip.mapImageDark){
                self.mapIV.sd_setImage(with: url, placeholderImage: UIImage(named: "map_static"))
            }
        }else{
            if let url = URL(string: trip.mapImage){
                self.mapIV.sd_setImage(with: url, placeholderImage: UIImage(named: "map_static"))
            }
        }

        if trip.bookingType == .manualBooking {
            self.scheduleTimeStack.isHidden = false
            self.scheduleBgView.isHidden = false
            self.schduleTripLbl.text = trip.bookingType.localizedString.capitalized
            self.schedulePriceLbl.isHidden = false
            self.vehicleTypeLbl.isHidden = true
            self.schedulePriceLbl.text = "\(trip.vehicleType) \(curr) \(trip.totalFare)"
        } else if trip.bookingType == .schedule {
            self.scheduleTimeStack.isHidden = false
            self.scheduleBgView.isHidden = false
            self.schduleTripLbl.text = trip.bookingType.localizedString.capitalized
        }
        self.dropLocLbl.text = trip.pickup
        self.pickLocLbl.text = trip.drop
        
        self.vehicleTypeLbl.text = trip.vehicleType
        if trip.isPool {
            self.vehicleTypeLbl.text = LangGofer.pool
        }
//        if trip.getCurrentTrip()?.mapImage == "" ||  type == "pending"{
//            self.locStack.isHidden = false
//            self.mapBgView.isHidden = true
//        }else{
//            self.locStack.isHidden = true
//            self.mapBgView.isHidden = false
//        }
        switch trip.status {
        
        case .completed:
            fallthrough
        case .rating:
            fallthrough
        case .payment:
            self.locStack.isHidden = true
            if trip.mapImage != ""
            {
                self.mapBgView.isHidden = false
            }else{
                self.mapBgView.isHidden = true
                self.locStack.isHidden = false
            }
            self.scheduleBgView.isHidden = true
            self.scheduleTimeStack.isHidden = true
            self.scheduleRideStack.isHidden = true
            
        case .cancelled:
            self.locStack.isHidden = false
            self.mapBgView.isHidden = true
        case .request:
            fallthrough
        case .beginTrip:
            fallthrough
        case .scheduled:
            fallthrough
        case .manualBookiingCancelled:
            fallthrough
        case .endTrip:
            self.locStack.isHidden = false
            self.mapBgView.isHidden = true
            self.scheduleBgView.isHidden = true
            self.scheduleTimeStack.isHidden = true
            self.scheduleRideStack.isHidden = true
            
        
        case .manuallyBookedReminder:
            fallthrough
        case .manualBookingInfo:
            fallthrough
        case .pending:
            fallthrough
        case .beginTripDel:
            fallthrough
        case .endTripDel:
            fallthrough
        case .manuallyBookedDel:
            fallthrough
        case .manuallyBookedReminderDel:
            fallthrough
        case .manualBookiingCancelledDel:
            fallthrough
        case .manualBookingInfoDel:
            fallthrough
        case .accepetedOrderDel:
            fallthrough
        case .confirmedOrderDel:
            fallthrough
        case .declinedOrderDel:
            fallthrough
        case .startedTripDel:
            fallthrough
        case .deliverdOrderDel:
            fallthrough
        case .manuallyBooked:
            self.amountLbl.text = ""
//            self.tripIdBgView.isHidden = true
            self.mapBgView.isHidden = true
            self.locStack.isHidden = false
            self.scheduleBgView.isHidden = false
            self.scheduleTimeStack.isHidden = false
            self.scheduleRideStack.isHidden = true
        }
        self.numberOfSeats.text = "\(LangGofer.noOfSeats) :" + "\(trip.seats )"
        self.scheduleTimeLbl.text = trip.scheduleDisplayDate
        if trip.isPool {
            self.numberSeatsView.isHidden = false
        } else {
            self.numberSeatsView.isHidden = true
        }
        if trip.seats == 0 {
            self.numberSeatsView.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dottedView.backgroundColor = .clear
            self.dottedView.addDashedBorder(view: self.dottedView, strokeColor: self.isDarkStyle ? .white : .lightGray)
            self.mapIV.cornerRadius = 15
        }
        
    }
    
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3]
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


