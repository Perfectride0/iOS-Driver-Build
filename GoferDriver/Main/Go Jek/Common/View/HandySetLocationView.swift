//
//  HandySetLocationView.swift
//  GoferHandy
//
//  Created by trioangle on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
class HandySetLocationView: BaseView {
    
    var setLocationVC :  HandySetLocationVC!
    
    //MARK:- Outlets
    @IBOutlet weak var locationTableView : CommonTableView!
    @IBOutlet weak var headerView : HeaderView!
    @IBOutlet weak var closeBtn : SecondaryThemeBorderedButton!
    @IBOutlet weak var titleLbl: SecondaryHeaderLabel!
    @IBOutlet weak var locationSearchBar : CommonTextField!
    @IBOutlet weak var locationOptionHolderView : SecondaryView!
    @IBOutlet weak var setLocationLbl : SecondarySmallHeaderLabel!
    @IBOutlet weak var setLocationArrow : CommonColorImageView!
   // @IBOutlet weak var userMyLocationView : UIView!
    @IBOutlet weak var setPinView : SecondaryView!
    @IBOutlet weak var markerView: CommonColorImageView!
    @IBOutlet weak var pinLocationIV : UIImageView!
    @IBOutlet weak var donePickingLocaitonBtn : PrimaryButton!
    @IBOutlet weak var contentHolderView: TopCurvedView!
    @IBOutlet weak var bottomHolderView: TopCurvedView!
    @IBOutlet weak var searchBGView: SecondaryView!
    @IBOutlet weak var searchIV: SecondaryTintImageView!
    
    override func darkModeChange() {
        super.darkModeChange()
        self.titleLbl.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.markerView.customColorsUpdate()
        self.setLocationArrow.customColorsUpdate()
        self.contentHolderView.customColorsUpdate()
        self.bottomHolderView.customColorsUpdate()
        self.locationTableView.customColorsUpdate()
        self.locationSearchBar.customColorsUpdate()
        self.searchBGView.customColorsUpdate()
        self.searchIV.customColorsUpdate()
        self.locationOptionHolderView.customColorsUpdate()
        self.setLocationLbl.customColorsUpdate()
        self.setPinView.customColorsUpdate()
        self.locationTableView.reloadData()
        self.setPinView.border(0.5, UIColor.TertiaryColor.withAlphaComponent(0.3))
       // self.onChangeMapStyle(map: self.mapView)
    }
    //MARK:- Actions
    @IBAction
    func backAction(_ sender : UIButton?){
        self.setLocationVC.exitScreen(animated: true)
    }
    @IBAction
    func donePinningAction(_ sender : UIButton){
        guard let location = idleLocation else{return}
        location.getAddress { (_) in
            self.usingPinToGetLocation = false
            self.setLocationVC.didPickALocation(location)
        }
    }
    //MARK:- variables
    var currentLocation : CLLocationCoordinate2D!
    var searchPredictions : [Prediction] = []
    var googlePlaceSearchHandler : GoogleAutoCompleteHandler?
    var map_view_is_idle = true
    var usingPinToGetLocation : Bool = false {
        didSet{
            self.idleLocation = nil
            if self.usingPinToGetLocation{
                self.pinLocationIV.isHidden = false
                self.donePickingLocaitonBtn.isHidden = false
                self.bottomHolderView.isHidden = false
                self.setPinView.isHidden = true
                self.endEditing(true)
            }else{
                self.pinLocationIV.isHidden = true
                self.bottomHolderView.isHidden = true
                self.donePickingLocaitonBtn.isHidden = true
                self.setPinView.isHidden = false
            }
            self.locationTableView.reloadData()
        }
    }
    var mapView : GMSMapView {
        let map = GMSMapView(frame: self.contentHolderView.bounds)
        map.delegate = self
        map.isMyLocationEnabled = true
        map.settings.myLocationButton  = true
        map.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.setLocationVC.bookingViewModel.getCurrentLocation { (newLocation) in
            self.currentLocation = newLocation.coordinate
            self.setLocation()
        }
        map.clipsToBounds = true
        map.layer.cornerRadius = 45
        return map
        
    }
    var idleLocation : MyLocationModel?{
        didSet{
            self.donePickingLocaitonBtn.setMainActive(false)
            idleLocation?.getAddress { (address) in
                self.locationSearchBar.text = address
                self.donePickingLocaitonBtn.setMainActive(true)
            }
        }
    }
    //MAKR:- life cycle
    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.setLocationVC = baseVC as? HandySetLocationVC
        let currentLat = Shared.instance.userProfile?.providerLocation?.providerLocLatitude
        let currentLong = Shared.instance.userProfile?.providerLocation?.providerLocLongitude
        let myCurrentLocation = currentLat != .zero ? (currentLat,currentLong) : nil
        self.googlePlaceSearchHandler =
            GoogleAutoCompleteHandler(searchTextField: self.locationSearchBar,
                                      delegate: self,
                                      userCurrentLatLng: myCurrentLocation as? (lat: Double, long: Double))
        self.initView()
        self.initLanguage()
        self.initGestures()
        self.setLocationLbl.text = LangHandy.setLocationOnMap
        self.darkModeChange()
    }
    override func willAppear(baseVC: BaseVC) {
        super.willAppear(baseVC: baseVC)
    }
    
    func addMapView() {
        self.contentHolderView.subviews.forEach { (view) in
            if (view.isKind(of: GMSMapView.self)) {
                return
            }
        }
        self.contentHolderView.addSubview(self.mapView)
        self.contentHolderView.bringSubviewToFront(self.mapView)
        self.contentHolderView.bringSubviewToFront(self.pinLocationIV)
        self.contentHolderView.bringSubviewToFront(self.searchBGView)
        self.contentHolderView.bringSubviewToFront(self.bottomHolderView)
        self.setLocation()
    }
    
    func setLocation() {
        guard let location = self.currentLocation else { return }
        self.contentHolderView.subviews.forEach { (view) in
            if (view.isKind(of: GMSMapView.self)) {
                (view as? GMSMapView)?.animate(toLocation: location)
                (view as? GMSMapView)?.animate(toZoom: 14)
                self.onChangeMapStyle(map: (view as! GMSMapView))
            }
        }
    }
    
    func removeMapView() {
        self.contentHolderView.subviews.forEach { (view) in
            if (view.isKind(of: GMSMapView.self)) {
                view.removeFromSuperview()
            }
        }
        self.contentHolderView.bringSubviewToFront(self.locationTableView)
    }
    
    //MARK:- initializers
    
    func initView(){
        if #available(iOS 13.0, *) {
            self.locationSearchBar.placeholder = LangCommon.searchLocation
        } else {
            // Fallback on earlier versions
            if let textfield = locationSearchBar.value(forKey: "searchField") as? UITextField {
                textfield.placeholder = LangCommon.searchLocation
            }
        }
        self.locationSearchBar.setTextAlignment()
        self.searchBGView.cornerRadius = 10
        self.searchBGView.elevate(2)
        self.setPinView.cornerRadius = 15
        
        self.setLocationArrow?.transform = isRTLLanguage
            ? CGAffineTransform(rotationAngle: .pi)
            : .identity
        
        self.pinLocationIV.isHidden = true
        self.donePickingLocaitonBtn.isHidden = true
        self.bottomHolderView.isHidden = true
        //markerView.image = #imageLiteral(resourceName: "location_icon_red")
        self.locationTableView.clipsToBounds = true
        self.locationTableView.cornerRadius = 15
        self.donePickingLocaitonBtn.setTitle(LangCommon.done.capitalized, for: .normal)
        self.locationTableView.delegate = self
        self.locationTableView.dataSource = self
        
        
    }
    func initLanguage(){
        let text = LangCommon.setLocation == "" ? "Set Location" : LangCommon.setLocation.capitalized
        self.titleLbl.text = text
    }
    func initGestures(){
        
        
        self.setPinView.addAction(for: .tap) { [weak self] in
            self?.usingPinToGetLocation = true
        }
        
        
    }
    //MARK:- UDF
    func fetchLocationFromPinAndSet(){
        self.searchPredictions.removeAll()
        self.usingPinToGetLocation = true
    }

}
//MARK:- UITableViewDataSource
extension HandySetLocationView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.usingPinToGetLocation {
            self.removeMapView()
            self.addMapView()
            return 0
        } else {
            self.removeMapView()
        }
        
        //tableView.backgroundView?.backgroundColor = .white
        return self.searchPredictions.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.searchPredictions.isNotEmpty{//self.usingPinToGetLocation ||
            return 0
        }
        if self.usingPinToGetLocation {
            return 0
        }
        return 100
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if  self.searchPredictions.isNotEmpty{//self.usingPinToGetLocation ||
            return nil
        }
        return locationOptionHolderView 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HandySearchLocationTVC = tableView.dequeueReusableCell(for: indexPath)
        guard let prediction = self.searchPredictions.value(atSafe: indexPath.row) else{return cell}
        cell.lblTitle.text = prediction.structuredFormatting.mainText
        cell.lblSubTitle.text = prediction.structuredFormatting.secondaryText
        cell.setTheme()
        if searchPredictions.count > 1 {
            if indexPath.row == 0 {
                cell.outerView.setSpecificCornersForTop(cornerRadius: 25)
            }else if indexPath.row == searchPredictions.count - 1 {
                cell.outerView.setSpecificCornersForBottom(cornerRadius: 25)
            }
            else{
                cell.outerView.cornerRadius = 0
            }
        }else{
            cell.outerView.cornerRadius = 10
        }
        cell.outerView.backgroundColor =  UIColor.TertiaryColor.withAlphaComponent(0.3)

        return cell
    }
    
    //---------------------------------------------
    //MARK: - Change Map Style
    //---------------------------------------------
    
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
    
}
//MARK:- UITableViewDelegate
extension HandySetLocationView : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       guard let prediction = self.searchPredictions.value(atSafe: indexPath.row) else{return }
        
        self.setLocationVC.getLocationCoordinates(withReferenceID: prediction.reference,
                                                  address: prediction.structuredFormatting.mainText + "," + prediction.structuredFormatting.secondaryText)
    }
    

    
}
//MARK:- GoogleAutoCompleteDelegate
extension HandySetLocationView : GoogleAutoCompleteDelegate{
    func googleAutoComplete(failedWithError error: String) {
        self.usingPinToGetLocation = false
        debug(print: error)
        AppUtilities().customCommonAlertView(titleString: appName,
                                             messageString: error)
    }
    
    func googleAutoComplete(predictionsFetched predictions: [Prediction]) {
        self.usingPinToGetLocation = false
        self.searchPredictions = predictions
        self.locationTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.darkModeChange()
        }
    }
    
    func searchBtnClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
   
}
//MARK:- GMSMapViewDelegate
extension HandySetLocationView : GMSMapViewDelegate{
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            guard !self.map_view_is_idle else{return}//Return if already in idle state
            self.map_view_is_idle = true
           
            self.idleLocation = .init(location: CLLocation(latitude: position.target.latitude,
                                                           longitude: position.target.longitude))
           

        }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
           self.map_view_is_idle = false
           return
    }
}

extension UIView{
    func setSpecificCornersForTop(cornerRadius : CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
    }
    func setSpecificCornersForBottom(cornerRadius : CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
