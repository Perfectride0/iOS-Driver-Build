//
//  countryCodeVM.swift
//  Goferjek Driver
//
//  Created by trioangle on 24/01/23.
//  Copyright © 2023 Vignesh Palanivel. All rights reserved.
//

import Foundation
class countryCodeVM: BaseViewModel {
    func getStart(param:JSON,_ result : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler.getRequest(for: .countryCode, params: param, showLoader: false).responseJSON({ (json) in
            if json.status_code != 0{
                result(.success(json))
            }
        }).responseFailure({ (error) in
            result(.failure(GoferError.failure(error)))
        })
    }
    
//    func CountryCodeApiCall(parms: [AnyHashable: Any],completionHandler : @escaping (Result<CountryModel,Error>) -> Void){
//        guard let parameters = parms as? JSON else{
//            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
//            return
//        }
//        ConnectionHandler.shared.getRequest(
//                         for: APIEnums.countryCode,
//                         params: parameters, showLoader: true)
//
//
//
//                     .responseDecode(to: CountryModel.self) { (json) in
//                     if json.status_code == "1" {
//                         Shared.instance.removeLoaderInWindow()
//                          completionHandler(.success(json))
//                     } else {
//                         AppDelegate.shared.createToastMessage(json.status_message)
//                         completionHandler(.failure(GoferError.failure("")))
//                     }
//                   }
//
//
////                     .responseJSON({ (json) in
////                         UberSupport.shared.removeProgressInWindow()
////                         if json.isSuccess{
////                            let profile = ProfileModel(json: json)
////                            completionHandler(.success(profile))
////                         }else{
////                             AppDelegate.shared.createToastMessage(json.status_message)
////                            completionHandler(.failure(GoferError.failure(json.status_message)))
////                         }
////                     })
//
//                     .responseFailure({ (error) in
//                        completionHandler(.failure(GoferError.failure(error)))
//                     })
//    }
}
