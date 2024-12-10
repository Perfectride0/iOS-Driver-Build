//
//  CustomBottomSheetView.swift
//  GoferHandy
//
//  Created by Trioangle on 05/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

protocol CustomBottomSheetDelegate {
    func TappedAction(indexPath: Int,SelectedItemName: String)
    func ActionSheetCanceled()
    func MultipleTapAction(selectedOptions: [String])
    func heatMapTapAction(selectedOptions : [String])
    func isSelectAllSelected (SelectAllValue: Bool)
    func isDeselectAllSelected()
}


class CustomBottomSheetView : BaseView {
    
    
    @IBOutlet weak var doneBtn: PrimaryButton!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var closeBtn: SecondaryTintButton!
    @IBOutlet weak var containerView: TopCurvedView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var dataTableView: CommonTableView!
    @IBOutlet weak var headerLabel: SecondaryHeaderLabel!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    
    var customBottomSheetVC : CustomBottomSheetVC!
    
    var listTitles: [String] { get { return customBottomSheetVC.detailsArray ?? [] } }
    var serviceList: [String] { get { return customBottomSheetVC.serviceArray ?? [] } }
    var selectedList: [Bool] { get { return customBottomSheetVC.selectedList ?? [] }
        set {
            customBottomSheetVC.selectedList.removeAll()
            customBottomSheetVC.selectedList = newValue
        }
    }
    var allList: [String] { get { return customBottomSheetVC.allList ?? [] } }
    
    var imageList : [String]  { get { return customBottomSheetVC.ImageArray ?? [] } }
    
    var isUrlImage : Bool { get { return customBottomSheetVC.isImageUrl ?? false } }
    
    var pageTitle : String { get { return customBottomSheetVC.pageTitle ?? "" } }
    
    var selectedItem : [String] { get { return customBottomSheetVC.selectedItem ?? [] } }
    var indexPathOfService : Int!
    let basicHeight : CGFloat = 60

    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.customBottomSheetVC = baseVC as? CustomBottomSheetVC
        if self.customBottomSheetVC.serviceSelected {
            self.setHeight(data: self.allList)
        } else {
            self.setHeight(data: self.listTitles)
        }
        self.initView()
        self.initGesture()
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.containerView.customColorsUpdate()
        self.closeBtn.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.headerLabel.customColorsUpdate()
        self.dataTableView.customColorsUpdate()
        self.dataTableView.reloadData()
        self.doneBtn.customColorsUpdate()
    }
    
    func initView() {
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        self.closeBtn.setTitle("", for: .normal)
        self.closeBtn.setImage(UIImage(named: "close_icon_white")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.headerLabel.text = self.pageTitle
        self.doneBtn.setTitle(LangCommon.done.capitalized, for: .normal)
        self.doneBtn.isHidden = self.customBottomSheetVC.selection == .single
        self.dataTableView.register(UINib(nibName: "CustomServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomServicesTableViewCell")
    }
    
    func initGesture() {
        self.dismissView.addAction(for: .tap) {
            var selectedArray = [String]()
            for (indexNumber,valueOfList) in self.selectedList.enumerated() {
                if valueOfList {
                    if let value = self.listTitles.value(atSafe: indexNumber) {
                        selectedArray.append(value)
                    }
                }
            }
            if selectedArray.isNotEmpty {
                self.customBottomSheetVC.dismiss(animated: true) {
                    self.customBottomSheetVC.delegate.ActionSheetCanceled()
                }
            } else if selectedArray.isEmpty && self.customBottomSheetVC.selection == .heatMap {
                self.customBottomSheetVC.dismiss(animated: true) {
                    self.customBottomSheetVC.delegate.ActionSheetCanceled()
                }
            }
        }
    }
    
    func setHeight(data: [String]) {
        let height = basicHeight * CGFloat(data.count)
        let maxHeight = self.frame.height * 0.75
        self.heightConst.constant = min(height, maxHeight)
        self.dataTableView.layoutIfNeeded()
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        var selectedArray = [String]()
        for (indexNumber,valueOfList) in selectedList.enumerated() {
            if valueOfList {
                if let value = allList.value(atSafe: indexNumber) {
                    selectedArray.append(value)
                }
            }
        }
        if selectedArray.isNotEmpty {
            self.customBottomSheetVC.dismiss(animated: true) {
                switch self.customBottomSheetVC.selection {
                
                case .single:
                    break
                case .multiple:
                    self.customBottomSheetVC.delegate.MultipleTapAction(selectedOptions: selectedArray)
                case .heatMap:
                    self.customBottomSheetVC.delegate.heatMapTapAction(selectedOptions: selectedArray)
                }
        
                
                print(selectedArray)
            }
        }
        if selectedArray.isEmpty && self.customBottomSheetVC.selection == .heatMap {
            self.customBottomSheetVC.delegate.isDeselectAllSelected()
            self.customBottomSheetVC.dismiss(animated: true)
        }
    }
    
}

extension CustomBottomSheetView : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.customBottomSheetVC.serviceSelected {
            return allList.count
        } else {
            return listTitles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.basicHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        if self.customBottomSheetVC.isForTypeSelection {
            let cell: CustomBottomSheetTVC = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLbl.text = self.listTitles.value(atSafe: indexPath.row)
            cell.checkBoxImg.image = self.selectedList[indexPath.row] ? UIImage(named: "checkbox_selected") : UIImage(named: "checkbox_unselected")
            cell.setTheme()
            return cell
        } else {
        if !self.customBottomSheetVC.serviceSelected {
            let cell: CustomBottomSheetTVC = tableView.dequeueReusableCell(for: indexPath)
            
            if indexPath.row == 0 {
                if selectedList[0] {
                    cell.titleLbl.text = LangCommon.deSelectAll
                } else {
                    cell.titleLbl.text = LangCommon.selectAll
                }
            }else {
                cell.titleLbl.text = self.listTitles.value(atSafe: indexPath.row)
            }
            cell.checkBoxImg.image = self.selectedList[indexPath.row] ? UIImage(named: "checkbox_selected") : UIImage(named: "checkbox_unselected")
            cell.setTheme()
            return cell
        } else {
            if indexPath.row < self.listTitles.count {
                let cell: CustomBottomSheetTVC = tableView.dequeueReusableCell(for: indexPath)
                if indexPath.row == 0 {
                    if selectedList[0] {
                        cell.titleLbl.text = LangCommon.deSelectAll
                    } else {
                        cell.titleLbl.text = LangCommon.selectAll
                    }
                }else {
                    cell.titleLbl.text = self.listTitles.value(atSafe: indexPath.row)
                }
                cell.checkBoxImg.image = self.selectedList[indexPath.row] ? UIImage(named: "checkbox_selected") : UIImage(named: "checkbox_unselected")
                cell.setTheme()
                if self.allList.value(atSafe: indexPath.row) == "Services" && self.selectedList[indexPath.row] {
                    self.indexPathOfService = indexPath.row
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomServicesTableViewCell", for: indexPath) as! CustomServicesTableViewCell
                cell.titleLbl.text = self.allList.value(atSafe: indexPath.row)
                cell.icon.image = self.selectedList[indexPath.row] ? UIImage(named: "checkbox_selected") : UIImage(named: "checkbox_unselected")
                cell.checkBoxImg.isHidden = true
                cell.setTheme()
                return cell
            }
        }
        }
    }
}

extension CustomBottomSheetView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.listTitles.count > 0 {
            self.selectedList[indexPath.row] = !self.selectedList[indexPath.row]
            tableView.reloadData()
        }
        if customBottomSheetVC.selection == .single {
            self.customBottomSheetVC.dismiss(animated: true) {
                self.customBottomSheetVC.delegate
                    .TappedAction(
                        indexPath: indexPath.row,
                        SelectedItemName: self.listTitles.value(atSafe: indexPath.row) ?? "")
            }
        } else if customBottomSheetVC.selection == .heatMap {
             if indexPath.row == 0 {
                self.customBottomSheetVC.delegate.isSelectAllSelected(SelectAllValue: selectedList[0])
                 if selectedList[0] {
                     for i in 1..<allList.count {
                         selectedList[i] = true
                     }
                     self.customBottomSheetVC.serviceSelected = true
                     self.setHeight(data: self.allList)
                 }else {
                     for i in 1..<allList.count {
                         selectedList[i] = false
                     }
                     self.customBottomSheetVC.serviceSelected = false
                     self.setHeight(data: self.listTitles)
                 }
                 self.dataTableView.reloadData()
             }
            if self.allList.value(atSafe: indexPath.row) == "Services" && self.selectedList[indexPath.row] {
                self.customBottomSheetVC.serviceSelected = true
                self.setHeight(data: self.allList)
                for i in self.listTitles.count..<self.allList.count {
                    self.selectedList[i] = true
                }
                self.indexPathOfService = indexPath.row
                tableView.reloadData()
            } else if self.allList.value(atSafe: indexPath.row) == "Services" && !self.selectedList[indexPath.row] {
                self.customBottomSheetVC.serviceSelected = false
                self.setHeight(data: self.listTitles)
                for i in self.listTitles.count..<self.allList.count {
                    selectedList[i] = false
                }
            }
            /*
             To Handle Select All / Deselect All
             */
            if indexPath.row > 0 {
                var selectList : [Bool] = []
                for i in 1..<allList.count {
                    selectList.append(selectedList[i])
                }
                if selectList.contains(false) {
                    selectedList[0] = false
                    self.dataTableView.reloadData()
                } else {
                    selectedList[0] = true
                    self.dataTableView.reloadData()
                }
            }
            /*
             To Handle Services if All service category are selected
             */
            if indexPath.row > listTitles.count - 1{
                var newList :[Bool] = []
                for i in self.listTitles.count..<self.allList.count {
                    newList.append(selectedList[i])
                }
                if !newList.contains(true) {
                    self.selectedList[self.indexPathOfService] = false
                    self.customBottomSheetVC.serviceSelected = false
                    self.setHeight(data: self.listTitles)
                    self.dataTableView.reloadData()
                }
                if self.selectedList[indexPath.row] == true {
                    self.selectedList[self.indexPathOfService] = true
                }
            }
        }
    }
}
