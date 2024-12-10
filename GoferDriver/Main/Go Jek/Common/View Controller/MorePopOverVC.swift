//
//  MorePopOverVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 31/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

protocol MorePopOverProtocol {
    func MorepopOverSelection(diSelect data : MoreOptions)
    func MorepopOverSelectionCancelled()
}
class MorePopOverVC: BaseVC {
    
    //------------------------------------------
    //MARK:- Outlets
    //------------------------------------------
    
    @IBOutlet var morePopOverView: MorePopOverView!
    @IBOutlet weak var tableHeight : NSLayoutConstraint!
    
    //------------------------------------------
    //MARK:- LocalVariables
    //------------------------------------------
    
    fileprivate(set) var fromFrame : CGRect!
    var delegate : MorePopOverProtocol!
    var datas = [MoreOptions]()
    var tableTitle = String()
    
    //------------------------------------------
    //MARK: - ViewController Life Cycle
    //------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------
    //MARK:- initWithStory
    //------------------------------------------
    
    class func initWithStory(preferredFrame size : CGSize,on host : UIView,delegate : MorePopOverProtocol,datas : [MoreOptions],button: UIBarButtonItem) -> MorePopOverVC{
        let infoWindow : MorePopOverVC = UIStoryboard.gojekCommon.instantiateViewController()
        infoWindow.datas = datas
        infoWindow.delegate = delegate
        infoWindow.preferredContentSize = size
        infoWindow.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = infoWindow.popoverPresentationController!
        popover.delegate = infoWindow as? UIPopoverPresentationControllerDelegate
        popover.barButtonItem = button
        popover.permittedArrowDirections = UIPopoverArrowDirection.down
        return infoWindow
    }
}


    
