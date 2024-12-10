//
//  NewVehicleView.swift
//  GoferHandyProvider
//
//  Created by Trioangle on 04/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

import UIKit


class NewVehicleView : BaseView {
    
    //---------------------------------
    // MARK: - Outlets
    //---------------------------------
    
    @IBOutlet weak var submitBtn : PrimaryButton!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var navView : HeaderView!
    @IBOutlet weak var vehicleDetailTableView : CommonTableView!
    @IBOutlet weak var bottomView : TopCurvedView!
    @IBOutlet weak var contentHolderView : TopCurvedView!
    
    //---------------------------------
    // MARK: - Local Variables
    //---------------------------------
    
    var newVehicleVC : NewVehicleVC!
    var vehicleDescription : VehicleDescription? = nil
    var selectedMake : Make? = nil
    var popUpForSection : VehicleSectionA? = nil
    var categoryNames = [BusinessType]()
    let staticSection : Int = 3
    var VehicleList = [BusinessType : [VehicleType]]()
    var serviceIdArrays: [Int: [VehicleType]] = [:]
    var TowVechileType: [VehicleType] = [];
    //-------------------------------------
    // MARK: - View Controller Life Cycle
    //-------------------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.newVehicleVC = baseVC as? NewVehicleVC
        self.initView()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.titleLbl.customColorsUpdate()
        self.navView.customColorsUpdate()
        self.vehicleDetailTableView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.vehicleDetailTableView.reloadData()
    }
    
    //---------------------------------
    // MARK: - Initalisation Function
    //---------------------------------
    
    func initView(){
        self.vehicleDetailTableView.dataSource = self
        self.vehicleDetailTableView.delegate = self
        self.submitBtn.setTitle(LangCommon.submit.uppercased(), for: .normal)
        self.titleLbl.text = self.newVehicleVC.currentVehicle.isNewVehicle ? LangCommon.addVehicle.capitalized : LangCommon.editVehicle.capitalized
    }
    
    //---------------------------------
    // MARK: - Action Function
    //---------------------------------
    
    @IBAction func backAction(_ sender : UIButton?) {
        if self.isValidInPut() {
            self.newVehicleVC.commonAlert
                .setupAlert(
                    alert: appName,
                    alertDescription: LangCommon.allProgressDiscard,
                    okAction: LangCommon.ok.capitalized,
                    cancelAction: LangCommon.cancel.capitalized,
                    userImage: nil)
            self.newVehicleVC.commonAlert
                .addAdditionalOkAction(isForSingleOption: false) {
                    self.newVehicleVC.exitScreen(animated: true) {
                        print("___________ New Vehicle VC Exit __________")
                    }
                }
        }else{
            self.newVehicleVC.exitScreen(animated: true) {
                print("___________ New Vehicle VC Exit __________")
            }
        }
    }
    
    @IBAction func submitAction(_ sender : UIButton?) {
        let currentVehicle =  self.newVehicleVC.currentVehicle
        var params = [
            "make_id": self.selectedMake?.id ?? 0,
            "model_id": self.selectedMake?.selectedModel?.id ?? 0,
            "year" : currentVehicle.year,
            "vehicle_number": currentVehicle.licenseNumber,
            "color": currentVehicle.color
        ] as [String : Any]
        var result : [String] = []
        for name in self.categoryNames {
            if let list = self.VehicleList[name]?.filter({$0.isSelected})
                .compactMap({$0.id.description}) {
                if list.isNotEmpty {
                    result.append(list.joined(separator: ","))
                }
            }
        }
        let resultValue = result.joined(separator: ",")
        params["vehicle_type"] = resultValue
        if let requests = self.vehicleDescription?.requestOptions
            .filter({$0.isSelected})
            .compactMap({$0.id.description}){
            params["options"] = requests.joined(separator: ",")
        }
        if !self.newVehicleVC.currentVehicle.isNewVehicle {
            guard self.canEditVehicle() else{return}//If old vehicle driver should not be in trip
            params["id"] = self.newVehicleVC.currentVehicle.id
        }
        self.newVehicleVC.wsToSubmit(params: params)
    }
    
    //---------------------------------
    // MARK: - Local Function
    //---------------------------------
    
    func isValidInPut() -> Bool{
        if !self.newVehicleVC.currentVehicle.isNewVehicle {
            if let existing = self.newVehicleVC.originalVehicleData {
                let vehicle = self.vehicleDescription?
                    .vehicleTypes.filter({$0.isSelected})
                    .compactMap({$0.id}).sorted()
                let existVehicle = existing.vehicleTypes
                    .compactMap({$0.id}).sorted()
                let requests = self.vehicleDescription?.requestOptions
                    .filter({$0.isSelected})
                    .compactMap({$0.id}).sorted()
                let existRequests = existing.requestOptions
                    .filter({$0.isSelected})
                    .compactMap({$0.id}).sorted()
                let notChanged = existing.make?.id == self.selectedMake?.id &&
                existing.make?.selectedModel?.id == self.selectedMake?.selectedModel?.id &&
                existing.color == self.newVehicleVC.currentVehicle.color &&
                existing.licenseNumber == self.newVehicleVC.currentVehicle.licenseNumber &&
                existing.year == self.newVehicleVC.currentVehicle.year &&
                vehicle == existVehicle
                let requestChanged = requests != existRequests

               return (!notChanged) || requestChanged
            }
            return false
        }
        if self.selectedMake != nil && //let vehicleDesc = self.vehicleDescription,
           self.selectedMake?.selectedModel != nil &&
            self.newVehicleVC.currentVehicle.allFieldEntered {
            if self.selectedMake!.isVehicleNumber {
                return self.newVehicleVC.currentVehicle.islicenseNumberEntered
            }
            //!vehicleDesc.vehicleTypes.filter({$0.isSelected}).isEmpty{
            return true
        }
        return false
    }
    
    func checkStatus() {
        self.submitBtn.backgroundColor = self.isValidInPut() ? .PrimaryColor : .TertiaryColor
        self.submitBtn.isUserInteractionEnabled = self.isValidInPut()
    }
    
    func canEditVehicle() -> Bool {
        if DriverTripStatus.default == .Trip {
            self.newVehicleVC.commonAlert
                .setupAlert(
                    alert: appName,
                    alertDescription: LangCommon.inTripComplete.capitalized,
                    okAction: LangCommon.ok.capitalized,
                    cancelAction: nil,
                    userImage: nil)
            return false
        }
        return true
    }
}


extension NewVehicleView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.checkStatus()

        
        
  

        // Result arrays
//        for (serviceID, items) in serviceIdArrays {
//            print("Array for service_id \(serviceID):", items)
//        }

        
       
        
        return self.staticSection + self.categoryNames.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return VehicleSectionA.count
        case 1:
            return AppWebConstants.selectedBusinessType.contains(where: {$0.busineesType == .Ride}) ? self.vehicleDescription?.requestOptions.count ?? 0 : 0
        case 2:
            return 0
        case self.staticSection...tableView.numberOfSections:
            if categoryNames[section - self.staticSection] == .Tow {

                return TowVechileType.count
            }else{
                return self.VehicleList[categoryNames[section - self.staticSection]]?.count ?? 0
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case self.staticSection...tableView.numberOfSections:
            let space: CGFloat = 25
            let holderView = UIView()
            let lbl = SecondarySubHeaderLabel(frame: CGRect(x: space, y: 0, width: (tableView.frame.width - space * 2), height: 40))
            lbl.customColorsUpdate()
            lbl.setTextAlignment()
            lbl.text = "\(self.categoryNames[section - self.staticSection].LocalizedString)"
            holderView.backgroundColor = .clear
            holderView.addSubview(lbl)
            return holderView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case self.staticSection...tableView.numberOfSections:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell : NewVehicleATVC = tableView.dequeueReusableCell(for: indexPath)
            cell.textField.isUserInteractionEnabled = false
            cell.dropDownIV.isHidden = false
            cell.textField.setTextAlignment()
            switch VehicleSectionA(rawValue: indexPath.row)!{
            case .make:
                cell.setPlaceHolder(text:  LangCommon.make.capitalized)
                cell.setValue(self.selectedMake?.name)
            case .model:
                cell.setPlaceHolder(text:  LangCommon.model.capitalized)
                cell.setValue(self.selectedMake?.selectedModel?.name)
            case .year:
                cell.setPlaceHolder(text: LangCommon.year.capitalized)
                cell.setValue(self.newVehicleVC.currentVehicle.year)
            case .licenePlate:
                cell.dropDownIV.isHidden = true
                cell.setPlaceHolder(text:  LangCommon.vehicleNumber.capitalized)
                cell.setValue(self.newVehicleVC.currentVehicle.licenseNumber)
                cell.textField.isUserInteractionEnabled = true
            case .color:
                cell.dropDownIV.isHidden = true
                cell.setPlaceHolder(text: LangCommon.color.capitalized)
                cell.setValue(self.newVehicleVC.currentVehicle.color)
                cell.textField.isUserInteractionEnabled = true
            }
            cell.textField.tag = indexPath.row
            cell.textField.delegate = self
            if Shared.instance.isStoreDriver{
                cell.textField.isUserInteractionEnabled = false
            }else{
                cell.textField.isUserInteractionEnabled = true
            }
            cell.setTheme()
            if let make = self.selectedMake ,
               !make.isVehicleNumber &&  VehicleSectionA(rawValue: indexPath.row) == .licenePlate {
                cell.holderView.isHidden = true
            } else {
                cell.holderView.isHidden = false
            }
            return cell
        case 1:
            let cell : NewVehicleDTVC = tableView.dequeueReusableCell(for: indexPath)
            guard let request = self.vehicleDescription?.requestOptions.value(atSafe: indexPath.row) else{
                return cell
            }
            cell.populate(with: request)
            return cell
        case 2:
            let cell : NewVehicleBTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.setTheme()
            return cell
        case self.staticSection...tableView.numberOfSections:
            if categoryNames[indexPath.section - self.staticSection] == .Tow {
                if self.TowVechileType[indexPath.row].isTitle{
//                    let cell : NewVehicleDTVC = tableView.dequeueReusableCell(for: indexPath)
//                    guard let vehicle = self.TowVechileType.value(atSafe: indexPath.row) else { return cell }
//                    cell.optionTitleLbl.text = vehicle.service_name
//                    cell.checkboxIV.isHidden = true
//                    cell.backgroundColor = .red
////                    cell.secondaryView.isHidden = true//cell.hideSecondary
////                    cell.populate(withVehicle: vehicle)
////                    cell.setTheme()
//                    return cell
                }else{
                    let cell : NewVehicleCTVC = tableView.dequeueReusableCell(for: indexPath)
                    guard let vehicle = self.TowVechileType.value(atSafe: indexPath.row) else { return cell }
                    cell.secondaryView.isHidden = true//cell.hideSecondary
                    cell.populate(withVehicle: vehicle)
                    cell.setTheme()
                    return cell
                }
            }
            let cell : NewVehicleCTVC = tableView.dequeueReusableCell(for: indexPath)
            guard let vehicle = self.VehicleList[categoryNames[indexPath.section - self.staticSection]]?.value(atSafe: indexPath.row) else { return cell }
            cell.secondaryView.isHidden = true//cell.hideSecondary
            cell.populate(withVehicle: vehicle)
            cell.setTheme()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}


extension NewVehicleView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case self.staticSection...tableView.numberOfSections:
            if categoryNames[indexPath.section - self.staticSection] == .Tow {
                if self.TowVechileType[indexPath.row].isTitle{
                    return 100
                }else{
                    return 100
                }
               
            }else{
                return 100
            }
            
        default:
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Shared.instance.isStoreDriver{
            return
        }
        
        switch indexPath.section {
        case 0:
            if indexPath.row >= VehicleSectionA.licenePlate.rawValue { return }
            let rect = tableView.rectForRow(at: indexPath)
            var datas = [String]()
            var title = "Sample"
            switch VehicleSectionA(rawValue: indexPath.row)! {
            case .make:
                title = LangCommon.selectMake.capitalized
                self.popUpForSection = .make
                datas = self.vehicleDescription?.make.compactMap({$0.name}) ?? []
            case .model:
                guard let make = self.selectedMake else{
                    self.newVehicleVC.commonAlert
                        .setupAlert(
                            alert: appName,
                            alertDescription: LangCommon.pleaseSelectMake,
                            okAction: LangCommon.ok.capitalized,
                            cancelAction: nil,
                            userImage: nil)
                    self.newVehicleVC.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
                        
                    }
                    return
                }
                title = LangCommon.selectModel.capitalized
                self.popUpForSection = .model
                datas = make.model.compactMap({$0.name})
            case .year:
                title = LangCommon.selectYear.capitalized
                self.popUpForSection = .year
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy"
                
                let currentYear = Int(formatter.string(from: date)) ?? 2020
                datas = Array((self.vehicleDescription?.startYear ?? 1996)...currentYear).compactMap({$0.description})
            case .licenePlate,.color:
                
                break
            }
            let popOver = PopOverSelectionVC
                .initWithStory(from: rect,
                               title: title,
                               delegate: self,
                               datas: datas)
            self.newVehicleVC.present(popOver,
                                      animated: true,
                                      completion: nil)
        case 1:
            guard let request = self.vehicleDescription?.requestOptions.value(atSafe: indexPath.row) else{
                return
            }
            request.isSelected = !request.isSelected
            tableView.reloadData()
        case 2:
            break
        case self.staticSection...tableView.numberOfSections:
            
            if categoryNames[indexPath.section - self.staticSection] == .Tow {
                if !self.TowVechileType[indexPath.row].isTitle{
                    guard let vehicle = self.TowVechileType.value(atSafe: indexPath.row) else {
                        return
                    }
                    vehicle.isSelected = !vehicle.isSelected
                }
               
            }else{
                guard let vehicle = self.VehicleList[self.categoryNames[indexPath.section - self.staticSection]]?.value(atSafe: indexPath.row) else {
                    return
                }
                vehicle.isSelected = !vehicle.isSelected
            }
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                tableView.reloadData()
            }
        default:
            break
        }
    }
}

//MARK:- PopOverProtocol
extension NewVehicleView : PopOverProtocol{
    func popOverSelection(diSelect data: String) {
        guard let section = self.popUpForSection else{return}
        switch section {
        case .make:
            self.selectedMake = self.vehicleDescription?.make.filter({$0.name == data}).first
            self.selectedMake?.selectedModel = nil
            self.vehicleDetailTableView.reloadData()
        case .model:
            self.selectedMake?.selectedModel = self.selectedMake?.model.filter({$0.name == data}).first
        case .year:
            self.newVehicleVC.currentVehicle.year = data
        default:
            break
        }
        self.vehicleDetailTableView.reloadData()
    }
    
    func popOverSelectionCancelled() {
        
    }
    
    
}



//MARK:- UITextFieldDelegate
extension NewVehicleView : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let section = VehicleSectionA(rawValue: textField.tag) else {return}
        switch section  {
        case .licenePlate:
            self.newVehicleVC.currentVehicle.licenseNumber = textField.text ?? ""
        case .color:
            self.newVehicleVC.currentVehicle.color = textField.text ?? ""
            
        default:
            break
        }
        self.checkStatus()
        self.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        return (textField.text?.count ?? 0) < 15
    }
}
import UIKit
class TowvehicleHeader : UITableViewCell{
    
    @IBOutlet weak var refTitlLbl : SecondaryExtraSmallLabel!

    
  
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
    }
  
}
