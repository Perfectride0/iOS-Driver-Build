//
//  DropOrderView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 16/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
class DropOrderView: BaseView {
    
    
    //MARK: - OUTLETS
   
    @IBOutlet weak var hoverView : SecondaryView!
    @IBOutlet weak var orderTable : CommonTableView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var closeBtn : PrimaryButton!
    @IBOutlet weak var tableHeight : NSLayoutConstraint!
    
   
    //MARK: - LOCAL VARIABLES
    var dropOrderVC:DropOrderVC!
    
    //MARK: - NECESSARY CLASS FUNCTIONS
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        dropOrderVC = baseVC as? DropOrderVC
        self.initView()
        self.initLayer()
        self.initLanugage()
        self.darkModeChange()
    }

    func initView(){
        self.dropOrderVC.dropView.orderTable.register(UINib(nibName: "OrderTVC", bundle: nil),
                                    forCellReuseIdentifier: "OrderTVC")
        self.dropOrderVC.dropView.orderTable.register(UINib(nibName: "OrderTVH",
                                          bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: "OrderTVH")
           
        self.dropOrderVC.dropView.orderTable.delegate = self
        self.dropOrderVC.dropView.orderTable.dataSource = self
        self.dropOrderVC.dropView.hoverView.addAction(for: .tap) {
            
        }
        self.dropOrderVC.view.addAction(for: .tap) {
            self.closeAction(nil)
        }
        self.dropOrderVC.dropView.hoverView.cornerRadius = 25
        self.dropOrderVC.dropView.hoverView.elevate(2)
           
    }
    
    override func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = UIColor.IndicatorColor.withAlphaComponent(0.5)
        self.hoverView.customColorsUpdate()
        self.titleLbl.customColorsUpdate()
        self.orderTable.customColorsUpdate()
        self.closeBtn.customColorsUpdate()
        self.orderTable.reloadData()
    }
    
    func initLanugage(){
        self.titleLbl.text = LangDeliveryAll.orderDetails.capitalized
        self.closeBtn.setTitle("COLLECT CASH"+"($\(dropOrderVC.order.collectCash))", for: .normal)
        
    }
    func initLayer(){
        self.dropOrderVC.dropView.orderTable.tableFooterView = dropOrderVC.order.collectCash.isEmpty ? nil : footerView()
     
        
    }
    
    //MARK:- Actions
    @IBAction
    func closeAction(_ sender : UIButton?){
        if self.dropOrderVC.isPresented(){
            self.dropOrderVC.dismiss(animated: true, completion: nil)
        }else{
            self.dropOrderVC.navigationController?.popViewController(animated: true)
        }
    }
   
    func footerView() -> UIView {
        let height : CGFloat = 50
        _ = "en"//LanguageEnum.default.object
        let lbl = SecondaryExtraSmallLabel()
        lbl.frame = CGRect(x: 8,
                           y: 3,
                           width: dropOrderVC.dropView.hoverView.frame.width - 16,
                           height: height - 3)
        lbl.textColor = .PrimaryColor
        lbl.text = "COLLECT CASH"+"($\(dropOrderVC.order.collectCash))"//lang.collectCash+"(\(UserDefaults.value(for: .currency_symbol) ?? "$")\(order.collectCash))"
        let bar = UIView()
        bar.frame = CGRect(x: 0,
                           y: 2,
                           width: dropOrderVC.dropView.hoverView.frame.width,
                           height: 1)
        bar.backgroundColor = .clear
        let holder = UIView()
        holder.frame = CGRect(x: 0,
                              y: 0,
                              width: dropOrderVC.dropView.hoverView.frame.width,
                              height: height)
       // holder.addSubview(lbl)
        holder.addSubview(bar)
        return holder
    }

}




//MARK: - TABLEVIEW DELEGATE,DATASOURCE
extension DropOrderView : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        self.dropOrderVC.view.layoutIfNeeded()
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80//UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropOrderVC.order.foodItems.count
        //return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = OrderTVH.getView()
        
//        view.setRecepient(name: "\(LangDeliveryAll.from) "+self.order.storeName,
//                          andOrderID: self.order.orderID)
        view.setRecepient(name: "DeliveryAll",andOrderID: self.dropOrderVC.order.orderID)
      
        view.acceptIV.isHidden = true
        view.cancelIV.isHidden = true
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : OrderTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let item = self.dropOrderVC.order.foodItems.value(atSafe: indexPath.row) else{return cell}
        cell.darkModeTheme()
        cell.populate(with: item)
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard !dropOrderVC.order.collectCash.isEmpty else{return 0}
        return 50

    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard !dropOrderVC.order.collectCash.isEmpty else{return nil}
        return footerView()
    }
    
}

    

