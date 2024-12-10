/**
* RequestAcceptVC.swift
*
* @package GoferDriver
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import AVFoundation
import MapKit
import FirebaseDatabase
import Foundation
import GoogleMaps
import Alamofire
class RequestAcceptVC1 : UIViewController,
    ProgressViewHandlerDelegate,
    APIViewProtocol
{
    var apiInteractor: APIInteractorProtocol?
    
    func onAPIComplete(_ response: ResponseEnum, for API: APIEnums) {
        switch response {
        case .tripDetailData(data: let detail):
            self.gotoToRouteView(with: detail)
        default:
            break
        }
    }
    func onFailure(error: String, for API: APIEnums) {
        self.appDelegate.createToastMessage(error)
    }
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var player: AVAudioPlayer?

    // MARK: - ViewController Methods
    @IBOutlet var viewDetailHoder: UIView!
    @IBOutlet var btnAccept: UIButton!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet var lblLocationName: UILabel!
    @IBOutlet var lblPickUpMins: UILabel!
    @IBOutlet var lblAcceptOrCancel: UILabel!
    @IBOutlet var viewCircular: BIZCircularProgressView!
    @IBOutlet var viewAccepting: UIView!
    @IBOutlet var mapView: UIImageView!
    
    @IBOutlet var requestVCView: UIView!
    
    @IBOutlet weak var lblStoreName: UILabel!
    
    @IBOutlet weak var lblTotalOrders: UILabel!
    @IBOutlet var mainview: UIView!
    
    lazy var gMapView : GMSMapView = {
        let map = GMSMapView()
        map.frame = self.mapView.bounds
        self.mapView.addSubview(map)
        self.mapView.bringSubviewToFront(map)
        return map
    }()
    var rippleEffect = LNBRippleEffect()
    
    var localTimeZoneName: String { return TimeZone.current.identifier }
    var isCalled : Bool = false
    var justLaunced = false
    
    var timerAni = Timer()
    var timerCancelTrip = Timer()
    var strRequestID = ""
    var strPickupLocation = ""
    var strPickupTime = ""
    var strPickUpLatitude = ""
    var strPickUpLongitude = ""
    var strStoreName = ""
    var orderID  = ""
    var restaurantName = ""
    var storeName = ""
    var store_Name = ""
    var totalOrders = ""
    var multipleDeliveryStatus = ""
    var groupID = ""

    
    var spinnerView = JTMaterialSpinner()
    // MARK: - Variable for Language Protocol
    var language : LanguageContentModel {
     get{return Shared.instance.AppLanaguage}
 }

    
// MARK: - ViewController Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mainview.backgroundColor = .ThemeMain
        UserDefaults.standard.set(strRequestID, forKey: "strRequestID")
        print("Request ID \(strRequestID)")
        self.apiInteractor = APIInteractor(self)
    
        setStaticMap()
        self.lblAcceptOrCancel.text = self.language.goferDeliveryAll.acceptingPickup.capitalized
        self.appDelegate.pushManager.registerForRemoteNotification()
        UberSupport().changeStatusBarStyle(style: .lightContent)

//
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        
//        lblStoreName.text = strStoreName
        lblPickUpMins.text = "\(strPickupTime) "
            + String(format:(strPickupTime == "1") ? self.language.goferDeliveryAll.minute.uppercased() : self.language.goferDeliveryAll.minutes.uppercased()) + "\n \(storeName)"
        lblLocationName.text = strPickupLocation
        if multipleDeliveryStatus == "Yes"{
                    lblTotalOrders.text = "Total Orders : \(totalOrders)"
                }else{
                    lblTotalOrders.text = ""
                }
        storeNameLbl.text = store_Name
        let frame = CGRect(x: (self.view.frame.size.width - (self.view.frame.size.width-80)) / 2, y: (self.view.frame.size.height - (self.view.frame.size.height - viewDetailHoder.frame.size.height)) / 2, width: self.view.frame.size.width-80, height: self.view.frame.size.width-80)
        
        viewAccepting.isHidden = true
        btnAccept.frame = CGRect(x: 0, y: (self.view.frame.size.height - (self.view.frame.size.height + 80 - viewDetailHoder.frame.size.height)) / 2, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        
        viewCircular.frame = CGRect(x: (self.view.frame.size.width - (self.view.frame.size.width-60)) / 2, y: (self.view.frame.size.height - (self.view.frame.size.height + 20 - viewDetailHoder.frame.size.height)) / 2, width: self.view.frame.size.width-60, height: self.view.frame.size.width-60)
        viewCircular.layer.cornerRadius = (self.view.frame.size.width-60) / 2
        
        
        mapView.frame = frame
        mapView.layer.cornerRadius = (self.view.frame.size.width-80) / 2
        mapView.clipsToBounds = true
        
        rippleEffect = LNBRippleEffect(image: UIImage(named: ""), frame: frame, color: UIColor.clear, target: #selector(self.onCallTimer), id: self)
        rippleEffect.setRippleColor(UIColor.clear)
        rippleEffect.setRippleTrailColor(UIColor.ThemeLight)
        self.view.addSubview(rippleEffect)
        self.view.addSubview(mapView)
        self.view.addSubview(btnAccept)
        
        viewCircular.progressLineWidth = 8
        viewCircular.progressLineColor = UIColor.white
        let progressView = BIZProgressViewHandler.init(progressView: viewCircular,
                                                       minValue:  0,
                                                       maxValue: self.justLaunced ? 5 : 9)
        progressView?.liveProgress = true
        progressView?.delegate = self
        progressView?.start()
        
        btnAccept.backgroundColor = UIColor.clear
        onCallTimer()
        timerAni = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.onCallTimer), userInfo: nil, repeats: true)
        
        timerCancelTrip = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.onGoBack), userInfo: nil, repeats: false)
        
        // Theme Changes
        
//        requestVCView.backgroundColor = .ThemeMain
        viewDetailHoder.backgroundColor = .clear
//        btnAccept.backgroundColor = .ThemeLight
        
    }
    
    func setStaticMap(){
        guard let lat = Double(self.strPickUpLatitude),
            let lng = Double(self.strPickUpLongitude) else{return}
        let pickUp = CLLocationCoordinate2D(latitude: lat,
                                            longitude: lng)
        self.gMapView.clear()
        let marker = GMSMarker()
        marker.icon = UIImage(named: "man_marker.png")
        marker.position = pickUp
        marker.map = self.gMapView
//        self.gMapView.animate(toLocation: pickUp)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.gMapView.frame = self.mapView.bounds
            self.view.layoutIfNeeded()
            self.gMapView.moveCamera(GMSCameraUpdate
                .setTarget(pickUp))
            self.gMapView.animate(toZoom: 13.4)
        }
        
        /*let mapmainUrl = "https://maps.googleapis.com/maps/api/staticmap?"
        let startlatlong = String(format:"%@ , %@",strPickUpLatitude,strPickUpLongitude)
        let mapUrl  = mapmainUrl + startlatlong
        let key = "&key=" + (UserDefaults.value(for: .google_api_key) ?? "")
        let size = "&size=" +  "\(Int(350))" + "x" +  "\(Int(350))"
        let pickupImgUrl = String(format:"%@public/images/man_marker.png|",iApp.baseURL.rawValue)
        let positionOnMap = "&markers=size:mid|icon:" + pickupImgUrl + startlatlong
        let staticImageUrl = mapUrl + size + "&zoom=14" + positionOnMap + key
        
        if let urlStr = staticImageUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! as NSString?{
            print(urlStr)
            mapView?.sd_setImage(with: NSURL(string: urlStr as String)! as URL, placeholderImage:UIImage(named:""))
        }*/
    }
    
    @objc func onGoBack()
    {
        lblAcceptOrCancel.text = self.language.goferDeliveryAll.cancellingRequest
//        callRequestAcceptAPI(status: self.language.cancelled.capitalized)
        btnAccept.isUserInteractionEnabled = false
        timerAni.invalidate()
        timerCancelTrip.invalidate()
        rippleEffect.stopRippleAnimation()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "handle_timer"), object: self, userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    internal func progressViewHandler(_ progressViewHandler: BIZProgressViewHandler!, didFinishProgressFor progressView: BIZCircularProgressView!) {
        timerAni.invalidate()
        rippleEffect.stopRippleAnimation()
        btnAccept.layer.borderWidth = 0.0
    }
    
    @objc func onCallTimer()
    {
        playSound("ub__reminder")
    }
    
    func playSound(_ fileName: String) {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func clearAllAnimations()
    {
        self.player?.stop()
        timerAni.invalidate()
        timerCancelTrip.invalidate()
        viewAccepting.isHidden = false
        self.view.addSubview(viewAccepting)
        viewAccepting.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: 60, y: (viewAccepting.frame.size.height - 40) / 2, width: 40, height: 40)
        spinnerView.circleLayer.lineWidth = 3.0
        spinnerView.circleLayer.strokeColor =  UIColor.ThemeLight.cgColor
        spinnerView.beginRefreshing()
        viewCircular.removeFromSuperview()
        rippleEffect.stopRippleAnimation()
    }
    
    @IBAction func onAcceptTapped()
    {
        callRequestAcceptAPI(status: "Trip")  // accepting rider trip
    }
    
    
    
    
    //MARK: ACCEPT RIDER TRIP REQUEST
    func callRequestAcceptAPI(status: String)
    {
        if YSSupport.checkDeviceType()
        {
            if !(UIApplication.shared.isRegisteredForRemoteNotifications)
            {
                let settingsActionSheet: UIAlertController = UIAlertController(title:self.language.goferDeliveryAll.message, message: self.language.goferDeliveryAll.pleaseEnablePushNotificationInSettingsForRequest.uppercased(),preferredStyle:UIAlertController.Style.alert)
                settingsActionSheet.addAction(UIAlertAction(title:NSLocalizedString(self.language.goferDeliveryAll.ok.uppercased(), comment: ""), style:UIAlertAction.Style.cancel, handler:{ action in
                    self.appDelegate.pushManager.registerForRemoteNotification()
                }))
                present(settingsActionSheet, animated:true, completion:nil)
                return
            }
        }
        
        clearAllAnimations()
        self.btnAccept.isUserInteractionEnabled = false
        var dicts = Parameters()
        dicts["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["status"] = status
        dicts["request_id"] = strRequestID
        dicts["timezone"] = self.localTimeZoneName
        dicts["order_id"] = self.orderID
        let loader = UberSupport()
//        loader.showProgressInWindow(showAnimation: true)
       
        self.apiInteractor?
            .getRequest(for: APIEnums.acceptRequest, params: dicts)
            .responseJSON { (json) in
//            loader.removeProgressInWindow()
            if json.isSuccess{
              let tripDetailData = TripDetailDataModel(json)
                self.handleResponse(gModel: tripDetailData,status : status)
            }else{
                self.appDelegate.createToastMessage(json.status_message)
                self.onGoBack()
                
            }
        }
        .responseFailure { (error) in
            self.appDelegate.createToastMessage(error)
            self.onGoBack()
        }

    
    }
    func handleResponse(gModel : TripDetailDataModel,status : String){
        if gModel.statusCode == "1"
        {
            let cash = gModel.paymentMode
            let requestID = gModel.requestID
            print("recived group ID \(requestID)")
            UserDefaults.standard.set(requestID, forKey: "req_ID")
            self.gotoToRouteView(with: gModel)
            Constants().STOREVALUE(value: status, keyname: USER_ONLINE_STATUS)
            Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
            Constants().STOREVALUE(value:  cash, keyname: CASH_PAYMENT)

        }
        else if gModel.statusCode == "0"{
            
            print(gModel.statusMessage)
            let messages = gModel.statusMessage
            print(messages)
            if(messages == self.language.goferDeliveryAll.alreadyAccepted) {
                let msg = self.language.goferDeliveryAll.alreadyAcceptedBySomeone
                
            self.appDelegate.createToastMessage(msg)
            Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
                let userDefaults = UserDefaults.standard
                userDefaults.set("driver", forKey:"getmainpage")
                self.appDelegate.onSetRootViewController(viewCtrl: self)                        }
            else{
                Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
            }

        }
        else
        {
            if gModel.statusMessage == "user_not_found" || gModel.statusMessage == "token_invalid" || gModel.statusMessage == "Invalid credentials" || gModel.statusMessage == "Authentication Failed"
            {
                self.appDelegate.logOutDidFinish()
                return
            }
            else{
            }
           
        }
    }
    //MARK:- initWithStory
    class func initWithStory() -> RequestAcceptVC{
        let view : RequestAcceptVC = UIStoryboard.trip.instantiateViewController()
        
        view.apiInteractor = APIInteractor(view)
        return view
    }
    
    // MARK: - NAVIGATE TO ROUTE VIEW AFTER ACCETPTING REQUEST
    func gotoToRouteView(with trip : TripDetailDataModel)
    {
        guard let intOrderID = Int(self.orderID) else{return}
        FireBaseNodeKey.rider.setValue(trip.id.description, for: "\(trip.riderID)","trip_id")
        
        let grp_ID = self.groupID
        UserDefaults.standard.set(grp_ID, forKey: "group_ID")

        Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
        let tripView = RouteVC.initWithStory(intOrderID)
//        let tripView = self.storyboard?.instantiateViewController(withIdentifier: "RouteVC") as! RouteVC
        tripView.tripDataModel = trip
        tripView.shouldPopToRootVC = true
       // tripView.shouldPopToOrdersVC = true
        tripView.reqID = trip.requestID
        tripView.groupID = grp_ID
        tripView.multipleDelivery = self.multipleDeliveryStatus
        self.navigationController?.pushViewController(tripView, animated: true)
    }
    
    func animateBorderWidth(view: UIButton, from: CGFloat, to: CGFloat, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        view.layer.add(animation, forKey: "Width")
        view.layer.borderWidth = to
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
    }
    
}
