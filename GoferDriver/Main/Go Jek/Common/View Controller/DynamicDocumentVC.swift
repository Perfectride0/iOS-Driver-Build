//
//  DynamicDocumentVC.swift
//  GoferDriver
//
//  Created by trioangle on 01/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class DynamicDocumentVC: BaseVC {

    @IBOutlet var dynamicDocumentView: DynamicDocumentView!
    enum Purpose{
        case forDriver(id : Int)
        case forVehicle(id : Int)
    }
    //MARK:- Variable
    private(set) var purposeFor : Purpose!
    private(set) var documents = [DynamicDocumentModel]()
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- initWithStory
    class func initWithStory(for purpose : Purpose,
                             using documents : [DynamicDocumentModel],
                             menuPresenter : MenuPresenter) -> DynamicDocumentVC{
        let vc : DynamicDocumentVC = UIStoryboard.gojekCommon.instantiateViewController()
        vc.purposeFor = purpose
        vc.documents = documents
        return vc
    }
   
}

