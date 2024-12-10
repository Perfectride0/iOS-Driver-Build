//
//  HandySetLocationVC.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
protocol HandySetLocationDelegate {
    func handySetLocation(didSetLocation location: MyLocationModel)
    func handySetLocationDidCancel()
}
enum UserLocationType{
    case Home
    case Work
}
class HandySetLocationVC: BaseVC {
    
    @IBOutlet weak var setLocationView : HandySetLocationView!
    var bookingViewModel : HandyHomeViewModel!
    var accountViewModel : AccountViewModel?
    var addressLocation:String?
    var addLocationFor : UserLocationType? = nil
    var setLocationDelegate : HandySetLocationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("ðDeinited\(Self.reuseIdentifier)")
    }
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    //MARK:- intiWithStory
    class func initWithStory(with delegate: HandySetLocationDelegate) -> HandySetLocationVC{
        let view : HandySetLocationVC =  UIStoryboard.gojekCommon.instantiateViewController()
        view.bookingViewModel = HandyHomeViewModel()
        view.modalPresentationStyle = .overCurrentContext
        view.accountViewModel = AccountViewModel()
        view.setLocationDelegate = delegate
        return view
    }
    //MARK:- UDF
    func fethcUserLocationAndSet(){
        self.bookingViewModel.getCurrentLocation { (newLocation) in
            newLocation.getAddress { (address) in
                print("åååAddress:\(String(describing: address))")
                self.didPickALocation(newLocation)
            }
        }
    }
    func didPickALocation(_ location : MyLocationModel){
        self.exitScreen(animated: true)
        self.setLocationDelegate?.handySetLocation(didSetLocation: location)
        
    }
   func getLocationCoordinates(withReferenceID referenceID: String,address : String)
   {
       var dicts = [AnyHashable: Any]()
       
       dicts["token"]   = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
       let paramsComponent: String = "\(GOOGLE_MAP_DETAILS_URL)?key=\(GooglePlacesApiKey)&reference=\(referenceID)&sensor=\("true")"
       WebServiceHandler.sharedInstance.getThridPartyWebService(wsMethod: paramsComponent, paramDict: dicts as! [String : Any], viewController: self, isToShowProgress: false, isToStopInteraction: false) { (responseDict) in
    let gModel =  GoogleLocationModel.generateModel(from: responseDict)
           
           if gModel.status_code == "1"
           {
               let dictsTempsss = gModel.dictTemp[RESPONSE_KEY_RESULT] as! NSDictionary
               self.googleData(didLoadPlaceDetails: dictsTempsss,address: address)
               
           }else {
               
           }
       }
       
   }
   
   func googleData(didLoadPlaceDetails placeDetails: NSDictionary,address : String) {
       self.searchDidComplete(withPlaceDetails: placeDetails,address: address)
   }
   
   
   func searchDidComplete(withPlaceDetails placeDetails: NSDictionary,address : String)
   {
       let placeGeometry =  (placeDetails[RESPONSE_KEY_GEOMETRY]) as? NSDictionary
       let locationDetails  = (placeGeometry?[RESPONSE_KEY_LOCATION]) as? NSDictionary
       let lat = (locationDetails?[RESPONSE_KEY_LATITUDE] as? Double)
       let lng = (locationDetails?[RESPONSE_KEY_LONGITUDE] as? Double)
       
       
       let longitude :CLLocationDegrees = Double(String(format: "%2f", lng!))!
       let latitude :CLLocationDegrees = Double(String(format: "%2f", lat!))!
   
       self.didPickALocation(MyLocationModel(address: address,
                                             location: CLLocation(
                                               latitude: latitude,
                                               longitude: longitude)))
   }

}

