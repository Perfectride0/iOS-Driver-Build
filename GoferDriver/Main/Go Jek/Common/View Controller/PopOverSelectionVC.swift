//
//  PopOverSelectionVC.swift
//  GoferDriver
//
//  Created by trioangle on 07/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit


protocol PopOverProtocol {
    func popOverSelection(diSelect data : String)
    func popOverSelectionCancelled()
}


class PopOverSelectionVC: BaseVC {

    //---------------------------------
    // MARK: - Outlets
    //---------------------------------
    
    @IBOutlet var popOverSelectionView : PopOverSelectionView!
    
    //---------------------------------
    // MARK: - Local Variables
    //---------------------------------
    
    fileprivate(set) var fromFrame : CGRect!
    var delegate : PopOverProtocol!
    var datas = [String]()
    var tableTitle = String()
    
    //---------------------------------
    // MARK: - lifeCycle
    //---------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //---------------------------------
    // MARK: - initWithStory
    //---------------------------------
    
    class func initWithStory(from frame : CGRect,title : String,delegate : PopOverProtocol,datas : [String]) -> PopOverSelectionVC{
        let vc : PopOverSelectionVC = UIStoryboard.gojekCommon.instantiateViewController()
        vc.fromFrame = frame
        vc.datas = datas
        vc.delegate = delegate
        vc.tableTitle = title
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
}




