//
//  PickUpVCView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 23/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit


class PickUpVCView: BaseView  {
    //MARK: - OUTLETS
    //@IBOutlet weak var outerTableView: TopCurvedView!
    @IBOutlet weak var orderTableView: CommonTableView!
    @IBOutlet weak var storeView: SecondaryView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var pickeUpOrderTitleLbl: SecondarySmallHeaderLabel!
    
    
    @IBOutlet weak var navview: HeaderView!
    @IBOutlet weak var pickupStoreTitleLbl: InactiveRegularLabel!
    @IBOutlet weak var storeName_Lbl: SecondarySubHeaderLabel!
    
    
    @IBOutlet weak var topView: TopCurvedView!
    @IBOutlet weak var holderView: SecondaryView!
    @IBOutlet weak var bottomView: TopCurvedView!
    
   
    
    //MARK: - LOCAL VARIABLES
    var pickVC:PickUpVC!
    var redirected : Bool = false
    var storename = String()
    
    let loader = UberSupport()
    
    
    
    var isAccepted = ""
    
    var distance = [String]()
    var PopToRootVC = Bool()
    var minDistance :Double {
        get {
            return (self.distance.map({$0}).min()! as NSString).doubleValue
        }
    }
    

    lazy var completedRefresher : UIRefreshControl = {
           return self.getRefreshController()
       }()
       //MARK:- loaders
       lazy var pendingLoader : UIActivityIndicatorView = {
           return self.getBottomLoader()
       }()
   //MARK: - NECESSARY CLASS FUNCTIONS
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.pickVC = baseVC as? PickUpVC
        self.initialize()
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func darkModeChange() {
        super.darkModeChange()
        self.navview.customColorsUpdate()
        self.ThemeChange()
        self.holderView.customColorsUpdate()
        self.orderTableView.customColorsUpdate()
        self.orderTableView.reloadData()
        self.topView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
    }
    
    func ThemeChange() {
          if #available(iOS 12.0, *) {
              let isDarkStyle = self.traitCollection.userInterfaceStyle == .dark
              self.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
              self.storeView.backgroundColor = isDarkStyle ? .DarkModeBackground : .SecondaryColor
          }
          self.storeName_Lbl.customColorsUpdate()
          self.pickeUpOrderTitleLbl.customColorsUpdate()
          self.pickupStoreTitleLbl.customColorsUpdate()
          self.storeView.customColorsUpdate()
      
         // self.outerTableView.customColorsUpdate()
      }


    
    func initialize() {
        //self.pickVC.pickupView.backgroundColor = .ThemeMain
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
//        self.pickVC.fetchDeliveryHistory()
//        self.pickVC.driverAcceptedOrders()
        //orderTableView.scrollToTop(animated: true)
        nextBtn.setTitle(LangDeliveryAll.next.capitalized,
                         for: .normal)
        nextBtn.backgroundColor = .PrimaryColor
        //self.nextBtn.mainThemeCorner()
        nextBtn.elevate(3.0)
        nextBtn.cornerRadius = 10
       // navview.backgroundColor = .ThemeMain
        self.pickeUpOrderTitleLbl.text = LangDeliveryAll.pickUpOrder
        self.pickupStoreTitleLbl.text = LangDeliveryAll.store//"The Coffee shop"//
//        self.storeName_Lbl.text = "MG Store"//LangDeliveryAll.noOrderFound
//        // corner radius
//        storeView.layer.cornerRadius = 8
//
//        // border
//        storeView.layer.borderWidth = 0.5
//        storeView.layer.borderColor = UIColor.gray.cgColor
//
//        // shadow
//        storeView.layer.shadowColor = UIColor.gray.cgColor
//        storeView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        storeView.layer.shadowOpacity = 0.3
//        storeView.layer.shadowRadius = 2.0
    }
    
    func getRefreshController() -> UIRefreshControl{
           let refresher = UIRefreshControl()
           refresher.tintColor = .PrimaryColor
           refresher.attributedTitle = NSAttributedString(string: "Pull To Refresh")
           return refresher
       }
       func getBottomLoader() -> UIActivityIndicatorView{
           let spinner = UIActivityIndicatorView(style: .large)
           spinner.color = UIColor.PrimaryColor
           spinner.hidesWhenStopped = true
           return spinner
       }
   //MARK: - BUTTON ACTIONS
    @IBAction func backAction(_ sender: Any) {
//        _ = navigationController?.popToRootViewController(animated: true)
        if self.storeName_Lbl.text == LangDeliveryAll.noOrderFound || storename == LangDeliveryAll.noOrderFound {
            self.pickVC.navigationController?.popToRootViewController(animated: false)
        } else {
            _ = pickVC.navigationController?.popViewController(animated: true)
        }
        //self.navigationController?.popToViewController(ofClass: RouteVC.self, animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        if let model = self.pickVC.driver_recieved_orders.first {
            self.pickVC.fetchTripDetails(orderId: model.order_id ?? 0)
        }
    }
    
}

//MARK: - TABLEVIEW DELEGATE, DATASOURCE
extension PickUpVCView : UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return pickVC.driver_recieved_orders.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pickVC.driver_recieved_orders.count
    }
    
   
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AcceptOrderCell
        
        print(":::: Get order count :::: \(pickVC.driver_recieved_orders.count)")

        guard let modelz = self.pickVC.driver_recieved_orders.value(atSafe: indexPath.row) else { return cell }
        cell.setValue(orderDetail: modelz,
                      isFood: self.pickVC.isFood)
        
              
        cell.acceptOrderOutlet.tag = indexPath.row
        cell.acceptOrderOutlet.accessibilityHint = indexPath.section.description + "," + indexPath.row.description
        cell.acceptOrderOutlet.addTarget(self,
                                         action: #selector(buttonSelected),
                                         for: .touchUpInside)
        cell.closeOrderOutlet.tag = indexPath.row
        cell.closeOrderOutlet.accessibilityHint = indexPath.section.description + "," + indexPath.row.description
        cell.closeOrderOutlet.addTarget(self,
                                        action: #selector(CancelSelected),
                                        for: .touchUpInside)
        
        
        cell.themeChange()
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        return nil
    }
    
    @objc func buttonSelected(sender: UIButton) {
        print("::::: Button tag :::::: \(sender.tag)")
        let model = self.pickVC.driver_recieved_orders[sender.tag]
        let pickView = OrderStatusVC.initWithStory()
        pickView.acceptOrders = [model]
        pickView.orderId = model.order_id!.description
        self.pickVC.navigationController?.pushViewController(pickView, animated: true)
    }
    
    @objc func CancelSelected(sender: UIButton) {
        let model = self.pickVC.driver_recieved_orders[sender.tag]
        let cancelVC = CancelRideVC.initWithStory(businessType: .DeliveryAll)
        //    _ = self.pickVC.driver_recieved_orders[sender.tag]
        cancelVC.isMultipleDelivery = self.pickVC.driver_recieved_orders.count > 1
        cancelVC.strTripId = model.order_id?.description ?? ""
        
        self.pickVC.navigationController?.pushViewController(cancelVC,
                                                             animated: true)
    }
    
}


extension Collection where Iterator.Element == String {
    var doubleArray: [Double] {
        return compactMap{ Double($0) }
    }
    var floatArray: [Float] {
        return compactMap{ Float($0) }
    }
}

extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
