//
//  DetailStatementView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 25/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

enum PayStatementTableSections : Int{
    case payStatements = 0
    case totalTripsCount  = 1
    case statements = 2
}
enum ScreenPurpose{
    case weekly
    case daily(_ id : Statement)
}
import UIKit
import Foundation
class DetailStatementView: BaseView {
    
    // --------------------
    // MARK: Outlets
    // --------------------
    
    @IBOutlet weak var titleView: HeaderView!
    @IBOutlet weak var pageTit : SecondaryHeaderLabel!
    @IBOutlet weak var contentHolderView: UIView!
    @IBOutlet weak var curvedContentHolderView: TopCurvedView!
    //Header View
    @IBOutlet weak var headerView: SecondaryView!
    @IBOutlet weak var pageUpperTit: PrimarySubHeaderLabel!
    @IBOutlet weak var pageUpperCostLbl: PayStatementLabel!
    @IBOutlet weak var tableHeaderTitle: SecondarySubHeaderLabel!
    //TableViews
    @IBOutlet weak var payStatementTableView: CommonTableView!
    @IBOutlet weak var dailyEarningTit: SecondarySubHeaderLabel!
    @IBOutlet weak var dailyEarningHeader: SecondaryView!
    
    // ---------------------------------
    // MARK: Local Variables
    // ---------------------------------
    
    var detailStatementVC : DetailStatementVC!
    var detailStatementModel: DeteailStatementModel?
    var dailyStatementArray = [DailyStatement]()
    var oneTimeForHistory : Bool = true
    var HittedTripPageIndex = 0
    var currentTripPageIndex = 1 {
        didSet { debug(print:currentTripPageIndex.description) }
    }
    var totalTripPages = 1 {
        didSet { debug(print: totalTripPages.description) }
    }
    
    // --------------------
    // MARK: life cycle
    // --------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.detailStatementVC = baseVC as? DetailStatementVC
        self.initView()
        self.initLanguage()
        self.setRefresher()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.titleView.customColorsUpdate()
        self.pageTit.customColorsUpdate()
        self.dailyEarningTit.customColorsUpdate()
        self.curvedContentHolderView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.pageUpperTit.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.pageUpperCostLbl.customColorsUpdate()
        self.tableHeaderTitle.customColorsUpdate()
        self.payStatementTableView.customColorsUpdate()
        self.dailyEarningHeader.customColorsUpdate()
        self.payStatementTableView.reloadData()
    }
    
    // --------------------
    // MARK: Initalisations
    // --------------------
    
    func initView() {
        self.payStatementTableView.delegate = self
        self.payStatementTableView.dataSource = self
        self.dailyEarningTit.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.dailyEarningTit.layer.cornerRadius = 10
        self.dailyEarningTit.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.2)
        self.dailyEarningTit.clipsToBounds = true
        self.tableHeaderTitle.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.tableHeaderTitle.layer.cornerRadius = 10
        self.tableHeaderTitle.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.2)
        self.tableHeaderTitle.clipsToBounds = true
    }
    
    func initLanguage() {
        
    }
    
    // ------------------------
    // MARK: Actions
    // ------------------------
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        self.detailStatementVC.exitScreen(animated: true)
    }
    
    // -------------------------
    // MARK: Local Functions
    // -------------------------
    
    func atributedLabel(str: String,
                        img: UIImage) -> NSMutableAttributedString {
        let iconsSize = CGRect(x: -1, y: -2, width: 16, height: 16)
        let attributedString = NSMutableAttributedString()
        let attachment = NSTextAttachment()
        if #available(iOS 13.0, *) {
            attachment.image = img.withTintColor(.PrimaryColor,
                                                 renderingMode: .alwaysTemplate)
        } else {
            // Fallback on earlier versions
            attachment.image = img
        }
        attachment.bounds = iconsSize
        attributedString.append(NSAttributedString(string: str))
        attributedString.append(NSAttributedString(attachment: attachment))
        return attributedString
    }
    func setRefresher() {
        self.payStatementTableView.tableFooterView = self.detailStatementVC.Loader
        if #available(iOS 10.0, *) {
            self.payStatementTableView.refreshControl = self.detailStatementVC.Refresher
        } else {
            self.payStatementTableView.addSubview(self.detailStatementVC.Refresher)
        }
    }
    func loadValueFromAPI(){
        guard let data = self.detailStatementModel, let statement = data.driverStatement else {return}
        self.pageUpperTit.text = statement.header?.key
        self.pageUpperCostLbl.text = statement.header?.value
        self.tableHeaderTitle.text = "  " + (statement.title ?? "")
        switch self.detailStatementVC.purpose{
        case .weekly:
            self.dailyEarningTit.text = "  " + LangCommon.dailyEarnings.capitalized
            self.pageTit.text = LangCommon.weeklyEarnings.capitalized
        case .daily(_):
            self.dailyEarningTit.text = "  " + LangCommon.timelyEarnings.capitalized
            self.pageTit.text = LangCommon.dailyEarnings.capitalized
        }
    }
}


// ----------------------------------------
// MARK: payStatementTableView DataSource
// ----------------------------------------

extension DetailStatementView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = detailStatementModel else { return 0 }
        switch PayStatementTableSections(rawValue: section) ?? .payStatements {
        case .payStatements:
            return model.driverStatement?.content.count ?? 0
        case .totalTripsCount:
            return model.driverStatement?.footer.count ?? 0
        case .statements:
            switch self.detailStatementVC.purpose {
            case .weekly:
                return model.statement.count
            case .daily(_):
                return self.dailyStatementArray.count
            }
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailData = self.detailStatementModel else{return UITableViewCell()}
        switch PayStatementTableSections(rawValue: indexPath.section) ?? .payStatements {
        case .payStatements:
            let cell:PayStatementInfo = payStatementTableView.dequeueReusableCell(withIdentifier: "PayStatementInfo")! as! PayStatementInfo
            guard let data = detailData.driverStatement?.content.value(atSafe: indexPath.row) else{return cell}
            cell.populateCellforPayStatement(with: data)
            if !data.tooltip.isEmpty{
                cell.lblTitle.attributedText = self.atributedLabel(str: cell.lblTitle.text!
                                                                    + "   ",
                                                                   img: #imageLiteral(resourceName: "Group 890"))
                cell.lblTitle.addAction(for: .tap) { [unowned self] in
                    self.detailStatementVC.showPopOver(withComment: data.tooltip,
                                                       on : cell.lblTitle)
                }
            }else{
                cell.lblTitle.addAction(for: .tap) {}
            }
            cell.setTheme()
            return cell
        case .totalTripsCount:
            let cell:TripsCountInfo = payStatementTableView.dequeueReusableCell(withIdentifier: "TripsCountInfo")! as! TripsCountInfo
            guard let data = detailData.driverStatement?.footer.value(atSafe: indexPath.row) else{return cell}
            print("aaa",data.value)
            
            let attributedString = NSMutableAttributedString(string: data.key
                                                             + " "
                                                             +  "\(data.value)")
            cell.setTheme()
            attributedString.setColorForText(textToFind: data.key,
                                             withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            attributedString.setColorForText(textToFind: "\(data.value)",
                                             withColor: .PrimaryColor)
            cell.completedTripsTit.attributedText = attributedString
            cell.completedTripsVal.isHidden = true
            return cell
        case .statements:
            let cell:CellTripsInfo = payStatementTableView.dequeueReusableCell(withIdentifier: "CellTripsInfo")! as! CellTripsInfo
            if isRTLLanguage{
                cell.lblArrow.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            }
            
//            cell.tripCellBGView.borderWidth = 1
//            cell.tripCellBGView.elevate(1.3)
//            cell.tripCellBGView.layer.cornerRadius = 5
//            cell.tripCellBGView.borderColor = .PrimaryColor
            switch self.detailStatementVC.purpose {
            case .weekly:
                guard let data = detailData.statement.value(atSafe: indexPath.row) else{return cell}
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.populateCellforWeekly(with: data)
            case .daily(_):
                guard let data = dailyStatementArray.value(atSafe: indexPath.row) else{return cell}
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.populateCellforDaily(with: data)
                cell.accessibilityHint = indexPath.row.description
            }
            cell.setTheme()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 200//UITableView.automaticDimension
        }else if section == 2{
            return 30
        }else{
            return 0.0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return UITableView.automaticDimension
        }else if section == 2{
            return 30
        }else{
            return 0.0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return self.headerView
        }else if section == 2{
            return self.dailyEarningHeader
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 80
        }else{
            return 70
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }else if indexPath.section == 1{
            return 70
        }else{
            return UITableView.automaticDimension
        }
    }
}

// ----------------------------------------
// MARK: payStatementTableView Delegate
// ----------------------------------------
extension DetailStatementView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if PayStatementTableSections.statements == PayStatementTableSections(rawValue: indexPath.section){
            switch self.detailStatementVC.purpose{
            case .weekly:
                //model.details.statemnt[indexpath.row].id
                guard let data = self.detailStatementModel?.statement.value(atSafe: indexPath.row) else{return}
                let vc = DetailStatementVC.initWithStory(for: .daily(data))
                self.detailStatementVC.navigationController?.pushViewController(vc, animated: true)
            case .daily(_):
                guard let data = self.dailyStatementArray.value(atSafe: indexPath.row) else{return}
                /// For Only Cache Purpose
                /// -notes:  If You Have a dynamic Staus in this Page Please Reset with your Values
                //New_Delivery_splitup_Start
                //Gofer splitup start
                // Handy Splitup Start
                // Laundry Splitup Start
                //Handy_NewSplitup_Start
                // InstaCart_NewSplitup_start
                if AppWebConstants.currentBusinessType == .DeliveryAll  {
                    // Laundry_NewSplitup_start
                    // Laundry_NewSplitup_end
                }
                //Deliveryall_Newsplitup_start
                else if AppWebConstants.currentBusinessType == .Instacart {
                    // InstaCart_NewSplitup_end
                    // Laundry_NewSplitup_start
                    // Laundry_NewSplitup_end
                    // InstaCart_NewSplitup_start
                }
                // Laundry Splitup end

                else if AppWebConstants.currentBusinessType == .Laundry{
                }
                //Deliveryall_Newsplitup_end
                //Delivery Splitup Start
                else {

                    //Handy_NewSplitup_End
                    //New Delivery splitup End

                    //New_Delivery_splitup_End

                    // delivery splitup end
                    //Gofer splitup end
                    // Handy Splitup End
                    let status : TripStatus = .completed
                    let paymentVC = HandyPaymentVC.initWithStory(model: nil,
                                                                 jobID: data.id,
                                                                 jobStatus: status)
                    paymentVC.jobId = data.id
                    self.detailStatementVC.navigationController?.pushViewController(paymentVC,
                                                                                    animated: true)
                    // Handy Splitup Start
                    //delivery splitup start
                    //Gofer splitup start

                    //New Delivery splitup Start
                    //Handy_NewSplitup_Start

                    //New_Delivery_splitup_Start

                }
                // InstaCart_NewSplitup_end
                //New_Delivery_splitup_End
                // Handy Splitup End
                //Handy_NewSplitup_End
                //Gofer splitup end
            }
        }
    }
}

// -----------------------------------------------
// MARK: payStatementTableView Scroll Pagination
// -----------------------------------------------
extension DetailStatementView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Based On the Current Tab Find The last cell id and Check with our model Last id
        // If it matches hit the api only ones
        switch self.detailStatementVC.purpose {
        case .weekly:
            return
        case .daily(_):
            let cell = payStatementTableView.visibleCells.last as? CellTripsInfo
            guard ((cell?.lblTitle.accessibilityHint) != nil),(self.dailyStatementArray.last != nil) else {return}
            
            if cell?.lblTitle.accessibilityHint == self.dailyStatementArray.last?.id.description && oneTimeForHistory && self.currentTripPageIndex != self.totalTripPages && cell?.accessibilityHint == (self.dailyStatementArray.count - 1).description{
                self.detailStatementVC.getDetailsFromApi()
                self.oneTimeForHistory = !self.oneTimeForHistory
                print("å:: This is Last For Completed")
            } else {
                print("å:: Already Hitted Api Completed")
            }
        }
    }
}
// ----------------------------------
// MARK: payStatementTableView Cells
// ----------------------------------
class CellTripsInfo : UITableViewCell {
    @IBOutlet weak var lblTitle: SecondarySubHeaderLabel!
    @IBOutlet weak var lblArrow: UILabel!
    @IBOutlet weak var costLbl: SecondaryRegularLabel!
    @IBOutlet weak var tripCellBGView: SecondaryView!
    
    func setTheme() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        }
        self.lblTitle.customColorsUpdate()
        self.costLbl.customColorsUpdate()
        self.tripCellBGView.customColorsUpdate()
    }
    
    let bar = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        bar.frame = CGRect(x: 8, y: 8, width: self.contentView.frame.width - 16, height: 1)
        bar.backgroundColor = .lightGray
        //self.contentView.addSubview(bar)
    }
    func setBar(_ val : Bool){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.bar.frame = CGRect(x: 8, y: 8, width: self.contentView.frame.width - 16, height: 1)
            self.contentView.addSubview(self.bar)
            self.bar.isHidden = !val
        }
    }
    func populateCellforWeekly(with data : Statement){
        print("111",data.totalFare)
        print("222",data.driverEarning)
        self.lblTitle.text = data.date
        self.costLbl.text = data.driverEarning
        self.lblArrow.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    func populateCellforDaily(with data : DailyStatement){
        self.lblTitle.text = data.time
        self.costLbl.text = data.driverEarning
        self.lblArrow.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.lblTitle.accessibilityHint = data.id.description
        //self.setBar(true)
    }
}
class PayStatementInfo : UITableViewCell {
    @IBOutlet weak var lblTitle: SecondarySubHeaderLabel!
    @IBOutlet weak var lblSubTitle: SecondarySubHeaderLabel!
    @IBOutlet weak var costLbl: SecondarySubHeaderLabel!
    
    func setTheme() {
        if #available(iOS 12.0, *) {
            let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
            self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
            self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        self.lblTitle.customColorsUpdate()
        self.lblSubTitle.customColorsUpdate()
        self.costLbl.customColorsUpdate()
    }
    
    let bar = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        bar.frame = CGRect(x: 8, y: 8, width: self.contentView.frame.width - 16, height: 1)
        bar.backgroundColor = .lightGray
        //self.contentView.addSubview(bar)
    }
    
    func setBar(_ val : Bool){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.bar.frame = CGRect(x: 8, y: 8, width: self.contentView.frame.width - 16, height: 1)
            self.contentView.addSubview(self.bar)
            self.bar.isHidden = !val
        }
    }
    func populateCellforPayStatement(with data : PayStatementInvoice){
        self.lblTitle.text = data.key
        self.costLbl.text = data.value
        let colorStr = data.colour
        if !colorStr.isEmpty {
            let color = colorStr == "black" ? UIColor(hex: "000000") : UIColor(hex: "27aa0b")
            self.costLbl?.font = .MediumFont(size: 16)
            self.lblTitle?.font = .MediumFont(size: 16)
            self.costLbl?.textColor = color
            self.lblTitle?.textColor = color
        }else{
            self.costLbl?.font = .MediumFont(size: 14)
            self.lblTitle?.font = .MediumFont(size: 14)
            let color = UIColor(hex: "000000")
            self.costLbl?.textColor = color
            self.lblTitle?.textColor = color
        }
    }
}

class TripsCountInfo: UITableViewCell {
    @IBOutlet weak var completedTripsTit: SecondaryRegularLabel!
    @IBOutlet weak var completedTripsVal: SecondaryRegularLabel!
    @IBOutlet weak var lineLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    func setTheme() {
        self.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.lineLbl.backgroundColor = isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.completedTripsVal.customColorsUpdate()
        self.completedTripsTit.customColorsUpdate()
    }
    
}
