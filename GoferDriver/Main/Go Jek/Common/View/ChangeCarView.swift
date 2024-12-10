//
//  ChangeCarView.swift
//  GoferHandyProvider
//
//  Created by Trioangle on 04/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class ChangeCarView : BaseView {
    
    //---------------------------------
    // MARK: - Outlets
    //---------------------------------
    
    @IBOutlet weak var contentView: TopCurvedView!
    @IBOutlet weak var tblChangeCar: CommonTableView!
    @IBOutlet weak var lblPageTitle: SecondaryHeaderLabel!
    @IBOutlet weak var addBtn : SecondaryButton!
    @IBOutlet weak var headerView: HeaderView!
    
    //---------------------------------
    // MARK: - Local Variables
    //---------------------------------
    
    var changeCarVC : ChangeCarVC!
    var strVehicleName = ""
    var strVehicleNo = ""
    var strCarType = ""
    var profile : ProfileModel?
    var titleLabel = UILabel()
    
    //---------------------------------
    // MARK: - View Controller Cycle
    //---------------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.changeCarVC = baseVC as? ChangeCarVC
        self.initView()
        self.initLanguage()
        self.initObservers()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.contentView.customColorsUpdate()
        self.tblChangeCar.customColorsUpdate()
        self.tblChangeCar.reloadData()
        self.lblPageTitle.customColorsUpdate()
        self.addBtn.customColorsUpdate()
        self.addBtn.tintColor = .ThemeTextColor
        self.headerView.customColorsUpdate()
        self.headerView.customColorsUpdate()
    }
    
    //---------------------------------
    // MARK: - Initalisation Functions
    //---------------------------------
    
    func initView() {
        if let company_name = self.profile?.company_name {
            self.titleLabel.text = company_name
        }
        self.tblChangeCar.dataSource = self
        self.tblChangeCar.delegate = self
        self.titleLabel.textAlignment = .center
        self.tblChangeCar.tableHeaderView = self.titleLabel
        let add = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        self.addBtn.setImage(add,
                             for: .normal)
        //share ride feature hidden
        self.addBtn.isHidden = false
        if Shared.instance.isStoreDriver{
            self.addBtn.isHidden = true
        }else{
            self.addBtn.isHidden = false
        }
    }
    
    func initLanguage() {
        self.lblPageTitle.text = LangCommon.vehicleInformation.capitalized
    }
    
    func initObservers() {
        self.changeCarVC.menuPresenter.listenToUpdate { (driverData) in
            self.tblChangeCar.reloadData()
        }
    }
    
    //---------------------------------
    // MARK: - Action Functions
    //---------------------------------
    
    @IBAction
    func onBackTapped(_ sender:UIButton!) {
        self.changeCarVC.exitScreen(animated: true) {
            print("___________ Completed Exited From Change Car VC ___________")
        }
    }
    
    @IBAction
    func addAction(_ sender: UIButton){
        let newVehicleVC = NewVehicleVC.initWithStory(menuPresenter: self.changeCarVC.menuPresenter)
        self.changeCarVC.navigationController?.pushViewController(newVehicleVC, animated: true)
    }
    
    //---------------------------------
    // MARK: - Local Functions
    //---------------------------------
    
    func canEditVehicle() -> Bool {
        if DriverTripStatus.default == .Trip {//|| !UserDefaults.isNull(for: .rider_user_id)
            self.changeCarVC.presentAlertWithTitle(title: appName,
                                       message: LangCommon.inTripComplete.capitalized,
                                       options: LangCommon.ok.capitalized) { (_) in
                
            }
            return false
        }
        return true
    }
}

//---------------------------------
// MARK: - tblChangeCar DataSource
//---------------------------------

extension ChangeCarView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0//[0,1].contains(self.profile?.company_id) ? 0 : 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHolder:UIView = UIView()
        viewHolder.frame =  CGRect(x: 0, y:0, width: (self.frame.size.width) ,height: 35)
        viewHolder.backgroundColor = UIColor(red: 239.0 / 255.0, green: 238.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
        return titleLabel
        //return viewHolder
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vc = self.changeCarVC else { return 0 }
        if vc.menuPresenter.driverProfile?.vehicles.count == 0 {
            let lbl = SecondaryRegularBoldLabel()
            lbl.customColorsUpdate()
            lbl.textColor = .ThemeTextColor
            lbl.setTextAlignment(aligned: .center)
            lbl.text = LangCommon.noDataFound
            tableView.backgroundView = lbl
        } else {
            tableView.backgroundView = nil
        }
        return vc.menuPresenter.driverProfile?.vehicles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyVehicleTVC = tblChangeCar.dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        cell.setTheme()
        guard let vehicle = self.changeCarVC.menuPresenter.driverProfile?.vehicles.value(atSafe: indexPath.row) else { return cell }
        cell.nameLbl.text = vehicle.name
        cell.valueLbl.text = vehicle.licenseNumber
        if let carURL = URL(string: vehicle.vehicleImage) {
            cell.iconIV.isHidden = false
            cell.iconLbl.isHidden = true
            cell.iconIV.sd_setImage(with: carURL,
                                    placeholderImage: UIImage(named: "car_placeHolder"),
                                    options: .highPriority,
                                    context: nil,
                                    progress: nil,
                                    completed: nil)
        }else{
            cell.iconLbl.isHidden = false
            cell.iconIV.isHidden = true
        }
        cell.iconIV.image = cell.iconIV.image?.withRenderingMode(.alwaysTemplate)
        cell.iconIV.tintColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        cell.statusLbl.textColor = (vehicle.isActive != 0) ? .ThemeTextColor : .ErrorColor
        cell.vehicleLbl.text = vehicle.vehicleTypes.compactMap({$0.type}).joined(separator: ",")
        if vehicle.status == "Active"{
            cell.statusLbl.text = LangCommon.active
        }else{
            cell.statusLbl.text = LangCommon.inActive
        }
        cell.editDocumentBtn.isHidden = vehicle.documents.isEmpty
        cell.editDocumentBtn.addAction(for: .tap) {
            let dynamicDocVC = DynamicDocumentVC.initWithStory(for: .forVehicle(id: vehicle.id), using: vehicle.documents, menuPresenter: self.changeCarVC.menuPresenter)
            self.changeCarVC.navigationController?.pushViewController(dynamicDocVC, animated: true)
        }
        cell.editVehicleBtn.addAction(for: .tap) {
            let newVehicle = NewVehicleVC.initWithStory(menuPresenter: self.changeCarVC.menuPresenter, vehicle: vehicle)
            self.changeCarVC.navigationController?.pushViewController(newVehicle, animated: true)
        }
        cell.deleteBtn.addAction(for: .tap) {
            guard self.canEditVehicle() else{return}
            self.changeCarVC.commonAlert
                .setupAlert(
                    alert: appName,
                    alertDescription: LangCommon.sureToDeleteVehicle,
                    okAction: LangCommon.yes.capitalized,
                    cancelAction: LangCommon.no.capitalized,
                    userImage: nil)
            self.changeCarVC.commonAlert
                .addAdditionalOkAction(isForSingleOption: false) {
                    self.changeCarVC.wstoDelete(vehicle: vehicle)
            }
        }
        return cell
    }
}

//---------------------------------
// MARK: - tblChangeCar Delegate
//---------------------------------

extension ChangeCarView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
