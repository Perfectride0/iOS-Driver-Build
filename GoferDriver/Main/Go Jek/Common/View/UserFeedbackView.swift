//
//  UserFeedbackView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class UserFeedbackView: BaseView {

    var oneTimeHittedForUserFeedBack: Bool = true
    
    @IBOutlet weak var feedbackTableView: CommonTableView!
    @IBOutlet weak var navTitleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var navigationView: HeaderView!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    
    var viewController: UserFeedbackVC!
    var  usersFeedBackArr:Array<UserFeedback> = []
    var remainigAPIHit : Int = 0
    var currentPage : Int = 1
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.navigationView.customColorsUpdate()
        self.navTitleLbl.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.feedbackTableView.customColorsUpdate()
        self.feedbackTableView.reloadData()
    }
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.feedbackTableView.delegate = self
        self.navTitleLbl.textAlignment = .natural
        self.navTitleLbl.text = LangHandy.riderFeedBack.capitalized
        self.viewController = baseVC as? UserFeedbackVC
        self.feedbackTableView.dataSource = self
        self.feedbackTableView.register(FeedbackTVC.nib, forCellReuseIdentifier: FeedbackTVC.reuseId)
        self.initView()
        self.darkModeChange()
    }
    
    func initView() {
        self.feedbackTableView.tableFooterView = self.viewController.userFeedBackLoader
        self.feedbackTableView.refreshControl = self.viewController.userFeedBackRefresher
        self.backgroundColor = .PrimaryColor
    }

    @IBAction func backButtonAction(_ sender: Any) {
       self.viewController.navigationController?.popViewController(animated: true)
    }

}

extension UserFeedbackView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = usersFeedBackArr.count
        if count == 0 && !self.viewController.userFeedBackLoader.isAnimating && !self.viewController.userFeedBackRefresher.isRefreshing {
            let noDataLabel = UILabel()
            noDataLabel.font = .MediumFont(size: 15)
            noDataLabel.text = LangCommon.noDataFound
            noDataLabel.textColor = UIColor.ThemeTextColor
            noDataLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = noDataLabel
        } else {
            tableView.backgroundView = nil
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTVC.reuseId) as! FeedbackTVC
        cell.ratingView.isUserInteractionEnabled = false
        guard let model = self.usersFeedBackArr.value(atSafe: indexPath.row) else { return UITableViewCell() }
        cell.accessibilityHint = (indexPath.row + 1).description
//        cell.ratingCountLbl.text = model.providerRating.description
        cell.userNameLbl.text = model.userName.description
        cell.dateLbl.text = model.date
        cell.expandableImageView.isHidden = true
        if model.providerComments != "" {
            cell.expandableImageView.isHidden = false
        }
        // Handy Splitup Start
        cell.ratingCountLbl.isHidden = AppWebConstants.currentBusinessType == .DeliveryAll
        cell.thumbsIV.isHidden = !(AppWebConstants.currentBusinessType == .DeliveryAll)
        if AppWebConstants.currentBusinessType == .DeliveryAll {
            cell.thumbsIV.image = model.isThumbsUp ? UIImage(named: "thumb_like")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "thumb_unlike")?.withRenderingMode(.alwaysTemplate)
            cell.thumbsIV.tintColor = model.isThumbsUp ? .CompletedStatusColor : .CancelledStatusColor
        } else {
            // Handy Splitup End
            let vals = Float(model.providerRating)
            if !vals.isZero {
                let textAtt = NSMutableAttributedString()
                    .bold("★ \(vals) ",fontSize: 14)
                textAtt.setColorForText(textToFind: "★", withColor: .ThemeYellow)
                textAtt.setColorForText(textToFind: "\(vals)",
                                        withColor: self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor)
                cell.ratingCountLbl.attributedText = textAtt
            }
            // Handy Splitup Start
        }
        // Handy Splitup End
        cell.ratingView.isHidden = true
        cell.userProfileImageView?.sd_setImage(with: NSURL(string: model.src)! as URL, placeholderImage:UIImage(named:"user_dummy"))
        if model.selectionState == .collapsed {
            if isRTLLanguage {
                cell.expandableImageView.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                cell.expandableImageView.transform = .identity
            }
            cell.feedbackdescriptionLbl.text = ""
        } else {
            cell.expandableImageView.transform = CGAffineTransform(rotationAngle: .pi/2)
            cell.feedbackdescriptionLbl.text = model.providerComments
        }
        cell.ThemeUpdate()
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.paginationForUserFeedBack()
    }
    
    func paginationForUserFeedBack() {
        let cell = self.feedbackTableView.visibleCells.last
        if cell?.accessibilityHint == self.usersFeedBackArr.count.description && oneTimeHittedForUserFeedBack && remainigAPIHit != 0 {
            self.viewController.getRatingsDetails(page: self.currentPage + 1)
            print("å:: This is Last For Completed")
            self.oneTimeHittedForUserFeedBack = !self.oneTimeHittedForUserFeedBack
        } else {
            print("å:: Already Hitted Api Completed or Nothing To Hit")
        }
    }
    
    func onImageViewTapped(_ row:Int) {
        if  self.usersFeedBackArr[row].selectionState == .collapsed {
            self.usersFeedBackArr[row].selectionState = .expand
        }else {
            self.usersFeedBackArr[row].selectionState = .collapsed
        }
        self.feedbackTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onImageViewTapped(indexPath.row)
    }
    
}
