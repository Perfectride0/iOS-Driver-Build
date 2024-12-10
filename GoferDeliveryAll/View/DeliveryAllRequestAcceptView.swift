//
//  DeliveryAllRequestAcceptView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 10/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import FirebaseDatabase
import Alamofire
import Lottie
import GoogleMaps
import GooglePlaces

class DeliveryAllRequestAcceptView: BaseView {
    //MARK: - OUTLETS
    var deliveryAllRequestAcceptVC: DeliveryAllRequestAcceptVC!
    @IBOutlet weak var timerLbl: SecondaryHeaderLabel!
    @IBOutlet weak var viewDetailHoder: TopCurvedView!
    @IBOutlet weak var topCurveMap: TopCurvedView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblAcceptOrCancel: SecondaryHeaderLabel!
    @IBOutlet weak var spinnerHolderView: UIView!
    @IBOutlet weak var acceptReqHolderView: SecondaryView!
    @IBOutlet weak var viewCircular: BIZCircularProgressView!
    @IBOutlet weak var viewAccepting: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var googleMap: UIView!
    //@IBOutlet weak var google_Map: GMSMapView!
    @IBOutlet weak var cancelRequestBtn : SecondaryBorderedButton!
    @IBOutlet weak var totalOrdersLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var storeNameLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var orderTimeLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var dropLocationLbl: SecondarySmallBoldLabel!
    
    //MARK: - LOCAL VARIABLES
    
    lazy var gMapView : GMSMapView = {
        let map = GMSMapView()
        
        self.mapView.addSubview(map)
        map.frame = self.mapView.bounds
        return map
    }()
    
    var player: AVAudioPlayer?
    
    var spinnerView = JTMaterialSpinner()
//    var animationView : AnimationView?
   
    var localTimeZoneName: String { return TimeZone.current.identifier }
    var isCalled : Bool = false
    var timerAni = Timer()
    var timerCancelTrip = Timer()
    var requestTime = 10
    var maxReqTime : Int?
    //MARK: - NECESSARY CLASS FUNCTIONS
    override
    func didLoad(baseVC: BaseVC) {
        self.deliveryAllRequestAcceptVC = baseVC as? DeliveryAllRequestAcceptVC
        super.didLoad(baseVC: baseVC)
        if let Time : Int = UserDefaults.value(for: .requestTime) {
            self.requestTime = Time
        }
        self.initView()
        self.initialize()
        self.darkModeChange()
    }
    func initView(){
//        self.mapView.layer.cornerRadius = 40.0
//        self.mapView.clipsToBounds = true
        self.onChangeMapStyle(map: self.gMapView)
    }
    override func darkModeChange() {
        super.darkModeChange()
        viewDetailHoder.customColorsUpdate()
        cancelRequestBtn.customColorsUpdate()
        lblAcceptOrCancel.customColorsUpdate()
        totalOrdersLbl.customColorsUpdate()
        storeNameLbl.customColorsUpdate()
        orderTimeLbl.customColorsUpdate()
        dropLocationLbl.customColorsUpdate()
        topCurveMap.customColorsUpdate()
        self.acceptReqHolderView.customColorsUpdate()
        self.onChangeMapStyle(map: self.gMapView)
    }

    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.IndicatorColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3]
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    func initialize() {
        setStaticMap()
        UserDefaults.standard.set(self.deliveryAllRequestAcceptVC.strRequestID, forKey: "strRequestID")
        print("Request ID \(self.deliveryAllRequestAcceptVC.strRequestID)")
                self.lblAcceptOrCancel.text = LangDeliveryAll.acceptingPickup.capitalized
                deliveryAllRequestAcceptVC.appDelegate.pushManager.registerForRemoteNotification()
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        storeNameLbl.text = deliveryAllRequestAcceptVC.strStoreName
        orderTimeLbl.text = "\(self.deliveryAllRequestAcceptVC.strPickupTime) \(self.deliveryAllRequestAcceptVC.strPickupTime == "1" ? LangCommon.min : LangCommon.mins)"
 
        dropLocationLbl.text = self.deliveryAllRequestAcceptVC.strPickupLocation
            totalOrdersLbl.text = "\(LangDeliveryAll.totalnumbers) : \(self.deliveryAllRequestAcceptVC.totalOrders)"
        let frame = CGRect(x: (self.frame.size.width - (self.frame.size.width-80)) / 2, y: (self.frame.size.height - (self.frame.size.height - viewDetailHoder.frame.size.height)) / 2, width: self.frame.size.width-80, height: self.frame.size.width-80)
                
        viewAccepting.isHidden = true
        
//        btnAccept.frame = CGRect(x: 0, y: (self.frame.size.height - (self.frame.size.height + 80 - viewDetailHoder.frame.size.height)) / 2, width: self.frame.size.width, height: self.frame.size.width)
                
        viewCircular.frame = CGRect(x: (self.frame.size.width - (self.frame.size.width-60)) / 2, y: (self.frame.size.height - (self.frame.size.height + 20 - viewDetailHoder.frame.size.height)) / 2, width: self.frame.size.width-60, height: self.frame.size.width-60)
       
        viewCircular.layer.cornerRadius = (self.frame.size.width-60) / 2
        guard let time : Int = UserDefaults.value(for: .requestTime) else{return}
        if time > self.requestTime {
            self.maxReqTime = time
        }else{
            self.maxReqTime = self.requestTime
        }
                
        mapView.frame = self.frame
        mapView.clipsToBounds = true
        self.addSubview(btnAccept)
        self.bringSubviewToFront(self.cancelRequestBtn)
        viewCircular.progressLineWidth = 8
        viewCircular.progressLineColor = .PrimaryColor
        let progressView = BIZProgressViewHandler.init(progressView: viewCircular,
                                                       minValue:  0,
                                                       maxValue:CGFloat(self.requestTime), progressTime: CGFloat(self.maxReqTime ?? 15 ))
        progressView?.liveProgress = true
        progressView?.delegate = self.deliveryAllRequestAcceptVC
        progressView?.start()
        
        btnAccept.backgroundColor = UIColor.clear
        onCallTimer()
        timerAni = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.onCallTimer), userInfo: nil, repeats: true)
        self.timerLbl.text = LangHandy.accept + " \n 0:\(self.requestTime) " + LangCommon.mins.capitalized
        timerCancelTrip = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.requestTime -= 1
            if self.requestTime <= 0 {
                timer.invalidate()
                self.onGoBack()
            }else{
                self.timerLbl.text = LangHandy.accept + " \n 0:\(self.requestTime) " + LangCommon.mins.capitalized
            }
        })
//        timerCancelTrip = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.onGoBack), userInfo: nil, repeats: false)
        viewDetailHoder.backgroundColor = .clear
    }
    
    //map view mode changes:
    func onChangeMapStyle(map: GMSMapView) {
            // Create a GMSCameraPosition that tells the map to display the
            // coordinate at zoom level 6.
            // googleMapView.setMinZoom(15.0, maxZoom: 55.0)
            let camera = GMSCameraPosition.camera(withLatitude: 9.917703, longitude: 78.138299, zoom: 4.0)
            GMSMapView.map(withFrame: map.frame, camera: camera)
            do {
                // Set the map style by passing the URL of the local file. Make sure style.json is present in your project
                if let styleURL = Bundle.main.url(forResource: self.isDarkStyle ?  "map_style_dark" : "mapStyleChanged", withExtension: "json") {
                    map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                }
            } catch {
            }
        }

    
    func setStaticMap(){
        guard let lat = Double(self.deliveryAllRequestAcceptVC.strPickUpLatitude),
              let lng = Double(self.deliveryAllRequestAcceptVC.strPickUpLongitude) else{return}
        let pickUp = CLLocationCoordinate2D(latitude: lat,
                                            longitude: lng)
        self.gMapView.clear()
        let marker = GMSMarker()
        marker.icon = UIImage(named: "man_marker.png")
        marker.position = pickUp
        marker.map = self.gMapView
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.gMapView.frame = self.mapView.bounds
            self.deliveryAllRequestAcceptVC.view.layoutIfNeeded()
            self.gMapView.moveCamera(GMSCameraUpdate
                .setTarget(pickUp))
            self.gMapView.animate(toZoom: 13.4)
        }
    }
    func clearAllAnimations() {
        self.player?.stop()
        self.timerAni.invalidate()
        self.timerCancelTrip.invalidate()
        self.viewAccepting.isHidden = false
        self.addSubview(self.viewAccepting)
        self.spinnerHolderView.addSubview(self.spinnerView)
        self.spinnerView.anchor(toView: self.spinnerHolderView,
                                leading: 0,
                                trailing: 0,
                                top: 0,
                                bottom: 0)
        self.spinnerView.circleLayer.lineWidth = 3.0
        self.spinnerView.circleLayer.strokeColor =  UIColor.PrimaryColor.cgColor
        self.spinnerView.beginRefreshing()
        self.viewCircular.removeFromSuperview()
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func cancelAction(_ sender:Any){
        appDelegate.onSetRootViewController(viewCtrl: self.deliveryAllRequestAcceptVC)
    }
    @IBAction func onAcceptTapped() {
        self.timerLbl.isHidden = false
        self.callRequestAcceptAPI(status: "Trip")  // accepting rider trip
    }
    
    func callRequestAcceptAPI(status: String) {
        if !isSimulator {
            if !(UIApplication.shared.isRegisteredForRemoteNotifications) {
                self.deliveryAllRequestAcceptVC
                    .commonAlert
                    .setupAlert(alert: LangDeliveryAll.message,
                                alertDescription: LangDeliveryAll.pleaseEnablePushNotificationInSettingsForRequest,
                                okAction: LangCommon.ok,
                                cancelAction: nil,
                                userImage: nil)
                self.deliveryAllRequestAcceptVC
                    .commonAlert
                    .addAdditionalOkAction(isForSingleOption: true) {
                        self.deliveryAllRequestAcceptVC.appDelegate.pushManager.registerForRemoteNotification()
                }
                return
            }
        }
        
        self.clearAllAnimations()
        self.btnAccept.isUserInteractionEnabled = false
        self.timerLbl.isHidden = true
        var dicts = JSON()
        dicts["status"] = status
        dicts["request_id"] = self.deliveryAllRequestAcceptVC.strRequestID
        dicts["timezone"] = self.localTimeZoneName
        dicts["order_id"] = self.deliveryAllRequestAcceptVC.orderID
        dicts["business_id"] = self.deliveryAllRequestAcceptVC.business_id
        
        self.deliveryAllRequestAcceptVC.onAcceptReq(json: dicts,
                                                    status: status)
    }
    @objc func onGoBack() {
        self.btnAccept.isUserInteractionEnabled = false
        self.timerAni.invalidate()
        self.timerCancelTrip.invalidate()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "handle_timer"),
                                        object: self,
                                        userInfo: nil)
        self.deliveryAllRequestAcceptVC.navigationController?.popViewController(animated: true)
    }

    @objc func onCallTimer() {
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
    
    internal func progressViewHandler(_ progressViewHandler: BIZProgressViewHandler!, didFinishProgressFor progressView: BIZCircularProgressView!) {
        timerAni.invalidate()
        btnAccept.layer.borderWidth = 0.0
    }

}
