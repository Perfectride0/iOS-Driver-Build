//
//  DeliveryOrderListView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 28/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit


class DeliveryOrderListView: BaseView {
    //MARK: - OUTLETS
    @IBOutlet weak var driverOrderTable: CommonTableView!
    @IBOutlet weak var ordersTitleLbl: SecondaryHeaderLabel!
    
    @IBOutlet weak var storeDetailsView: UIStackView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var storeValueLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var storeTitleLbl: InactiveRegularLabel!
    @IBOutlet weak var curvedView: TopCurvedView!
    @IBOutlet weak var navview: HeaderView!

    var fetchDeliveryData = false
    let loader = UberSupport()
    
    
    var orderVC:DriverOrderListVC!
    
    //MARK:- loaders
       lazy var pendingLoader : UIActivityIndicatorView = {
           return self.getBottomLoader()
       }()
       lazy var completedLoader : UIActivityIndicatorView = {
           return self.getBottomLoader()
       }()

    //MARK:- Refreshers
      lazy var pendingRefresher : UIRefreshControl = {
          return self.getRefreshController()
      }()
      lazy var completedRefresher : UIRefreshControl = {
          return self.getRefreshController()
      }()
    
    //MARK: - NECESSARY CLASS FUNCTIONS
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.orderVC = baseVC as? DriverOrderListVC
        self.initialize()
        self.darkModeChange()
    }
    
    
    
    func initialize() {
        self.driverOrderTable.delegate = self
        self.driverOrderTable.dataSource = self
        self.curvedView.elevate(2.5)
        self.ordersTitleLbl.text = LangDeliveryAll.orderlist.capitalized
        self.storeTitleLbl.text = LangDeliveryAll.store.capitalized
    }

    
    override func darkModeChange() {
        super.darkModeChange()
        self.ordersTitleLbl.customColorsUpdate()
        self.driverOrderTable.customColorsUpdate()
        self.curvedView.customColorsUpdate()
        self.driverOrderTable.reloadData()
        self.navview.customColorsUpdate()
        self.storeTitleLbl.customColorsUpdate()
        self.storeValueLbl.customColorsUpdate()
        self.barView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.5)
       
    }
    
  
    
    func getBottomLoader() -> UIActivityIndicatorView{
           let spinner = UIActivityIndicatorView(style: .large)
           spinner.color = UIColor.PrimaryColor
           spinner.hidesWhenStopped = true
           return spinner
       }

    func getRefreshController() -> UIRefreshControl{
        let refresher = UIRefreshControl()
        refresher.tintColor = .PrimaryColor
        refresher.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refresher.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        return refresher
    }
    
    func setStoreDetails() {
        if let name = self.orderVC.storeName,
           !name.isEmpty {
            self.storeDetailsView.isHidden = false
            self.storeValueLbl.text = name
        } else {
            self.storeDetailsView.isHidden = true
        }
    }

    @objc func onRefresh(_ sender : UIRefreshControl){
        //self.fetchPendingTripsData()
      }
    //MARK: - BUTTON ACTIONS
    
    @IBAction func backBtnAction(_ sender: Any) {
        _ = orderVC.navigationController?.popViewController(animated: true)
    }

    @IBAction func shuffleDriverOrders(_ sender: Any) {
        driverOrderTable.isEditing = !driverOrderTable.isEditing

    }



}
//MARK: - EXTENSIONS

extension UINavigationController {

  func laundrypopToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
      popToViewController(vc, animated: animated)
    }
  }

  func laundrypopViewControllers(viewsToPop: Int, animated: Bool = true) {
    if viewControllers.count > viewsToPop {
      let vc = viewControllers[viewControllers.count - viewsToPop - 1]
      popToViewController(vc, animated: animated)
    }
  }

}
extension DeliveryOrderListView : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count driver",self.orderVC.driverAcceptOrders.count)
        return self.orderVC.driverAcceptOrders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "driverOrder", for: indexPath) as! OrderListCell
        
        cell.selectionStyle = .none
        guard let model = self.orderVC.driverAcceptOrders.value(atSafe: indexPath.row) else { return cell }
        cell.nameLblText.text = model.eater_name
        cell.orderIdLbl.text = "\(LangDeliveryAll.orderId): #" + "\(model.order_id ?? 0)"//
        cell.deliveryLocLbl.text = "\(LangDeliveryAll.deliveryLocation) : \(model.drop_location ?? "")"
        cell.estimationLbl.isHidden = true
        //cell.estimationLbl.text = "\(language.goferDeliveryAll.distance) : \(self.driverAcceptOrders[indexPath.row].distance ?? "0") KM"
        cell.estimationLbl.text = ""
        cell.nameLblText.isHidden = model.eater_name?.isEmpty ?? true
        cell.darkModeChnages()
        if isRTLLanguage{
            cell.deliveryLocLbl.textAlignment = .right
        }else{
            cell.deliveryLocLbl.textAlignment = .left
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order_Id = self.orderVC.driverAcceptOrders[indexPath.row].order_id!
        print(":::::Selected Order ID :::::\(order_Id)")
        
        //        let trip : TripDataModel?
        //         trip = self.pendingTrips.value(atSafe: indexPath.row)
        //        if let index = self.pendingTrips.firstIndex(where: {$0.id == order_Id}) {
        //            let tripDataModel = self.pendingTrips[index]
        //            print("GET THE TRIP DETAILS HERE \(tripDataModel)")
        //            AppRouter(self).routeInCompleteTrips(tripDataModel, shouldPopToRoot: true)
        //        }
        self.orderVC.fetchTripDetails(orderId: order_Id)
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let orders = orderVC.driverAcceptOrders[sourceIndexPath.row]
        orderVC.driverAcceptOrders.remove(at: sourceIndexPath.row)
        orderVC.driverAcceptOrders.insert(orders, at: destinationIndexPath.row)
        
    }
}

