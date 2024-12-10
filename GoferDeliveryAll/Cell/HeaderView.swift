//
//  HeaderView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 22/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class HeadersView: UITableViewCell {
    
    @IBOutlet weak var store_nameLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var order_idLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var acceptedLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var closeOrderOutlet: UIButton!
    @IBOutlet weak var acceptOrderOutlet: UIButton!
    
     var action : Closure<Bool>? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
       //MARK:- UDF
        func hightLight(option : Bool?){
            let like_light = UIImage(named: "like_light")?.withRenderingMode(.alwaysTemplate)
            let like_filled = UIImage(named: "like_full")?.withRenderingMode(.alwaysTemplate)
            let cancel_light = UIImage(named: "close_light")?.withRenderingMode(.alwaysTemplate)
            let cancel_filled = UIImage(named: "close_full")?.withRenderingMode(.alwaysTemplate)
             
             if let choosed = option{
                
                self.acceptOrderOutlet.setImage(choosed ? like_filled : like_light, for: .normal)
                 self.closeOrderOutlet.setImage(!choosed ? cancel_filled : cancel_light, for: .normal)

                
                self.acceptOrderOutlet.tintColor = choosed ? .PrimaryColor : .black
                self.closeOrderOutlet.tintColor = !choosed ? .PrimaryColor : .black
                
                
             }else{
                self.acceptOrderOutlet.setImage(like_light, for: .normal)
                self.closeOrderOutlet.setImage( cancel_light, for: .normal)
                
                
                self.acceptOrderOutlet.tintColor =  .black
                self.closeOrderOutlet.tintColor =  .black
                
                
            }
         }
    
    
         func setRecepient(name : String,andOrderID orderId : Int){
//             self.recepientNameLbl.text = name
//            self.orderIDLbl.text = "\(Language.default.object.orderID.uppercased()) #"+orderId.description
             
         }
        func onAction(_ action : @escaping Closure<Bool>){
            self.action = action
        }
        @IBAction
         func acceptOrderAction(_ sender : UIButton?){
             self.hightLight(option: true)
            
            
            
            
         }
         @IBAction
         func canceltOrderAction(_ sender : UIButton?){
             self.hightLight(option: false)
         }
 
}
