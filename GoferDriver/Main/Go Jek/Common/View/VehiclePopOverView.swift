//
//  VehiclePopOverView.swift
//  GoferHandyProvider
//
//  Created by Trioangle on 03/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class VehiclePopOverView : BaseView {
    
    @IBOutlet weak var backView : UIView!
    @IBOutlet weak var popUpView : SecondaryView!
    @IBOutlet weak var vehicleIV : PrimaryImageView!
    @IBOutlet weak var vehicleNameLbl : SecondaryHeaderLabel!
    @IBOutlet weak var vehicleTable : CommonTableView!
    @IBOutlet weak var tableHeight : NSLayoutConstraint!
    @IBOutlet weak var manageVehicleBtn  : SecondaryButton!
    @IBOutlet weak var btnHolderView: SecondaryView!
    @IBOutlet weak var addVehicleBtn  : PrimaryButton!
    
    
    //MARK:- Local Variable
    var vehiclePopOverVC: VehiclePopOverVC!
    
    //MARK:- View life cycle
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.vehiclePopOverVC = baseVC as? VehiclePopOverVC
        self.initView()
        self.initLanguage()
        self.initGestures()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.initLayer()
        }
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.backView.backgroundColor = .clear
        self.popUpView.customColorsUpdate()
        self.vehicleIV.customColorsUpdate()
        self.vehicleNameLbl.customColorsUpdate()
        self.vehicleTable.customColorsUpdate()
        self.vehicleTable.reloadData()
        self.manageVehicleBtn.customColorsUpdate()
        self.btnHolderView.customColorsUpdate()
        self.addVehicleBtn.customColorsUpdate()
        self.addVehicleBtn.cornerRadius = 10
    }
    
    //MARK:- Action
    @IBAction func manageVehicleAction(_ sender : UIButton?){
        self.vehiclePopOverVC.dismiss(animated: true) {
            let changeVC = ChangeCarVC.initWithStory(withPresenter: self.vehiclePopOverVC.menuPresenter)
            self.vehiclePopOverVC.menuResponse.routeToView(changeVC)
        }
    }
    @IBAction func addVehcileAction(_ sender : UIButton){
        let newVehicleVC = NewVehicleVC.initWithStory(menuPresenter: self.vehiclePopOverVC.menuPresenter)
        self.vehiclePopOverVC.menuResponse.routeToView(newVehicleVC)
        self.vehiclePopOverVC.dismiss(animated: false, completion: nil)
    }
    
    func initView(){
        self.vehicleTable.dataSource = self
        self.vehicleTable.delegate = self
        self.vehicleNameLbl.setTextAlignment()
        isStoreDriver()
    }
    
    func isStoreDriver(){
        if Shared.instance.isStoreDriver{
            self.addVehicleBtn.isHidden = true
        }else{
            self.addVehicleBtn.isHidden = false
        }
    }
    
    func initLanguage(){
        self.vehicleNameLbl.text = LangCommon.selectVehicle.capitalized
        self.vehicleIV.image = UIImage(named: "choose_vehicle")
        self.manageVehicleBtn.setTitle(LangCommon.manageVehicle.capitalized, for: .normal)
        self.vehicleIV.tintColor = .PrimaryColor
        self.addVehicleBtn.setTitle(LangCommon.addNew.capitalized, for: .normal)
    }
    func initLayer(){
        self.popUpView.clipsToBounds = true
        self.popUpView.cornerRadius = 15
        self.manageVehicleBtn.cornerRadius = 10
        self.manageVehicleBtn.elevate(2)
    }
    func initGestures(){
        self.backView.addAction(for: .tap) {
            self.vehiclePopOverVC.menuResponse.refreshVehcileView()
            self.vehiclePopOverVC.dismiss(animated: true, completion: nil)
        }
    }
}

extension VehiclePopOverView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.vehiclePopOverVC.menuPresenter.driverProfile?.vehicles.count ?? 0
        let maxHeight = self.frame.height * 0.55
        let minHeight = CGFloat(60 * 0)
        let calculated : CGFloat = CGFloat(60 * count)
        self.tableHeight.constant = min(max(calculated, minHeight),maxHeight)
        print("________________ number of Rows \(count) __________________")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let cell : VehicleRadioTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let vehicle = self.vehiclePopOverVC.menuPresenter.driverProfile?.vehicles.value(atSafe: indexPath.row) else{
            return cell
        }
        let image = vehicle.isCurrentOrDefault ? UIImage(named:"radio_on")?.withRenderingMode(.alwaysTemplate) : UIImage(named:"radio_off")?.withRenderingMode(.alwaysTemplate)
        cell.radioIV.image = image
        cell.vehicleNameLbl.text = vehicle.name
        cell.numberLbl.isHidden = vehicle.licenseNumber.isEmpty
        cell.numberLbl.text = "(\(vehicle.licenseNumber))"
        cell.contentView.alpha = (vehicle.isActive != 0) ? 1 : 0.5
        cell.setTheme()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension VehiclePopOverView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let data = self.vehiclePopOverVC.menuPresenter.driverProfile,
              let selectedVehicle = data.vehicles.value(atSafe: indexPath.row) else{return}
        if selectedVehicle.isCurrentOrDefault {
            return
        }
        if (selectedVehicle.isActive == 0) {
            self.vehiclePopOverVC.presentAlertWithTitle(title: appName,
                                                        message: LangCommon.vehicleIsNotActive.capitalized,
                                                        options: LangCommon.ok.capitalized) { (_) in
                
            }
            return
        }
        
        if DriverTripStatus.default == .Trip {//|| !UserDefaults.isNull(for: .rider_user_id)
            self.vehiclePopOverVC.presentAlertWithTitle(title: appName,
                                                        message: LangCommon.inTripComplete.capitalized,
                                                        options: LangCommon.ok.capitalized) { (_) in
                                        
            }
            return
        }
        self.vehiclePopOverVC.updateVehicle(selectedVehicle, profile: data)
        
    }
        
    
}
