//
//  AccountViewModel.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 02/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

typealias NumberValidationResponse = (otp : String?,verified : Bool,message : String?)

class AccountViewModel: BaseViewModel {
    override init() {
        super.init()
    }
    func LoginApicall(parms: [AnyHashable: Any],completionHandler : @escaping (Result<Bool,Error>) -> Void)
    {
        guard let params = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        
        guard AppUtilities().checkNetwork() else {return}
        ConnectionHandler.shared.getRequest(for: APIEnums.login, params: params, showLoader: false)
        
            .responseDecode(to: LoginModel.self) { (json) in
                if json.status_code == "1"{
                    completionHandler(.success(true))
                }else{
                    completionHandler(.failure(GoferError.failure(json.status_message)))
                }
            }
        
//                       .responseJSON({ (json) in
//                       let loginData = LoginModel(json)
//                       if json.isSuccess{
//                        completionHandler(.success(true))
//                       }else{
//                        completionHandler(.failure(GoferError.failure(loginData.status_message)))
//                       }
//                   })
        
            .responseFailure({ (error) in
                completionHandler(.failure(GoferError.failure(error)))
            })
        
    }
    func SocialInfoApiCall(parms: [AnyHashable: Any],completionHandler : @escaping (Result<String,Error>) -> Void){
        guard let parameters = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
       

        ConnectionHandler.shared.getRequest(for: APIEnums.register,params: parameters, showLoader: true)
        
            .responseDecode(to: LoginModel.self) { (json) in
                if json.status_code == "1"{
                    completionHandler(.success(json.status_message))
                }else{
                    completionHandler(.failure(GoferError.failure(json.status_message)))
                }
            }

//            .responseJSON({ (json) in
//            let user = LoginModel(json)
//            if json.isSuccess{
//                completionHandler(.success(user.status_message))
//
//            }else{
//                completionHandler(.failure(GoferError.failure(user.status_message)))
//            }
//
//
//        })
            .responseFailure({ (error) in
            completionHandler(.failure(GoferError.failure(error)))
        })
            
       
    }
    func resetPasswordApi(parms: [AnyHashable: Any],completionHandler : @escaping (Result<Bool,Error>) -> Void){
        guard let parameters = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        ConnectionHandler.shared.getRequest(for: APIEnums.forgotPassword, params: parameters, showLoader: true)
//                      .responseJSON({ (json) in
//                          let loginData = LoginModel(json)
//                          if json.isSuccess{
//                            completionHandler(.success(true))
//                          }else{
//                            completionHandler(.failure(GoferError.failure(loginData.status_message)))
//                          }
//                      })
        
            .responseDecode(to: LoginModel.self) { (json) in
                if json.status_code == "1"{
                    completionHandler(.success(true))
                }else{
                    completionHandler(.failure(GoferError.failure(json.status_message)))
                }
            }
        
            .responseFailure({ (error) in
                completionHandler(.failure(GoferError.failure(error)))
            })
        
    }
    //MARK:- ReferalVC
    func getReferal(_ result : @escaping Closure<(Result<(referal : String,
                    totalEarning : String,
                    maxReferal : String,
                    incomplete : [ReferalModel],
                    complete :[ReferalModel],
                    appLink: String),Error>)>){
        
         Shared.instance.showLoaderInWindow()
        self.connectionHandler
            .getRequest(for: .getReferals, params: [:], showLoader: true)
//            .responseJSON({ (json) in
//                Shared.instance.removeLoaderInWindow()
//                let referalCode = json.string("referral_code")
//                let refAppLink = json.string("referral_link")
//                let total_earning = json.string("total_earning")
//                let max_referal = json.string("referral_amount")
//                let inCompleteReferals = json.array("pending_referrals")
//                    .compactMap({ReferalModel.init(withJSON: $0)})
//                let completedReferals = json.array("completed_referrals")
//                    .compactMap({ReferalModel.init(withJSON: $0)})
//                result(.success((referal: referalCode,
//                                 totalEarning: total_earning,
//                                 maxReferal: max_referal,
//                                 incomplete: inCompleteReferals,
//                                 complete: completedReferals,
//                                 appLink: refAppLink)))
//            })
        
        
            .responseDecode(to: ReferalModelData.self) { (json) in
                Shared.instance.removeLoaderInWindow()
                let referalCode = json.referral_code
                let refAppLink = json.referral_link
                let total_earning = json.total_earning
                let max_referal = json.referral_amount
                let inCompleteReferals = json.pending_referrals
                let completedReferals = json.completed_referrals
                result(.success((referal: referalCode,
                                 totalEarning: total_earning,
                                 maxReferal: max_referal,
                                 incomplete: inCompleteReferals,
                                 complete: completedReferals,
                                 appLink: refAppLink)))
            }
        
            
            .responseFailure({ (error) in
                Shared.instance.removeLoaderInWindow()
                result(.failure(GoferError.failure(error)))
            })
    }
    
    func updatePasswordApi(params:JSON,
                           completionHandler: @escaping (Result<JSON,Error>) -> Void) {
      ConnectionHandler.shared
        .getRequest(for: APIEnums.updateNewPassword,
                    params: params,showLoader: true)
        .responseJSON( { (json) in
            completionHandler(.success(json))
        })
        .responseFailure({ (error) in
            completionHandler(.failure(GoferError.failure(error)))
      })
    }
    
    func wsToVerifyOTP(parms: JSON,completionHandler : @escaping (Result<Bool,Error>) -> Void) {
        
        ConnectionHandler.shared.getRequest(for: .otpVerification, params: parms, showLoader: true).responseJSON { (json) in
            if json.isSuccess {
                completionHandler(.success(json.bool("status")))
            } else {
                completionHandler(.success(json.bool("status")))
            }
        }.responseFailure ({ (error) in
            completionHandler(.failure(GoferError.failure(error)))
        })
    }
    
    
    
    func wsToVerifyNumberApiCall(parms: [AnyHashable: Any],completionHandler : @escaping (Result<NumberValidationResponse,Error>) -> Void){
       guard let parameters = parms as? JSON else{
                           AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
                           return
                       }

        ConnectionHandler.shared.getRequest(for: APIEnums.validateNumber, params: parameters, showLoader: false).responseJSON({ (json) in
         UberSupport.shared.removeProgressInWindow()
         if json.isSuccess{
             let isValid = json.isSuccess
             let otp = json.string("otp")
             let message = json.status_message
             UberSupport.shared.removeProgressInWindow()
             if isValid{
                let response = NumberValidationResponse(otp : otp,verified : isValid,message: message)

                completionHandler(.success(response))
             }else{
                completionHandler(.failure(GoferError.failure(message)))

             }

         }else{
            completionHandler(.failure(GoferError.failure(json.status_message)))
         }
     }).responseFailure({ (error) in
        completionHandler(.failure(GoferError.failure(error)))
     })
    }
    
    
    func wsToVerifyDeleteOTP(parms: JSON,completionHandler : @escaping (Result<JSON,Error>) -> Void) {
        
        ConnectionHandler.shared.getRequest(for: .deleteOtpVerification, params: parms, showLoader: true).responseJSON { (json) in
            if json.isSuccess {
                completionHandler(.success(json))
            } else {
                AppDelegate.shared.createToastMessage(json.string("status_message"))
                completionHandler(.success(json))
            }
        }.responseFailure ({ (error) in
            completionHandler(.failure(GoferError.failure(error)))
        })
    }
    
    
    func profileVCApiCall(parms: [AnyHashable: Any],completionHandler : @escaping (Result<ProfileModel,Error>) -> Void){
        guard let parameters = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        ConnectionHandler.shared.getRequest(
                         for: APIEnums.updateProviderProfile,
                         params: parameters, showLoader: true)
                    
                     
        
                     .responseDecode(to: ProfileModel.self) { (json) in
                     if json.status_code == "1" {
                         Shared.instance.removeLoaderInWindow()
                          completionHandler(.success(json))
                     } else {
                         AppDelegate.shared.createToastMessage(json.status_message)
                         completionHandler(.failure(GoferError.failure("")))
                     }
                   }
        
        
//                     .responseJSON({ (json) in
//                         UberSupport.shared.removeProgressInWindow()
//                         if json.isSuccess{
//                            let profile = ProfileModel(json: json)
//                            completionHandler(.success(profile))
//                         }else{
//                             AppDelegate.shared.createToastMessage(json.status_message)
//                            completionHandler(.failure(GoferError.failure(json.status_message)))
//                         }
//                     })
                     
                     .responseFailure({ (error) in
                        completionHandler(.failure(GoferError.failure(error)))
                     })
    }
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
