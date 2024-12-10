//
//  CustomBottomSheetVC.swift
//  GoferHandy
//
//  Created by Trioangle on 05/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
class CustomBottomSheetVC : BaseVC {
    
    enum CustomSelection {
        case single
        case multiple
        case heatMap
    }
    
    var delegate : CustomBottomSheetDelegate!
    var pageTitle: String?
    var detailsArray : [String]?
    var serviceArray : [String]?
    var ImageArray: [String]?
    var isImageUrl: Bool?
    var selectedItem : [String]?
    var selection : CustomSelection = .single
    var selectedList : [Bool]!
    var serviceSelected = Bool()
    var allList : [String]?
    var isForTypeSelection = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    class func initWithStory(_ delegate: CustomBottomSheetDelegate,
                             pageTitle: String?,
                             selectedItem : [String]?,
                             detailsArray: [String]?,
                             ImageArray: [String]? = nil,
                             isImageUrl: Bool? = false,
                             serviceArray : [String]?,
                             selection : CustomSelection = .single) -> CustomBottomSheetVC {
        
        let vc : CustomBottomSheetVC = UIStoryboard.gojekCommon.instantiateViewController()
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = delegate
        
        if let pageTitle = pageTitle {
            vc.pageTitle = pageTitle
        } else {
            print("Page Title is Missing")
        }
        
       
        if let detailsArray = detailsArray {
            vc.detailsArray = detailsArray
            vc.allList = detailsArray
        } else {
            print("details Array is Missing")
        }
        if let serviceArray = serviceArray {
            vc.serviceArray = serviceArray
            vc.allList?.append(contentsOf: serviceArray)
        } else {
            print("details Array is Missing")
        }
        
        vc.selectedList = []
        if let selectedItem = selectedItem,
           let detailsArray = detailsArray, let serviceArray = serviceArray{
            vc.selectedItem = selectedItem
            var allArray : [String] = []
            allArray.append(contentsOf: detailsArray)
            allArray.append(contentsOf: serviceArray)
            vc.selectedList = allArray.compactMap({selectedItem.contains($0)})
        } else {
            print("Selected Item is Missing")
        }
        
        
        if let ImageArray = ImageArray {
            vc.ImageArray = ImageArray
        } else {
            print("Image Array is Missing")
        }
        
        if let isImageUrl = isImageUrl {
            vc.isImageUrl = isImageUrl
        } else {
            print("is ImageUrl is Missing")
        }
        
        vc.selection = selection
        
        return vc
    }
    
    func createAlert(msg: String) {
        self.commonAlert.setupAlert(alert: msg, okAction: LangCommon.ok)
    }
    
}
