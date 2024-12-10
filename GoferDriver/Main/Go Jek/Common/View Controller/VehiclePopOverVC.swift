//
//  VehiclePopOverVC.swift
//  GoferDriver
//
//  Created by trioangle on 23/04/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class VehiclePopOverVC: BaseVC {
    
    //MARK:- Outlets
    @IBOutlet weak var vehiclePopOverView : VehiclePopOverView!
    
    //MARK:- variables
    var menuResponse : MenuResponseProtocol!
    var menuPresenter : MenuPresenter!
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- init with story
    class func initWithStory(using menu : MenuResponseProtocol,
                             andPresenter presenter : MenuPresenter) -> VehiclePopOverVC {
        let vc : VehiclePopOverVC = UIStoryboard.gojekCommon.instantiateViewController()
        vc.menuResponse = menu
        vc.menuPresenter = presenter
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    //MARK:- WSto
    
    func updateVehicle(_ selectedVehicle : DynamicVehicleModel,profile : ProfileModel){
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared
            .getRequest(
                for: APIEnums.updateDefaultVehicle,
                   params: [
                    "vehicle_id" : selectedVehicle.id
                   ], showLoader: true)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                guard json.isSuccess else{
                    self.presentProjectError(message: json.status_message)
                    return
                }
                var updateVehicles = [DynamicVehicleModel]()
                for vehicle in profile.vehicles{
                    vehicle.isCurrentOrDefault = vehicle == selectedVehicle
                    updateVehicles.append(vehicle)
                }
                profile.vehicles = updateVehicles
                NotificationEnum.addressRefresh.postNotification()
                self.vehiclePopOverView.vehicleTable.reloadData()
            }).responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                self.presentProjectError(message: error)
            })
    }
    
}


