//
//  TripHistoryView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 09/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit


class HandyTripHistoryView: BaseView {
    
    var viewController: HandyTripHistoryVC!
    enum Tabs{
        ///past
        case pending
        ///upcomming
        case completed
    }
    //MARK:- Outlets
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var buttonBgView: SecondaryView!
    @IBOutlet weak var navView : HeaderView!
    @IBOutlet weak var pageTitleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var segmentedControl: CommonSegmentControl!
    @IBOutlet weak var pendingTitleBtn : UIButton!
    @IBOutlet weak var completedTitleBtn : UIButton!
    @IBOutlet weak var sliderView : UIView!
    @IBOutlet weak var parentScrollView : UIScrollView!
    @IBOutlet weak var stackScrollChild : UIStackView!
    @IBOutlet weak var viewScrollChild : SecondaryView!
    @IBOutlet weak var pendingTable : CommonTableView!
    @IBOutlet weak var completedTable : CommonTableView!
    @IBOutlet weak var sliderBGView: SecondaryView!
    @IBOutlet weak var pendingHolderView: TopCurvedView!
    @IBOutlet weak var completedHolderView: TopCurvedView!
    @IBOutlet weak var completedCurveHolderView: SecondaryView!
    @IBOutlet weak var pendingCurveHolderView: SecondaryView!
    
    //MARK:- Getter setters
    var oneTimeForCompleted : Bool = true
    var oneTimeForPending : Bool = true
    var currentTab : Tabs = .pending{
        didSet{
            let isPending = currentTab == .pending
            
            UIView.animate(withDuration: 0.3, animations: {
                self.pendingTitleBtn.alpha = isPending ? 1 : 0.5
                self.completedTitleBtn.alpha = !isPending ? 1 : 0.5
                if isRTLLanguage{
                    self.parentScrollView.contentOffset = isPending
                        ? CGPoint(x: self.pendingCurveHolderView.frame.minX,
                                  y: 0)
                        : CGPoint.zero
                    self.sliderView.transform = isPending
                        ? .identity
                        : CGAffineTransform(translationX: -self.pendingTitleBtn.frame.width,
                                            y: 0)
                    if(isPending){
                        self.segmentedControl.selectedSegmentIndex = 0
                        self.viewController.selectedIndex = 0
                    }else{
                        self.segmentedControl.selectedSegmentIndex = 1
                        self.viewController.selectedIndex = 1
                    }
                }else{
                    self.parentScrollView.contentOffset = isPending
                        ? CGPoint.zero
                        : CGPoint(x: self.completedCurveHolderView.frame.minX,
                                  y: 0)
                    self.sliderView.transform = isPending
                        ? .identity
                        : CGAffineTransform(translationX: self.pendingTitleBtn.frame.width,
                                            y: 0)
                    if(isPending){
                        self.segmentedControl.selectedSegmentIndex = 0
                        self.viewController.selectedIndex = 0
                    }else{
                        self.segmentedControl.selectedSegmentIndex = 1
                        self.viewController.selectedIndex = 1
                    }
                }
            }){ completed in
                if completed{
                    isPending
                        ? self.pendingTable.reloadData()
                        : self.completedTable.reloadData()
                }
            }
        }
    }
    var isAlreadyHitted : Bool = false
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? HandyTripHistoryVC
        
        self.initView()
        self.initLanguage()
        self.viewController.fetchPendingTripsData(NeedCache: true)
        self.viewController.fetchCompletedTripsData(NeedCache: true)
        self.isAlreadyHitted = true
        // Do any additional setup after loading the view.
        self.darkModeChange()
    }
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.sliderBGView.customColorsUpdate()
        self.pageTitleLbl.customColorsUpdate()
        self.navView.customColorsUpdate()
        self.pendingCurveHolderView.customColorsUpdate()
        self.pendingHolderView.customColorsUpdate()
        self.completedHolderView.customColorsUpdate()
        self.completedCurveHolderView.customColorsUpdate()
        self.sliderView.backgroundColor = .PrimaryColor
        self.navView.customColorsUpdate()
        self.pageTitleLbl.customColorsUpdate()
        self.segmentedControl.customColorsUpdate()
        self.viewScrollChild.customColorsUpdate()
        self.pendingTable.customColorsUpdate()
        self.completedTable.customColorsUpdate()
        self.pendingTable.reloadData()
        self.completedTable.reloadData()
        self.pendingTitleBtn.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor ,
                                           for: .normal)
        self.completedTitleBtn.setTitleColor(self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor ,
                                             for: .normal)
        self.filterBtn.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        self.completedTable.backgroundView = nil
        self.pendingTable.backgroundView = nil
        if !self.isAlreadyHitted {
            self.viewController.fetchPendingTripsData(NeedCache: false)
            self.viewController.fetchCompletedTripsData(NeedCache: false)
        }
        self.isAlreadyHitted = false
    }
    
    //MAKR:- initializers
    func initView() {
        self.parentScrollView.showsVerticalScrollIndicator = false
        self.parentScrollView.showsHorizontalScrollIndicator = false
        self.parentScrollView.delegate = self
        self.pageTitleLbl.text = LangHandy.yourJobs.capitalized
        self.segmentedControl.setTitle(LangCommon.pendingStatus.capitalized, forSegmentAt: 0)
        self.segmentedControl.setTitle(LangCommon.completedStatus.capitalized, forSegmentAt: 1)
        self.pendingTable.register(NormalTripTVC.getNib(), forCellReuseIdentifier: "NormalTripTVC")
        self.pendingTable.registerNib(forCell: PendingTripTVC.self)
        self.pendingTable.delegate = self
        self.pendingTable.dataSource = self
        self.pendingTable.prefetchDataSource = self
        
        self.completedTable.register(NormalTripTVC.getNib(), forCellReuseIdentifier: "NormalTripTVC")
        // Handy Splitup Start
       
        self.completedTable.register(PastAndUpcommingTVC.getNib(), forCellReuseIdentifier: "PastAndUpcommingTVC")
        self.pendingTable.register(PastAndUpcommingTVC.getNib(), forCellReuseIdentifier: "PastAndUpcommingTVC")
                // Handy Splitup End
        self.completedTable.registerNib(forCell: PendingTripTVC.self)
        self.completedTable.delegate = self
        self.completedTable.dataSource = self
        self.completedTable.prefetchDataSource = self
        
        //Refresh contoller
        if #available(iOS 10.0, *) {
            self.pendingTable.refreshControl = self.viewController.pendingRefresher
            self.completedTable.refreshControl = self.viewController.completedRefresher
        } else {
            self.pendingTable.addSubview(self.viewController.pendingRefresher)
            self.completedTable.addSubview(self.viewController.completedRefresher)
        }
        //BottomLoader
        self.pendingTable.tableFooterView = self.viewController.pendingLoader
        self.completedTable.tableFooterView = self.viewController.completedLoader
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.PrimaryTextColor], for: .selected)
        //segmentedControl.selectedSegmentIndex = self.viewController.selectedIndex
        self.filterBtn.setTitle("", for: .normal)
        self.filterBtn.isHidden = isSingleApplication
        self.filterBtn.setImage(UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.updateCurrentTab()
    }
    func updateCurrentTab(){
        
        self.currentTab = (self.viewController.selectedIndex == 0) ? .pending : .completed
    }
    
    
    func initLanguage(){
        self.completedTitleBtn.setTitle("\(LangCommon.completedStatus.capitalized) \(LangCommon.trips.capitalized)", for: .normal)
        self.pendingTitleBtn.titleLabel?.font = .MediumFont(size: 18)
        self.pendingTitleBtn.setTitle("\(LangCommon.pendingStatus.capitalized) \(LangCommon.trips.capitalized)", for: .normal)
        self.completedTitleBtn.titleLabel?.font = .MediumFont(size: 18)
        if isRTLLanguage{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.currentTab = (self.viewController.selectedIndex == 0) ? .pending : .completed
            }
        }
    }
    
    @IBAction func filterBtnPressed(_ sender: Any) {
        // Handy Splitup Start
        guard let selected = AppWebConstants.selectedBusinessType.filter({$0.id == AppWebConstants.currentBusinessType.rawValue}).first else { return }
        let vc = CustomBottomSheetVC.initWithStory(self,pageTitle: LangCommon.history,
                                                   selectedItem: [selected.name],
                                                   detailsArray: AppWebConstants.selectedBusinessType.compactMap({$0.name}), serviceArray: [])
        vc.isForTypeSelection = true
        self.viewController.present(vc, animated: true) {
            print("_________ CustomBottomSheetVC ______ Presented")
        }
        // Handy Splitup End
    }
    
    
    @IBAction func segmentedControlIndexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.currentTab = .pending
        case 1:
            self.currentTab = .completed
        default:
            break
        }
    }
    
    @IBAction func switchTabAction(_ sender : UIButton?){
        if self.currentTab == .completed {
            self.currentTab = .pending
            
        }else{
            self.currentTab = .completed
            
        }
    }
    @IBAction func backAction(_ sender : UIButton?){
        self.viewController.tabBarController?.tabBar.isHidden = false
        if self.viewController.isPresented(){
            self.viewController.dismiss(animated: true, completion: nil)
        }else{
            self.viewController.navigationController?.popViewController(animated: true)
        }
    }
    
    func paginationUpdateInPendingAndCompleted() {
        // Based On the Current Tab Find The last cell id and Check with our model Last id
        // If it matches hit the api only ones
        
        if self.currentTab == .completed {
            let cell = completedTable.visibleCells.last as? PendingTripTVC
            if cell?.jobId.text?.replacingOccurrences(of:"\(LangCommon.number.capitalized)#", with: "") == self.viewController.completedJobHistoryModel?.data.last?.id.description && oneTimeForCompleted {
                self.viewController.fetchCompletedTripsData(NeedCache: false)
                self.oneTimeForCompleted = !self.oneTimeForCompleted
                print("å:: This is Last For Completed")
            } else {
                print("å:: Already Hitted Api Completed")
            }
        } else {
            let cell = pendingTable.visibleCells.last as? PendingTripTVC
            if  cell?.jobId.text?.replacingOccurrences(of:"\(LangCommon.number.capitalized)#", with: "") == self.viewController.pendingJobHistoryModel?.data.last?.id.description && oneTimeForPending {
                self.viewController.fetchPendingTripsData(NeedCache: false)
                self.oneTimeForPending = !self.oneTimeForPending
                print("å:: This is Last For Pending")
            } else {
                print("å:: Already Hitted Api Pending")
            }
        }
    }
}

//MARK:- ScrollView Delegate
extension HandyTripHistoryView : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.paginationUpdateInPendingAndCompleted()
        if self.viewController.currentCompletedTripPageIndex + 1 > self.viewController.totalCompletedTripPages {
            self.viewController.fetchPendingTripsData(NeedCache: false)
            self.viewController.fetchCompletedTripsData(NeedCache: false)
            self.completedTable.reloadData()
            self.pendingTable.reloadData()
        }
        guard scrollView == self.parentScrollView else{return}
        
        
        
        if isRTLLanguage{
            self.sliderView
                .transform = CGAffineTransform(translationX: (scrollView
                                                                .contentOffset.x / 2) - self.sliderView.frame.width ,
                                               y: 0)
        }else{
            self.sliderView
                .transform = CGAffineTransform(translationX: scrollView
                                                .contentOffset.x / 2,
                                               y: 0)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.parentScrollView else{return}
        let currentX = scrollView.contentOffset.x
        let maxX = self.frame.width
        
        
        
        if isRTLLanguage{
            self.currentTab = currentX >= maxX ? .pending : .completed
        }else{
            self.currentTab = currentX >= maxX ? .completed : .pending
        }
    }
}

extension HandyTripHistoryView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let count : Int
        if tableView == self.pendingTable{
            count = self.viewController.pendingJobHistoryModel?.data.count ?? 0
            let pendingDataIsFetching = self.viewController.pendingLoader.isAnimating && self.viewController.pendingRefresher.isRefreshing
            if pendingDataIsFetching {
                self.pendingTable.backgroundView = nil
            } else {
                if count == 0 && !self.viewController.pendingLoader.isAnimating{
                    let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.pendingTable.bounds.size.width, height: self.pendingTable.bounds.size.height))
                    noDataLabel.font = .MediumFont(size: 15)
                    noDataLabel.text = LangCommon.noDataFound
                    noDataLabel.textColor = UIColor.ThemeTextColor
                    noDataLabel.textAlignment = NSTextAlignment.center
                    self.pendingTable.backgroundView = noDataLabel
                } else {
                    self.pendingTable.backgroundView = nil
                }
            }
        } else {
            count = self.viewController.completedJobHistoryModel?.data.count ?? 0
            let completedDataIsFetching = self.viewController.completedLoader.isAnimating && self.viewController.completedRefresher.isRefreshing
            if completedDataIsFetching {
                self.completedTable.backgroundView = nil
            } else {
                if count == 0 && !self.viewController.completedLoader.isAnimating {
                    let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.completedTable.bounds.size.width, height: self.pendingTable.bounds.size.height))
                    noDataLabel.text = LangCommon.noDataFound
                    noDataLabel.textColor = UIColor.ThemeTextColor
                    noDataLabel.font = .MediumFont(size: 15)
                    noDataLabel.textAlignment = NSTextAlignment.center
                    self.completedTable.backgroundView = noDataLabel
                } else {
                    self.completedTable.backgroundView = nil
                }
            }
        }
        return count
    }
    
    func setCellContents(cell: PendingTripTVC,
                         trip: DataModel,
                         indexPath: IndexPath) {
        cell.requestServiceStack.isHidden = true
        cell.acceptedJobBtn.setTitle((trip.status == TripStatus.scheduled ? trip.status.localizedString : trip.status.localizedString), for: .normal) // "Begin Job" -> changed button title Coz referal to android by Rathna
        cell.declinedServicesBtn.setTitle(LangHandy.cancelJob.capitalized, for: .normal)
        cell.declinedServicesBtn.isHidden = trip.status == TripStatus.scheduled || trip.status == .beginTrip ? false : true
        cell.acceptedJobBtn.isHidden = true
        cell.acceptedJobBtn.addAction(for: .tap) {
            // Laundry Splitup Start
            // Instacart Splitup Start
            guard   let trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row)  else {return}
            if trip.status != .pending {
                /// From Job Id get all the details
                var params = JSON()
                params["job_id"] = trip.jobID
                self.viewController.getJobDetailsApiCall(params: params,
                                                         jobStatus: trip.status)
            } else {
                print("It Still In Pending State So I Can't Allow You")
            }
            // Laundry Splitup End
            // Instacart Splitup End
        }
        cell.declinedServicesBtn.addAction(for: .tap) {
            guard let trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row) else {return}
            let propertyView = CancelRideVC.initWithStory(businessType: AppWebConstants.currentBusinessType)
            propertyView.strTripId = trip.jobID.description
            propertyView.isFromHistory = true
            propertyView.isManualBooking = false
            self.viewController.navigationController?.pushViewController(propertyView, animated: true)
        }
        cell.buttonStackMain.isHidden = cell.acceptedJobBtn.isHidden && cell.declinedServicesBtn.isHidden
        
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  tableView {
        case self.pendingTable:
            //Handy_NewSplitup_Start
           
            //Gofer splitup start
            // Laundry Splitup Start
            // Instacart Splitup Start
        if AppWebConstants.currentBusinessType == .Services {
            //Handy_NewSplitup_End
            guard let trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
            let cell :PendingTripTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.setTheme()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.jobDateTime.text = trip.scheduleDisplayDate
            cell.jobId.text = "\(LangCommon.number.capitalized)#" + trip.jobID.description
            cell.jobLocation.text = trip.pickup
            cell.jobLocationText.text = LangHandy.jobLocation
            cell.dropStack.isHidden = true
            cell.dropLocation.isHidden = true
            cell.barStack.isHidden = false
            cell.statusStack.isHidden = false
            cell.buttonsStack.isHidden = false
            cell.buttonStackMain.isHidden = false
            cell.acceptedJobBtn.isHidden = false
            cell.requestServiceStack.isHidden = true
            cell.declinedServicesBtn.isHidden = false
            cell.statusStackHeight.constant = 20.0
            cell.barStackHeight.constant = 1.0
            cell.buttonStackHeight.constant = 45.0
            
            if trip.priceType == .Distance && trip.drop != ""{
                cell.dropStack.isHidden = false
                cell.dropLocation.isHidden = false
                cell.dropLocation.text = trip.drop
                cell.dropLocationText.text = LangHandy.destinationLocation
            }
            // Status Title Label Was Hidden Because of the RTL Issue By Karuppasamy and Status Added to Status value Label
            let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + trip.status.localizedString)
            AttributedString.setFont(textToFind: trip.status.localizedString,
                                     weight: .bold,
                                     fontSize: 12)
            cell.statusTitleLbl.attributedText =  AttributedString
            
            if trip.bookingType == .manualBooking || trip.bookingType == .schedule{
                if trip.status == .pending{
                    cell.acceptedJobBtn.setTitle(LangHandy.accept.capitalized, for: .normal)
                    cell.declinedServicesBtn.isHidden = false
                    cell.declinedServicesBtn.setTitle(LangHandy.decline.capitalized, for: .normal)
                    cell.acceptedJobBtn.addAction(for: .tap) {
                        var dicts = JSON()
                        dicts["request_id"] = trip.requestID
                        //New_Delivery_splitup_Start

                        self.viewController.acceptJobApiCall(params: dicts)
                        //New_Delivery_splitup_End
                    }
                    cell.declinedServicesBtn.addAction(for: .tap) {
                        guard let trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row) else {return}
                        
                        let propertyView = CancelRideVC.initWithStory(businessType: AppWebConstants.currentBusinessType)
                        propertyView.isFromHistory = true
                        propertyView.isManualBooking = false // true for scheduled Cancel Comment added By Karuppasamy
                        propertyView.strTripId = trip.jobID.description
                        self.viewController.navigationController?.pushViewController(propertyView, animated: true)
                    }
                    // added by rathna
                    cell.requestServiceStack.isHidden = false
                    cell.requestedServiceButton.setTitle(LangHandy.requestedService, for: .normal)
                    cell.requestedServiceButton.titleLabel?.numberOfLines = 2
                    cell.requestedServiceButton.titleLabel?.textAlignment = .center
                    cell.requestedServiceButton.addTap {
                        //                        self.viewRequestedServicesBtn.isUserInteractionEnabled = false
                        //                        let vc = HandyBookedServicesVC.initWithStory(reqId: self.viewController.requestId)
                        //                        self.viewController.navigationController?.pushViewController(vc, animated: true)
                        
                        cell.requestedServiceButton.isUserInteractionEnabled = false
                        //Deliveryall splitup start
                        //New_Delivery_splitup_Start

                        //Deliveryall_Newsplitup_start

                        // Laundry_NewSplitup_start
                        // Laundry_NewSplitup_end
                        //New_Delivery_splitup_End
                        //Deliveryall splitup end
                        //Deliveryall_Newsplitup_end
                    }
                }else{
                    if trip.status == .scheduled {
                        cell.acceptedJobBtn.setTitle(LangCommon.scheduledStatus.capitalized, for: .normal)
                    }
                    self.setCellContents(cell: cell, trip: trip,indexPath: indexPath)
                }
            }
            else{
                self.setCellContents(cell: cell, trip: trip,indexPath: indexPath)
            }
            
            cell.jobId.setTextAlignment()
            cell.jobDateTime.textAlignment = isRTLLanguage ? .left : .right
            return cell
            //Handy_NewSplitup_Start
            }
            
     else
        if AppWebConstants.currentBusinessType == .Delivery {
        guard let trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
        let cell :PendingTripTVC = tableView.dequeueReusableCell(for: indexPath)
        cell.setTheme()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.jobDateTime.text = trip.scheduleDisplayDate
        cell.jobId.text = "\(LangCommon.number.capitalized)#" + trip.jobID.description
        cell.jobLocation.text = trip.pickup
        cell.jobLocationText.text = LangHandy.jobLocation
        cell.dropStack.isHidden = true
        cell.dropLocation.isHidden = true
        cell.barStack.isHidden = false
        cell.statusStack.isHidden = false
        cell.buttonsStack.isHidden = false
        cell.buttonStackMain.isHidden = false
        cell.acceptedJobBtn.isHidden = false
        cell.requestServiceStack.isHidden = true
        cell.declinedServicesBtn.isHidden = false
        cell.statusStackHeight.constant = 20.0
        cell.barStackHeight.constant = 1.0
        cell.buttonStackHeight.constant = 45.0
        
        if trip.priceType == .Distance && trip.drop != ""{
            cell.dropStack.isHidden = false
            cell.dropLocation.isHidden = false
            cell.dropLocation.text = trip.drop
            cell.dropLocationText.text = LangHandy.destinationLocation
        }
        // Status Title Label Was Hidden Because of the RTL Issue By Karuppasamy and Status Added to Status value Label
        let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + trip.status.localizedString)
        AttributedString.setFont(textToFind: trip.status.localizedString,
                                 weight: .bold,
                                 fontSize: 12)
        cell.statusTitleLbl.attributedText =  AttributedString
        
        if trip.bookingType == .manualBooking || trip.bookingType == .schedule{
            if trip.status == .pending{
                cell.acceptedJobBtn.setTitle(LangHandy.accept.capitalized, for: .normal)
                cell.declinedServicesBtn.isHidden = false
                cell.declinedServicesBtn.setTitle(LangHandy.decline.capitalized, for: .normal)
                cell.acceptedJobBtn.isHidden = true
                cell.declinedServicesBtn.isHidden = true

                // added by rathna
                cell.requestServiceStack.isHidden = false
                cell.requestedServiceButton.setTitle(LangDelivery.viewRecipients, for: .normal)
                cell.requestedServiceButton.titleLabel?.numberOfLines = 2
                cell.requestedServiceButton.titleLabel?.textAlignment = .center
                cell.requestedServiceButton.addTap {
                    cell.requestedServiceButton.isUserInteractionEnabled = false
                    //Deliveryall splitup start

                    //Deliveryall_Newsplitup_start

                    // Laundry_NewSplitup_start
                    // Laundry_NewSplitup_end
                    //Deliveryall splitup end
                    //Deliveryall_Newsplitup_end
                }
              
            }else{
                if trip.status == .scheduled {
                    cell.acceptedJobBtn.setTitle(LangCommon.scheduledStatus.capitalized,
                                                 for: .normal)
                    cell.acceptedJobBtn.isHidden = true

                }
                self.setCellContents(cell: cell, trip: trip,indexPath: indexPath)
            }
            cell.buttonStackMain.isHidden = cell.acceptedJobBtn.isHidden && cell.declinedServicesBtn.isHidden

        }
        else{
            self.setCellContents(cell: cell, trip: trip,indexPath: indexPath)
        }
        
        cell.jobId.setTextAlignment()
        cell.jobDateTime.textAlignment = isRTLLanguage ? .left : .right
        return cell
        }
        //delivery splitup start
            //Gofer splitup start
            // Laundry Splitup End
            // Instacart Splitup End
            else if AppWebConstants.currentBusinessType == .DeliveryAll || AppWebConstants.currentBusinessType == .Laundry || AppWebConstants.currentBusinessType == .Instacart{
                let cell : PastAndUpcommingTVC = tableView.dequeueReusableCell(for: indexPath)
                guard let trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.setDesign()
                cell.populateCell(trip, type: "pending")
                return cell

            }
            // Laundry Splitup Start
            // Instacart Splitup Start
            else if AppWebConstants.currentBusinessType == .Ride{
                //Gofer splitup end
                    let cell : PastAndUpcommingTVC = tableView.dequeueReusableCell(for: indexPath)
                    guard let trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.setDesign()
                    cell.populateRiderCell(trip, type: "pending")
                let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + trip.status.localizedString)
                switch trip.status {
                case .cancelled:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.cancelled.color)
                case .completed:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.completed.color)
                default:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.Pending.color)
                }
                cell.jobStatusLbl.attributedText = AttributedString
                    return cell
                //Gofer splitup start
                }
            else if AppWebConstants.currentBusinessType == .Tow{
                //Gofer splitup end
                    let cell : PastAndUpcommingTVC = tableView.dequeueReusableCell(for: indexPath)
                    guard let trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
                    cell.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell.setDesign()
                    cell.populateRiderCell(trip, type: "pending")
                let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + trip.status.localizedString)
                switch trip.status {
                case .cancelled:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.cancelled.color)
                case .completed:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.completed.color)
                default:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.Pending.color)
                }
                cell.jobStatusLbl.attributedText = AttributedString
                    return cell
                //Gofer splitup start
                }
            // Laundry Splitup End
            // Instacart Splitup End
        else{//
                
            let cell :NormalTripTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
                        //cell.populateCell(trip)
                        //cell.statusLocalization(trip.status)
                        cell.ratingBtn.addAction(for: .tap) {
            cell.ratingBtn.addAction(for: .tap) { [weak self] in
            }
            
            }
                return cell
            }
            //Gofer splitup end
            //Handy_NewSplitup_End
        case self.completedTable:
            
            //Handy_NewSplitup_Start
            //Gofer splitup start
             if AppWebConstants.currentBusinessType == .DeliveryAll || AppWebConstants.currentBusinessType == .Laundry || AppWebConstants.currentBusinessType == .Instacart{
                let cell : PastAndUpcommingTVC = tableView.dequeueReusableCell(for: indexPath)
                 guard let trip = self.viewController.completedJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.setDesign()
                cell.populateCell(trip, type: "completed")
                return cell

            }
            // Laundry Splitup Start
            // Instacart Splitup Start
             else
             if (AppWebConstants.currentBusinessType == .Delivery){
                let cell :PendingTripTVC = tableView.dequeueReusableCell(for: indexPath)
                guard let trip = self.viewController.completedJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
                cell.setTheme()
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.jobDateTime.text = trip.scheduleDisplayDate
                cell.jobId.text = "\(LangCommon.number.capitalized)#" + trip.jobID.description
                cell.jobLocation.text = trip.pickup
                cell.jobLocationText.text = LangHandy.jobLocation
                cell.dropStack.isHidden = true
                cell.dropLocation.isHidden = true
                cell.barStack.isHidden = false
                cell.statusStack.isHidden = false
                cell.buttonsStack.isHidden = true
                cell.buttonStackMain.isHidden = true
                cell.acceptedJobBtn.isHidden = true
                cell.requestServiceStack.isHidden = true
                cell.declinedServicesBtn.isHidden = true
                cell.statusStackHeight.constant = 20.0
                cell.barStackHeight.constant = 1.0
                cell.buttonStackHeight.constant = 0.0
                
                if trip.priceType == .Distance && trip.drop != ""{
                    cell.dropStack.isHidden = false
                    cell.dropLocation.isHidden = false
                    cell.dropLocation.text = trip.drop
                    cell.dropLocationText.text = LangHandy.destinationLocation
                }
                let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + trip.status.localizedString)
                switch trip.status {
                case .cancelled:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.cancelled.color)
                case .completed:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.completed.color)
                default:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.Pending.color)
                }
                cell.statusTitleLbl.attributedText = AttributedString
                cell.jobId.setTextAlignment()
                cell.jobDateTime.textAlignment = isRTLLanguage ? .left : .right
                return cell
            }
            
            else if AppWebConstants.currentBusinessType == .Services{
                //Handy_NewSplitup_End
                let cell :PendingTripTVC = tableView.dequeueReusableCell(for: indexPath)
                guard let trip = self.viewController.completedJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
                cell.setTheme()
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.jobDateTime.text = trip.scheduleDisplayDate
                cell.jobId.text = "\(LangCommon.number.capitalized)#" + trip.jobID.description
                cell.jobLocation.text = trip.pickup
                cell.jobLocationText.text = LangHandy.jobLocation
                cell.dropStack.isHidden = true
                cell.dropLocation.isHidden = true
                cell.barStack.isHidden = false
                cell.statusStack.isHidden = false
                cell.buttonsStack.isHidden = true
                cell.buttonStackMain.isHidden = true
                cell.acceptedJobBtn.isHidden = true
                cell.requestServiceStack.isHidden = true
                cell.declinedServicesBtn.isHidden = true
                cell.statusStackHeight.constant = 20.0
                cell.barStackHeight.constant = 1.0
                cell.buttonStackHeight.constant = 0.0
                
                if trip.priceType == .Distance && trip.drop != ""{
                    cell.dropStack.isHidden = false
                    cell.dropLocation.isHidden = false
                    cell.dropLocation.text = trip.drop
                    cell.dropLocationText.text = LangHandy.destinationLocation
                }
                let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + trip.status.localizedString)
                switch trip.status {
                case .cancelled:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.cancelled.color)
                case .completed:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.completed.color)
                default:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.Pending.color)
                }
                cell.statusTitleLbl.attributedText = AttributedString
                cell.jobId.setTextAlignment()
                cell.jobDateTime.textAlignment = isRTLLanguage ? .left : .right
                return cell
                //Handy_NewSplitup_Start
            }
             else if AppWebConstants.currentBusinessType == .Ride{
                 //Gofer splitup end
               let cell : PastAndUpcommingTVC = tableView.dequeueReusableCell(for: indexPath)
                guard let trip = self.viewController.completedJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
               cell.selectionStyle = UITableViewCell.SelectionStyle.none
               cell.setDesign()
               cell.populateRiderCell(trip, type: "completed")
                 let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + trip.status.localizedString)
                 switch trip.status {
                 case .cancelled:
                     AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                      withColor: JobStatusTheme.cancelled.color)
                 case .completed:
                     AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                      withColor: JobStatusTheme.completed.color)
                 default:
                     AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                      withColor: JobStatusTheme.Pending.color)
                 }
                 cell.jobStatusLbl.attributedText = AttributedString
               return cell
                 //Gofer splitup start
           }
            else if AppWebConstants.currentBusinessType == .Tow{
                //Gofer splitup end
              let cell : PastAndUpcommingTVC = tableView.dequeueReusableCell(for: indexPath)
               guard let trip = self.viewController.completedJobHistoryModel?.data.value(atSafe: indexPath.row) else{return UITableViewCell()}
              cell.selectionStyle = UITableViewCell.SelectionStyle.none
              cell.setDesign()
              cell.populateRiderCell(trip, type: "completed")
                let AttributedString : NSMutableAttributedString  = NSMutableAttributedString(string: LangCommon.status + " : " + trip.status.localizedString)
                switch trip.status {
                case .cancelled:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.cancelled.color)
                case .completed:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.completed.color)
                default:
                    AttributedString.setColorForText(textToFind: trip.status.localizedString,
                                                     withColor: JobStatusTheme.Pending.color)
                }
                cell.jobStatusLbl.attributedText = AttributedString
              return cell
                //Gofer splitup start
          }
            // Laundry Splitup End
            // Instacart Splitup End
            else{
                let cell : NormalTripTVC = tableView.dequeueReusableCell(for: indexPath)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
            //Handy_NewSplitup_End
            //Gofer splitup end
        default:
            return UITableViewCell()
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip : DataModel?
        if tableView == self.pendingTable {
            trip = self.viewController.pendingJobHistoryModel?.data.value(atSafe: indexPath.row)
        }
        else {
            trip = self.viewController.completedJobHistoryModel?.data.value(atSafe: indexPath.row)
        }
        guard  let tripData = trip else {
            return
        }
        
        //Handy_NewSplitup_Start
        // Laundry Splitup Start
        // Instacart Splitup Start
        //New_Delivery_splitup_Start

        if AppWebConstants.currentBusinessType == .DeliveryAll {
            AppRouter(viewController).routeInCompleteOrders(orderID: tripData.jobID, status: tripData.status)
        }
        // Instacart Splitup End
        //Deliveryall_Newsplitup_start
        else if AppWebConstants.currentBusinessType == .Instacart{
            AppRouter(viewController).routeInCompleteOrdersInstacart(orderID: tripData.jobID, status: tripData.status)

        }
        // Instacart Splitup Start

        else         // Laundry Splitup End

            if AppWebConstants.currentBusinessType == .Laundry{
            AppRouter(viewController).routeInCompleteOrdersLaundry(orderID: tripData.jobID, status: tripData.status)
            let deliveryId = tripData.deliveryId
            UserDefaults.standard.set(deliveryId, forKey: "deliveryId")
        }
        //Deliveryall_Newsplitup_end
//        else if AppWebConstants.currentBusinessType == .Delivery{
//            AppRouter(viewController).routeInGoferCompleteOrders(tripData) //Gofer check
//        }
        // Instacart Splitup End

        else{
            

            //Handy_NewSplitup_End
            //New Delivery splitup End

            // Handy Splitup End
            //New_Delivery_splitup_End


            // Laundry Splitup Start
            // Instacart Splitup Start
            if (tripData.status) != .pending {
                //                AppRouter(viewController).routeInCompleteJobs(tripData)
                AppRouter(viewController).routeToIncompleteJobs(businessType: AppWebConstants.currentBusinessType,
                                                                jobID: tripData.jobID,
                                                                jobStatus: tripData.status,
                                                                isPool: tripData.isPool)
                
            } else {
                print("It Still In Pending State So I Can't Allow You")
            }
       
            //Handy_NewSplitup_Start
            // Laundry Splitup End
            // Instacart Splitup End
            //New_Delivery_splitup_Start

        }
        //New_Delivery_splitup_End

        // delivery splitup end
        //Handy_NewSplitup_End
    }
    
    func AttributedStringCreator(text_one:String,text_two:String,color_two:UIColor) -> NSMutableAttributedString {
        // Attributed Text Creation
        var color_one1 = UIColor()
        if #available(iOS 12.0, *) {
            color_one1 = (self.traitCollection.userInterfaceStyle == .light) ? .SecondaryTextColor : .DarkModeTextColor
        } else {
            // Fallback on earlier versions
        }
        let yourAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: color_one1,
                                                             .font: UIFont.MediumFont(size: 12)]
        let yourOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: color_two,
                                                                  .font: UIFont.MediumFont(size: 12)]
        let partOne = NSMutableAttributedString(string: "\(text_one) : ",
                                                attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: text_two,
                                                attributes: yourOtherAttributes)
        partOne.append(partTwo)
        return partOne
    }
    
    
}

extension HandyTripHistoryView : UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
      
    }
}

extension HandyTripHistoryView {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == self.parentScrollView else{return}
        let currentX = scrollView.contentOffset.x
        let maxX = self.frame.width
        if isRTLLanguage{
            self.currentTab = currentX >= maxX ? .pending : .completed
        }else{
            self.currentTab = currentX >= maxX ? .completed : .pending
        }
    }
}

extension HandyTripHistoryView : CustomBottomSheetDelegate {
    func isDeselectAllSelected() {
    }
    
    func isSelectAllSelected(SelectAllValue: Bool) {
    }
    
    func serviceTypeSelected(SelectedItemName: String) {
    }
    
    func heatMapTapAction(selectedOptions: [String]) {
    }
    
    
    func MultipleTapAction(selectedOptions: [String]) {
    }
    
    func TappedAction(indexPath: Int,
                      SelectedItemName: String) {
        // Handy Splitup Start
        print("__________Selected Item: \(indexPath) : \(SelectedItemName)")
        guard let selected = AppWebConstants.selectedBusinessType.filter({$0.name == SelectedItemName}).first else { return }
        AppWebConstants.currentBusinessType = selected.busineesType
        NotificationEnum.completedTripHistory.postNotification()
        NotificationEnum.pendingTripHistory.postNotification()
        self.completedTable.reloadData()
        // Handy Splitup End
    }
    func ActionSheetCanceled() {
        print("__________Sheet Cancelled")
    }
}

extension UIScrollView {
    func getpageOffSet() -> Bool {
        return (self.contentOffset.y + self.frame.size.height) > self.contentSize.height
    }
}
