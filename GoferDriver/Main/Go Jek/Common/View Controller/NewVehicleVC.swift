//
//  NewVehicleVC.swift
//  GoferDriver
//
//  Created by trioangle on 06/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


enum VehicleSectionA : Int {
    case make = 0
    case model
    case year
    case licenePlate
    case color
    static let count = 5
}

class NewVehicleVC: BaseVC {
    
    //---------------------------------
    // MARK: - Outlets
    //---------------------------------
    
    @IBOutlet weak var newVehicleView : NewVehicleView!
    
    //---------------------------------
    // MARK: - Local Variables
    //---------------------------------
    
    var menuPresenter : MenuPresenter!
    var currentVehicle : DynamicVehicleModel = .init()
    var originalVehicleData : DynamicVehicleModel? = nil
    var somearray = [VehicleType]()
    var servicearray = [Int]()
    //-------------------------------------
    // MARK: - View Controller Life Cycle
    //-------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.wsToFetchBaseData()
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    //-------------------------------------
    // MARK: - initWithStory
    //-------------------------------------
    
    class func initWithStory(menuPresenter : MenuPresenter,
                             vehicle : DynamicVehicleModel? = nil) -> NewVehicleVC{
        let vc : NewVehicleVC = UIStoryboard.gojekCommon.instantiateViewController()
        vc.menuPresenter = menuPresenter
        if let _vehicle = vehicle{
            vc.currentVehicle = DynamicVehicleModel(copy: _vehicle)
            vc.originalVehicleData = _vehicle//copying original data
        }
        return vc
    }
    
    //-------------------------------------
    // MARK: - WebService
    //-------------------------------------
    func wsToFetchBaseData() {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared
            .getRequest(
                for: APIEnums.vehicleDescription,
                   params: [:],
                   showLoader: true)
            .responseDecode(to: VehicleDescription.self, { response in
                UberSupport.shared.removeProgressInWindow()
                if !self.currentVehicle.isNewVehicle {
                    self.newVehicleView.selectedMake = response.make.filter({$0.id == self.currentVehicle.make?.id}).first
                    self.newVehicleView.selectedMake?.selectedModel = self.newVehicleView.selectedMake?.model.filter({$0.id == self.currentVehicle.make?.selectedModel?.id }).first
                    response.requestOptions.forEach { (request) in
                        request.isSelected =
                        self.currentVehicle.requestOptions.filter({$0.id == request.id}).first?.isSelected ?? false
                    }
                    response.vehicleTypes.forEach { (vehicle) in
                        vehicle.isSelected =  self.currentVehicle.vehicleTypes.compactMap({$0.type}).contains(vehicle.type)
                    }
                }
                response.vehicleTypes.forEach { (vehicle) in
                    vehicle.isSelected =  self.currentVehicle.vehicleTypes.compactMap({$0.type}).contains(vehicle.type)
                    
                    if let _ = self.newVehicleView.VehicleList[vehicle.businessType] {
                        self.newVehicleView.VehicleList[vehicle.businessType]?.append(vehicle)
                    } else {
                        self.newVehicleView.VehicleList[vehicle.businessType] = [vehicle]
                    }
                }
                var some = (response.vehicleTypes.forEach({ new in
                    if new.businessID == 7{
                        self.somearray.append(new)
                    }
                }))
               self.somearray.forEach({ new in
                   if !self.servicearray.contains(new.service_id){
                       self.servicearray.append(new.service_id)
                   }
                 
                   
                })
                dump(self.somearray)
                dump(self.servicearray)
                for (name,_) in self.newVehicleView.VehicleList {
                    self.newVehicleView.categoryNames.append(name)
                }
                
                for details in self.newVehicleView.VehicleList[.Tow] ?? [] {
                    if let serviceID = details.service_id as? Int {
                        if var existingArray = self.newVehicleView.serviceIdArrays[serviceID] {
                            existingArray.append(details)
                            self.newVehicleView.serviceIdArrays[serviceID] = existingArray
                        } else {
                            self.newVehicleView.serviceIdArrays[serviceID] = [VehicleType(id: 0, type: "", businessID: details.businessID, location: details.location, service_id: 0, service_name: details.service_name, isTitle: true),details]
                        }
                    }
                }
                
                var itemsCount = 0
                //var itemsss = [VehicleType]()
                for (serviceID, items) in self.newVehicleView.serviceIdArrays {
                    print("Array for service_id \(serviceID):", items)
                    itemsCount = itemsCount + items.count
                    
                    self.newVehicleView.TowVechileType.append(contentsOf: items)
                }
                
                
                self.newVehicleView.vehicleDescription = response
                self.newVehicleView.vehicleDetailTableView.reloadData()
                
            })
        //            .responseJSON({ (json) in
        //                UberSupport.shared.removeProgressInWindow()
        //                let descriptions = VehicleDescription(json)
        //                if !self.currentVehicle.isNewVehicle {
        //                    
        //                    self.newVehicleView.selectedMake = descriptions.make.filter({$0.item.id == self.currentVehicle.make.item.id}).first
        //                    self.newVehicleView.selectedMake?.selectedModel = self.newVehicleView.selectedMake?.models.filter({$0.id == self.currentVehicle.make.selectedModel?.id }).first
        //                    descriptions.requestOptions.forEach { (request) in
        //                        request.isSelected =
        //                            self.currentVehicle.requestOptions.filter({$0.id == request.id}).first?.isSelected ?? false
        //
        //                    }
        //                    descriptions.vehicleTypes.forEach { (vehicle) in
        //                        vehicle.isSelected =  self.currentVehicle.vehicleTypes.compactMap({$0.type}).contains(vehicle.type)
        //                        
        //                    }
        //                }
        //                descriptions.vehicleTypes.forEach { (vehicle) in
        //                    vehicle.isSelected =  self.currentVehicle.vehicleTypes.compactMap({$0.type}).contains(vehicle.type)
        //                    if let _ = self.newVehicleView.VehicleList[vehicle.businessType] {
        //                        self.newVehicleView.VehicleList[vehicle.businessType]?.append(vehicle)
        //                    } else {
        //                        self.newVehicleView.VehicleList[vehicle.businessType] = [vehicle]
        //                    }
        //                }
        //                
        //                
        //                for (name,_) in self.newVehicleView.VehicleList {
        //                    self.newVehicleView.categoryNames.append(name)
        //                }
        //                self.newVehicleView.vehicleDescription = descriptions
        //                self.newVehicleView.vehicleDetailTableView.reloadData()
        //                
        //            })
            .responseFailure({ (error) in
                self.newVehicleView.vehicleDetailTableView.reloadData()
                UberSupport.shared.removeProgressInWindow()
                //AppDelegate.shared.createToastMessage(error)
            })
    }
    
    //-------------------------------------
    // MARK: - UDF
    //-------------------------------------
    
    func wsToSubmit(params: JSON) {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        ConnectionHandler.shared
            .getRequest(
                for: APIEnums.addUpdaeVehicle,
                   params: params,
                   showLoader: true)
            .responseDecode(to: UpdateVehicleModel.self, { (response) in
                if response.statusCode == 1 {
                    UberSupport.shared.removeProgressInWindow()
                    self.menuPresenter.driverProfile?.vehicles = response.vehicleDetails
                    self.exitScreen(animated: true) {
                        print("___________ New Vehicle VC Exit __________")
                    }
                } else {
                    self.presentAlertWithTitle(
                        title: appName,
                        message: response.statusMessage,
                        options: LangCommon.ok) { (_) in }
                }
            })
            .responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                self.presentAlertWithTitle(
                    title: appName,
                    message: error,
                    options: LangCommon.ok) { (_) in
                        
                    }
            })
    }
    
}




