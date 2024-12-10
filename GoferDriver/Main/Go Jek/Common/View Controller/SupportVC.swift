//
//  SupportVC.swift
//  Gofer
//
//  Created by trioangle on 16/11/20.
//  Copyright © 2020 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SupportVC: BaseVC{

    @IBOutlet var supportView: SupportView!
    override func viewDidLoad() {
        super.viewDidLoad()          
    }
    class func initWithStory()-> SupportVC{
        let view : SupportVC = UIStoryboard.gojekCommon.instantiateViewController()
        return view
    }
    
}

