//
//  ListPayoutView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 03/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class ListPayoutView: BaseView {
    
    //MARK:- Outlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var payoutTableView : CommonTableView!
    
    override func darkModeChange() {
        super.darkModeChange()
        self.headerView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.payoutTableView.customColorsUpdate()
        self.payoutTableView.reloadData()
    }
      var payouts : [PayoutItemModel] = []
    var viewController: NewPayoutListVC!
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? NewPayoutListVC
        self.initView()
        self.initLanguage()
        self.darkModeChange()
    }

    
        var selctedIndex = 0
        var payoutDetailList = [PayoutDetail]()
    
    
    func initView(){
        self.payoutTableView.delegate = self
        self.payoutTableView.dataSource = self
    }
       func initLanguage(){
          
           self.titleLbl.text = LangCommon.managePayouts.capitalized
       }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
}

extension ListPayoutView{
    //MARK: UDF
    func showActionSheet(for item : PayoutItemModel){
        let actionSheet = UIAlertController(title: item.value + " " + LangCommon.payout.capitalized,
                                            message: LangCommon.whatLike2_Do,
                                            preferredStyle: .actionSheet)
        actionSheet
            .addAction(UIAlertAction(title: LangCommon.makeDefault.capitalized,
                                     style: .default,
                                     handler: { (_) in
                                        self.viewController.wsToGetPayoutList(for: .setDefault(id: item.id))
            }))
        actionSheet
            .addAction(UIAlertAction(title: LangCommon.delete.capitalized,
                                     style: .destructive,
                                     handler: { (_) in
                                        self.viewController.wsToGetPayoutList(for: .delete(id: item.id))
            }))
        
        actionSheet
            .addAction(.init(title: LangCommon.cancel.capitalized,
                             style: .cancel,
                             handler: { (_) in
                                actionSheet.dismiss(animated: true, completion: nil)
            }))
        self.viewController.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension ListPayoutView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.payouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PayoutItemTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let item = self.payouts.value(atSafe: indexPath.row) else{return cell}
        cell.populateCell(with: item)
        cell.ThemeChange()
        return cell
    }
    
    
}
extension ListPayoutView : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.payouts.value(atSafe: indexPath.row) else{return}
        
        if item.id == 0 {
            self.viewController.handleAddAction(for: item)
        }else if item.isDefault {
            self.viewController.handleAddAction(for: item)
        } else {
            self.showActionSheet(for: item)
        }
      
    }
}
