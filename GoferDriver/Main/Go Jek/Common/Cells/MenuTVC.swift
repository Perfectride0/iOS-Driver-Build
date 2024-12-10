//
//  MenuTVC.swift
//  GoferDriver
//
//  Created by trioangle on 01/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

class MenuItemModel{
    var title : String
    var icon : String?
    var viewController : UIViewController?
    init(withTitle title :String,icon : String, VC : UIViewController? ){
        self.title = title
        self.icon = icon
        self.viewController = VC
    }
}
class CellMenus: UITableViewCell
{
    @IBOutlet var lblName: UILabel?
}
