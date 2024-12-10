//
//  HandyHomeMapView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 28/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

//--------------------------
//MARK: - Framework Import
//--------------------------
import UIKit
import GoogleMaps
import SDWebImage
import Foundation
import GooglePlaces

//New_Delivery_splitup_Start

//Deliveryall_Newsplitup_start

// Laundry_NewSplitup_start
// Laundry_NewSplitup_end

//New_Delivery_splitup_End
// Delivery Splitup Start remove RefreshHome
// Laundry Splitup Start remove RefreshHome
// Instacart Splitup Start remove RefreshHome
//Deliveryall splitup start
class HandyHomeMapView: BaseView {

//    func refresh() {
//        self.handyHomeMapVC.getUserData(showloader: false)
//    }
    // Delivery Splitup End
    // Laundry Splitup End
    //Deliveryall splitup End
    //--------------------------
    //MARK: - Outlets
    //--------------------------
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var customSwitchHolder: UITextSwitch!
    @IBOutlet weak var mapHolderView: UIView!
    @IBOutlet weak var bottomHolderView: SecondaryView!
    @IBOutlet weak var profileImageHolderView: UIView!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var addressHolderView: UIView!
    @IBOutlet weak var providerNameLbl: SecondarySubHeaderLabel!
    @IBOutlet weak var yourWorkLocationLbl: SecondarySmallHeaderLabel!
    @IBOutlet weak var workLocationAddressLbl: SecondaryRegularLabel!
    @IBOutlet weak var editIV: PrimaryImageView!
    @IBOutlet weak var addDocumentBtn : SecondaryButton!
    @IBOutlet weak var setAvailabilityBtn : SecondaryButton!
    @IBOutlet weak var setServicesBtn : SecondaryButton!
    @IBOutlet weak var checkStatusBtn : PrimaryButton!
    @IBOutlet weak var checkStatusView : SecondaryView!
    @IBOutlet weak var setDocumentIV : PrimaryImageView!
    @IBOutlet weak var setAvaliablityIV : PrimaryImageView!
    @IBOutlet weak var setServicesIV : PrimaryImageView!
    @IBOutlet weak var setAvailbilityBGView : UIView!
    @IBOutlet weak var setDocumentBGView : UIView!
    @IBOutlet weak var setServicesBGView : UIView!
    @IBOutlet weak var addVehiclesBtn : SecondaryButton!
    @IBOutlet weak var addVehiclesBgView : UIView!
    @IBOutlet weak var addVehiclesIV : PrimaryImageView!
    @IBOutlet weak var DriverStack: UIStackView!
    @IBOutlet weak var changeTitleLbl: SecondaryRegularLabel!
    @IBOutlet weak var heatImageHolderView: SecondaryView!
    @IBOutlet weak var heatIV: UIImageView!
    @IBOutlet weak var locationStack: UIStackView!
    @IBOutlet weak var vehicleNumberLbl: SecondaryRegularBoldLabel!
    @IBOutlet weak var editIconHolderView: UIView!
    
    @IBOutlet weak var driverDetailsStack: UIStackView!
    //--------------------------
    //MARK: - Map Initalisation
    //--------------------------
    
    var map : GMSMapView?
    
    //--------------------------
    //MARK: - Local Variables
    //--------------------------
    var heatMapTimer : Timer?
    var handyHomeMapVC : HandyHomeMapVC!
    var address: String = ""
    var lat: Double?
    var long: Double?
    var flat_no: String = ""
    var nick_name: String = ""
    var land_mark: String = ""
    var updateWorkLoc = false
    var isServiceEnabled : Bool = false
    var isAvailabilityEnabled : Bool = false
    //Handy_NewSplitup_Start
    var orginalBusinessType : BusinessType!
    //Handy_NewSplitup_End
    lazy var connectionHandler = ConnectionHandler()
    var heatTileLayer : GMUHeatmapTileLayer?
    var heatMapData : HeatMapDataModel?
    var localTimeZoneName: String { return TimeZone.current.identifier }
    var text = ""
    var arr : [String] = []
    var serviceArr : [String] = []
    var heatMapBussinessType : [GojekService] = []
    var selectedBusiness : String = ""
    var heatMapServiceTypes : [ServiceTypes] = []
    var selectedService : String = ""
    var heatMapSelectedList : [String] = []
    var tapped = false
    /// After the Approved By Admin it's Value is True. Otherwise False
    var isProviderApproved : Bool = false
    
    /// After Approved By Admin If user not Selected Any Service It's Value True. Otherwise False
    var isProviderNotEnabledService : Bool = false
    
    /// After Approved By Admin If user not Selected Any Availability It's Value True. Otherwise False
    var isProviderNotEnabledvailability : Bool = false
    
    /// After Approved By Admin if Both Availability and Services are not selected It's Value True. Otherwise False
    var isBothServiceAndAvailabilityNotSet : Bool = false
    
    //---------------------------------------
    //MARK: - life Cycle or Overide Function
    //---------------------------------------
    
    override
    func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.handyHomeMapVC = baseVC as? HandyHomeMapVC
        self.initView()
        self.initLanguage()
        self.initGestures()
        self.darkModeChange()
    }
    
    override
    func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
        self.refereshTheme()
        self.handyHomeMapVC.getEssentialsApiCall()
        //Gofer splitup start
        //New_Delivery_splitup_Start
        //Laundry splitup start
        //Instacart splitup start
        //Deliveryall_Newsplitup_start
        self.handyHomeMapVC.getMyServicesAPI()
        //Deliveryall_Newsplitup_end
        //Gofer splitup end
        //New_Delivery_splitup_End
        //Laundry splitup end
        //Instacart splitup end

        self.addMapView()
    }
    
    override
    func didDisappear(baseVC: BaseVC) {
        super.didDisappear(baseVC: baseVC)
        self.removeMapView()
    }
    
    override
    func darkModeChange() {
        super.darkModeChange()
        self.checkStatusView.customColorsUpdate()
        self.checkStatusBtn.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.bottomHolderView.customColorsUpdate()
        self.providerNameLbl.customColorsUpdate()
        self.yourWorkLocationLbl.customColorsUpdate()
        self.workLocationAddressLbl.customColorsUpdate()
        self.setAvailabilityBtn.customColorsUpdate()
        self.setServicesBtn.customColorsUpdate()
        self.addDocumentBtn.customColorsUpdate()
        self.addVehiclesBtn.customColorsUpdate()
        self.menuBtn.backgroundColor = .PrimaryColor
        self.menuBtn.tintColor = .PrimaryTextColor
        self.editIV.customColorsUpdate()
        self.setAvailabilityBtn.backgroundColor = .clear
        self.setServicesBtn.backgroundColor = .clear
        self.addDocumentBtn.backgroundColor = .clear
        self.addVehiclesBtn.backgroundColor = .clear
        self.setCustomSwitchColor()
        self.onChangeMapStyle(map: self.map ?? GMSMapView())
        self.vehicleNumberLbl.customColorsUpdate()
        self.changeTitleLbl.customColorsUpdate()
        self.changeTitleLbl.textColor = .ThemeTextColor
        self.heatImageHolderView.customColorsUpdate()
        self.refereshTheme()
    }
    
    //----------------------------------
    //MARK: - initalisation Functions
    //----------------------------------
    
    func BottomViewPrepartion() {
        self.profileImageHolderView.isHidden = true
        self.addressHolderView.isHidden = true
    }
    
    func setCustomSwitchColor() {
        self.customSwitchHolder.backgroundColor = self.isDarkStyle ? .DarkModeTextColor : .SecondaryTextColor
        self.customSwitchHolder.onColor = self.isDarkStyle ? .DarkModeBackground : .PrimaryTextColor
        self.customSwitchHolder.offColor = self.isDarkStyle ? .DarkModeBackground : .PrimaryTextColor
        self.customSwitchHolder.fontName = G_BoldFont
        self.customSwitchHolder.setFont()
    }
    
    func refereshTheme(){
        self.setAvaliablityIV.customColorsUpdate()
        self.setServicesIV.customColorsUpdate()
        self.setDocumentIV.customColorsUpdate()
        self.addVehiclesIV.customColorsUpdate()
    }
    
    func initView() {
        self.setAvaliablityIV.image = UIImage(named: "My Availablity")?.withRenderingMode(.alwaysTemplate)
        self.setServicesIV.image = UIImage(named: "Manage Services")?.withRenderingMode(.alwaysTemplate)
        self.setDocumentIV.image = UIImage(named: "Manage Document")?.withRenderingMode(.alwaysTemplate)
        self.addVehiclesIV.image = UIImage(named: "choose_vehicle")?.withRenderingMode(.alwaysTemplate)
        self.mapHolderView.clipsToBounds = true
        self.mapHolderView.cornerRadius = 50
        self.mapHolderView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        self.bottomHolderView.cornerRadius = 15
        self.profileIV.cornerRadius = 20
        self.profileIV.contentMode = .scaleAspectFill
        self.menuBtn.cornerRadius = 10
        self.menuBtn.backgroundColor = .PrimaryColor
        self.menuBtn.tintColor = .SecondaryColor
        self.menuBtn.imageEdgeInsets = UIEdgeInsets(top: 8,
                                                    left: 5,
                                                    bottom: 8,
                                                    right: 5)
//        self.customSwitchHolder.setOn(false, animated: true)
        self.customSwitchHolder.onText = LangCommon.online.capitalized
        self.customSwitchHolder.offText = LangCommon.offline.capitalized
        self.setCustomSwitchColor()
        self.customSwitchHolder.semanticContentAttribute = isRTLLanguage ? .forceRightToLeft : .forceLeftToRight
        
//        self.heatIV.image = UIImage(named: "heat_map_off")?.withRenderingMode(.alwaysTemplate)
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            let heatMapOn = Constants().GETVALUE(keyname: "HEAT_MAP")
            if heatMapOn == "true" && Shared.instance.isHeatMapEnabled(){
                self.fetchHeatMapFirstTime()
                self.tapped = true
                self.heatIV.image = UIImage(named: "heat_map_on")
            } else {
                self.heatIV.image = UIImage(named: "heat_map_off")
            }
            self.setHeatMap()
        })
    }
    func setHeatMap() {
        self.heatImageHolderView.isHidden = !Shared.instance.isHeatMapEnabled()
        self.heatImageHolderView.isRounded = true
        self.heatImageHolderView.elevate(3)
    }
    
    func setHome() {
        // Handy Splitup Start
        
        if AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.Services)  {
            if AppWebConstants.selectedBusinessType.count == 1 {
                self.vehicleNumberLbl.isHidden = true
                self.changeTitleLbl.isHidden = true
            }
        }
        // Delivery , Delivery All , Ride
        let isVehcileNeed = AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.Delivery) || AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.DeliveryAll) || AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.Ride) ||
        AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.Laundry) ||
        AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.Instacart) ||
        AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.Tow)
        //        self.DriverStack.isHidden = !isVehcileNeed
        self.vehicleNumberLbl.isHidden = !isVehcileNeed
        self.changeTitleLbl.isHidden = !isVehcileNeed
        self.addVehiclesBgView.isHidden = !isVehcileNeed
        
        // Handy
        self.providerNameLbl.text = Constants().GETVALUE(keyname: "PROVIDER_NAME")
        let isLocationNeed = AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.Services)
        self.yourWorkLocationLbl.isHidden = !isLocationNeed
        self.locationStack.isHidden = !isLocationNeed
        self.setAvailbilityBGView.isHidden = !isLocationNeed
        self.setServicesBGView.isHidden = !isLocationNeed
        if isVehcileNeed && isLocationNeed {
            self.providerNameLbl.isHidden = true
        } else {
            self.providerNameLbl.isHidden = false
        }
        // Handy Splitup End
        // Ride
//        let isHeatNeed = AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).contains(.Ride)
//        self.heatImageHolderView.isHidden = !isHeatNeed
//        self.heatImageHolderView.isHidden = true
        
       
    }
    
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
    
    
    func openBottomSheetForTypeSelection() {
        // Handy Splitup Start
        let vc = CustomBottomSheetVC.initWithStory(self,
                                                   pageTitle: LangCommon.whatYouProvide,
                                                   selectedItem: AppWebConstants.selectedBusinessType.compactMap({$0.name}),
                                                   detailsArray: AppWebConstants.availableBusinessType.compactMap({$0.name}), serviceArray:[],
                                                   selection: .multiple)
        vc.isForTypeSelection = true
        self.handyHomeMapVC.present(vc, animated: true) {
            print("Home Bottom Sheet Presented Successfully")
        }
        // Handy Splitup End
    }
    //Gofer splitup start
    func openBottomSheetForHeatMap() {
        arr.removeAll()
        serviceArr.removeAll()
        heatMapSelectedList.removeAll()
        var allselectedList = AppWebConstants.selectedBusinessType.compactMap({$0.isHeatMapSelected})
        if AppWebConstants.selectedBusinessType.compactMap({$0.name}).contains("Services") {
            serviceArr.append(contentsOf: self.handyHomeMapVC.selectedServiceListArray.compactMap({$0.name}))
            allselectedList.append(contentsOf: self.handyHomeMapVC.selectedServiceListArray.compactMap({$0.isHeatMapSelected}))
        }
        
       
        if allselectedList.contains(false) {
            self.text = LangCommon.selectAll
        } else {
            self.text = LangCommon.deSelectAll
            heatMapSelectedList.append(text)
        }
            arr.append(text)
            arr.append(contentsOf: AppWebConstants.selectedBusinessType.compactMap({$0.name}))
        heatMapSelectedList.append(contentsOf: AppWebConstants.selectedBusinessType.filter({$0.isHeatMapSelected}).compactMap({$0.name}))
        heatMapSelectedList.append(contentsOf: self.handyHomeMapVC.selectedServiceListArray.filter({$0.isHeatMapSelected}).compactMap({$0.name}))
       
        let vc = CustomBottomSheetVC.initWithStory(self,
                                                   pageTitle: LangCommon.heatMap,
                                                   selectedItem:heatMapSelectedList,
                                                   detailsArray: arr, serviceArray: serviceArr,
                                                   selection: .heatMap)
        if heatMapSelectedList.contains("Services") {
            print("it contains Services")
            vc.serviceSelected = true
        } else {
            vc.serviceSelected = false
        }
        self.handyHomeMapVC.present(vc, animated: true) {
            print("Home Bottom Sheet Presented Successfully")
        }
    }
    //Gofer splitup end
    
    func genderSelection(){

        //Handy_NewSplitup_Start
        // New Delivery splitup Start
        //Deliveryall_Newsplitup_start
        // Handy Splitup Start
        //New_Delivery_splitup_Start

        //Laundry splitup start
        //Instacart splitup start
        //Deliveryall splitup start
        // Laundry_NewSplitup_start
        // InstaCart_NewSplitup_start
        let view = GenderSelectionViewController.initWithStory()
        view.accViewModel = AccountViewModel()
        view.homeModel = self.handyHomeMapVC.homeViewModel
        view.modalPresentationStyle = .overFullScreen
        self.handyHomeMapVC.present(view,
                                    animated: true,
                                    completion: nil)
        // InstaCart_NewSplitup_end

        // Laundry_NewSplitup_end


        //Handy_NewSplitup_End
        // New Delivery splitup End

        //Deliveryall_Newsplitup_end




        // Handy Splitup End
        //New_Delivery_splitup_End

        //Laundry splitup end
        //Instacart splitup end
        //Deliveryall splitup End
    }
    
    func initGestures() {
        // Handy Splitup Start
        self.changeTitleLbl.addAction(for: .tap) {
            self.handyHomeMapVC.menuPresenter.driverProfile = self.handyHomeMapVC.homeViewModel.profileModel
            let vc = VehiclePopOverVC.initWithStory(using: self.handyHomeMapVC, andPresenter: self.handyHomeMapVC.menuPresenter)
            self.handyHomeMapVC.present(vc, animated: true) {
                print("_____________VehiclePopOverVC_____________")
            }
//            let vc = InstaRemovEditVC.initWithStory()
//            self.handyHomeMapVC.presentInFullScreen(vc, animated: true, completion: nil)
            
//            let vc = InstaPickUpVC.initWithStory()
//            self.handyHomeMapVC.navigationController?.pushViewController(vc, animated: true)
        }
        // Handy Splitup End
        //Gofer splitup start

        self.heatImageHolderView.addAction(for: .tap) { [self] in
            self.tapped = tapped ? false : true
            self.enableHeatMap(self.tapped)
        }
        //delivery splitup start
        // Handy Splitup Start
        //New_Delivery_splitup_Start
        //Laundry splitup start
        //Instacart splitup start
        //Deliveryall splitup start
        //Deliveryall_Newsplitup_start
        self.editIV.addAction(for: .tap) {
            // Laundry_NewSplitup_start
            // Laundry_NewSplitup_end
        }
        //Deliveryall_Newsplitup_end
        //Deliveryall splitup end
        //delivery splitup end
        //Gofer splitup end
        //New_Delivery_splitup_End
        //Laundry splitup end
        //Instacart splitup end
        self.profileIV.addAction(for: .tap) {
            let propertyView : ViewProfileVC  = .initWithStory(with: self.handyHomeMapVC.menuPresenter)
            self.handyHomeMapVC.menuPresenter.driverProfile = self.handyHomeMapVC.homeViewModel.profileModel
            self.handyHomeMapVC.navigationController?.pushViewController(propertyView, animated: true)
        }
    }
    
    func initLanguage() {
        self.yourWorkLocationLbl.text = LangHandy.yourWorkLocation.capitalized
        self.changeTitleLbl.text = LangCommon.change.capitalized
        self.checkStatusBtn.setTitle(LangCommon.checkStatus, for: .normal)
    }
    
    @objc func fetchNewHeatMapData(){
        var param = JSON()
        param["timezone"] = self.localTimeZoneName
        //Gofer splitup start
        param["business_id"] = self.selectedBusiness
        //Gofer splitup end
        param["service_id"] = self.selectedService
        self.connectionHandler.getRequest(for: APIEnums.getHeatMapData, params: param, showLoader: true)
            .responseDecode(to: HeatMapDataModel.self) { (json) in
                if json.status_code == "1" {
                    Shared.instance.removeLoaderInWindow()
                    let heatData = json
                    self.setHeatMapData(json)
                    //Gofer splitup start
                    let service = heatData.service.last?.service ?? []
                    self.handyHomeMapVC.selectedServiceListArray = service
                    // Handy Splitup Start
                    AppWebConstants.selectedBusinessType.removeAll()
                    AppWebConstants.selectedBusinessType = json.service.filter({$0.selectedBusinessId})
                    // Handy Splitup End
                    //Gofer splitup end
                } else {
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
            }
            .responseFailure { (error) in
                print(error)
            }
    }
    
    func fetchHeatMapFirstTime(){
        var param = JSON()
        param["timezone"] = self.localTimeZoneName
        param["business_id"] = Constants().GETVALUE(keyname:"business_types")
        param["service_id"] = Constants().GETVALUE(keyname:"service_id")
        self.connectionHandler.getRequest(for: APIEnums.getHeatMapData, params: param, showLoader: true)
        
            .responseDecode(to: HeatMapDataModel.self) { (json) in
                if json.status_code == "1" {
                    Shared.instance.removeLoaderInWindow()
                    self.setHeatMapData(json)
                    // Handy Splitup Start
                    AppWebConstants.selectedBusinessType.removeAll()
                    AppWebConstants.selectedBusinessType = json.service.filter({$0.selectedBusinessId})
                    // Handy Splitup End
                } else {
                    AppDelegate.shared.createToastMessage(json.status_message)
                }
            }
            .responseFailure { (error) in
                print(error)
            }
    }
    
    
    func setHeatMapData(_ heatData: HeatMapDataModel?){
        
        self.heatTileLayer?.map = nil
        self.heatTileLayer?.clearTileCache()
        self.heatMapData = heatData
        guard let data = heatData else{return}
        self.heatTileLayer = data.getTileLayer()
        self.heatTileLayer?.map = self.map
        
    }
    
    func enableHeatMap(_ enable : Bool){
        UserDefaults.set(enable, for: .user_enabled_heat_map)
        self.heatIV.isUserInteractionEnabled = false
        if enable{
//            DispatchQueue.main.async {
//                self.handyHomeMapVC.getUserData(showloader: false)
//            }
            
            
//            self.heatMapBtn.setImage(UIImage(named: "heat_map_on"), for: .normal)
            //Gofer splitup start

        if enable {
            // Handy Splitup Start
            //Gofer splitup start
            if AppWebConstants.selectedBusinessType.count == 1 {
                if AppWebConstants.selectedBusinessType.last?.name == "Services" && self.handyHomeMapVC.selectedServiceListArray.count == 1 {
                    self.selectedBusiness = AppWebConstants.selectedBusinessType.last?.id.description ?? ""
                    self.selectedService = self.handyHomeMapVC.selectedServiceListArray.last?.id.description ?? ""
                    self.heatIV.image = UIImage(named: "heat_map_on")
                    Constants().STOREVALUE(value: "true", keyname: "HEAT_MAP")
                    Constants().STOREVALUE(value: selectedBusiness, keyname: "business_types")
                    Constants().STOREVALUE(value: selectedService, keyname: "service_id")
                    self.fetchNewHeatMapData()
                } else if AppWebConstants.selectedBusinessType.last?.name == "Services" {
                    self.tapped = false
                    self.heatIV.isUserInteractionEnabled = true
                    Shared.instance.showLoader(in: self)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        Shared.instance.removeLoader(in: self)
                        self.openBottomSheetForHeatMap()
                    })
                    
                } else {
                    //Gofer splitup end

                self.selectedBusiness = AppWebConstants.selectedBusinessType.last?.id.description ?? ""
                    self.heatIV.image = UIImage(named: "heat_map_on")
                    Constants().STOREVALUE(value: "true", keyname: "HEAT_MAP")
                    Constants().STOREVALUE(value: selectedBusiness, keyname: "business_types")
                self.fetchNewHeatMapData()
                    //Gofer splitup start

                    self.selectedBusiness = AppWebConstants.selectedBusinessType.last?.id.description ?? ""
                    self.heatIV.image = UIImage(named: "heat_map_on")
                    Constants().STOREVALUE(value: "true", keyname: "HEAT_MAP")
                    Constants().STOREVALUE(value: selectedBusiness, keyname: "business_types")
                    self.fetchNewHeatMapData()
                }
            } else {
                Shared.instance.showLoader(in: self)
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    Shared.instance.removeLoader(in: self)
                    self.tapped = false
                    self.openBottomSheetForHeatMap()
                    self.heatIV.isUserInteractionEnabled = true
                })
                //Gofer splitup end

            }
            //Gofer splitup end
//            self.heatMapTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5 * 60),
//                                                     target: self,
//                                                     selector: #selector(fetchNewHeatMapData),
//                                                     userInfo: nil,
//                                                     repeats: true)
//            self.animation()
                
            }
        } else {
            //Gofer splitup start

            if AppWebConstants.selectedBusinessType.count == 1 || self.handyHomeMapVC.selectedServiceListArray.count == 1 {
                //Gofer splitup end
            self.heatIV.image = UIImage(named: "heat_map_off")
            Constants().STOREVALUE(value: "false", keyname: "HEAT_MAP")
            self.selectedService = ""
            self.selectedBusiness = ""
            Constants().STOREVALUE(value: self.selectedBusiness, keyname: "business_types")
            Constants().STOREVALUE(value: self.selectedService, keyname: "service_id")
            self.fetchNewHeatMapData()
                //Gofer splitup start

                self.heatIV.image = UIImage(named: "heat_map_off")
                Constants().STOREVALUE(value: "false", keyname: "HEAT_MAP")
                self.selectedService = ""
                self.selectedBusiness = ""
                Constants().STOREVALUE(value: self.selectedBusiness, keyname: "business_types")
                Constants().STOREVALUE(value: self.selectedService, keyname: "service_id")
                self.fetchNewHeatMapData()
            } else {
                self.openBottomSheetForHeatMap()
            }
            print("need something here")
//            self.endAnimation()
            //Gofer splitup end

            //            self.endAnimation()
        }
        // Handy Splitup End
        self.heatIV.contentMode = .scaleToFill
    }
//    func animation(){
//
//        CATransaction.begin()
//
//        let layer : CAShapeLayer = CAShapeLayer()
//        layer.strokeColor = UIColor.yellow.cgColor
//        layer.lineWidth = 2.0
//        layer.fillColor = UIColor.clear.cgColor
//
//        let path : UIBezierPath = UIBezierPath(roundedRect: CGRect(x: -10, y: -10, width: self.heatImageHolderView.frame.size.width + 10, height: self.heatImageHolderView.frame.size.height + 10), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5.0, height: 0.0))
//        layer.path = path.cgPath
//
//        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeStart")
//        animation.fromValue = 1.0
//        animation.toValue = 0.0
//
//        animation.duration = 7.0
//
//        CATransaction.setCompletionBlock{ [weak self] in
//            print("Animation completed")
//        }
//
//        layer.add(animation, forKey: "myStrokeReverse")
//        CATransaction.commit()
//        self.heatImageHolderView.layer.addSublayer(layer)
//    }
//    func endAnimation(){
//        self.heatImageHolderView.layer.sublayers?.removeAll()
//        CATransaction.begin()
//
//        let layer : CAShapeLayer = CAShapeLayer()
//        layer.strokeColor = UIColor.red.cgColor
//        layer.lineWidth = 3.0
//        layer.fillColor = UIColor.clear.cgColor
//
//        let path : UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.heatImageHolderView.frame.size.width + 2, height: self.heatImageHolderView.frame.size.height + 2), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5.0, height: 0.0))
//        layer.path = path.cgPath
//
//        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0.0
//        animation.toValue = 1.0
//
//        animation.duration = 7.0
//
//        CATransaction.setCompletionBlock{ [weak self] in
//            print("Animation completed")
//        }
//
//        layer.add(animation, forKey: "myStroke")
//        CATransaction.commit()
//        self.heatImageHolderView.layer.addSublayer(layer)
//    }

    
    //------------------------------
    //MARK: - Button Actions
    //------------------------------
    @IBAction func customSwitchBtnAction(_ sender: Any) {
        let val = sender as? UITextSwitch
        val?.setOn(!(val?.isOn ?? true), animated: true)
        self.switchAction()
        self.setCustomSwitchColor()
       if self.customSwitchHolder.isOn{
           UserDefaults.standard.set("Online", forKey: "user_online_status")
            self.handyHomeMapVC.updateGeofire()
       }else{
           UserDefaults.standard.set("Offline", forKey: "user_online_status")
           self.handyHomeMapVC.updateGeofire()
       }
        
    }
    
    @IBAction
    func menuButtonClicked(_ sender: Any) {
        self.endEditing(true)
        let menuVc = MenuVC.initWithStory(self.handyHomeMapVC)
            menuVc.modalPresentationStyle = .overCurrentContext
        menuVc.menuPresenter.driverProfile = self.handyHomeMapVC.homeViewModel.profileModel
        self.handyHomeMapVC.present(menuVc,
                                    animated: false,
                                    completion: nil)
    }
    
    //delivery splitup start
    //Gofer splitup start

    //New_Delivery_splitup_Start
    //Laundry splitup start
    //Instacart splitup start
    //Deliveryall splitup start
    //Deliveryall_Newsplitup_start
    @IBAction
    func setAvailabilityBtnPressed(_ sender: Any) {
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    
    @IBAction
    func setServicesBtnPressed(_ sender: Any) {
        // Laundry_NewSplitup_start
        // Laundry_NewSplitup_end
    }
    //Deliveryall_Newsplitup_end
    //Deliveryall splitup start
    //deliery splitup end
    //Gofer splitup end
    //New_Delivery_splitup_End
    //Laundry splitup end
    //Instacart splitup end

    @IBAction
    func addDocumentsBtnPressed(_ sender: Any) {
        guard let driver = self.handyHomeMapVC.homeViewModel.profileModel else {return}
        let dynamicDoc = DynamicDocumentVC.initWithStory(for: .forDriver(id: 0),
                                                         using: driver.driverDocuments,
                                                         menuPresenter: self.handyHomeMapVC.menuPresenter)
        self.handyHomeMapVC.navigationController?.pushViewController(dynamicDoc, animated: true)
    }
    @IBAction
    func addVehiclesBtnPressed(_ sender: Any) {
        // Handy Splitup Start
        let dynamicDoc = ChangeCarVC.initWithStory(withPresenter: self.handyHomeMapVC.menuPresenter)
        self.handyHomeMapVC.navigationController?.pushViewController(dynamicDoc, animated: true)
        // Handy Splitup End
    }
    
    @IBAction
    func checkStatusBtnPressed(_ sender: Any) {
        self.handyHomeMapVC.checkProviderStatus()
    }
    
    //------------------------------
    //MARK: - Setup User Details
    //------------------------------
    
    func set(userDetails: ProfileModel) {
        if let url : URL = URL(string: userDetails.user_thumb_image) {
            self.profileIV.sd_setImage(with: url,
                                       placeholderImage: UIImage(named:"user_dummy"),
                                       options: .highPriority,
                                       progress: nil,
                                       completed: nil)
        }
        Constants().STOREVALUE(value: userDetails.getUserName, keyname: "PROVIDER_NAME")
        self.providerNameLbl.text = userDetails.getUserName
        self.map?.isMyLocationEnabled = true
        self.map?.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: userDetails.providerLocation?.providerLocLatitude ?? 0.0,
                                                                            longitude: userDetails.providerLocation?.providerLocLongitude ?? 0.0),
                                             zoom: 16.5)
        self.handyHomeMapVC.oldCoordinate = CLLocationCoordinate2D(latitude: userDetails.providerLocation?.providerLocLatitude ?? 0.0,
                                                                   longitude: userDetails.providerLocation?.providerLocLongitude ?? 0.0)
        self.map?.animate(toLocation: CLLocationCoordinate2D(latitude: userDetails.providerLocation?.providerLocLatitude ?? 0.0,
                                                             longitude: userDetails.providerLocation?.providerLocLongitude ?? 0.0))
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: userDetails.providerLocation?.providerLocLatitude ?? 0.0,
                                                                longitude: userDetails.providerLocation?.providerLocLongitude ?? 0.0))
        //marker.map = self.map
        let image = UIImageView(image: UIImage(named: "top_view"))
        image.frame = CGRect(x: 0, y: 0, width: 25, height: 35)
        marker.iconView = image
        self.handyHomeMapVC.driverMarker = GMSMarker()
        self.handyHomeMapVC.driverMarker.position = CLLocationCoordinate2D(latitude: userDetails.providerLocation?.providerLocLatitude ?? 0.0,
                                                                           longitude: userDetails.providerLocation?.providerLocLongitude ?? 0.0)
        self.handyHomeMapVC.driverMarker.icon = UIImage(named: "cartopview2_40")
        self.handyHomeMapVC.driverMarker.map = self.map
        self.handyHomeMapVC.driverMarker.isFlat = true

        self.workLocationAddressLbl.text = userDetails.providerLocation?.address
        let status : DriverTripStatus = userDetails.provider_status
        switch status {
        case .Online:
            self.customSwitchHolder.setOn(true, animated: true)
        case .Offline:
            self.customSwitchHolder.setOn(false, animated: true)
        case .Trip:
            self.customSwitchHolder.setOn(true, animated: true)
        case .Job:
            self.customSwitchHolder.setOn(true, animated: true)
            
        }
        self.vehicleNumberLbl.text = userDetails.vehicle_no.isEmpty ? userDetails.vehicle_name : userDetails.vehicle_no
        self.setHome()
    }
    
    //------------------------
    //MARK: - adding MapView
    //------------------------
    func addMapView() {
        self.map = GMSMapView()
        guard let map = self.map else { return }
        self.mapHolderView.addSubview(map)
        map.anchor(toView: self.mapHolderView,
                   leading: 0,
                   trailing: 0,
                   top: 0,
                   bottom: 0)
        self.onChangeMapStyle(map: map)
        self.mapHolderView.bringSubviewToFront(self.bottomHolderView)
    }
    
    //------------------------
    //MARK: - removing MapView
    //------------------------
    
    func removeMapView() {
        guard let map = self.map else { return }
        map.removeFromSuperview()
        self.map = nil
    }
    
    func switchAction() {
        UberSupport.shared.showProgressInWindow(showAnimation: true)
        self.handyHomeMapVC.updateCurrentLocationToServer(status: customSwitchHolder.isOn ? .Online : .Offline)
    }
    
    func userLocationCheck(from profile : ProfileModel) {
        if profile.userLocaitonIsAvailable {
            self.workLocationAddressLbl.text = profile.providerLocation?.address
        } else {
            self.workLocationAddressLbl.text = LangCommon.cancel
            self.handyHomeMapVC.commonAlert.setupAlert(alert: LangCommon.appName,
                                                       alertDescription: LangCommon.locationPermissionDescription
                                                        + " "
                                                        + LangCommon.appName
                                                        + " "
                                                        + LangCommon.toAccessYourLocation,
                                                       okAction: LangCommon.ok,
                                                       cancelAction: LangCommon.cancel, userImage: nil)
            self.handyHomeMapVC.commonAlert.addAdditionalOkAction(isForSingleOption: false) {
                self.handyHomeMapVC.getCurrentLocation()
            }
            self.handyHomeMapVC.commonAlert.addAdditionalCancelAction {
                print("Cancel Btn Pressed")
            }
        }
    }
    
    func updateButtonTittles() {
        guard let isAllDocumentsUploaded = self.handyHomeMapVC.homeViewModel.profileModel?.driverDocuments.anySatisfy({$0.urlString.isEmpty}) else { return }
        self.addDocumentBtn.setTitle(isAllDocumentsUploaded ? LangCommon.addDocument.capitalized : LangCommon.manageDocuments.capitalized, for: .normal)
        self.addVehiclesBtn.setTitle((self.handyHomeMapVC.homeViewModel.profileModel?.vehicles.isEmpty ?? false) ? LangCommon.addVehicle : LangCommon.manageVehicle, for: .normal)
    }
    
    func setSwitchStatus() {
        self.customSwitchHolder.setOn(DriverTripStatus.default == .Online ||
                                      DriverTripStatus.default == .Job,
                                      animated: true)
    }
    
    func setUpTheAvailabiltyAndServicesStatus() {
        if let checkedServices = self.handyHomeMapVC.homeViewModel.profileModel?.checkedServices ,
           let checkedAvailability = self.handyHomeMapVC.homeViewModel.profileModel?.checkedAvailability ,
           let approveStatus = self.handyHomeMapVC.homeViewModel.profileModel?.isProviderApproved {
            self.isServiceEnabled = checkedServices
            self.isAvailabilityEnabled = checkedAvailability
            self.isProviderApproved = approveStatus
        }
        self.isBothServiceAndAvailabilityNotSet = (self.isAvailabilityEnabled == false && self.isServiceEnabled == false)
        self.isProviderNotEnabledvailability = self.isAvailabilityEnabled
        self.isProviderNotEnabledService = self.isServiceEnabled
        self.titleCheckingOfSetAvailability()
        self.titleCheckingOfSetServicesBtn()
    }
    
    func titleCheckingOfSetServicesBtn() {
        if isProviderApproved {
//            self.isBothServiceAndAvailabilityNotSet ? AppDelegate.shared.createToastMessage(LangCommon.setBothAvailabilityAndServices)
//                : nil
//            !self.isProviderNotEnabledService &&
//                !self.isBothServiceAndAvailabilityNotSet ? AppDelegate.shared.createToastMessage(LangHandy.setYourProvidingService) : nil
        } else {
            self.setServicesBtn.setTitle(isServiceEnabled ?
                                            LangCommon.manageServices
                                            : LangCommon.setServices, for: .normal)
        }
    }
    
    /// check the Title of The Set Availability Button Based on the Availability
    func titleCheckingOfSetAvailability() {
        if isProviderApproved {
//            !self.isProviderNotEnabledvailability && !self.isBothServiceAndAvailabilityNotSet ? AppDelegate.shared.createToastMessage(LangHandy.setYourAvailability)
//                : nil
        } else {
            self.setAvailabilityBtn.setTitle(isAvailabilityEnabled ?
                                                LangCommon.manageAvailability
                                                : LangCommon.setAvailability , for: .normal)
        }
        
    }
    
    func setUpBottomView(toActive active : Bool) {
        self.checkStatusBtn.cornerRadius = 15
        self.setDocumentBGView.isHidden = Shared.instance.userProfile?.driverDocuments.first?.name == nil
        if !active {
            self.checkStatusView.frame.origin.y = self.frame.maxY
            self.bottomHolderView.addSubview(self.checkStatusView)
            self.checkStatusView.anchor(toView: self.bottomHolderView,
                                        leading: 15,
                                        trailing: -15,
                                        top: 15,
                                        bottom: -15)
            
            //self.customSwitchHolder.isHidden = true
        } else {
            self.profileImageHolderView.isHidden = false
            self.addressHolderView.isHidden = false
            //self.customSwitchHolder.isHidden = false
        }
        UIView.animate(withDuration: 0.7) {
            if !active {
                self.checkStatusView.frame.origin.y = self.bottomHolderView.frame.minY + 15
            } else {
                self.checkStatusView.frame.origin.y = self.frame.maxY
            }
        } completion: { (completd) in
            if completd && active {
                self.checkStatusView.removeFromSuperview()
            }
        }
    }
}

extension HandyHomeMapVC : MenuResponseProtocol {
    
    func openFontActionSheet() {
        self.openChangeFontSheet()
    }
    
    func routeToView(_ view: UIViewController) {
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func refreshVehcileView() {
        //        self.setVehicleData()
    }
    
    func callAdminForManualBooking() {
        //        self.checkMobileNumeber()
    }
    
    func openThemeActionSheet() {
        self.openThemeSheet()
    }
    
    func openBusinessTypeChooser() {
        self.handyHomeMapView.openBottomSheetForTypeSelection()
    }
    
}

extension HandyHomeMapView : CustomBottomSheetDelegate {
    
    func isDeselectAllSelected() {
        self.text = LangCommon.selectAll
        self.heatIV.image = UIImage(named: "heat_map_off")
        Shared.instance.heatMapOn = false
        Constants().STOREVALUE(value: "false", keyname: "HEAT_MAP")
        //Gofer splitup start
        //            self.tapped = false
        // Handy Splitup Start
        AppWebConstants.selectedBusinessType.forEach { service in
            service.isHeatMapSelected = false
        }
        // Handy Splitup End
        self.handyHomeMapVC.selectedServiceListArray.forEach({
            service in
            service.isHeatMapSelected = false
        })
        self.heatMapBussinessType.removeAll()
        self.heatMapServiceTypes.removeAll()
        selectedBusiness = ""
        selectedService = ""
        Constants().STOREVALUE(value: selectedBusiness, keyname: "business_types")
        Constants().STOREVALUE(value: selectedService, keyname: "service_id")
        //Gofer splitup end
        self.fetchNewHeatMapData()
    }
    
    func isSelectAllSelected (SelectAllValue: Bool) {
        //Gofer splitup start
        self.heatMapBussinessType.removeAll()
        self.heatMapServiceTypes.removeAll()
        if SelectAllValue {
            self.text = LangCommon.deSelectAll
            Constants().STOREVALUE(value: "true", keyname: "HEAT_MAP")
//            self.tapped = true
            // Handy Splitup Start
            AppWebConstants.selectedBusinessType.forEach { service in
                service.isHeatMapSelected = true
                self.heatMapBussinessType.append(service)
            }
            // Handy Splitup End
            self.handyHomeMapVC.selectedServiceListArray.forEach({
                service in
                self.heatMapServiceTypes.append(service)
                service.isHeatMapSelected = true
            })
            selectedBusiness = self.heatMapBussinessType.compactMap({$0.id.description}).joined(separator: ",")
            print("selectedBusiness : \(selectedBusiness)")
            selectedService = self.heatMapServiceTypes.compactMap({$0.id.description}).joined(separator: ",")
            print("selectedServices : \(selectedService)")
        } else {
            // Handy Splitup Start
            AppWebConstants.selectedBusinessType.forEach { service in
                service.isHeatMapSelected = false
            }
            // Handy Splitup End
            self.handyHomeMapVC.selectedServiceListArray.forEach({
                service in
                service.isHeatMapSelected = false
            })
            self.heatMapBussinessType.removeAll()
            self.heatMapServiceTypes.removeAll()
            selectedBusiness = ""
            selectedService = ""
        }
        //Gofer splitup end
    }

    
func heatMapTapAction(selectedOptions: [String]) {
    //Gofer splitup start
    self.heatMapBussinessType.removeAll()
    self.heatMapServiceTypes.removeAll()
    AppWebConstants.selectedBusinessType.forEach { service in
        for i in 0..<selectedOptions.count {
            if selectedOptions[i] == service.name {
                self.heatMapBussinessType.append(service)
                service.isHeatMapSelected = !service.isHeatMapSelected
            } else {
                service.isHeatMapSelected = false
            }
        }
    }
   
    selectedBusiness = self.heatMapBussinessType.filter({selectedOptions.contains($0.name)})
        .compactMap({$0.id.description}).joined(separator: ",")
    print("selectedBusiness : \(selectedBusiness)")
    self.handyHomeMapVC.selectedServiceListArray.forEach({
        service in
        for i in 0..<selectedOptions.count {
            if selectedOptions[i] == service.name {
                self.heatMapServiceTypes.append(service)
                service.isHeatMapSelected = !service.isHeatMapSelected
            } else {
                service.isHeatMapSelected = false
            }
        }
    }
    )
    
    selectedService = self.heatMapServiceTypes.filter({selectedOptions.contains($0.name)})
        .compactMap({$0.id.description}).joined(separator: ",")
    print("selectedService : \(selectedService)")
    if selectedBusiness.contains("1") && selectedService.isEmpty {
        let alert = CommonAlert()
        alert.setupAlert(alert: "Please select one Service Category", okAction: LangCommon.ok)
        
    } else {
        self.fetchNewHeatMapData()
        self.heatIV.image = UIImage(named: "heat_map_on")
        Shared.instance.heatMapOn = true
        Constants().STOREVALUE(value: "true", keyname: "HEAT_MAP")
        Constants().STOREVALUE(value: selectedBusiness, keyname: "business_types")
        Constants().STOREVALUE(value: selectedService, keyname: "service_id")
    }
    //Gofer splitup end

}
    
    func MultipleTapAction(selectedOptions: [String]) {
        //Gofer splitup start

        var selectedBusiness : String = ""
        selectedBusiness = AppWebConstants.availableBusinessType.filter({selectedOptions.contains($0.name)})
            .compactMap({$0.id.description}).joined(separator: ",")
        print("selectedBusiness : \(selectedBusiness)")
        self.handyHomeMapVC.wsToUpdateService(param: ["business_id": selectedBusiness])
        self.setHome()
        self.selectedBusiness = ""
        selectedService = ""
        self.heatIV.image = UIImage(named: "heat_map_off")
//        self.tapped = false
        Constants().STOREVALUE(value: "false", keyname: "HEAT_MAP")
        Constants().STOREVALUE(value: self.selectedBusiness, keyname: "business_types")
        Constants().STOREVALUE(value: selectedService, keyname: "service_id")
        //Gofer splitup end
        fetchNewHeatMapData()
    }
    
    func TappedAction(indexPath: Int,
                      SelectedItemName: String) {
        print("__________Selected Item: \(indexPath) : \(SelectedItemName)")
        AppWebConstants.availableBusinessType.forEach { service in
            if SelectedItemName == service.name {
                //Gofer splitup start
                self.selectedBusiness = service.id.description
                //Gofer splitup end
                service.isHeatMapSelected = !service.isHeatMapSelected
            } else {
                service.isHeatMapSelected = false
            }
        }
        //Gofer splitup start
        print("selectedBusiness : \(selectedBusiness)")
        //Gofer splitup end

    }
    
    func ActionSheetCanceled() {
        print("Home Screen Bottom Sheet Cancelled")
    }
    
    
}
