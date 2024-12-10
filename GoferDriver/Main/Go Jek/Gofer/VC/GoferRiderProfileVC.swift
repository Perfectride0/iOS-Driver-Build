/**
* RiderProfileVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
*
* @link http://trioangle.com
*/

import UIKit
import Foundation
import MapKit

class GoferRiderProfileVC : BaseVC {
    
    //-------------------------------------
    // MARK: - Outlets
    //-------------------------------------
    
    @IBOutlet weak var goferRiderProfileView : GoferRiderProfileView!
    
    //-------------------------------------
    // MARK: - Local Variables
    //-------------------------------------
    
    var isTripStarted : Bool = false
    var tripDetailDataModel : JobDetailModel!
    
    //-------------------------------------
    // MARK: - ViewController Methods
    //-------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        if tripDetailDataModel != nil {
            self.goferRiderProfileView.setRiderInfo()
        }
    }
    
    override
    func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
    
    //-------------------------------------
    //MARK: - initWithStory
    //-------------------------------------
    
    class func initWithStory() -> GoferRiderProfileVC {
        let view : GoferRiderProfileVC = UIStoryboard.karuppasamy.instantiateViewController()
        return view
    }
    
}


