//
//  TripsDetailView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 09/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class TripsDetailView: BaseView, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - OUTLETS
    @IBOutlet weak var SeparateView: TopCurvedView!
    @IBOutlet weak var tblTripsInfo : CommonTableView!
    @IBOutlet weak var lblPageTitle : PrimaryHeaderLabel!
    @IBOutlet weak var topView: HeaderView!
    //MARK: - LOCAL VARIABLES
    var viewController:TripsDetailVC!
    var headerView = TripDetailHeaderView()
    var footerView = TripDeatilFooterView()
    //MARK: - NECESSARY CLASS FUNCTIONS
    override func didLoad(baseVC: BaseVC) {
        self.viewController = baseVC as? TripsDetailVC
        super.didLoad(baseVC: baseVC)
        self.tblTripsInfo.delegate = self
        self.tblTripsInfo.dataSource = self
       // self.tblTripsInfo.registerNib(forCell: TripDetailHeaderView.self)
        self.viewController.apiCall()
        self.initLanguage()
        self.sampleDesign()
    }
    
    func initLanguage() {
        self.lblPageTitle.text = LangDeliveryAll.orderDetails.capitalized
    }
    
    
    override
    func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        self.tblTripsInfo.reloadData()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.SeparateView.customColorsUpdate()
        self.tblTripsInfo.customColorsUpdate()
        self.lblPageTitle.customColorsUpdate()
        self.topView.customColorsUpdate()
        self.tblTripsInfo.reloadData()
        if let headerView = self.tblTripsInfo.tableHeaderView,
           headerView.isKind(of: TripDetailHeaderView.self){
            (headerView as! TripDetailHeaderView).setTheme()
            self.tblTripsInfo.tableHeaderView = headerView
        }
        if let footerView = self.tblTripsInfo.tableFooterView,
           footerView.isKind(of: TripDeatilFooterView.self){
            (footerView as! TripDeatilFooterView).setTheme()
            self.tblTripsInfo.tableFooterView = footerView
        }
        self.setHeader()
    }
    
    func sampleDesign() {
        self.headerView = .fromNib()
        self.footerView = .fromNib()
        self.headerView.setTheme()
        self.footerView.setTheme()
        self.setHeader()
        self.setFooter()
        self.tblTripsInfo.tableHeaderView = headerView
        self.tblTripsInfo.tableFooterView = footerView
//        self.tblTripsInfo.reloadData()
    }
    
    
    // MARK: When User Press Back Button
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.viewController.navigationController!.popViewController(animated: true)
    }
    
    
    //MARK: *****Table view Delegate and Datasource Methods *****
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let invoiceArray = self.viewController.invoice else { return 0 }
        return invoiceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DeliveryTripHistoryCell = tblTripsInfo.dequeueReusableCell(withIdentifier: "DeliveryTripHistoryCell") as! DeliveryTripHistoryCell
        cell.darkModeChange()
        guard let invoiceArray = self.viewController.invoice,
              let invoice = invoiceArray.value(atSafe: indexPath.row) else{ return cell }
        
        cell.serviceNameLbl.text = invoice.key
        cell.rateLbl.text = invoice.value
        cell.serviceNameLbl.setTextAlignment()
        cell.rateLbl.setTextAlignment(aligned: .right)
//        cell.setBar(invoice.bar == 1)
        if indexPath.row == (invoiceArray.count - 1) {
            cell.bar.isHidden = true
        } else {
            cell.bar.isHidden = !(invoice.bar == 1)
        }
        
        let colorStr = invoice.colour
        if !colorStr.isEmpty {
            if invoice.colour == "green" {
                cell.serviceNameLbl.textColor = .ThemeTextColor
                cell.rateLbl.textColor = .ThemeTextColor
            } else {
                cell.serviceNameLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
                cell.rateLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
            }
            cell.serviceNameLbl.font = .BoldFont(size: 14)
            cell.rateLbl.font = .BoldFont(size: 14)
        } else {
            cell.rateLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
            cell.serviceNameLbl.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        }
        if !invoice.comment.isEmpty {
            cell.serviceNameLbl.text = cell.serviceNameLbl.text! + " ⓘ"
            cell.serviceNameLbl.addAction(for: .tap) { [unowned self] in
                self.viewController.showPopOver(withComment: invoice.comment,
                                                on : cell.serviceNameLbl)
            }
        }else{
            cell.serviceNameLbl.addAction(for: .tap) {}
        }
        return cell
    }

    func setHeader() {
        guard let trip = self.viewController.trip_Details else { return }
        self.headerView.setTheme()
        self.headerView.tripIdlbl.text = "\(LangDeliveryAll.orderId.capitalized) \(trip.order_id ?? 0)"
        self.headerView.lblTripTime.text = trip.trip_date
        self.headerView.paymentTypeLbl.text = trip.paymentResult
        if trip.status == 5 {
            self.headerView.lblTripStatus.text = LangDeliveryAll.completed
        } else if trip.status == 6 {
            self.headerView.lblTripStatus.text = LangDeliveryAll.cancelled
        } else if trip.status == 4 {
            self.headerView.lblTripStatus.text = LangDeliveryAll.delivered
        } else {
            self.headerView.lblTripStatus.text = LangDeliveryAll.confirmed
        }
        
        if AppWebConstants.businessType == .DeliveryAll || AppWebConstants.businessType == .Delivery {
            self.headerView.NoofSeats.isHidden = true
            self.headerView.NoofSeats.text = ""
        } else {
            self.headerView.NoofSeats.isHidden = false
            self.headerView.NoofSeats.text = "No of seats : \(trip.status?.description ?? "")"
        }
 //       self.headerView.vehicleLblHt.constant = self.estimatedHeightOfLabel(text: trip.vehicle_name ?? "")
     //   self.headerView.lblCarType.text = trip.vehicle_name
        self.headerView.lblCost.text = "\(trip.total_fare?.description ?? "")"
        self.headerView.lblCost.setTextAlignment(aligned: .right)
        if isDarkStyle{
            if let image = trip.map_image_dark {
                self.headerView.mapView.isHidden = false
                self.headerView.imgMapRoot.sd_setImage(with: URL(string: image),
                                                       placeholderImage: UIImage(named: "map_static"),
                                                       options: .highPriority,
                                                       context: nil)
            } else {
                self.headerView.mapView.isHidden = true
            }
        }else{
            if let image = trip.map_image {
                self.headerView.mapView.isHidden = false
                self.headerView.imgMapRoot.sd_setImage(with: URL(string: image),
                                                       placeholderImage: UIImage(named: "map_static"),
                                                       options: .highPriority,
                                                       context: nil)
            } else {
                self.headerView.mapView.isHidden = true
            }
        }
        
        self.headerView.lblPickUpLoc.text = trip.pickup_location
        self.headerView.lblDropLoc.text = trip.drop_location
    }
    
    func setFooter() {
        guard let trip = self.viewController.trip_Details else { return }
        self.footerView.durationTitleLbl.text = LangCommon.duration.capitalized
        self.footerView.distanceTitleLbl.text = LangCommon.distance.capitalized
        self.footerView.durationValueLbl.text = "\(trip.duration_hour ?? "")hrs \(trip.duration_min ?? "")mins"
        if self.viewController.is_KM == true {
            self.footerView.distanceValueLbl.text = "\(trip.distance ?? "")MILES"
        } else {
            self.footerView.distanceValueLbl.text = "\(trip.distance ?? "")KM"
        }
    }



 
}
//MARK: - TABLEVIEW CELL
class CellTripsInfo1 : UITableViewCell {
    
    @IBOutlet weak var lblTitle: SecondaryRegularLabel!
    @IBOutlet weak var lblCostInfo: ThemeMixLabel!
    
    let bar = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.subviews.forEach { (child) in
            child.isHidden = child.frame.height <= 2
        }
        bar.frame = CGRect(x: 0, y: 1, width: self.contentView.frame.width, height: 1)
        bar.backgroundColor = UIColor(hex: "#F4F4F4")
        self.contentView.addSubview(bar)
    }
    func setBar(_ val : Bool){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.bar.frame = CGRect(x: 0, y: 1, width: self.contentView.frame.width, height: 1)
            self.bar.isHidden = !val
        }
    }
    
    func setTheme(){
        self.backgroundColor =  self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.lblTitle?.customColorsUpdate()
        self.lblCostInfo?.customColorsUpdate()
    }
}



//MARK: - TABLEVIEW CELL

class DeliveryTripHistoryCell: UITableViewCell {
//    @IBOutlet weak var serviceNameLbl: SecondaryRegularLabel!
//    @IBOutlet weak var rateLbl: SecondaryRegularLabel!
    let serviceNameLbl = SecondaryRegularLabel()
    let rateLbl = SecondaryRegularLabel()
    let bar = UIView()
     
    func darkModeChange() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.serviceNameLbl.customColorsUpdate()
        self.rateLbl.customColorsUpdate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initSetup()
        self.darkModeChange()
    }
    
    func initSetup() {
        self.addSubview(self.serviceNameLbl)
        self.serviceNameLbl.anchor(toView: self,
                                   leading: 15,
                                   top: 8,
                                   bottom: -8)
        self.addSubview(self.rateLbl)
        self.rateLbl.anchor(toView: self,
                            trailing: -15,
                            top: 8,
                            bottom: -8)
        self.rateLbl.leadingAnchor.constraint(greaterThanOrEqualTo: self.serviceNameLbl.trailingAnchor,
                                              constant: 15).isActive = true
        
        self.addSubview(self.bar)
        self.bar.anchor(toView: self,
                        leading: 5,
                        trailing: -5,
                        bottom: -1)
        self.bar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.bar.backgroundColor = .TertiaryColor
        self.bringSubviewToFront(self.bar)
        self.bar.isHidden = true
    }
    
    func setBar(_ val : Bool){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.bar.frame = CGRect(x: 0,
                                    y: self.contentView.frame.maxY - 1,
                                    width: self.contentView.frame.width,
                                    height: 1)
            self.contentView.addSubview(self.bar)
            self.bar.anchor(toView: self.contentView,
                            leading: 1,
                            trailing: -1,
                            top: self.contentView.frame.maxY - 2,
                            bottom: -1)
            self.contentView.bringSubviewToFront(self.bar)
            self.bar.isHidden = !val
        }
    }
    
}
//MARK: - EXTENSION
extension TripsDetailView{
    func estimatedHeightOfLabel(text: String) -> CGFloat {
        let size = CGSize(width: self.frame.width - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        print("RectangleHeight===================",rectangleHeight)
        return rectangleHeight
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGFloat {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGFloat(signOf: rect.size.width, magnitudeOf: rect.size.height)
            return size
        }
}
