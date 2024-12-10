//
//  UserFeedbackVCViewController.swift
//  GoferHandyProvider
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class UserFeedbackVC: BaseVC {

    @IBOutlet var userFeedbackView: UserFeedbackView!
    
    var darkMode = false
    var userFeedBack = feedBackModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRatingsDetails(page: 1)
        UIApplication.shared.statusBarView?.isHidden = true
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    class func initWithStory() -> UserFeedbackVC {
        let vc : UserFeedbackVC = UIStoryboard.gojekCommon.instantiateViewController()
        return vc
    }
    
    // Refresher
    lazy var userFeedBackRefresher : UIRefreshControl = {
        return self.getRefreshController()
    }()
    //MARK:- loaders
    lazy var userFeedBackLoader : UIActivityIndicatorView = {
        return self.getBottomLoader()
    }()
    
    func getRefreshController() -> UIRefreshControl{
        let refresher = UIRefreshControl()
        refresher.tintColor = .PrimaryColor
        refresher.attributedTitle = NSAttributedString(string: LangCommon.pullToRefresh)
        refresher.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        return refresher
    }
    
    @objc func onRefresh(_ sender : UIRefreshControl){
        self.userFeedbackView.usersFeedBackArr.removeAll()
        self.userFeedBack.feedBack?.userFeedback.removeAll()
        self.userFeedbackView.feedbackTableView.reloadData()
        self.getRatingsDetails(page: 1)
    }

    func getBottomLoader() -> UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.PrimaryColor
        spinner.hidesWhenStopped = true
        return spinner
    }
    
    
    
    
    func getRatingsDetails(page : Int) {
        // Handy Splitup Start
        let json : JSON = ["business_id" : AppWebConstants.currentBusinessType.rawValue] // [:]
        // Handy Splitup End
        self.userFeedBack.userFeedBackRequestApi(page: page,
                                                 params: json) { (result) in
            switch result {
            case .success(let model):
                if model.statusCode == "1" {
                    if model.currentPage == 1 {
                        self.userFeedbackView.usersFeedBackArr.removeAll()
                        self.userFeedbackView.usersFeedBackArr = model.userFeedback
                    } else {
                        self.userFeedbackView.usersFeedBackArr.append(contentsOf: model.userFeedback)
                    }
                    if self.userFeedBackRefresher.isRefreshing {
                        self.userFeedbackView.feedbackTableView.reloadData()
                        self.userFeedBackRefresher.endRefreshing()
                    }
                    self.userFeedBackLoader.stopAnimating()
                    self.userFeedbackView.currentPage = model.currentPage
                    self.userFeedbackView.remainigAPIHit = model.totalPages - model.currentPage
                    self.userFeedbackView.oneTimeHittedForUserFeedBack = !(model.currentPage == model.totalPages)
                    self.userFeedbackView.feedbackTableView.reloadData()
                } else {
                    if self.userFeedBackRefresher.isRefreshing {
                        self.userFeedbackView.feedbackTableView.reloadData()
                        self.userFeedBackRefresher.endRefreshing()
                    }
                    self.userFeedBackLoader.stopAnimating()
                    self.userFeedbackView.feedbackTableView.reloadData()
                }
            case .failure(let error):
                self.userFeedBackRefresher.endRefreshing()
                self.userFeedBackLoader.stopAnimating()
                self.userFeedbackView.feedbackTableView.reloadData()
                print("Error: \(error.localizedDescription)")
               // AppDelegate.shared.createToastMessage(error.localizedDescription)
            }
        }
        if !self.userFeedBackRefresher.isRefreshing {
            self.userFeedBackLoader.startAnimating()
        }
    }


}
