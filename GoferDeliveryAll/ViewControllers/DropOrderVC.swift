//
//  DropOrderVC.swift
//  GoferHandyProvider
//
//  Created by trioangle on 16/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class DropOrderVC: BaseVC {
    //MARK: - OUTLETS
   @IBOutlet weak var dropView:DropOrderView!
    //MARK: - LOCAL VARIABLES
    var order : DeliveryOrderDetail!
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dropView.initView()
        self.dropView.initLanugage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.dropView.initLayer()
             }
        // Theme Changes
        self.dropView.closeBtn.whiteThemeCorner()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var _ : CGFloat = 80//header
        /*if !dropView.order.collectCash.isEmpty{
            height += 50 //footer
        }
        height += CGFloat(dropView.order.foodItems.count * 40)
        let maxHeight = self.view.frame.height * 0.75
        self.dropView.tableHeight.constant = CGFloat(height < maxHeight ? height : maxHeight )*/
    }
    
    //MARK:- initWithStory
    class func initWithStory(forOrder order : DeliveryOrderDetail) -> DropOrderVC{
        let view : DropOrderVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
        view.order = order
        return view
    }
   
}
