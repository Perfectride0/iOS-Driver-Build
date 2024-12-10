//
//  ExtraTripFareVC.swift
//  GoferDriver
//
//  Created by trioangle on 21/10/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import UIKit



class ExtraTripFareVC: BaseVC {
    
    //------------------------------------------
    // MARK: - Outlets
    //------------------------------------------
    
    @IBOutlet var extraTripFareView : ExtraTripFareView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reasonViewHeight: NSLayoutConstraint!
    
    //------------------------------------------
    // MARK: - Local Variables
    //------------------------------------------
    
    var extraTripFareDelegate : ExtraTripFareDelegate?
    // Handy Splitup Start
    var businessID : Int!
    // Handy Splitup End
    
    //------------------------------------------
    // MARK: - View Controller Life Cycle
    //------------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------
    // MARK:- init With Story
    //------------------------------------------
    
    class func initWithStory(_ delegate : ExtraTripFareDelegate,
                             // Handy Splitup Start
                             businessID : Int
                             // Handy Splitup End
    )->ExtraTripFareVC{
        let view : ExtraTripFareVC = UIStoryboard.gojekHandyUnique.instantiateViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.extraTripFareDelegate = delegate
        // Handy Splitup Start
        view.businessID = businessID
        // Handy Splitup End
        return view
    }
    
    //------------------------------------------
    // MARK:- ws Functions
    //------------------------------------------
    
    func getExtraFeeOptions() {
        // Handy Splitup Start
        guard let businessID = businessID else {
            print("businessID Missing")
            return }
        // Handy Splitup End
        ConnectionHandler.shared
            .getRequest(
                for: .getExtraFeeOptions,
                   // Handy Splitup Start
                params: ["business_id":4]
                   // Handy Splitup Start // [:]
                   ,showLoader: true)
            .responseDecode(to: ExtraFareOptionModel.self) { (json) in
                if json.status_code == "1" {
                    self.extraTripFareView.fareOptions = json.toll_reasons
                } else {
                    //AppDelegate.shared.createToastMessage(json.status_message)
                }

            }
            .responseFailure { (error) in
                self.getExtraFeeOptions()
            }
    }
}


