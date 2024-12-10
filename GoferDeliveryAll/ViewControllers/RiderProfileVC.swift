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

class RiderProfileVC : BaseVC {
    
    //--------------------------
    //MARK: - OUTLETS
    //--------------------------
    
    @IBOutlet var riderProfView: RiderProfileView!
    @IBOutlet weak var backBtn: UIButton!
    
    //--------------------------
    //MARK: - LOCAL VARIABLES
    //--------------------------
    
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var isTripStarted : Bool = false
    let arrMenus: [String] = ["Help", "Documents", "About"]
    var tripDetailDataModel : DeliveryOrderDetail!
    
    //-------------------------------------
    // MARK: - ViewController Methods
    //-------------------------------------
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }

    override
    func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
    
    //-------------------------------------
    // MARK: - initWithStory
    //-------------------------------------
    
    class func initWithStory() -> RiderProfileVC{
        let vc : RiderProfileVC = UIStoryboard.gojekDeliveryallTrip.instantiateViewController()
        return vc
    }
}



