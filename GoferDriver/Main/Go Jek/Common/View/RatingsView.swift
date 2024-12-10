//
//  RatingsView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 30/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class RatingsView: BaseView {
    
    //---------------------------------
    //MARK: - Outlets
    //---------------------------------
    
    @IBOutlet weak var tblRatings: CommonTableView!
    @IBOutlet weak var lblCurrentRating: ThemeMixLabel!
    @IBOutlet weak var lblLifeTimeTrips: ThemeMixLabel!
    @IBOutlet weak var lblRatedTrips: ThemeMixLabel!
    @IBOutlet weak var lblFiveStars: ThemeMixLabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var viewTopHeader: HeaderView!
    @IBOutlet weak var lblOnlineStatus: UILabel!
    @IBOutlet weak var ratingTitleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var borderLineView: UIView!
    @IBOutlet weak var yourCurrentRatingLabel: SecondaryHeaderLabel!
    @IBOutlet weak var starLabel: UILabel?
    @IBOutlet weak var lblLifeTime: SecondarySubHeaderLabel!
    @IBOutlet weak var lblRatedTitle: SecondarySubHeaderLabel!
    @IBOutlet weak var lbl5StarTitle: SecondarySubHeaderLabel!
    @IBOutlet weak var headerHolderView: SecondaryView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var lifeTimeStack: UIStackView!
    @IBOutlet weak var lifeRatedStack: UIStackView!
    @IBOutlet weak var fiveStarStack: UIStackView!
    @IBOutlet weak var thumbsDownIVHolderView: UIView!
    @IBOutlet weak var thumbsUpIVHolderView: UIView!
    @IBOutlet weak var thumbsUpIV: UIImageView!
    @IBOutlet weak var thumbsDownIV: UIImageView!
    
    //---------------------------------
    //MARK: - Local Variables
    //---------------------------------
    
    var ratingsVC : RatingsVC!
    
    
    //---------------------------------
    //MARK: - Overide Functions
    //---------------------------------
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.yourCurrentRatingLabel.customColorsUpdate()
        self.yourCurrentRatingLabel.textColor = .PrimaryColor
        self.headerHolderView.customColorsUpdate()
        self.ratingTitleLbl.customColorsUpdate()
        self.viewTopHeader.customColorsUpdate()
        self.tblRatings.customColorsUpdate()
        self.tblRatings.reloadData()
        self.lblLifeTime.customColorsUpdate()
        self.lblFiveStars.customColorsUpdate()
        self.lblRatedTrips.customColorsUpdate()
        self.lblRatedTitle.customColorsUpdate()
        self.lbl5StarTitle.customColorsUpdate()
        self.lblLifeTimeTrips.customColorsUpdate()
        self.filterBtn.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
    }
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.ratingsVC = baseVC as? RatingsVC
        self.initView()
        self.initLanuage()
        self.darkModeChange()
    }
    
    //---------------------------------
    //MARK: - initial Functions
    //---------------------------------
    
    func initView() {
        var rectTblView = tblRatings.frame
        rectTblView.size.height = self.frame.size.height-120
        tblRatings.frame = rectTblView
        self.filterBtn.setTitle("", for: .normal)
        self.filterBtn.isHidden = isSingleApplication
        self.filterBtn.setImage(UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.headerHolderView.clipsToBounds = true
        self.headerHolderView.cornerRadius = 15
        self.headerHolderView.elevate(4)
        self.lblCurrentRating.alpha = 0.0
        self.yourCurrentRatingLabel.transform = CGAffineTransform(translationX: 0, y: -50).concatenating(CGAffineTransform(scaleX: 1.2, y: 1.2))
        self.thumbsUpIV.image = UIImage(named: "thumb_like")?.withRenderingMode(.alwaysTemplate)
        self.thumbsUpIV.tintColor = .CompletedStatusColor
        self.thumbsDownIV.image = UIImage(named: "thumb_unlike")?.withRenderingMode(.alwaysTemplate)
        self.thumbsDownIV.tintColor = .CancelledStatusColor
        self.thumbsUpIVHolderView.isHidden = true
        self.thumbsDownIVHolderView.isHidden = true

    }
    
    func initLanuage(){
        self.yourCurrentRatingLabel.text = LangCommon.yourCurrentRating.capitalized
        self.ratingTitleLbl.text = LangCommon.ratings.capitalized
    }
    
    //---------------------------------
    //MARK: - Button Actions
    //---------------------------------
    
    @IBAction func backAction(_ sender : UIButton?){
        self.ratingsVC.exitScreen(animated: true)
    }
    
    @IBAction func filterBtnPressed(_ sender: Any) {
        // Handy Splitup Start
        guard let selected = AppWebConstants.selectedBusinessType.filter({$0.id == AppWebConstants.currentBusinessType.rawValue}).first else { return }
        let vc = CustomBottomSheetVC.initWithStory(self,
                                                   pageTitle: LangCommon.ratings,
                                                   selectedItem: [selected.name],
                                                   detailsArray: AppWebConstants.selectedBusinessType.compactMap({$0.name}), serviceArray: [])
        vc.isForTypeSelection = true
        self.ratingsVC.present(vc, animated: true) {
            print("CustomBottomSheetVC Presented Successfully")
        }
        // Handy Splitup End
    }
    //---------------------------------
    //MARK: - Local Functions
    //---------------------------------
    
    func setRatingHeaderInfo(_ ratingModel: RatingModel) {
        if ratingModel.driver_rating != "0.00" && ratingModel.driver_rating != "" {
            self.yourCurrentRatingLabel.isHidden = true
            self.yourCurrentRatingLabel.text = LangCommon.yourCurrentRating
            self.starLabel?.isHidden = false
            self.lblCurrentRating.isHidden = false
            UIView.animateKeyframes(withDuration: 0.8,
                                    delay: 0,
                                    options: [.layoutSubviews], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.6,
                                   relativeDuration: 0.4,
                                   animations: {
                    
                    self.lblCurrentRating.alpha = 1.0                    
                    if isRTLLanguage{
                        self.lblCurrentRating.alpha = 1.0
                    }
                })
                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: 1.0,
                                   animations: {
                    self.yourCurrentRatingLabel.transform = .identity
                })
            }) { (finished) in
            }
            if isRTLLanguage {
                let strUberName = UberSupport().createAttributUserName(originalText: String(format:"i %@",ratingModel.driver_rating) as NSString, normalText: String(format:"i %@",ratingModel.driver_rating) as NSString, textColor: lblCurrentRating.textColor, boldText: "i", fontSize: 25)
                self.lblCurrentRating.attributedText = strUberName
            } else {
                let strUberName = UberSupport().createAttributUserName(originalText: String(format:"i %@",ratingModel.driver_rating) as NSString, normalText: String(format:"i %@",ratingModel.driver_rating) as NSString, textColor: lblCurrentRating.textColor, boldText: "i", fontSize: 25)
                self.lblCurrentRating.attributedText = strUberName
            }
        } else {
            self.lblCurrentRating.isHidden = true
            self.yourCurrentRatingLabel.isHidden = false
            self.starLabel?.isHidden = true
            self.yourCurrentRatingLabel.text = LangCommon.yourCurrentRating
        }
        // Handy Splitup Start
        if AppWebConstants.currentBusinessType == .DeliveryAll || AppWebConstants.currentBusinessType == .Laundry || AppWebConstants.currentBusinessType == .Instacart{
            self.lblRatedTitle.isHidden = true
            self.lbl5StarTitle.isHidden = true
            self.thumbsUpIVHolderView.isHidden = false
            self.thumbsDownIVHolderView.isHidden = false
            self.lblRatedTrips.text = ratingModel.thumbsUpCount
            self.lblFiveStars.text = ratingModel.thumbsDownCount
            self.thumbsUpIV.isHidden = false
            self.thumbsDownIV.isHidden = false
        }else if AppWebConstants.currentBusinessType == .Ride {
            self.lblRatedTrips.isHidden = false
            self.lblRatedTrips.isHidden = false
            self.thumbsUpIV.isHidden = true
            self.lblFiveStars.isHidden = false
            self.lbl5StarTitle.isHidden = false
            self.thumbsDownIV.isHidden = true
            self.lblRatedTitle.isHidden = false
            self.thumbsUpIVHolderView.isHidden = true
            self.thumbsDownIVHolderView.isHidden = true
            self.lblRatedTitle.text = LangHandy.ratedJobs.capitalized
            self.lblRatedTrips.text = ratingModel.total_rating
            self.lblFiveStars.text = ratingModel.five_rating_count
          //  self.fiveStarStack.isHidden = true
         //   self.lifeTimeStack.isHidden = true
        }
        else if AppWebConstants.currentBusinessType == .Tow {
            self.lblRatedTrips.isHidden = false
            self.lblRatedTrips.isHidden = false
            self.thumbsUpIV.isHidden = true
            self.lblFiveStars.isHidden = false
            self.lbl5StarTitle.isHidden = false
            self.thumbsDownIV.isHidden = true
            self.lblRatedTitle.isHidden = false
            self.thumbsUpIVHolderView.isHidden = true
            self.thumbsDownIVHolderView.isHidden = true
            self.lblRatedTitle.text = LangHandy.ratedJobs.capitalized
            self.lblRatedTrips.text = ratingModel.total_rating
            self.lblFiveStars.text = ratingModel.five_rating_count
          //  self.fiveStarStack.isHidden = true
         //   self.lifeTimeStack.isHidden = true
        }
        else {
            self.thumbsUpIVHolderView.isHidden = true
            self.thumbsDownIVHolderView.isHidden = true
            self.thumbsUpIV.isHidden = true
            self.thumbsDownIV.isHidden = true
            self.lblRatedTrips.isHidden = false
            self.lblRatedTrips.isHidden = false
            self.lblFiveStars.isHidden = false
            self.lbl5StarTitle.isHidden = false
            self.lblRatedTitle.isHidden = false
            self.lblRatedTitle.text = LangHandy.ratedJobs.capitalized
            self.lbl5StarTitle.text = LangCommon.fiveStarTrips.capitalized
            self.lblRatedTrips.text = ratingModel.total_rating
            self.lblFiveStars.text = ratingModel.five_rating_count
            self.thumbsUpIVHolderView.isHidden = true
            self.thumbsDownIVHolderView.isHidden = true

        }
        // Handy Splitup End
        self.lblLifeTime.text = LangHandy.lifetimeJobs.capitalized
        self.lblLifeTimeTrips.text = ratingModel.total_rating_count
    }
}


//---------------------------------
//MARK: - tblRatings DataSource
//---------------------------------

extension RatingsView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellEarnItems = tblRatings.dequeueReusableCell(withIdentifier: "CellEarnItems") as! CellEarnItems
        cell.lblTitle.text = LangHandy.riderFeedBack.capitalized
        cell.lblSubTitle.text = LangHandy.checkOut.capitalized
        if isRTLLanguage {
            cell.lblArrow.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblTitle.textAlignment = NSTextAlignment.right
            cell.lblSubTitle.textAlignment = NSTextAlignment.right
        }
        cell.RatingBgView.clipsToBounds = true
        cell.RatingBgView.cornerRadius = 15
        cell.RatingBgView.elevate(4)
        cell.lblArrow.textColor = isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        cell.lblSubTitle.customColorsUpdate()
        cell.lblSubTitle.font = UIFont(name: G_MediumFont, size: 14)
        cell.lblTitle.customColorsUpdate()
        cell.lblTitle.font = UIFont(name: G_BoldFont, size: 18)
        cell.RatingBgView.customColorsUpdate()
        cell.setTheme()
        return cell
    }
}

//---------------------------------
//MARK: - tblRatings Delegate
//---------------------------------
extension RatingsView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userFeedBackVC = UserFeedbackVC.initWithStory()
        self.ratingsVC.navigationController?.pushViewController(userFeedBackVC, animated: true)
    }
}

//---------------------------------
//MARK: - CustomBottomSheet Delegate
//---------------------------------
extension RatingsView : CustomBottomSheetDelegate {
    func isDeselectAllSelected() {
    }
    
    func isSelectAllSelected(SelectAllValue: Bool) {
    }
    
    func serviceTypeSelected(SelectedItemName: String) {
    }
    
    func heatMapTapAction(selectedOptions: [String]) {
    }
    
   
    
    func TappedAction(indexPath: Int,
                      SelectedItemName: String) {
        // Handy Splitup Start
        if let result =  AppWebConstants.selectedBusinessType.filter({$0.name == SelectedItemName}).first {
            AppWebConstants.currentBusinessType = result.busineesType
            self.ratingsVC.callRatingAPI()
        }
        // Handy Splitup End
    }
    
    func ActionSheetCanceled() {
        print("Bottom Sheet is Cancelled Successfully")
    }
    
    func MultipleTapAction(selectedOptions: [String]) {
        // No Multiple Selection Here
    }
    
    
}
