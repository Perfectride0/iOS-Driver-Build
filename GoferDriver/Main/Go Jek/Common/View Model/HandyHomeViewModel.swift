//
//  HandyHomeViewModel.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 08/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth

typealias jobStatusResponse = (jobStatus : TripStatus,detail: JobDetailModel,message : String?,statusCode:String)

class HandyHomeViewModel: BaseViewModel {
    var profileModel : ProfileModel? = nil
    var jobDetails: JobDetailModel? = nil
    var jobRequest : JobRequestModel? = nil
    //Gofer splitup start
    var serviceListArray:Array<ServiceTypes> = []
    //Gofer splitup end
    override init() {
           super.init()
       }
    func stopListening()
    {
        self.locationHandler?.startListening(toLocationChanges: false)
    }
    func updateWorkLocationApi(parms: [AnyHashable: Any],completionHandler : @escaping (Result<Bool,Error>) -> Void)
     {
        guard let params = parms as? JSON else{
                          AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
                          return
                      }
        self.connectionHandler.getRequest(for: APIEnums.updateWorkLocation, params: params, showLoader: true)
          .responseJSON({ (json) in
                     if json.isSuccess{
//                        self.profileModel?.providerLocation = ProviderLocationModel(json: json["location"] as? JSON ?? JSON())
                        dump(self.profileModel)
                      completionHandler(.success(true))
                     }else{
                      completionHandler(.failure(GoferError.failure(json.status_message)))
                     }
                 })
             .responseFailure { (error) in
                 print(error)
                 completionHandler(.failure(GoferError.failure(error)))
    }
    }
    func getProviderProfileApi(showloader : Bool,completionHandler : @escaping (Result<ProfileModel,Error>) -> Void)
    {
        var param = JSON()
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        param["currency_code"] = userCurrencyCode
        param["currency_symbol"] = userCurrencySym
        ConnectionHandler.shared.getRequest(for: APIEnums.getProviderProfile, params: param, showLoader: showloader)
        
        
        
            .responseDecode(to: ProfileModel.self) { (json) in
                if json.status_code == "1"{
                 let currency_code = json.currency_code
                 let currency_symbol = json.currency_symbol
                 Constants().STOREVALUE(value: currency_symbol, keyname: USER_CURRENCY_SYMBOL_ORG_splash)
                 Constants().STOREVALUE(value: currency_code, keyname: USER_CURRENCY_ORG_splash)
//                        Constants().STOREVALUE(value: currency_symbol, keyname: USER_CURRENCY_SYMBOL_ORG)
//                        Constants().STOREVALUE(value: currency_code, keyname: USER_CURRENCY_ORG)
                 self.profileModel = json
                 let service = json.services
                    //Gofer splitup start
                    self.serviceListArray.removeAll()
                    self.serviceListArray = service.last?.service ?? []
                    //Gofer splitup end
                    AppWebConstants.availableBusinessType.removeAll()
                    AppWebConstants.selectedBusinessType.removeAll()
                 AppWebConstants.availableBusinessType = service
                 AppWebConstants.selectedBusinessType = service.filter({$0.selectedBusinessId})
                 if AppWebConstants.currentBusinessType == .Gojek && AppWebConstants.selectedBusinessType.isNotEmpty {
                     AppWebConstants.currentBusinessType = AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).first ?? .Gojek
                 }
                 completionHandler(.success(json))
                }else{
                 completionHandler(.failure(GoferError.failure(json.status_message)))
                }

          }
        
        
//                          .responseJSON({ (json) in
//                       UberSupport.shared.removeProgressInWindow()
//                       if json.isSuccess{
//                           let profileModel = ProfileModel(json: json)
//                        let currency_code = json.string("currency_code")
//                        let currency_symbol = json.string("currency_symbol")
//                        Constants().STOREVALUE(value: currency_symbol, keyname: USER_CURRENCY_SYMBOL_ORG_splash)
//                        Constants().STOREVALUE(value: currency_code, keyname: USER_CURRENCY_ORG_splash)
////                        Constants().STOREVALUE(value: currency_symbol, keyname: USER_CURRENCY_SYMBOL_ORG)
////                        Constants().STOREVALUE(value: currency_code, keyname: USER_CURRENCY_ORG)
//                        self.profileModel = profileModel
//                        let service = json.array("service").compactMap({GojekService(json: $0)})
//                           self.serviceListArray.removeAll()
//                           self.serviceListArray = service.last?.service ?? []
//                           AppWebConstants.availableBusinessType.removeAll()
//                           AppWebConstants.selectedBusinessType.removeAll()
//                        AppWebConstants.availableBusinessType = service
//                        AppWebConstants.selectedBusinessType = service.filter({$0.selectedBusinessId})
//                        if AppWebConstants.currentBusinessType == .Gojek && AppWebConstants.selectedBusinessType.isNotEmpty {
//                            AppWebConstants.currentBusinessType = AppWebConstants.selectedBusinessType.compactMap({$0.busineesType}).first ?? .Gojek
//                        }
//                        completionHandler(.success(profileModel))
//                       }else{
//                        completionHandler(.failure(GoferError.failure(json.status_message)))
//                       }
//                   })
                          
                          .responseFailure({ (error) in
                    completionHandler(.failure(GoferError.failure(error)))
                   })
    }
    
    func updateProviderStatusApi(parms: JSON,
                                 completionHandler : @escaping (Result<JSON,Error>) -> Void) {
        ConnectionHandler.shared.getRequest(for: APIEnums.updateStatus,
                                               params: parms,
                                               showLoader: true)
            .responseJSON({ (json) in
                UberSupport.shared.removeProgressInWindow()
                completionHandler(.success(json))
            }).responseFailure({ (error) in
                completionHandler(.failure(GoferError.failure(error)))
            })
    }
    func firebaseAuthentication() {
        let firebaseToken = UserDefaults.standard.value(forKey: USER_FIREBASE_TOKEN) as? String ?? ""
//        if !firebaseAuth{
            Auth.auth().signIn(withCustomToken: firebaseToken) { (user, error) in
                if (error != nil) {
                    UserDefaults.standard.setValue(false, forKey: USER_FIREBASE_AUTH)
                    print(error.debugDescription)
                }else{
                    if Shared.instance.permissionDenied {
                        AppDelegate.shared.pushManager.startObservingProvider()
                    }
                    UserDefaults.standard.setValue(true, forKey: USER_FIREBASE_AUTH)
                }
//            }
        }
    }
    func getEssentials(completionHandler : @escaping (Result<JSON,Error>) -> Void)
    {
        ConnectionHandler.shared.getRequest(for: .getEssetntials, params: JSON(), showLoader: true).responseJSON { (json) in
            if json.isSuccess{
                ConnectionHandler.shared.handleEssenetials(json: json)
                self.firebaseAuthentication()
                    if Shared.instance.resumeTripHitCount == 0{
                        self.getJobDetails(){(result) in
                            switch result{
                            case .success(let detail):
                                completionHandler(.success(detail))
                            case .failure(let error):
//                                AppDelegate.shared.createToastMessage(error.localizedDescription)
                                completionHandler(.failure(GoferError.failure(error.localizedDescription)))
                            }
                    }
                    }
                     }else{
                      completionHandler(.failure(GoferError.failure(json.status_message)))
                     }
                     
                  }.responseFailure { (erro) in
                      print(erro)
                  }
    }
    
    func getJobDetails(completionHandler : @escaping (Result<JSON,Error>) -> Void){
        ConnectionHandler.shared.getRequest(for: .getJobDetails, params: [:], showLoader: true)
            .responseJSON({ (json) in
                if json.isSuccess{
                    completionHandler(.success(json))
                }
                else {
                    completionHandler(.failure(GoferError.failure(json.status_message)))
                }
            })
            .responseFailure { (erro) in
                  print(erro)
              }

    }
    func getJobRequestApi(parms: [AnyHashable: Any],completionHandler : @escaping (Result<Bool,Error>) -> Void)
    {
        guard let params = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        
        self.connectionHandler.getRequest(for: APIEnums.getJobRequest, params: params,showLoader: true)
            .responseDecode(to: JobRequestModel.self) { (response) in
                self.jobRequest = response
                completionHandler(.success(true))
        }
        .responseFailure { (error) in
            print(error)
            completionHandler(.failure(GoferError.failure(error)))
        }
        
    }
    //Gofer splitup start
    //New_Delivery_splitup_Start
    //Laundry splitup Start
    //Instacart splitup Start
    //Deliveryall splitup start

    //Deliveryall_Newsplitup_start

    // Laundry_NewSplitup_start
    // Laundry_NewSplitup_end

    //Gofer splitup end
    //New_Delivery_splitup_End
    //Laundry splitup End
    //Instacart splitup End
    //Deliveryall splitup end
    
    func getCountryList(_ response : @escaping Closure<Result<CountryCodeModel,Error>>){
        
        ConnectionHandler.shared
            .getRequest(for: .countryCode,
                        params: [:],showLoader: true)
            .responseDecode(to: CountryCodeModel.self, { (result) in
                if result.status_code == "1"{
                    Shared.instance.removeLoaderInWindow()
                    response(.success(result))
                }else{
                    AppDelegate.shared.createToastMessage(result.status_message)
                    response(.failure(GoferError.failure("")))
                }
                
            }).responseFailure({ (error) in
                response(.failure(CommonError.failure(error)))
            })
    }
}
