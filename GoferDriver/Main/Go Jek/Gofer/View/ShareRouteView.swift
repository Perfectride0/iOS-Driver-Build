//
//  ShareRouteView.swift
//  GoferDriver
//
//  Created by Trioangle on 01/09/21.
//  Copyright © 2021 Trioangle Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseDatabase

class ShareRouteView : BaseView {
    
    //-----------------------------
    // MARK: - Outlets
    //-----------------------------
    
    @IBOutlet weak var riderTableView : CommonTableView!
    @IBOutlet weak var riderTblHolderView : SecondaryView!
    @IBOutlet weak var riderTableHeight : NSLayoutConstraint!
    @IBOutlet weak var viewAddressHoder: SecondaryView!
    @IBOutlet weak var lblLocationName: SecondaryRegularBoldLabel!
    @IBOutlet weak var googleMap: UIView!
    @IBOutlet weak var cashView: SecondaryInvertedView!
    @IBOutlet weak var navigateLabel : SecondaryInvertedRegularLabel!
    @IBOutlet weak var navigationView : SecondaryInvertedView!
    @IBOutlet weak var navigationImage : PrimaryImageView!
    @IBOutlet weak var barView : SecondaryView!
    @IBOutlet weak var enRouteLbl: SecondaryHeaderLabel!
    @IBOutlet weak var cashTripLbl : SecondaryInvertedRegularLabel!
    @IBOutlet weak var etaLbl : SecondaryInvertedSmallLabel!
    @IBOutlet weak var cashImg: SecondaryInvertedImageView!
    @IBOutlet weak var topIndicatorView: UIView!
    @IBOutlet weak var barIV: PrimaryImageView!
    @IBOutlet weak var headerView: HeaderView!
    
    //-----------------------------
    // MARK: - Local Variables
    //-----------------------------
  
//    let tripProgressBtn = ProgressButton()
    var viewDetailHoder: TripProgressBtnHolder!
    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var map : GMSMapView?
    var shareRouteVC : ShareRouteVC!
    let mainCellHeight : CGFloat = 90
    let coCellHeight : CGFloat = 50
    var currentLocation: CLLocation!
    lazy var polyline = GMSPolyline()
    var driversPositiionAtPath : UInt = 0
    var knownETASecFromGoogle : Int = 60
    fileprivate let cameraDefaultZoom : Float = 16.5
    var lastDirectionAPIHitStamp : Date?
    var chatBubbleBtn : UIButton?
    var chatBubbleIV : UIImageView?
    var yMovement: CGFloat?
    lazy var currenRouteData : Route? = nil
    var ref: DatabaseReference!
    var dropLocation = ""


    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    lazy var tripCache = TripCache()
    var isNetworkReachable : Bool?
    var getTripID : String{
        return self.shareRouteVC.tripId.description
    }
    var IsendPopUp = false
    
    // var wayPoints = [WayPoint]()


    var timerForETA : Timer? = nil
    var tripManager : TripManager?
    lazy var googlePath = GMSPath() {
        didSet{
            guard !self.googlePath.encodedPath().isEmpty,
                  oldValue != self.googlePath else{return}
            self.updateFirebase(withNewPath: self.googlePath.encodedPath())
        }
    }
    
    //-----------------------------
    // MARK: - Life Cycle
    //-----------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.shareRouteVC = baseVC as? ShareRouteVC
        self.viewDetailHoder = TripProgressBtnHolder.initViewFromXib(width: self.riderTableView.bounds.width)
        self.darkModeChange()
        //        self.shareRouteVC.getTripDetails()


    }
    
    override func willAppear(baseVC: BaseVC) {
//        self.shareRouteVC.getTripDetails()
    }

    
    
    override
    func didDisappear(baseVC: BaseVC) {
        super.didDisappear(baseVC: baseVC)
        self.removeMap()
    }
    
    //-----------------------------
    // MARK: - Actions
    //-----------------------------
    
    @IBAction func goToChatVC() {
        //
        guard let data = self.tripManager?.tripDetailModel.getCurrentTrip() else{return}
        let chatVC = ChatVC.initWithStory(withTripId: data.jobID.description,
                                          ridereID: data.id,
                                          riderRating: Double(data.rating),
                                          imageURL: data.image,
                                          name: data.name,
                                          typeCon: .u2d)
        self.shareRouteVC.navigationController?
            .pushViewController(chatVC,
                                animated: true)
    }
    
    
    @IBAction
    func onBackTapped() {
        Shared.instance.resumeTripHitCount = 1
        self.deinitObjects()
        if let vc = self.shareRouteVC.findLastBeforeVC(),
           vc.isKind(of: HandyTripHistoryVC.self) {
            self.shareRouteVC.updateTripHistory?.updateContent()
            self.shareRouteVC.exitScreen(animated: true)
        } else {
            self.shareRouteVC.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction
    func onRiderViewProfileTapped() {
        guard let data = self.tripManager?.tripDetailModel else{
            self.tripManager?.fetchTripDetails() ; return }
        let tripView = GoferRiderProfileVC.initWithStory()
        tripView.tripDetailDataModel = data
        tripView.isTripStarted = self.tripManager?.currentTripStatus.isTripStarted ?? true
        self.shareRouteVC.navigationController?.pushViewController(tripView,
                                                                   animated: true)
    }
    
    override
    func didLayoutSubviews(baseVC: BaseVC) {
        super.didLayoutSubviews(baseVC: baseVC)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewDetailHoder.frame.size = CGSize(width: self.riderTableView.bounds.width,
                                                     height: 60)
            self.viewDetailHoder.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
    
    //-----------------------------
    // MARK: - init Functions
    //-----------------------------
    func initView(){
        self.riderTableView.delegate = self
        self.riderTableView.dataSource = self
        
        if !ChatInteractor.instance.isInitialized{
            ChatInteractor.instance.initialize(withTrip: getTripID,
                                               type: .u2d)
        }
        
        ref = Database.database().reference().child(firebaseEnvironment.rawValue)
        cashView.layer.cornerRadius = 10
        googleMap.addSubview(cashView)
        self.viewDetailHoder.darkModeChange()
        
        if !(self.shareRouteVC.tripDataModel.getCurrentTrip()?.isMultiTrip ?? false),
           let waypoints = self.shareRouteVC.tripDataModel?.getCurrentTrip()?.wayPoints{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                switch self.tripManager?.currentTripStatus ?? .scheduled {
                case .scheduled:
                    self.viewDetailHoder.tripProgressBtn.set2Trip(state: .scheduled)
                case .beginTrip:
                    self.viewDetailHoder.tripProgressBtn.set2Trip(state: .beginTrip)
                    Constants().STOREVALUE(value: "Trip", keyname: TRIP_STATUS)
                case .endTrip:
                    self.viewDetailHoder.tripProgressBtn.set2Trip(state: .endTrip)
                    Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
                    Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
                default:
                    break
                }
            }
        }
        self.tripManager?.updateCurrentLocationToServer()
        let nav_comapass = UIImage(named: "compass.png")?.withRenderingMode(.alwaysTemplate)
        self.navigationImage.image = nav_comapass
        self.barView.elevate(2)
        self.setFonts()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.enRouteLbl.customColorsUpdate()
        self.riderTableView.customColorsUpdate()
        self.riderTableView.reloadData()
        self.riderTblHolderView.customColorsUpdate()
        self.viewAddressHoder.customColorsUpdate()
        self.cashView.customColorsUpdate()
        self.navigateLabel.customColorsUpdate()
        self.navigationView.customColorsUpdate()
        self.navigationImage.customColorsUpdate()
        self.barView.customColorsUpdate()
        self.cashTripLbl.customColorsUpdate()
        self.etaLbl.customColorsUpdate()
        self.cashImg.customColorsUpdate()
        self.barIV.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.lblLocationName.customColorsUpdate()
        self.onChangeMapStyle()
        self.tripManager?.updateMarker()
        guard let viewDetailHoder = self.viewDetailHoder else { return }
        viewDetailHoder.darkModeChange()
    }
    
    func initLangugage(){
        self.enRouteLbl.text = LangCommon.enRoute
        self.cashTripLbl.text = LangCommon.cashTrip
        self.navigateLabel.text = LangCommon.navigate.capitalized
    }
    
    
    
    func initialize() {
        self.tripManager = TripManager(using: self,
                                       forTrip: self.shareRouteVC.tripDataModel)
        if let currentTrip = self.shareRouteVC.tripDataModel.getCurrentTrip() {
            self.tripManager?.switchToCurrent(tripID: currentTrip.id)
        }
        self.createMap()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.viewDetailHoder.tripProgressBtn.initialize(self.tripManager!)
            self.initView()
            self.initGesture()
            self.initLangugage()
            self.initNotification()
            self.createInitialTripFireBaseNode()
        }
    }
    
    func deinitNotifications(){
        NotificationCenter.default.removeObserver(self,
                                                  name: .TripCancelledByDriver,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .TripCancelled,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .CancelJobByUser,
                                                  object: nil)
        self.timerForETA?.invalidate()
    }
    
    func initNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.driverCancelledTrip),
                                               name: .TripCancelledByDriver,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.riderCancelledTrip),
                                               name: .TripCancelled,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.riderCancelledTrip),
                                               name: .CancelJobByUser,
                                               object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadInput), name: .immediate_end_trip, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadUpdateStopsInput), name: .update_stops, object: nil)

        self.IsendPopUp = false


        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        self.timerForETA = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] (_) in
            self?.calculateETA()
        }
        
    }
    
    @objc
       func reloadInput() {
           
           if self.IsendPopUp == false {
               self.IsendPopUp = true
               self.setAlert()

               self.tripManager = TripManager(using: self, forTrip: tripDataModel)
               DispatchQueue.main.asyncAfter(deadline: .now()) {
                       self.viewDetailHoder.tripProgressBtn.initialize(self.tripManager!)
                       self.initView()
                       self.initGesture()
                       self.initLangugage()
                       self.initNotification()
//                       self.setAlert()
                       // self.setFireBaseRefreshPayment()
                   }
               
               
               NotificationCenter.default.removeObserver(self,
                                                         name: .immediate_end_trip,
                                                         object: nil)
               NotificationCenter.default.removeObserver(self,
                                                         name: .update_stops,
                                                         object: nil)
           }
       }
    
    @objc
    func reloadUpdateStopsInput() {
           if self.IsendPopUp == false {
               self.IsendPopUp = true
               self.setAlert(IsUpdateStop: true)

               self.tripManager = TripManager(using: self, forTrip: tripDataModel)
               DispatchQueue.main.asyncAfter(deadline: .now()) {
                   
//                       self.viewDetailHoder.tripProgressBtn.initialize(self.tripManager!)
//                       self.initView()
//                       self.initGesture()
//                       self.initLangugage()
//                       self.initNotification()
                       self.initialize()
//                       self.setAlert(IsUpdateStop: true)
                       // self.setFireBaseRefreshPayment()
                   }
               
               NotificationCenter.default.removeObserver(self,
                                                         name: .immediate_end_trip,
                                                         object: nil)
               NotificationCenter.default.removeObserver(self,
                                                         name: .update_stops,
                                                         object: nil)


           }
       }
    
    
    func setAlert(IsUpdateStop: Bool = false) {
        //           let alert = UIAlertController(
        //               title: appName.capitalized,
        //               message: "User requested to End trip",
        //               preferredStyle: .alert)
        //           alert.addAction(UIAlertAction(title: LangCommon.ok.uppercased(), style: .default, handler: { (action) in
        //               self.tripManager?.fetchTripDetails()
        //           }))
        
        
        self.shareRouteVC.commonAlert.setupAlert(alert: IsUpdateStop ? "Stops Updated" : "User requested to End trip",
                                                 okAction: LangCommon.ok.uppercased())
        self.IsendPopUp = true
        self.shareRouteVC.commonAlert.addAdditionalOkAction(isForSingleOption: true) {
            self.IsendPopUp = false
            if IsUpdateStop == false {
                self.tripManager?.setButtonTitle(forMultiTripStatus: .endTrip)
            }else{
                self.viewDetailHoder.tripProgressBtn.initialize(self.tripManager!)
            }
        }
        
        
        

        

        
    }
    
    func initGesture() {
        self.navigationView.addAction(for: .tap) { [weak self] in
            self?.showAlertForThirdPartyNavigation()
        }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panGesuture(_:)))
        self.riderTblHolderView.addGestureRecognizer(pan)
        self.riderTableView.addGestureRecognizer(pan)
        self.riderTblHolderView.isUserInteractionEnabled = true
        
    }
    
    func initChatBubble() {
        let chat_bub = UIImage(named: "ic_chat")?.withRenderingMode(.alwaysTemplate)
        
        let c_width : CGFloat = 60
        let x_pos  = self.frame.width - c_width - 8
        let chatBubbleBtn = UIButton(frame: CGRect(x: x_pos,
                                                   y: self.riderTblHolderView.frame.minY - c_width - 15,
                                                   width: c_width - 8,
                                                   height: c_width - 8))
        chatBubbleBtn.setTitle("", for: .normal)
        chatBubbleBtn.backgroundColor = .white
        chatBubbleBtn.isRoundCorner = true
        chatBubbleBtn.elevate(2.3)
        chatBubbleBtn.tintColor = .ThemeYellow
        chatBubbleBtn.isUserInteractionEnabled = true
        
        let chat_bubIV = UIImageView(image: chat_bub, highlightedImage: nil)
        chat_bubIV.frame = CGRect(x: chatBubbleBtn.frame.minX + 10,
                                  y: chatBubbleBtn.frame.minY + 10,
                                  width: chatBubbleBtn.frame.width - 20,
                                  height: chatBubbleBtn.frame.height - 20)
        chat_bubIV.tintColor = .ThemeYellow
        chat_bubIV.isUserInteractionEnabled = false
        
        chatBubbleBtn.addTarget(self, action: #selector(self.goToChatVC), for: .touchUpInside)
        
        self.addSubview(chatBubbleBtn)
        self.bringSubviewToFront(chatBubbleBtn)
        self.addSubview(chat_bubIV)
        self.bringSubviewToFront(chat_bubIV)
        self.chatBubbleBtn = chatBubbleBtn
        self.chatBubbleIV = chat_bubIV
        
    }
    
    
    
    //-----------------------------
    // MARK: - Local Functions
    //-----------------------------
    
    func setFonts() {
        self.barIV.image = self.barIV.image?.withRenderingMode(.alwaysTemplate)
        self.viewAddressHoder.cornerRadius = 20
        self.barView.setSpecificCornersForTop(cornerRadius: 35)
//        self.enRouteLbl.textColor = .Title
//        self.enRouteLbl.font = AppWebConstants.GoferFont.centuryBold.font(size: 17)
//        self.lblLocationName.font = AppWebConstants.GoferFont.centuryBold.font(size: 13)
//        self.lblLocationName.textColor = .Title
//        self.navigationImage.tintColor = .ThemeYellow
//        self.navigateLabel.font = AppWebConstants.GoferFont.centuryBold.font(size: 13)
//        self.etaLbl.font = AppWebConstants.GoferFont.centuryBold.font(size: 13)
//        self.navigateLabel.textColor = .white
//        self.etaLbl.textColor = .white
        self.navigationView.cornerRadius = 20
//        self.navigationView.backgroundColor = .Title
        self.viewAddressHoder.elevate(3)
        self.googleMap.setSpecificCornersForTop(cornerRadius: 35)
//        self.cashView.backgroundColor = .Title
//        self.cashTripLbl.font = AppWebConstants.GoferFont.centuryBold.font(size: 15)
//        self.cashTripLbl.textColor = .white
        self.cashImg.image = UIImage(named: "CashIcon")?.withRenderingMode(.alwaysTemplate)
//        self.barView.backgroundColor = .white
    }
    
    func showArriveNowButton() {
        UIView.animate(withDuration:  1.2,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: { () -> Void in
            var viewDetailRect = self.viewDetailHoder.frame
            viewDetailRect.origin.y = self.frame.size.height - self.viewDetailHoder.frame.size.height
            self.viewDetailHoder.frame = viewDetailRect
        }, completion: { (finished: Bool) -> Void in
        })
    }
    
    //-----------------------------------------
    // MARK: - showThirdPartyNavigation
    //-----------------------------------------
    
    func showThirdPartyNavigation(for party : ThirdPartyNavigation){
        if party.isApplicationAvailable{
            party.openThirdPartyDirection()
        }else{
            let alert = UIAlertController(
                title: appName.capitalized,//LangCommon.doYouWantToAccessdirection
                message: party.getDownloadPermissionText,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LangCommon.ok.uppercased(), style: .default, handler: { (action) in
                party.openAppStorePage()
            }))
            alert.addAction(UIAlertAction(title: LangCommon.cancel, style: .cancel, handler: nil))
            self.shareRouteVC.present(alert, animated: true)
            
        }
    }
    
    func showAlertForThirdPartyNavigation() {
        guard let data = self.tripManager?.tripDetailModel.getCurrentTrip() else{return}
        guard let pickupCoordinate = self.tripManager?.lastDriverLocation?.coordinate else{return}
        let dropCoordinate = data.getDestination.coordinate
        
        
        
        let actionSheetController = UIAlertController(
//            @Karuppasamy
            title: LangCommon.hereYouCanChangeYourMap,//self.langugage.hereYouCanChangeYourMap
            message: LangCommon.byClicking,//self.langugage.byClicking
            preferredStyle: .actionSheet)
        actionSheetController
            .addColorInTitleAndMessage(titleColor: UIColor.PrimaryColor,
                                       messageColor: UIColor.PrimaryColor,
                                       titleFontSize: 15,
                                       messageFontSize: 13)
        let googleMapAction = UIAlertAction(title: LangCommon.googleMap,
                                            style: .default) { (action) in
            self.showThirdPartyNavigation(for: .google(pickup: pickupCoordinate,
                                                       drop: dropCoordinate))
        }
        googleMapAction.setValue(UIColor.PrimaryColor,
                                 forKey: "TitleTextColor")
        let wazeMapAction = UIAlertAction(title: LangCommon.wazeMap,
                                          style: .default) { (action) in
            self.showThirdPartyNavigation(for: .waze(pickup: pickupCoordinate,
                                                     drop: dropCoordinate))
        }
        wazeMapAction.setValue(UIColor.PrimaryColor,
                               forKey: "TitleTextColor")
        let cancelAction: UIAlertAction = UIAlertAction(title: LangCommon.cancel,
                                                        style: .cancel) { action -> Void in }
        actionSheetController.addAction(googleMapAction)
        actionSheetController.addAction(wazeMapAction)
        actionSheetController.addAction(cancelAction)
        self.shareRouteVC.present(actionSheetController, animated: false, completion: nil)
    }
    
    //-----------------------------------------
    // MARK:- ETA Calculation
    //-----------------------------------------
    
    func calculateETA() {
        guard let route = self.currenRouteData,
              let driverLocation = LocationHandler.shared().lastKnownLocation,
              let leg = route.legs.first else{return}
        
        let steps = leg.steps
        var remainingSecETA : Int? = nil
        
        for step in steps{
            if let availableETA = remainingSecETA {
                remainingSecETA = availableETA + (step.duration.value )
            }else if (step.startLocation.distance(from: driverLocation) ) < 100{
                remainingSecETA = step.duration.value
            }
        }
        
        let secondsETA = remainingSecETA ?? self.knownETASecFromGoogle
        self.knownETASecFromGoogle = secondsETA
        var minutesETA = secondsETA / 60
        if minutesETA < 1{
            minutesETA = 1
        }
        debug(print: minutesETA.description)
        self.calculateSpeed(googleETAMin: Double(minutesETA), from: googlePath)
    }
    
    func drawRoute(forRoute route: Route) {
        self.currenRouteData = route
        let points = route.overviewPolyline.points
        
        if let newPath = GMSPath(fromEncodedPath: points){
            self.googlePath = newPath
            self.driversPositiionAtPath = 0
            self.drawRoute(for: googlePath)
        }
        
    }
    
    func drawRoute(for path : GMSPath){
        let drawingPath = GMSMutablePath()
        for i in self.driversPositiionAtPath..<path.count(){
            drawingPath.add(path.coordinate(at: i))
        }
        self.polyline.path = drawingPath
        self.polyline.strokeColor = UIColor.PrimaryColor
        self.polyline.strokeWidth = 3.0
        self.polyline.map = map
        self.calculateETA()
    }
    func calculateSpeed(googleETAMin : Double,from path : GMSPath){
        guard path.count() != 0 else{return}
        var oldLoc = path.coordinate(at: self.driversPositiionAtPath).location
        var distance : Double = 0
        for index in self.driversPositiionAtPath..<path.count() where index % 5 == 0 {
            let newLocation = path.coordinate(at: index).location
            distance += newLocation.distance(from: oldLoc)
            oldLoc = newLocation
        }
        
        
        let lastLocation = path.coordinate(at: path.count() - 1).location
        distance += lastLocation.distance(from: oldLoc)
        
        let distanceInKM = distance / 1000
        var currentSpeed = self.tripManager?.currentSpeed ?? 18
        if currentSpeed < 18{
            currentSpeed = 18
        }
        if currentSpeed > 40{
            currentSpeed = 40
        }
        let calculatedETAHrs = distanceInKM / currentSpeed
        var averageETAmins = ((calculatedETAHrs * 60) + googleETAMin) / 2
        averageETAmins = averageETAmins <= 1 ? 1 : averageETAmins
        self.updateFirebase(withNewETA: Int(averageETAmins))
        var etaString = String()
        let minutesETA = Int(averageETAmins)
        let hrs = minutesETA / 60
        let mins = minutesETA % 60
        if hrs > 0{
            etaString.append("\(hrs) \(hrs == 1 ? LangCommon.hr : LangCommon.hrs) ")
//            etaString.append("\(hrs) \(hrs == 1 ? LangCommon.hr.lowercased() : LangCommon.hrs.lowercased()) ")
        }
        if mins > 1 {
            etaString.append("\(mins) \(LangCommon.mins.lowercased())")
        }else{
            etaString.append("1 \(LangCommon.min.lowercased())")
        }
        self.etaLbl.text = etaString
        
    }
    
    func createMap() {
        self.map = GMSMapView()
        guard let map = self.map else { return }
        self.googleMap.addSubview(map)
        map.anchor(toView: self.googleMap,
                   leading: 0,
                   trailing: 0,
                   top: 0,
                   bottom: 0)
        self.googleMap.bringSubviewToFront(map)
        
        // Style For Map
        self.onChangeMapStyle()
        
        // Setting Location on the Map
        currentLocation = LocationHandler.default().lastKnownLocation ?? CLLocation()
//        
        let camera: GMSCameraPosition = GMSCameraPosition
            . camera(withLatitude: currentLocation.coordinate.latitude,
                     longitude: currentLocation.coordinate.longitude,
                     zoom: self.cameraDefaultZoom)
        map.camera = camera
    }
    func removeMap() {
        self.map?.removeFromSuperview()
        self.map = nil
    }
    
    // driver callcel the trip
    @objc
    func driverCancelledTrip() {
        
        NotificationCenter.default.removeObserver(self, name:UIApplication.didEnterBackgroundNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name:UIApplication.didBecomeActiveNotification, object:nil)
        self.tripManager?.removeAllTripRelatedDataFromLocal()
    }
    
    // Rider cancel the trip
    @objc func riderCancelledTrip(notification: Notification)
    {
        
        if self.shareRouteVC.tripDataModel.isPoolTrip {
            self.resetTablePosition()
            self.tripManager?.fetchTripDetails()
            Shared.instance.resumeTripHitCount = 0
        }
        NotificationCenter.default.removeObserver(self, name:UIApplication.didEnterBackgroundNotification, object:nil)
        NotificationCenter.default.removeObserver(self, name:UIApplication.didBecomeActiveNotification, object:nil)
        Constants().STOREVALUE(value: "Online", keyname: USER_ONLINE_STATUS)
        Constants().STOREVALUE(value: "Online", keyname: TRIP_STATUS)
        self.appDelegate.onSetRootViewController(viewCtrl: self.viewController)
        
    }
    
    //-----------------------------------------
    // MARK: - Change Map Style
    //-----------------------------------------
    
    /*
     Here we are changing the Map style from Json File
     */
    func onChangeMapStyle() {
        do {
            if let styleURL = Bundle.main.url(forResource: self.isDarkStyle ?  "map_style_dark" : "mapStyleChanged", withExtension: "json") {
                map?.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
            }
        } catch {
        }
    }
    
    //-------------------------------------------------
    // MARK:- set refresh Payment node 0 as initial
    //-------------------------------------------------
    
    func createInitialTripFireBaseNode() {
        guard self.ref != nil else {return}
        let tracking = self.ref.child(FireBaseNodeKey.trip.rawValue)
        tracking.observeSingleEvent(of: .value) { (snapShot) in
            
            for rider in self.shareRouteVC.tripDataModel.users{
                if !snapShot.hasChild(rider.jobID.description){//node not available
                    var node = [String:Any]()
                    node[FireBaseNodeKey._refresh_payment.rawValue] = "0"
                    node[FireBaseNodeKey._polyline_path.rawValue] = "0"
                    node[FireBaseNodeKey._eta_min.rawValue] = "0"
                    tracking.child(rider.jobID.description).setValue(node)
                }else if self.googlePath.encodedPath().isEmpty{// no local path right now
                }
            }
        }
    }
    
    func updateFirebase(withNewPath path : String){
        let current = self.shareRouteVC.tripDataModel.getCurrentTrip()
        for rider in self.shareRouteVC.tripDataModel.users {
            guard self.ref != nil else {return}
            let tracking = self.ref
                .child(FireBaseNodeKey.trip.rawValue)
                .child(rider.jobID.description)
                .child("Provider")
//                .child(rider.id.description)
            tracking.updateChildValues([FireBaseNodeKey._polyline_path.rawValue : current == rider ? path : "0"])
        }
    }
    
    func updateFirebase(withNewETA eta : Int){
        guard self.shareRouteVC.tripDataModel.id != 0 else { return }
        guard self.ref != nil else {return}
        let tracking = self.ref
            .child(FireBaseNodeKey.trip.rawValue)
            .child(self.shareRouteVC.tripDataModel.getCurrentTrip()?.jobID.description ?? "")
            .child("Provider")
//            .child(self.shareRouteVC.tripDataModel.getCurrentTrip()?.id.description ?? "")
        tracking.updateChildValues([FireBaseNodeKey._eta_min.rawValue : eta.description])
    }
}

extension ShareRouteView : GMSMapViewDelegate {
    
}

extension ShareRouteView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.shareRouteVC.tripDataModel != nil else {return 1}
        let count = self.shareRouteVC.tripDataModel.users.count
        if count < 5{
            riderTableHeight.constant  = self.mainCellHeight + CGFloat(count + 1) * self.coCellHeight - self.safeAreaInsets.bottom + 50
        }else{
            riderTableHeight.constant  = self.mainCellHeight + CGFloat(5 + 1) * self.coCellHeight - self.safeAreaInsets.bottom + 50
        }
        self.barView.isHidden =  self.shareRouteVC.tripDataModel.users.count <= 1
        return count > 1 ? 2 : 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.shareRouteVC.tripDataModel != nil else {return 1}
        let ridersCount = self.shareRouteVC.tripDataModel.users.count
        return section == 0 ? 1 : ridersCount //- 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.shareRouteVC.tripDataModel != nil else {return UITableViewCell()}
        
        guard  let data = self.shareRouteVC.tripDataModel.getCurrentTrip() else { return UITableViewCell() }
        tableView.separatorStyle = .none
        let isSection1 = indexPath.section == 0
        if isSection1{
            let cell : ShareRiderTVC = tableView.dequeueReusableCell(for: indexPath)
            
            cell.nameLbl.text = data.name
            cell.thumbIV.sd_setImage(with: URL(string: data.image),
                                     placeholderImage:UIImage(named:"user_dummy"))
//            cell.ratingLbl.text = data.rating.description
//            cell.ratingLbl.isHidden = data.rating == 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                cell.thumbIV.contentMode = .scaleToFill
            }
            cell.ratingLbl.isHidden = true
            cell.callBtn.isClippedCorner = true
            cell.messageBtn.isClippedCorner = true
            cell.messageBtn.isHidden = !isSection1
            
            cell.callBtn.backgroundColor = .PrimaryColor
            cell.callBtn.setTitleColor(.white,
                                       for: .normal)
            cell.callBtn.setTitle(LangCommon.call,
                                  for: .normal)
            
            
            let isShowMsg = (self.shareRouteVC.tripDataModel.getCurrentTrip()?.bookingType != BookingEnum.manualBooking)
            
            cell.messageStack.isHidden = !isShowMsg
            cell.messageIconView.isHidden = !isShowMsg
            cell.messageIcon.isHidden = !isShowMsg
            cell.messageBtn.isHidden = !isShowMsg
            cell.messageStack.addTap {
                self.goToChatVC()
            }
            cell.selectionStyle = .none
            cell.darkModeChange()
            return cell
        }else{
            let cell : CoShareRiderTVC = tableView.dequeueReusableCell(for: indexPath)
            guard let item = self.shareRouteVC.tripDataModel.users
                    .value(atSafe: indexPath.row) else{
                        return cell
                    }
            
            cell.nameLbl.text = item.name
            cell.thumbIV.sd_setImage(with: URL(string: item.image),
                                     placeholderImage:UIImage(named:"user_dummy"))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                cell.thumbIV.isRoundCorner = true
                cell.thumbIV.border(1, .PrimaryColor)
                cell.thumbIV.contentMode = .scaleToFill
            }
            cell.thumbIV.contentMode = .scaleToFill
            
            cell.changeBtn.addAction(for: .tap) {
                self.googlePath = GMSPath()
//                self.polyline.path = nil
                self.resetTablePosition()
                self.tripManager?.switchToCurrent(tripID: item.id)
            }
            let isShowMsg = (self.shareRouteVC.tripDataModel.getCurrentTrip()?.bookingType != BookingEnum.manualBooking)
            
            cell.messageStack.isHidden = !isShowMsg
            cell.messageIconView.isHidden = !isShowMsg
            cell.messageIcon.isHidden = !isShowMsg
            cell.sendMessageBtn.isHidden = !isShowMsg
            cell.messageStack.addTap {
                self.goToChatVC()
            }
            cell.darkModeChange()
            cell.selectionStyle = .none
            return cell
        }
    }
}


extension ShareRouteView : UITableViewDelegate{
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? self.mainCellHeight : self.coCellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let tripView = GoferRiderProfileVC.initWithStory()
//            tripView.tripDetailDataModel = self.shareRouteVC.tripDataModel
            tripView.tripDetailDataModel = self.tripManager?.tripDetailModel
            tripView.isTripStarted = self.tripManager?.currentTripStatus.isTripStarted ?? true
            self.shareRouteVC.navigationController?.pushViewController(tripView, animated: true)
        }else{
            self.resetTablePosition()
            if indexPath.row == 0 {
                return
            }
            guard let currentTrip  = tripManager?.tripDetailModel.getCurrentTrip(),                  let item = self.tripManager?.tripDetailModel.users
                    .value(atSafe: indexPath.row) else{  return }
        }
        self.yMovement = nil
    }
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 60 : 0
    }
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        self.viewDetailHoder.frame = self.viewDetailHoder.setFrame(CGRect(x: 0,
                                                                          y: 0,
                                                                          width: tableView.frame.width,
                                                                          height: 60))
        self.viewDetailHoder.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.viewDetailHoder.layoutIfNeeded()
        return section == 0 ? self.viewDetailHoder : nil
    }
}

//------------------------
// MARK:- Gestures
//------------------------

extension ShareRouteView {
    @objc func panGesuture(_ gesture : UIPanGestureRecognizer){
        var riderCount = self.shareRouteVC.tripDataModel.users.count
        guard riderCount > 1 else{return}
        if riderCount > 5{
            riderCount = 5
        }
        let section2sHeight : CGFloat = (CGFloat(riderCount /*- 1*/) * ( -self.coCellHeight ))
        
        let translation = gesture.translation(in: self.riderTableView)
        var yMovement = translation.y
        if let existingYmoventn = self.yMovement{
            yMovement += existingYmoventn
        }
        switch gesture.state {
        case .began,.changed:
            print(yMovement)
            if yMovement > section2sHeight && yMovement < 0{//
                self.riderTblHolderView.transform = CGAffineTransform(translationX:0,
                                                                      y:  yMovement)
                self.barView.transform = CGAffineTransform(translationX:0,
                                                           y:  yMovement)
                self.chatBubbleIV?.isHidden = true
                self.chatBubbleBtn?.isHidden = true
            }
            
        default:
            
            
            if abs(yMovement) <= self.frame.width * 0.25 {//show
                self.resetTablePosition()
            }else{//hide
                self.riderTblHolderView.transform = CGAffineTransform(translationX:0,
                                                                      y:  section2sHeight)
                
                self.barView.transform = CGAffineTransform(translationX:0,
                                                           y:  section2sHeight)
                self.chatBubbleIV?.isHidden = true
                self.chatBubbleBtn?.isHidden = true
                self.yMovement = section2sHeight
                self.riderTableView.isScrollEnabled = self.shareRouteVC.tripDataModel.users.count > 5
            }
        }
    }
    func resetTablePosition(){
        
        self.riderTblHolderView.transform = .identity
        self.chatBubbleIV?.isHidden = false
        self.chatBubbleBtn?.isHidden = false
        self.barView.transform = .identity
        self.yMovement = nil
        self.riderTableView.isScrollEnabled = false
    }
}


class CoShareRiderTVC : UITableViewCell{
    @IBOutlet weak var nameLbl : SecondaryRegularBoldLabel!
    @IBOutlet weak var thumbIV : UIImageView!
    @IBOutlet weak var changeBtn : UIButton!
    @IBOutlet weak var messageStack: UIStackView!
    
    @IBOutlet weak var sendMessageBtn: TransparentPrimaryButton!
    @IBOutlet weak var messageIcon: PrimaryImageView!
    @IBOutlet weak var messageIconView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.thumbIV.cornerRadius = 10
        self.thumbIV.border(2,
                            UIColor.init(hex: "eaeaea"))
        self.sendMessageBtn.setTitle(LangCommon.sendMessage,
                                     for: .normal)
        self.messageIcon.image = UIImage(named: "chat_bub")?.withRenderingMode(.alwaysTemplate)
        self.darkModeChange()
    }
    
    func darkModeChange() {
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.contentView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.nameLbl.customColorsUpdate()
        self.sendMessageBtn.customColorsUpdate()
        self.messageIcon.customColorsUpdate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

class ShareRiderTVC: UITableViewCell {
    @IBOutlet weak var nameLbl : SecondaryRegularBoldLabel!
    @IBOutlet weak var ratingLbl : SecondarySmallBoldLabel!
    @IBOutlet weak var thumbIV : UIImageView!
    @IBOutlet weak var sendMessageBtn: TransparentPrimaryButton!
    @IBOutlet weak var messageIcon: PrimaryImageView!
    @IBOutlet weak var messageIconView: UIView!

    @IBOutlet weak var messageStack: UIStackView!
    @IBOutlet weak var callBtn : UIButton!
    @IBOutlet weak var messageBtn : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbIV.cornerRadius = 10
        self.selectionStyle = .none
        self.thumbIV.border(2, UIColor.init(hex: "eaeaea"))
        self.sendMessageBtn.setTitle(LangCommon.sendMessage,
                                     for: .normal)
        self.messageIcon.image = UIImage(named: "chat_bub")?.withRenderingMode(.alwaysTemplate)
        self.darkModeChange()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    func darkModeChange() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.nameLbl.customColorsUpdate()
        self.ratingLbl.customColorsUpdate()
        self.sendMessageBtn.customColorsUpdate()
        self.messageIcon.customColorsUpdate()
    }
}

//MARK:- TripManagerDelegate
extension ShareRouteView : TripManagerDelegate {
    
    
    func currentImage(currentRider: Users)  {
   //        let value = "Hello"
   //        return value
       }
    
    func handleButtonInteraction(withCurrent current: CLLocation, forDrop drop: CLLocation) {
                var enable = drop.distance(from: current) <= 200 //Distance in meter filter 200m
                print("∂Drop Distance",drop.distance(from: current))
            if self.tripManager?.tripDetailModel?.getCurrentTrip()?.requestedToEndTrip ?? false{
                    enable = true
        //        Shared.instance.showtime = 0
        //        stopTimer()
                }
        //        if ["BEGIN TRIP","CONFIRM YOU'VE ARRIVED"].contains(btnArriveNow.titleLabel?.text){
        //            enable = true
        //        }
                self.progressBtn.isActive = enable//true//
            }
    


    
    func moveToPayment(tripID: Int, status: TripStatus) {
        let vc = HandyPaymentVC.initWithStory(model: nil,
                                              jobID: tripID,
                                              jobStatus: status)
        self.viewController.navigationController?.pushViewController(vc,
                                                                     animated: true)
    }
    
    
    
//    func currentImage(currentRider: Users) {
//
//    }
    
    var tripDataModel: JobDetailModel! {
        get { return self.shareRouteVC.tripDataModel }
        set {}
    }
    
    var shouldFocusPolyline: Bool {
        get { return self.shareRouteVC.shouldFocusPolyline }
        set { }
    }
    
    
    func deinitObjects() {
        
    }
    
    func currentImage(currentRider : Users ) -> String {
        var image = String()
        if currentRider.jobStatus.isTripStarted == true{
            image = self.isDarkStyle ? "box_white" : "box"
        }else{
            image =  isDarkStyle ? "circle_white" : "circle"
        }
        return image
    }
    func currentStatus(currentRider : Users ) -> CLLocation {
          var loc = CLLocation()
          if currentRider.jobStatus.isTripStarted{
              loc = CLLocation(latitude: currentRider.dropLat, longitude: currentRider.dropLng)
          }else{
              loc = CLLocation(latitude: currentRider.pickupLat, longitude: currentRider.pickupLng)
          }
          return loc
      }
    func updateDestination(with detail: JobDetailModel, skipPolyValidation: Bool) {
           
           guard let data = detail.getCurrentTrip() else{return}
           self.etaLbl.isHidden = data.jobStatus.isTripStarted
           if Shared.instance.needToShowChatVC{
               self.goToChatVC()
           }
           data.storeRiderInfo(true)
           //lblRiderName.text = data.riderName
           let pickUP : CLLocation = LocationHandler.shared().lastKnownLocation ?? CLLocation()
           var drop = CLLocation()
           if data.jobStatus.isTripStarted == true{
               if !(detail.getCurrentTrip()?.isMultiTrip ?? false){
                       lblLocationName.text = data.drop
                       dropLocation = data.drop
                   drop = CLLocation(latitude: data.dropLat , longitude: data.dropLng )
               }else if let point = data.wayPoints.filter({$0.isCompleted == 0}).first{
                   lblLocationName.text = point.end.location ?? ""
                   dropLocation = point.end.location ?? ""
                   drop = CLLocation(latitude: point.end.latitude?.toDouble() ?? 0.000, longitude: point.end.longitude?.toDouble() ?? 0.000)
               }else{
                   let point = data.wayPoints.filter({$0.isCompleted == 1}).last
                   lblLocationName.text = point?.end.location ?? ""
                   dropLocation = point?.end.location ?? ""
                   drop = CLLocation(latitude: point?.end.latitude?.toDouble() ?? 0.000, longitude: point?.end.longitude?.toDouble() ?? 0.000)

               }
           }else{
               lblLocationName.text = data.pickup
               drop = data.getDestination
           }
           self.createPolyLine(start: pickUP,
                               end: drop,
                               skipValidation: skipPolyValidation,
                               getDistance: nil)
           self.riderTableView.reloadData()
       }


    var gMapView: GMSMapView {
        return self.map ?? GMSMapView()
    }
    
    var viewController: UIViewController {
        return self.shareRouteVC
    }
    
    var progressBtn: ProgressButton {
        return self.viewDetailHoder.tripProgressBtn
    }
    
   
    
    func onSuccessfullTripCompletion() {
        guard let data = self.tripManager?.tripDetailModel else{return}
               var parameters = JSON()
               parameters["job_id"] = data.id
               
//        let propertyView = RateYourRideVC.initWithStory(trip: self.tripDataModel)
////        propertyView.tripId = data.getCurrentTrip()?.id ?? 0
//               propertyView.isFromRoutePage = true
//        self.navigationController?.pushViewController(propertyView, animated: true)
        guard let currentTrip = data.getCurrentTrip() else { return }
        let propertyView = HandyPaymentVC.initWithStory(model: self.shareRouteVC.tripDataModel,
                                                        jobID: currentTrip.jobID,
                                                        jobStatus: currentTrip.jobStatus)
        self.shareRouteVC.navigationController?.pushViewController(propertyView, animated: true)
    }
    
    func isPathChanged(byDriver coordinate : CLLocation) -> Bool{
  
        guard self.googlePath.count() != 0 else{return true}
        
        for range in 0..<self.googlePath.count(){
            let point = self.googlePath.coordinate(at: range).location
            
            if point.distance(from: coordinate) < 75{
                self.driversPositiionAtPath = range
                self.drawRoute(for: self.googlePath)
                return false
            }
        }
        return true
    }
    
    func createPolyLine(start : CLLocation,
                        end: CLLocation,
                        skipValidation : Bool,
                        getDistance : DistanceClosure? = nil ) {
        DispatchQueue.performAsync(on: .main) { [weak self] in
            guard let welf = self else{return}
            debug(print: getDistance == nil ? "empty" : "full")
            if ((welf.tripDataModel.getCurrentTrip()?.wayPoints.filter({$0 .isCompleted == 0})) != nil) {


            if welf.shareRouteVC.shouldFocusPolyline {
                
                let bounds = GMSCoordinateBounds(coordinate: start.coordinate,
                                                 coordinate: end.coordinate)
                let camera1 = welf.map?.camera(for: bounds, insets:UIEdgeInsets.zero)
                welf.map?.camera = camera1!
                welf.shareRouteVC.shouldFocusPolyline = false
            }
            //Apply validation for trip not for end trip
            if getDistance == nil && !skipValidation {
                if welf.polyline.path != nil {
                    guard welf.isPathChanged(byDriver: start) else{return}
                    
                }
                let timeDifference = Date().timeIntervalSince(self?.lastDirectionAPIHitStamp ?? Date())
                guard self?.lastDirectionAPIHitStamp == nil || timeDifference > 15 else{return}
            }
            self?.lastDirectionAPIHitStamp = Date()
            let count = UserDefaults.value(for: .direction_hit_count) ?? 0
            UserDefaults.set(count + 1, for: .direction_hit_count)

            ConnectionHandler.shared
                .getRequest(forAPI: "https://maps.googleapis.com/maps/api/directions/json",
                            params: [
                                "origin" : "\(start.coordinate.latitude),\(start.coordinate.longitude)",
                                "destination" :"\(end.coordinate.latitude),\(end.coordinate.longitude)",
                                "mode" : "driving",
                                "units" : "metric",
                                "sensor" : "true",
                                "key" : "\(GooglePlacesApiKey)"
                            ],showLoader: false,
                            cacheAttribute: .none)
                .responseDecode(to: GoogleGeocode.self, { (googleGecode) in
                    self?.handleDirectionResponse(googleGecode,getDistance: getDistance)

                })
                .responseFailure({ (error) in
                    debugPrint(error)
                    if let distanceFromGoogle = getDistance{
                        distanceFromGoogle(0.0,"")
                        return
                    }
                })
        
                
                
            }
                        if welf.shareRouteVC.shouldFocusPolyline {
                            
                            let bounds = GMSCoordinateBounds(coordinate: start.coordinate,
                                                             coordinate: end.coordinate)
                            let camera1 = welf.map?.camera(for: bounds, insets:UIEdgeInsets.zero)
                            welf.map?.camera = camera1!
                            welf.shareRouteVC.shouldFocusPolyline = false
                        }
                        //Apply validation for trip not for end trip
                        if getDistance == nil && !skipValidation {
                            if welf.polyline.path != nil {
                                guard welf.isPathChanged(byDriver: start) else{return}
                                
                            }
                            let timeDifference = Date().timeIntervalSince(self?.lastDirectionAPIHitStamp ?? Date())
                            guard self?.lastDirectionAPIHitStamp == nil || timeDifference > 15 else{return}
                        }
                        self?.lastDirectionAPIHitStamp = Date()
                        let count = UserDefaults.value(for: .direction_hit_count) ?? 0
                        UserDefaults.set(count + 1, for: .direction_hit_count)

                        ConnectionHandler.shared
                            .getRequest(forAPI: "https://maps.googleapis.com/maps/api/directions/json",
                                        params: [
                                            "origin" : "\(start.coordinate.latitude),\(start.coordinate.longitude)",
                                            "destination" :"\(end.coordinate.latitude),\(end.coordinate.longitude)",
                                            "mode" : "driving",
                                            "units" : "metric",
                                            "sensor" : "true",
                                            "key" : "\(GooglePlacesApiKey)"
                                        ],showLoader: false,
                                        cacheAttribute: .none)
                            .responseDecode(to: GoogleGeocode.self, { (googleGecode) in
                                self?.handleDirectionResponse(googleGecode,getDistance: getDistance)

                            })
                            .responseFailure({ (error) in
                                debugPrint(error)
                                if let distanceFromGoogle = getDistance{
                                    distanceFromGoogle(0.0,"")
                                    return
                                }
                            })


            
        }
    }
    func handleDirectionResponse(_ gecode : GoogleGeocode,
                                 getDistance : DistanceClosure? = nil ){
        if let distanceFromGoogle = getDistance{
            if let route = gecode.routes.first{
                let distance = route.legs.first?.distance.value ?? 0
                let path = route.overviewPolyline.points
                distanceFromGoogle(Double(distance),path)
                self.calculateETA()
            }else{
                distanceFromGoogle(0.0,"")
            }
         
            return
        }
        if let route = gecode.routes.first{
            self.drawRoute(forRoute: route)
            self.knownETASecFromGoogle = route.legs.first?.duration.value ?? 60
            self.calculateETA()
        }
    
    }
}




extension UIButton{
    var isActive : Bool{
        get {return self.isUserInteractionEnabled}
        set{
            self.isUserInteractionEnabled = newValue
            self.backgroundColor = newValue ? UIColor.PrimaryColor : UIColor.InactiveTextColor
        }
    
    }
}
