//
//  PopOverSelectionView.swift
//  PopOverSelectionView
//
//  Created by Trioangle on 06/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class PopOverSelectionView: BaseView {
    
    //---------------------------------
    // MARK: - Outlets
    //---------------------------------
    
    @IBOutlet weak var dismissView : UIView!
    @IBOutlet weak var holderView : SecondaryView!
    @IBOutlet weak var titleLabel : SecondaryHeaderLabel!
    @IBOutlet weak var dataTableView : CommonTableView!
    @IBOutlet weak var tableHeight : NSLayoutConstraint!
    
    //---------------------------------
    // MARK: - Local Variables
    //---------------------------------
    
    var popOverSelectionVC : PopOverSelectionVC!
    
    //---------------------------------
    // MARK: - lifeCycle
    //---------------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.popOverSelectionVC = baseVC as? PopOverSelectionVC
        self.initView()
        self.initGestures()
        DispatchQueue.main
            .asyncAfter(deadline: .now() + 0.2) {
                self.initLayers()
        }
        self.darkModeChange()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.holderView.customColorsUpdate()
        self.titleLabel.customColorsUpdate()
        self.dataTableView.customColorsUpdate()
        self.dataTableView.reloadData()
    }
    
    //---------------------------------
    // MARK: - initializers
    //---------------------------------
    
    func initView(){
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        self.dataTableView.tableFooterView = UIView()
        self.titleLabel.text = self.popOverSelectionVC.tableTitle
    }
    
    func initLayers(){
        self.holderView.isClippedCorner = true
    }
    
    func initGestures(){
        self.dismissView.addAction(for: .tap) {
            self.popOverSelectionVC.delegate.popOverSelectionCancelled()
            self.popOverSelectionVC.dismiss(animated: true,
                                            completion: nil)
        }
    }
}


//-----------------------------------
// MARK: - dataTableView DataSource
//-----------------------------------

extension PopOverSelectionView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let height = tableView.contentSize.height
        let maxHeight = self.frame.height * 0.5
        self.tableHeight.constant = height < maxHeight  ? height : maxHeight
        return self.popOverSelectionVC.datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SelectionTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let data = self.popOverSelectionVC.datas.value(atSafe: indexPath.row) else{return cell}
        cell.dataLbl.text = data
        cell.lineLbl.isHidden = data == self.popOverSelectionVC.datas.last
        cell.setTheme()
        return cell
    }
    
}

//---------------------------------
// MARK: - dataTableView Delegate
//---------------------------------

extension PopOverSelectionView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = self.popOverSelectionVC.datas.value(atSafe: indexPath.row) else{return}
        self.popOverSelectionVC.delegate.popOverSelection(diSelect: data)
        self.popOverSelectionVC.dismiss(animated: false,
                                        completion: nil)

    }
    
}


//---------------------------------
// MARK: - dataTableView Cell
//---------------------------------

class SelectionTVC : UITableViewCell {
    
    @IBOutlet weak var bgView: SecondaryView!
    @IBOutlet weak var dataLbl : SecondaryRegularLabel!
    @IBOutlet weak var lineLbl: UILabel!
    
    func setTheme() {
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.bgView.customColorsUpdate()
        self.dataLbl.customColorsUpdate()
        self.lineLbl.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.2)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setTheme()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
