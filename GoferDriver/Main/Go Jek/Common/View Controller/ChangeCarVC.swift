/**
* ChangeCarVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
import Foundation
import MapKit

class ChangeCarVC : BaseVC {
    
    //---------------------------------
    // MARK: - Outlets
    //---------------------------------
    
    @IBOutlet weak var changeCarView : ChangeCarView!
    
    
    //---------------------------------
    // MARK: - Local Variables
    //---------------------------------
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var menuPresenter : MenuPresenter!
    
    //-------------------------------------
    // MARK: - View Controller Life Cycle
    //-------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.changeCarView.tblChangeCar.reloadData()
        self.menuPresenter.wsToGetUserProfileInfo()
    }
    
    //-------------------------------------
    // MARK: - initWithStory
    //-------------------------------------
    
    class func initWithStory(withPresenter presenter : MenuPresenter) -> ChangeCarVC{
        let view : ChangeCarVC = UIStoryboard.gojekCommon.instantiateViewController()
        view.menuPresenter = presenter
        return view
    }
    
    //-------------------------------------
    // MARK: - UDF
    //-------------------------------------
    
    func wstoDelete(vehicle : DynamicVehicleModel) {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared
            .getRequest(
                for: APIEnums.deleteVehicle,
                   params: ["id":vehicle.id],
                   showLoader: true)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                guard json.isSuccess else{
                    self.presentProjectError(message: json.status_message)
                    return
                }
                self.commonAlert
                    .setupAlert(
                        alert: appName,
                        alertDescription: json.status_message,
                        okAction: LangCommon.ok,
                        cancelAction: nil,
                        userImage: nil)
                self.commonAlert
                    .addAdditionalOkAction(
                        isForSingleOption: true) {
                    if let profile = self.menuPresenter.driverProfile{
                        profile.vehicles = profile.vehicles.filter({$0.id != vehicle.id})
                    }
                    self.changeCarView.tblChangeCar.reloadData()
                }
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                self.presentProjectError(message: error)
            })
    }
}
