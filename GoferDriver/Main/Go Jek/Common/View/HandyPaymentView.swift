//
//  HandyPaymentView.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 21/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit


class HandyPaymentView: BaseView,
                        UITableViewDelegate,
                        UITableViewDataSource,
                        UICollectionViewDelegate,
                        UICollectionViewDataSource,
                        UITextViewDelegate,
                        FloatRatingViewDelegate{
    
   
    //MARK:- Outlets
    @IBOutlet weak var locationAndServiceBGView : SecondaryView!
    @IBOutlet weak var fareDetailsTable: CommonTableView!
    @IBOutlet weak var cornerView: TopCurvedView!
    @IBOutlet weak var feedbackview: SecondaryView!
    @IBOutlet weak var totalFareValueLbl: ThemeMixLabel!
    @IBOutlet weak var totalFareLbl: SecondaryRegularLabel!
    @IBOutlet weak var paymentTypeLbl: SecondaryRegularLabel!
    @IBOutlet weak var paymentTypeValueLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var priceTypeLbl: SecondaryRegularLabel!
    @IBOutlet weak var priceTypeValueLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var lineLabel: UIView!
    @IBOutlet weak var lineLabel1: UILabel!
    @IBOutlet weak var navView: HeaderView!
    @IBOutlet weak var jobDetailsTitleLbl: SecondaryHeaderLabel!
    
    @IBOutlet weak var totalFareStack: UIStackView!
    @IBOutlet weak var lineStack: UIStackView!
    @IBOutlet weak var paymentTypeStack: UIStackView!
    @IBOutlet weak var priceTypeStack: UIStackView!
    @IBOutlet weak var collectPaymentBtn: PrimaryButton!
    @IBOutlet weak var collectPaymentBtnHeight : NSLayoutConstraint!
    
    @IBOutlet weak var PaymentButtonConst: NSLayoutConstraint!
    @IBOutlet weak var locationView: SecondaryView!
    @IBOutlet weak var userName: SecondaryRegularLargeLabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userDetailsView: SecondaryView!
    @IBOutlet weak var jobRegValueLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var jobReqLbl: InactiveRegularLabel!
    @IBOutlet weak var jobReqView: SecondaryView!
    @IBOutlet weak var headerView: SecondaryView!
    @IBOutlet weak var pickupImg: UIImageView!
    @IBOutlet weak var pickupLbl: InactiveRegularLabel!
    @IBOutlet weak var beforeServiceLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var howWasJobLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var ratingCommentsTV: CommonTextView!
    @IBOutlet weak var provideYourFeedLbl: UILabel!
    @IBOutlet weak var ratingView: SecondaryView!
    @IBOutlet weak var afterServiceCollection: CommonCollectionView!
    @IBOutlet weak var beforeServiceCollection: CommonCollectionView!
    @IBOutlet weak var AfterServiceLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var serviceView: SecondaryView!
    @IBOutlet weak var dropLocationValueLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var dropLbl: InactiveRegularLabel!
    @IBOutlet weak var dropImg: UIImageView!
    @IBOutlet weak var pickupLocValueLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var footerView: SecondaryView!
    @IBOutlet weak var thanksLbl: InactiveRegularLabel!
    @IBOutlet weak var serviceNoLbl: ThemeButtonTypeLabel!
    @IBOutlet weak var dropStack: UIStackView!
    
    
    @IBOutlet weak var dropImgBack: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var userRatingLAbel: UILabel!
    //@IBOutlet weak var userRatingView: FloatRatingView!
    @IBOutlet weak var titleHeaderView: SecondaryView!
    @IBOutlet weak var bgView: SecondaryView!
    @IBOutlet weak var jobRatingView: FloatRatingView!
    
    @IBOutlet weak var bottomView: TopCurvedView!
    @IBOutlet weak var viewReqBtn: SecondaryButton!
    
    
    
    @IBOutlet var tripDistView: SecondaryView!
    @IBOutlet var tripHeaderView: SecondaryView!
    @IBOutlet weak var durationLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var durationValueLbl: ThemeMixLabel!
    @IBOutlet weak var distanceLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var distanceValueLbl: ThemeMixLabel!
    
    @IBOutlet weak var vehicleTypeStack: UIStackView!
    @IBOutlet weak var vehicleTitle: SecondaryRegularLabel!
    @IBOutlet weak var vehicleName: SecondarySmallHeaderLabel!
    
    enum paymentOrder : CaseIterable {
        case thanks
        case paymentDetails
        case feedback
    }
    
    
    override func darkModeChange() {
        super.darkModeChange()
        self.jobDetailsTitleLbl.customColorsUpdate()
        self.navView.customColorsUpdate()
        self.userName.customColorsUpdate()
        self.jobReqLbl.customColorsUpdate()
        self.viewReqBtn.customColorsUpdate()
        self.viewReqBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.afterServiceCollection.customColorsUpdate()
        self.afterServiceCollection.reloadData()
        self.beforeServiceCollection.customColorsUpdate()
        self.beforeServiceCollection.reloadData()
        self.serviceView.customColorsUpdate()
        self.userDetailsView.customColorsUpdate()
        self.footerView.customColorsUpdate()
        self.ratingView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.jobReqView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.bgView.customColorsUpdate()
        self.titleHeaderView.customColorsUpdate()
        self.priceTypeValueLbl.customColorsUpdate()
        self.priceTypeLbl.customColorsUpdate()
        self.paymentTypeValueLbl.customColorsUpdate()
        self.paymentTypeLbl.customColorsUpdate()
        self.thanksLbl.customColorsUpdate()
        self.pickupLocValueLbl.customColorsUpdate()
        self.dropLbl.customColorsUpdate()
        self.dropLocationValueLbl.customColorsUpdate()
        self.AfterServiceLbl.customColorsUpdate()
        self.fareDetailsTable.customColorsUpdate()
        self.cornerView.customColorsUpdate()
        self.fareDetailsTable.reloadData()
        self.totalFareLbl.customColorsUpdate()
        self.locationView.customColorsUpdate()
        self.jobRegValueLbl.customColorsUpdate()
        self.pickupLbl.customColorsUpdate()
        self.beforeServiceLbl.customColorsUpdate()
        self.howWasJobLbl.customColorsUpdate()
        self.ratingCommentsTV.customColorsUpdate()
        if self.ratingCommentsTV.text == LangCommon.provideYourFeedback.capitalized {
            self.ratingCommentsTV.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
        locationView.backgroundColor = UIColor.clear
        userDetailsView.backgroundColor = UIColor.clear
        if let text = self.userRatingLAbel.attributedText {
            let attText = NSMutableAttributedString(attributedString: text)
            attText.setColorForText(textToFind: attText.string, withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            attText.setColorForText(textToFind: "★", withColor: .ThemeYellow)
            self.userRatingLAbel.attributedText = attText
        }
        
        self.tripDistView.customColorsUpdate()
        self.tripHeaderView.customColorsUpdated()
        self.durationLbl.customColorsUpdate()
        self.durationValueLbl.customColorsUpdate()
        self.distanceLbl.customColorsUpdate()
        self.distanceValueLbl.customColorsUpdate()
        self.vehicleTitle.customColorsUpdate()
        self.vehicleName.customColorsUpdate()
    }
    
    //MARK:- Class Variables
    var viewController: HandyPaymentVC!
    var isFareDetailsShow : Bool = false
    var isPaidShown : Bool = false
    var strPaymentStatus = ""
    var totalAmt = Double()
    var paymentMode = ""
    //MARK:- Life Cycles
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? HandyPaymentVC
        self.fareDetailsTable.delegate = self
        self.fareDetailsTable.dataSource = self
        //Gofer splitup start
        self.beforeServiceCollection.delegate = self
        self.beforeServiceCollection.dataSource = self
        self.afterServiceCollection.delegate = self
        self.afterServiceCollection.dataSource = self
        //Gofer splitup end
        self.provideYourFeedLbl.text = LangCommon.provideYourFeedback
        self.jobDetailsTitleLbl.text = LangHandy.jobDetails
        fareDetailsTable.register(UINib(nibName: ReusableIdentifier.XIBName.PaymentTVC, bundle: nil), forCellReuseIdentifier: ReusableIdentifier.ReuseID.PaymentTVC)
        
        self.ratingCommentsTV.delegate = self
//        self.userRatingView.backgroundColor = .clear
//        self.jobRatingView.backgroundColor = .clear
        AppUtilities().setFloatingView(view: self.jobRatingView,
                                       parentView: self)
//        self.setData()
        self.initLanguage()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.checkPaymentStatus()
        }
        self.titleHeaderView.layer.cornerRadius = 15
        self.titleHeaderView.elevate(2.5)
        self.initView()
        self.initRating()
        self.darkModeChange()
    }
    
    func initRating() {
        self.ratingCommentsTV.text = LangCommon.provideYourFeedback.capitalized
    }
   
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
    }
    
    func initView() {
        self.jobRegValueLbl.setTextAlignment()
        self.dropLbl.setTextAlignment()
        self.viewReqBtn.cornerRadius = 5
        self.viewReqBtn.elevate(2)
        self.pickupLbl.setTextAlignment()
        self.pickupLocValueLbl.setTextAlignment()
        self.jobReqLbl.setTextAlignment()
        self.dropLocationValueLbl.setTextAlignment()
        self.serviceNoLbl.setTextAlignment()
        self.thanksLbl.setTextAlignment()
        self.totalFareValueLbl.setTextAlignment(aligned: .right)
        self.paymentTypeValueLbl.setTextAlignment(aligned: .right)
        self.priceTypeValueLbl.setTextAlignment(aligned: .right)
        self.ratingCommentsTV.setTextAlignment()
        self.provideYourFeedLbl.setTextAlignment()
        self.howWasJobLbl.setTextAlignment()
    }
    
    func initLanguage() {
        self.thanksLbl.text =  LangCommon.thanksText
        self.jobReqLbl.text = LangCommon.jobRequestedDate
        self.viewReqBtn.setTitle(LangDelivery.viewRecipients.capitalized, for: .normal)
        self.distanceLbl.text = LangCommon.distance
        self.durationLbl.text = LangCommon.duration
    }
    func sizeHeaderToFit() {
        if let headerView = fareDetailsTable.tableHeaderView {
            
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            fareDetailsTable.tableHeaderView = headerView
        }
    }
    
    func sizeFooterToFit() {
        if let footerView = fareDetailsTable.tableFooterView {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = footerView.frame
            frame.size.height = height
            footerView.frame = frame
            
            fareDetailsTable.tableFooterView = footerView
        }
    }
    func setData() {
        guard let model = self.viewController.jobDataModel.getCurrentTrip() else {return}
        self.collectPaymentBtnHeight.constant = model.jobStatus == TripStatus.payment ? 50 : 0
        self.PaymentButtonConst.constant = model.jobStatus == TripStatus.payment ? 50 : 0
        self.bottomView.isHidden = !(model.jobStatus == .payment)
        self.collectPaymentBtn.isHidden = model.jobStatus != TripStatus.payment
        self.totalFareValueLbl.text = model.currencySymbol  + " " + model.providerEarnings
        self.totalFareLbl.text = LangCommon.driverEarnings
        // Handy Splitup Start
        self.priceTypeLbl.isHidden = (model.businessId == .Delivery || model.businessId == .Ride) ? true : false
        self.priceTypeStack.isHidden = (model.businessId == .Delivery || model.businessId == .Ride) ? true : false
        self.priceTypeValueLbl.isHidden = (model.businessId == .Delivery || model.businessId == .Ride) ? true : false
        self.vehicleTypeStack.isHidden = model.businessId == .Services
        self.viewReqBtn.isHidden = !(model.businessId == .Delivery && model.jobStatus.isTripCompleted)
        // Handy Splitup End
        self.paymentTypeLbl.isHidden = false
        self.paymentTypeLbl.text = "\(LangCommon.paymentType)"
        self.priceTypeLbl.text = "\(LangCommon.priceType)"
        self.vehicleTitle.text = "\(LangCommon.VehicleType)" //need to change
        self.vehicleName.text = model.vehicleName
        self.vehicleTitle.setTextAlignment()
        self.vehicleName.setTextAlignment(aligned: .right)
        
        switch model.paymentModeKey.lowercased(){
        case "cash":
            paymentTypeValueLbl.text = LangCommon.cash
        case "paypal":
            paymentTypeValueLbl.text = LangCommon.paypal
        case "onlinepayment":
            paymentTypeValueLbl.text = LangCommon.onlinepayment
        case "stripe":
            paymentTypeValueLbl.text = LangCommon.stripe
        case "braintree":
            paymentTypeValueLbl.text = LangDeliveryAll.braintree
        default:
            break
        }
        switch model.priceType{
        case .Fixed:
            priceTypeValueLbl.text = LangCommon.fixed
        case .Distance:
            priceTypeValueLbl.text = LangCommon.time_distance
        case .Hourly:
            priceTypeValueLbl.text = LangCommon.hourly
        default:
            break
        }
        self.serviceNoLbl.backgroundColor = .clear
        self.serviceNoLbl.textColor = .PrimaryColor
        self.serviceNoLbl.text = "\(LangHandy.serviceNo) #\(model.jobID.description)" 
        self.jobRegValueLbl.text = model.scheduleDisplayDate
        self.pickupLbl.text = LangHandy.jobLocation
        self.pickupLocValueLbl.text = model.pickup
        self.dropImg.isHidden = true
        self.dropImgBack.isHidden = true
        self.submitBtn.isHidden = true
        self.dropLbl.text = ""
        self.dropLocationValueLbl.text = ""
        let str = model.image
        let url = URL(string: str)
        self.userImg.isCurvedCorner = true
        self.userImg.sd_setImage(with: url,
                                 placeholderImage:UIImage(named:"user_dummy"))
        self.userName.text = model.name
        self.ratingLbl.text = LangCommon.ratingStatus
        let vals = Float(model.rating)
        if vals == 0.0 {
            self.userRatingLAbel.isHidden = true
        }else{
            let textAtt =  NSMutableAttributedString(string: "★ \(vals)")
            textAtt.setColorForText(textToFind: "\(vals)", withColor:self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
            textAtt.setColorForText(textToFind: "★", withColor: .ThemeYellow)
            userRatingLAbel.attributedText = textAtt
            self.userRatingLAbel.isHidden = false
        }
        
        self.howWasJobLbl.text = LangCommon.howWasYourJob
        self.jobRatingView.rating = Float(model.jobRating.userRating)
//        self.provideYourFeedLbl.isHidden = model.jobRating.userRating > 0 ? true : false
        self.feedbackview.isHidden = model.jobRating.userRating > 0 ? true : false
        self.ratingCommentsTV.text = model.jobRating.userComments

        if model.jobStatus == .completed {
            let vals = Float(model.jobRating.userRating)
               if vals == 0.0 {
                if model.jobRating.userComments == "" {
                    self.ratingView.isHidden = true
                         self.jobRatingView.isHidden = true
                }else{
                    self.ratingView.isHidden = false
                    self.jobRatingView.isHidden = true
                }
                   self.jobRatingView.isHidden = true
               }else{
                   self.jobRatingView.rating = vals
               }
     
            
        }else if model.jobStatus == .cancelled{ //for cancel the job
            self.ratingView.isHidden = true
            self.jobRatingView.isHidden = true
        }else{
            
        }
        self.jobRatingView.editable = false
        self.ratingCommentsTV.isEditable = false
        self.ratingCommentsTV.isSelectable = false
        self.submitBtn.addTarget(self, action: #selector(self.onTappedSubmit(_:)), for: .touchUpInside)
        if model.priceType == .Distance{
            self.dropImg.isHidden = false
            self.dropImgBack.isHidden = false
            self.dropLbl.text = LangHandy.destinationLocation
            self.dropLocationValueLbl.text = model.drop.isEmpty ? model.pickup : model.drop
            self.dropLocationValueLbl.isHidden = false
            //self.dropStack.isHidden = false
        }else{
            self.dropLocationValueLbl.isHidden = true
            //self.dropStack.isHidden = true
        }
        self.beforeServiceLbl.text = LangHandy.beforeServices
        self.AfterServiceLbl.text = LangHandy.afterServices
        self.afterServiceCollection.isHidden = false
        self.beforeServiceCollection.isHidden = false

        if  (model.jobImage?.afterImages.count ?? 0) == 0{
            self.AfterServiceLbl.text = ""
            self.afterServiceCollection.isHidden = true
        } else {
            self.afterServiceCollection.reloadData()
        }
        if (model.jobImage?.beforeImages.count ?? 0) == 0{
            self.beforeServiceLbl.text = ""
            self.beforeServiceCollection.isHidden = true
        } else {
            self.beforeServiceCollection.reloadData()
        }
        if model.jobStatus == .rating {
            self.submitBtn.isHidden = false
            self.jobRatingView.editable = true
            self.ratingCommentsTV.isEditable = true
            self.ratingCommentsTV.isSelectable = true
            self.jobRatingView.editable = true
            self.ratingCommentsTV.text = model.jobRating.userComments.isEmpty ? LangCommon.provideYourFeedback.capitalized : model.jobRating.userComments
            if self.ratingCommentsTV.text == LangCommon.provideYourFeedback.capitalized {
                self.ratingCommentsTV.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
            } else {
                self.ratingCommentsTV.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
            }
        } else if model.jobStatus == .cancelled {
            
        }
        self.sizeFooterToFit()
        self.fareDetailsTable.reloadDataWithAutoSizingCellWorkAround()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.fareDetailsTable.reloadDataWithAutoSizingCellWorkAround()
        }
        if model.is_KM == true {
            self.durationValueLbl.text = "\(model.totalTime)"  + " " + LangCommon.mins.uppercased()
            self.distanceValueLbl.text = "\(model.totalkm)" + " " + LangCommon.km.uppercased()
        } else {
            self.durationValueLbl.text = "\(model.totalTime)"  + " " + LangCommon.mins.uppercased()
            self.distanceValueLbl.text = "\(model.totalkm)" + " " + LangCommon.miles.uppercased()
        }
    }
    //MARK:- Actions
    @objc func onTappedSubmit(_ sender:UIButton) {
        self.endEditing(true)
//        self.provideYourFeedLbl.isHidden = Int(self.jobRatingView.rating) != 0 ? true : false
        self.feedbackview.isHidden = Int(self.jobRatingView.rating) != 0 ? true : false
        if Int(self.jobRatingView.rating) == 0 {
            
            //TRVicky
            self.viewController.commonAlert.setupAlert(alert: LangCommon.message,alertDescription: LangCommon.pleaseGiveRating, okAction: LangCommon.ok.uppercased())
              
            

            return
        } else {
            if let text = self.ratingCommentsTV.text {
                self.viewController.updateRating(ratingValue: String(format: "%d", Int(self.jobRatingView.rating)),
                                                 jobId: self.viewController.jobDataModel.getCurrentTrip()?.jobID.description ?? "",
                                                 RatingComments: text == LangCommon.provideYourFeedback ? "" : text)
            } else {
                self.viewController.updateRating(ratingValue: String(format: "%d", Int(self.jobRatingView.rating)),
                                                 jobId: self.viewController.jobDataModel.getCurrentTrip()?.jobID.description ?? "",
                                                 RatingComments: "")
            }
        }
    }
    
    @IBAction func backAtn(_ sender: Any) {
        Shared.instance.resumeTripHitCount = 1
        //uncomment the below line line
        //Delivery splitup start
        if let vc = self.viewController.findLastBeforeVC()

            //Deliveryall_Newsplitup_start
            

            // Laundry_NewSplitup_start
            // InstaCart_NewSplitup_start
            ,
           // Laundry_NewSplitup_end

           //Gofer splitup start
           //New_Delivery_splitup_Start
            //Laundry splitup start
            //Instacart splitup start
            //Deliveryall splitup start
            // Laundry_NewSplitup_start
            vc.isKind(of: ShareRouteVC.self
            //New_Delivery_splitup_End
                         //Deliveryall splitup End
                         // Handy Splitup End
                         //Laundry splitup End
                         //Instacart splitup end
            )

        //Deliveryall_Newsplitup_end


            // Laundry_NewSplitup_end
        // InstaCart_NewSplitup_end
      


        //Handy_NewSplitup_End
         {

            self.viewController.navigationController?.popToRootViewController(animated: true)
        } else {
            self.viewController.exitScreen(animated: true)
            
        }
        //Delivery Splitup End
    }
    
    //Gofer splitup start

    @IBAction func viewReqBtnTapped(_ sender: Any) {
        //Handy_NewSplitup_Start
        //Laundry splitup start
        //Instacart splitup start
        //Deliveryall splitup start

        //Deliveryall_Newsplitup_start

        // Laundry_NewSplitup_start

        // Laundry_NewSplitup_end
        // Handy Splitup End


        //Handy_NewSplitup_End

        //Laundry splitup end
        //Instacart splitup end
        //Deliveryall splitup End
    }
    
    //Gofer splitup end
    
    //MARK:- Merge
    //MARK: Payment  btn status
    func checkPaymentStatus() {
        
        
        collectPaymentBtn.isUserInteractionEnabled = true
        guard let viewModel = self.viewController.jobDataModel else { return }
        switch viewModel.getCurrentTrip()?.paymentModeKey ?? "cash" { 
        case let x where x.lowercased() == "cash" ://Cash
            if totalAmt.isZero {
                self.setBtnState(to: .waitingForConfirmation)
            }else{
                // Handy Splitup start
                //Gofer splitup start
                if viewModel.getCurrentTrip()?.businessId ?? .Ride == .Delivery{
                    self.setBtnState(to: .waitingForConfirmation)
                }else{
                    // Handy Splitup End
                    //Gofer splitup end
                    self.setBtnState(to: .cashCollected)
                    //Gofer splitup start
                    // Handy Splitup Start
                }
                // Handy Splitup End
                //Gofer splitup end
            }
        case let x where x.lowercased().first == "b":
            if totalAmt.isZero{
                self.setBtnState(to: .waitingForConfirmation)
            }else{
                self.setBtnState(to: .waitingForConfirmation)
            }
        case let x where x.lowercased().first == "p"://Pay Pal
            if totalAmt.isZero{
                self.setBtnState(to: .waitingForConfirmation)
            }else{
                self.setBtnState(to: .waitingForConfirmation)
            }
        case let x where x.lowercased().first == "s"://Pay Pal
            if totalAmt.isZero{
                self.setBtnState(to: .waitingForConfirmation)
            }else{
                self.setBtnState(to: .waitingForConfirmation)
            }
        case let x where x.lowercased().first == "o"://Pay Pal
            if totalAmt.isZero{
                self.setBtnState(to: .waitingForConfirmation)
            }else{
                self.setBtnState(to: .waitingForConfirmation)
            }
        default:
            self.setBtnState(to: .paid)
            self.strPaymentStatus = LangCommon.paid.uppercased()
        }
        self.sizeToFit()
        
    }
    func setBtnState(to state : BtnPymtStatus){
        switch state {
        case .cashCollected:
            collectPaymentBtn.setTitle(LangCommon.cashCollected.uppercased(), for: UIControl.State.normal)
            collectPaymentBtn.backgroundColor = .PrimaryColor
            collectPaymentBtn.isUserInteractionEnabled = true
        case .waitingForConfirmation:
            collectPaymentBtn.setTitle(LangCommon.waitingForPayment.uppercased(), for: UIControl.State.normal)
            collectPaymentBtn.backgroundColor = .TertiaryColor
            collectPaymentBtn.isUserInteractionEnabled = false
        case .proceed:
            collectPaymentBtn.setTitle(LangCommon.proceed.uppercased(), for: UIControl.State.normal)
            collectPaymentBtn.backgroundColor = .PrimaryColor
            collectPaymentBtn.isUserInteractionEnabled = true
        default:
            collectPaymentBtn.setTitle(LangCommon.proceed.uppercased(), for: UIControl.State.normal)
            collectPaymentBtn.backgroundColor = .PrimaryColor
            collectPaymentBtn.isUserInteractionEnabled = true
        }
    }
    

    //MARK:- TextView delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

                   // check if paste action
//        if text.count > 1 {
//            let filteredString = text.replacingOccurrences(of: "\'", with: "´")
//            textView.text = filteredString
//            return false
//        }
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
         return true

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == LangCommon.provideYourFeedback.capitalized {
            textView.text = nil
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LangCommon.provideYourFeedback.capitalized
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        lblPlaceHolder.isHidden = (txtComments.text.count > 0) ? true : false
        if textView.text == LangCommon.provideYourFeedback.capitalized {
            textView.textColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
        } else {
            textView.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        }
    }
    
    //MARK:- CollectionView delegate and datasoure
    //Gofer splitup start

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == beforeServiceCollection {
            guard let viewModel = self.viewController.jobDataModel else { return 0 }
            guard let model = viewModel.getCurrentTrip()?.jobImage?.beforeImages else { return 0 }
            return model.count
        } else{
            guard let viewModel = self.viewController.jobDataModel else { return 0 }
            guard let model = viewModel.getCurrentTrip()?.jobImage?.afterImages else { return 0 }
            return model.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ServiceImageCell = beforeServiceCollection.dequeueReusableCell(for: indexPath)
        if collectionView == beforeServiceCollection {
            guard let viewModel = self.viewController.jobDataModel else { return UICollectionViewCell() }
            guard let model = viewModel.getCurrentTrip()?.jobImage?.beforeImages.value(atSafe: indexPath.row) else { return UICollectionViewCell() }
            let str = model.image
            let url = URL(string: str)
            cell.imageView.sd_setImage(with: url,
                                       placeholderImage:UIImage(named:"user_dummy"))
            cell.imageView.clipsToBounds = true
        } else {
            guard let viewModel = self.viewController.jobDataModel else { return UICollectionViewCell() }
            guard let model = viewModel.getCurrentTrip()?.jobImage?.afterImages.value(atSafe: indexPath.row) else { return UICollectionViewCell() }
            let str = model.image
            let url = URL(string: str)
            cell.imageView.sd_setImage(with: url,
                                       placeholderImage:UIImage(named:"user_dummy"))
            cell.imageView.clipsToBounds = true
        }
        cell.ThemeChange()
        return cell
    }
    //New_Delivery_splitup_Start
    //Laundry splitup start
    //Instacart splitup start
    //Deliveryall splitup start
    //Deliveryall_Newsplitup_start
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == beforeServiceCollection{
            let model = self.viewController.jobDataModel.getCurrentTrip()?.jobImage?.beforeImages
            guard let cell = collectionView.cellForItem(at: indexPath) as? ServiceImageCell,
                let _parentTableView = self.fareDetailsTable else{return}

            var frame = collectionView.convert(cell.frame, to: _parentTableView)
            frame = _parentTableView.convert(frame, to: self)
            let imagesArray = model?.compactMap{$0.image} ?? []
            // Laundry_NewSplitup_start
            // Laundry_NewSplitup_end
        }
        else{
            let model = self.viewController.jobDataModel.getCurrentTrip()?.jobImage?.afterImages
            guard let cell = collectionView.cellForItem(at: indexPath) as? ServiceImageCell,
                let _parentTableView = self.fareDetailsTable else{return}
            var frame = collectionView.convert(cell.frame, to: _parentTableView)
            frame = _parentTableView.convert(frame, to: self)
            let imagesArray = model?.compactMap{$0.image} ?? []
            // Laundry_NewSplitup_start
            // Laundry_NewSplitup_end
        }
    }
    //Deliveryall_Newsplitup_end
    //Deliveryall splitup end
    //Laundry splitup end
    //Instacart splitup end
    //New_Delivery_splitup_End
    //Gofer splitup end
 //MARK:- Tableview delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        // Handy Splitup Start
        guard let modelData = self.viewController.jobDataModel ,let model = modelData.getCurrentTrip() else {return 0}
        return model.businessId == .Ride ? 4:3
        // return 3
        // Handy Splitup End
    }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      switch section {
      case 0:
        return 1
      case 1:
          guard let jobVM = self.viewController.jobDataModel else {  return 0 }
          guard let model = jobVM.getCurrentTrip()?.modifiedInvoice else { return 0 }
          return model.count
      case 2:
          // Handy Splitup Start
          let model = self.viewController.jobDataModel.getCurrentTrip()
          return model?.businessId == .Ride ? 1 : self.viewController.jobStatus.isTripCompleted ? 1 : 0
          // Handy Splitup End
      case 3:
          return self.viewController.jobStatus.isTripCompleted  ? 1 : 0
      default:
          return 0
      }
     }
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath)
    -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            guard let jobVM = self.viewController.jobDataModel else {  return UITableView.automaticDimension }
            guard let model = jobVM.getCurrentTrip()?.modifiedInvoice.value(atSafe: indexPath.row) else { return UITableView.automaticDimension }
            return model.bar == 1 ? 64 : 44
        case 2:
            return UITableView.automaticDimension
        case 3:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        case 2:
            return UITableView.automaticDimension
        case 3:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.viewController.jobDataModel else { return UITableViewCell() }
        guard let model = viewModel.getCurrentTrip()?.modifiedInvoice.value(atSafe: indexPath.row) else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") else { return UITableViewCell() }
            cell.addSubview(self.headerView)
            self.headerView.anchor(toView: cell,
                                   leading: 0,
                                   trailing: 0,
                                   top: 0,
                                   bottom: 0)
            cell.layoutIfNeeded()
            return cell
        case 1:
            
            let cell : PaymentTVC = fareDetailsTable.dequeueReusableCell(for: indexPath)
            cell.setTheme()
            if model.key == LangHandy.fareDetails && indexPath.row == 0  {
                if #available(iOS 12.0, *) {
                    let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
                    cell.serviceItem.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
                } else {
                    // Fallback on earlier versions
                }
                cell.dropDownImg.transform = self.viewController.jobDataModel.getCurrentTrip()?.showInvoice ?? false ? CGAffineTransform(rotationAngle: .pi) : .identity
                
                cell.setTheme()
                cell.serviceItem.font = .lightFont(size: 16)
                cell.rate.font = .lightFont(size: 16)
                cell.outerView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
                cell.outerView.borderWidth = 0
                cell.rate.text = ""
                cell.serviceItem.setTextAlignment()
                cell.serviceItem.text = LangHandy.fareDetails
                cell.currencySymbol.text = ""
                cell.borderView.borderColor = UIColor.clear
                cell.borderView.borderWidth = 0
                cell.borderView.cornerRadius = 0
                cell.dropDownImg.isHidden = false
                //        cell.borderView.backgroundColor = UIColor.clear
                cell.contentView.layoutIfNeeded()
                cell.contentView.layoutSubviews()
                cell.layoutIfNeeded()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    cell.layoutIfNeeded()
                }
            } else if model.bar == 1 && indexPath.row != 0 {
                cell.outerView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
                cell.borderView.borderColor = .clear
                cell.borderView.borderWidth = 0
                cell.borderView.cornerRadius = 0
                //                cell.borderView.backgroundColor = .SecondaryColor
                cell.dropDownImg.isHidden = true
                if #available(iOS 12.0, *) {
                    let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
                    cell.currencySymbol.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
                    cell.rate.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
                    cell.serviceItem.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
                }
                cell.serviceItem.font = .lightFont(size: 16)
                cell.rate.font = .lightFont(size: 16)
                //cell.outerView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 0)
                cell.outerView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
                cell.currencySymbol.text = "$"
                cell.rate.text = model.value
                cell.serviceItem.text = model.key
                cell.contentView.layoutIfNeeded()
                cell.contentView.layoutSubviews()
            } else {
                if #available(iOS 12.0, *) {
                    let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
                    cell.serviceItem.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
                }
                //                cell.serviceItem.textColor = .SecondaryTextColor
                cell.serviceItem.font = .lightFont(size: 16)
                cell.rate.font = .lightFont(size: 16)
                cell.outerView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
                cell.outerView.borderWidth = 0
                cell.currencySymbol.text = "$"
                cell.rate.text = model.value
                cell.serviceItem.text = model.key
                cell.borderView.borderColor = UIColor.clear
                cell.borderView.borderWidth = 0
                cell.borderView.cornerRadius = 0
                cell.dropDownImg.isHidden = true
                //                cell.borderView.backgroundColor = UIColor.clear
                cell.contentView.layoutIfNeeded()
                cell.contentView.layoutSubviews()
            }
            let comment = model.comment
            if !(comment.isEmpty){
                cell.serviceItem.text = cell.serviceItem.text! + " ⓘ"
                cell.serviceItem.addAction(for: .tap) { [unowned self] in
                    self.viewController.showPopOver(withComment: comment,
                                                    on : cell.serviceItem!)
                }
            }else{
                cell.serviceItem.addAction(for: .tap) {}
            }
            
            let colorStr = model.colour
            if !(colorStr.isEmpty) {
                let color = UIColor(named: colorStr.capitalized)//colorStr == "black" ? UIColor(hex: "000000") : UIColor(hex: "27aa0b")
                cell.serviceItem?.textColor = color
                cell.rate?.textColor = color
            }else{
                if #available(iOS 12.0, *) {
                    let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
                    cell.serviceItem.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
                    cell.rate.textColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
                }
            }
            cell.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                cell.layoutIfNeeded()
            }
            if indexPath.row == 0 {
                if self.viewController.jobDataModel.getCurrentTrip()?.showInvoice ?? false {
                    cell.outerView.setSpecificCornersForTop(cornerRadius: 10)
                    cell.outerView.clipsToBounds = true
                    cell.outerView.layoutIfNeeded()
                } else {
                    cell.outerView.cornerRadius = 10
                    cell.outerView.clipsToBounds = true
                    cell.outerView.layoutIfNeeded()
                }
            } else if indexPath.row == self.viewController.jobDataModel.getCurrentTrip()?.modifiedInvoice.count ?? 0 - 1 {
                cell.outerView.setSpecificCornersForBottom(cornerRadius: 10)
                cell.outerView.clipsToBounds = true
                cell.outerView.layoutIfNeeded()
            } else {
                cell.outerView.cornerRadius = 0
                cell.outerView.clipsToBounds = false
                cell.outerView.layoutIfNeeded()
            }
            return cell
        case 2:
            // Handy Splitup Start
            //Gofer splitup start
            let model = self.viewController.jobDataModel.getCurrentTrip()
            if model?.businessId == .Ride
                //&& self.viewController.jobDataModel.getCurrentTrip()?.jobStatus == TripStatus.completed
            {
                //Gofer splitup end
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "tripDistCell") else { return UITableViewCell() }
                cell.addSubview(self.tripDistView)
                self.tripDistView.anchor(toView: cell,
                                       leading: 0,
                                       trailing: 0,
                                       top: 0,
                                       bottom: 0)
                cell.layoutIfNeeded()
                return cell
                //Gofer splitup start
            }else{
                // Handy Splitup End
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") else { return UITableViewCell() }
                cell.addSubview(self.footerView)
                self.footerView.anchor(toView: cell,
                                       leading: 0,
                                       trailing: 0,
                                       top: 0,
                                       bottom: 0)
                cell.layoutIfNeeded()
                return cell
                // Handy Splitup Start
            }
            //Gofer splitup end
            // Handy Splitup End
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") else { return UITableViewCell() }
            cell.addSubview(self.footerView)
            self.footerView.anchor(toView: cell,
                                   leading: 0,
                                   trailing: 0,
                                   top: 0,
                                   bottom: 0)
            cell.layoutIfNeeded()
            return cell
        default:
            return UITableViewCell()
        }
        
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 &&
            indexPath.row == 0 {
            self.viewController.jobDataModel.getCurrentTrip()?.showInvoice = !(self.viewController.jobDataModel.getCurrentTrip()?.showInvoice ?? false)
            isFareDetailsShow = !isFareDetailsShow
            self.fareDetailsTable.reloadDataWithAutoSizingCellWorkAround()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.fareDetailsTable.reloadDataWithAutoSizingCellWorkAround()
            }
        }
    }
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        self.endEditing(true)

    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        let strRating = NSString(format: "%.2f", self.jobRatingView.rating) as String
        jobRatingView.rating = Float(strRating)!
    }
}

