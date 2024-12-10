//
//  MenuPresenter.swift
//  GoferDriver
//
//  Created by trioangle on 02/07/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation


class MenuPresenter {
    //MARK:- APIViewProtocol
    
    
    //MARK:- localVariables
    fileprivate var userData : ProfileModel?

    
    fileprivate var profileUpdateListeners : [Closure<ProfileModel>] = []
    //MARK:- initializers
    init(){
//        self.wsToGetUserProfileInfo()
    }
    //MARK:- WebService
    fileprivate var retryCount = 0
    func wsToGetUserProfileInfo(){
//       yamini hiding it
        guard let token : String = UserDefaults.value(for: .access_token) else{return}

            UberSupport.shared.showProgressInWindow(showAnimation: true)
            var dicts = [String: Any]()
//        /Volumes/Time Machine Backups/Product/GoferHandy/goferhandy_provider_ios/GoferDriver/Modules/Gofer/TripModule/Protocols/MenuPresenter.swift    dicts["token"] = token
        dicts["token"] = token
        var param = JSON()
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        param["currency_code"] = userCurrencyCode
        param["currency_symbol"] = userCurrencySym
        ConnectionHandler.shared.getRequest(for: APIEnums.getProviderProfile, params:param, showLoader: true)
                
        
            .responseDecode(to: ProfileModel.self) { (json) in
            if json.status_code == "1" {
                self.retryCount = 0
                let profileModel = json
                Constants().STOREVALUE(value: profileModel.car_id, keyname: USER_CAR_ID)
                self.driverProfile = profileModel
            } else {
                if self.retryCount < 3{
                    self.retryCount += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                        self.wsToGetUserProfileInfo()
                    }
                }
            }
          }
            
//            .responseJSON({ (json) in
//                UberSupport.shared.removeProgressInWindow()
//                if json.isSuccess{
//                    self.retryCount = 0
//                    let profileModel = ProfileModel(json: json)
//                    Constants().STOREVALUE(value: profileModel.car_id, keyname: USER_CAR_ID)
//                    self.driverProfile = profileModel
//                }else{
//                    if self.retryCount < 3{
//                        self.retryCount += 1
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
//                            self.wsToGetUserProfileInfo()
//                        }
//                    }
//                }
//            })
                   
                   .responseFailure({ (error) in

                UberSupport.shared.removeProgressInWindow()
                if self.retryCount < 3{
                    self.retryCount += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                        self.wsToGetUserProfileInfo()
                    }
                }
            })
       
    }
}
//MARK:- UDF
extension MenuPresenter {
    var driverProfile : ProfileModel?{
        get{
            if self.userData == nil{
                self.wsToGetUserProfileInfo()
                
            }
            return self.userData
        }
        set{
            self.userData = newValue
            if let nonNullData = newValue{
                self.profileUpdateListeners.forEach({$0(nonNullData)})
            }
        }
    }
    func listenToUpdate(onProfile : @escaping  Closure<ProfileModel>){
        self.profileUpdateListeners.append(onProfile)
    }
    func isDriverActive() -> Bool{
        return self.driverProfile?.driverStatus == 1//[DriverStatus.active].contains(.getStatusFromPreference())
    }
    func isDriverOnline() -> Bool{
        return DriverTripStatus.default == .Online
    }
    
    func setDriverTripStatus(to status: DriverTripStatus,didSet : @escaping (Closure<DriverTripStatus>)){
        var dicts = JSON()
        dicts["token"] =  Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        dicts["latitude"] = Constants().GETVALUE(keyname: USER_LATITUDE)
        dicts["longitude"] = Constants().GETVALUE(keyname: USER_LONGITUDE)
        dicts["car_id"] = Constants().GETVALUE(keyname: USER_CAR_ID)
        dicts["status"] = status.rawValue
        guard let lat = dicts["latitude"] as? String,!lat.isEmpty else {return}
        guard let lang = dicts["longitude"] as? String,!lang.isEmpty else {return}
        
       
        ConnectionHandler.shared.getRequest(for: APIEnums.updateDriverLocation,params: dicts, showLoader: false
        ).responseJSON({ (json) in
            if json.isSuccess{
                didSet(status)
            }else{
                let commonAlert = CommonAlert()
                commonAlert.setupAlert(alert: appName,
                                                             alertDescription: json.status_message,
                                                             okAction: LangCommon.ok.capitalized)


                didSet(.Offline)
            }
        }).responseFailure({ (error) in
            didSet(.Offline)
        })
    }
}
