//
//  RequestAcceptView.swift
//  Goferjek Driver
//
//  Created by trioangle on 19/10/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import Foundation
import GoogleMaps
import SwiftUI

class RequestAcceptView: BaseView, ProgressViewHandlerDelegate {

    @IBOutlet weak var timerLbl: PrimaryHeaderLabel!
    @IBOutlet weak var verticalBar: UIView!
    @IBOutlet weak var dropView: PrimaryView!
    @IBOutlet weak var pickView: UIView!
    @IBOutlet weak var viewDetailHoder: SecondaryView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var pickupLocLbl: UILabel!
    @IBOutlet weak var dropLocLbl: UILabel!
    @IBOutlet weak var lblPickUpMins: SecondaryRegularLabel!
    @IBOutlet weak var lblAcceptOrCancel: UILabel!
    @IBOutlet weak var viewCircular: BIZCircularProgressView!
    @IBOutlet weak var viewAccepting: UIView!
    @IBOutlet weak var mapView: UIImageView!
    @IBOutlet weak var cancelRequestBtn : PrimaryBorderedButton!
    @IBOutlet weak var seatsLbl : SecondaryRegularLabel!
    @IBOutlet weak var separatorLbl: UILabel!
    @IBOutlet weak var stopsLbl: SecondaryRegularBoldLabel!

    
    var viewcontroller : RequestAcceptVC!
    
    lazy var gMapView : GMSMapView? = {
        let map = GMSMapView()
        map.frame = self.mapView.bounds
        self.mapView.addSubview(map)
        self.mapView.bringSubviewToFront(map)
        return map
    }()
    
    lazy var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    var progressView : BIZProgressViewHandler?
    let shapeLayer = CAShapeLayer()
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewcontroller = baseVC as? RequestAcceptVC
        self.initializeTime()
    }
    
    override func darkModeChange() {
        super.darkModeChange()
        setTheme()
        setDesign()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setTheme()
        self.setDesign()
    }
    func setTheme(){
        onChangeMapStyle()
        self.viewCircular.backgroundColor = UIColor.PrimaryColor.withAlphaComponent(0.5)
        self.timerLbl.customColorsUpdate()
        self.viewDetailHoder.customColorsUpdates()
        self.lblPickUpMins.customColorsUpdate()
        self.seatsLbl.customColorsUpdate()
        self.dropView.customColorsUpdate()
        self.cancelRequestBtn.customColorsUpdate()
        self.stopsLbl.customColorsUpdate()
        shapeLayer.strokeColor = isDarkStyle ? UIColor.DarkModeTextColor.cgColor : UIColor.DarkModeBackground.cgColor
    }
    
    func initializeTime(){
        DispatchQueue.main.async {
            self.drawDottedLine(start: CGPoint(x: self.verticalBar.bounds.minX, y: self.verticalBar.bounds.minY), end: CGPoint(x: self.verticalBar.bounds.minX, y: self.verticalBar.frame.maxY), view: self.verticalBar)
        }
        let start_time = self.viewcontroller.startTime ?? ""
        let end_time = self.viewcontroller.endTime ?? ""
        let epocTimeStart = TimeInterval(start_time) ?? Double()
        let epocTimeEnd = TimeInterval(end_time) ?? Double()
        let myStartDate = NSDate(timeIntervalSince1970: epocTimeStart)
        let myEndDate = NSDate(timeIntervalSince1970: epocTimeEnd)
        let components = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: myEndDate as Date)
        print(components.second ?? "")
        let currentTimeStamp = Date()
        print(currentTimeStamp)
        let diffcomponents = Calendar.current.dateComponents([.second], from: myStartDate as Date, to: currentTimeStamp as Date)
        print(diffcomponents.second ?? "")
        if (components.second ?? 0) >= diffcomponents.second ?? 0 {
            let seconds = (components.second ?? 0)  - (diffcomponents.second ?? 0)
            self.viewcontroller.requestTime = seconds
        }
        setStaticMap()
        self.viewcontroller.appDelegate.pushManager.registerForRemoteNotification()
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.initView()
        }
        self.setDesign()
    }
    
    
    func initView(){
        lblPickUpMins.text = "\(self.viewcontroller.strPickupTime) "
        + String(format:(self.viewcontroller.strPickupTime == "1") ? LangCommon.minute.uppercased() : LangCommon.minutes.uppercased())
        self.lblAcceptOrCancel.text = LangCommon.acceptingRequest.capitalized
        self.stopsLbl.isHidden = self.viewcontroller.isMultiTrip
        self.stopsLbl.text = LangCommon.noOfStops + ": \(self.viewcontroller.no_of_stops.description)"
        self.stopsLbl.borderColor = UIColor.black
        self.stopsLbl.cornerRadius = 20
        self.stopsLbl.borderWidth = 0.5

        
        viewAccepting.isHidden = true
        viewCircular.layer.cornerRadius = (self.viewCircular.frame.width) / 2
        self.addSubview(mapView)
        self.addSubview(btnAccept)
        self.bringSubviewToFront(self.mapView)
        self.bringSubviewToFront(self.viewCircular)
        self.bringSubviewToFront(self.viewAccepting)
        self.bringSubviewToFront(self.btnAccept)
        self.bringSubviewToFront(self.viewDetailHoder)
        self.bringSubviewToFront(self.timerLbl)
        self.bringSubviewToFront(self.cancelRequestBtn)
        self.bringSubviewToFront(self.seatsLbl)
        if self.viewcontroller.no_of_stops > 0 {
            self.bringSubviewToFront(self.stopsLbl)
        } else {
            print("Hello...")
        }


        guard let time : Int = UserDefaults.value(for: .requestTime) else{return}
        if time > self.viewcontroller.requestTime {
            self.viewcontroller.maxReqTime = time
        }else{
            self.viewcontroller.maxReqTime = self.viewcontroller.requestTime
        }
        self.timerLbl.text = "\(LangGofer.accept.uppercased()) \n 0:\(self.viewcontroller.requestTime ) \(LangCommon.min.uppercased())"
        viewCircular.progressLineWidth = 8
        progressView = BIZProgressViewHandler.init(progressView: viewCircular,
                                                       minValue:  0,
                                                   maxValue: CGFloat(self.viewcontroller.requestTime), progressTime: CGFloat(self.viewcontroller.maxReqTime ?? 15 ))
        progressView?.liveProgress = true
        progressView?.delegate = self
        progressView?.start()
        btnAccept.backgroundColor = UIColor.clear
        self.viewcontroller.timerAni = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.onCallTimer), userInfo: nil, repeats: true)
        self.viewcontroller.timerCancelTrip = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.viewcontroller.requestTime -= 1
            if self.viewcontroller.requestTime <= 0 {
                timer.invalidate()
                self.viewcontroller.onGoBack()
            }else{
                self.timerLbl.text = "\(LangGofer.accept.uppercased()) \n 0:\(self.viewcontroller.requestTime ) \(LangCommon.min.uppercased())"
            }
        })
        self.seatsLbl.isHidden = !self.viewcontroller.isPoolRequest
        
        self.seatsLbl.text = "\(LangGofer.poolRequest): ( \(self.viewcontroller.numberOfSeats) \(self.viewcontroller.numberOfSeats == 1 ? LangCommon.person : LangCommon.person) )".capitalized
        self.cancelRequestBtn.setTitle(LangCommon.cancel.capitalized, for: .normal)
        self.viewCircular.isHidden = false
        
        let tinyFont = [ NSAttributedString.Key.font: UIFont(name: G_BoldFont, size: 13)! ]
        let RegularFont = [ NSAttributedString.Key.font: UIFont(name: G_BoldFont, size: 17)! ]

        let pickUpheader = NSMutableAttributedString(string: "\(LangCommon.pickUp.capitalized) \(LangCommon.address.capitalized) : \n",attributes: tinyFont)
        let pickup = NSMutableAttributedString(string: self.viewcontroller.strPickupLocation,attributes: RegularFont)
        pickUpheader.append(pickup)
        self.pickupLocLbl.attributedText = pickUpheader

        let dropHeader = NSMutableAttributedString(string: "\(LangCommon.dropOff.capitalized) \(LangCommon.address.capitalized) : \n",attributes: tinyFont)
        let drop = NSMutableAttributedString(string: self.viewcontroller.strDropLocation,attributes: RegularFont)
        dropHeader.append(drop)
        self.dropLocLbl.attributedText = dropHeader
    }
    
    
    @objc func onCallTimer(){
        playSound("ub__reminder")
    }
    
    func playSound(_ fileName: String) {
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        do {
            self.viewcontroller.player = try AVAudioPlayer(contentsOf: url)
            guard let player = self.viewcontroller.player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setDesign(){
        self.separatorLbl.backgroundColor = .TertiaryColor.withAlphaComponent(0.5)
        self.lblAcceptOrCancel.cornerRadius = 10
        self.lblAcceptOrCancel.textColor = .SecondaryTextColor
        self.pickView.backgroundColor = isDarkStyle ? .SecondaryColor : .InactiveTextColor
        self.pickView.isRoundCorner = true
        self.dropView.isRoundCorner = true
        self.viewDetailHoder.elevate(4)
        self.cancelRequestBtn.cornerRadius = 10
      
    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [7, 3]
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    
    func onChangeMapStyle()
    {
        do {
           
           if let styleURL = Bundle.main.url(forResource: self.isDarkStyle ?  "map_style_dark" : "mapStyleChanged", withExtension: "json") {
               gMapView?.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
            }
        } catch {
        }
    }
    
    func setStaticMap(){
        guard let lat = Double(self.viewcontroller.strPickUpLatitude),
              let lng = Double(self.viewcontroller.strPickUpLongitude) else{return}
        let pickUp = CLLocationCoordinate2D(latitude: lat,
                                            longitude: lng)
        self.gMapView?.clear()
        let marker = GMSMarker()
        marker.icon = UIImage(named: "man_marker.png")
        marker.position = pickUp
        marker.map = self.gMapView
        DispatchQueue.main.asyncAfter(deadline: .now()+0.002) {
            self.gMapView?.frame = self.mapView.bounds
            self.layoutIfNeeded()
            self.gMapView?.moveCamera(GMSCameraUpdate
                                        .setTarget(pickUp))
            self.gMapView?.animate(toZoom: 13.4)
        }
    }
    
    internal func progressViewHandler(_ progressViewHandler: BIZProgressViewHandler!, didFinishProgressFor progressView: BIZCircularProgressView!) {
        self.viewcontroller.timerAni.invalidate()
        self.btnAccept.layer.borderWidth = 0.0
    }
    
    @IBAction func onAcceptTapped()
    {
        self.viewCircular.isHidden = true
        self.timerLbl.isHidden = true
        self.viewcontroller.callRequestAcceptAPI(status: "Trip")  // accepting rider trip
    }
    
    @IBAction func onCancelRequest(_ sender : UIButton?){
        self.viewcontroller.clearAllAnimations()
        self.viewcontroller.onGoBack()
    }
    
}
