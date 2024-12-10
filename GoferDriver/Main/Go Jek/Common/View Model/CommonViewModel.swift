//
//  CommonViewModel.swift
//  Goferjek Driver
//
//  Created by trioangle on 06/10/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit

class CommonViewModel: BaseViewModel {
    var jobDetailModel : JobDetailModel? = nil

    func getJobApi(parms: [AnyHashable: Any],
                   completionHandler : @escaping (Result<JobDetailModel,Error>) -> Void)
    {
        guard let params = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        self.connectionHandler.getRequest(for: APIEnums.getJobDetails, params: params,showLoader: true).responseDecode(to: JobDetailModel.self, { (response) in
            self.jobDetailModel = response
            completionHandler(.success(response))
        })

            .responseFailure { (error) in
                print(error)
                completionHandler(.failure(GoferError.failure(error)))
        }

    }
    func acceptJobApi(parms: [AnyHashable: Any],completionHandler : @escaping (Result<JobDetailModel,Error>) -> Void)
    {
        guard let params = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        self.connectionHandler.getRequest(for: APIEnums.acceptRequest, params: params,showLoader: true).responseDecode(to: JobDetailModel.self, { (response) in
            self.jobDetailModel = response
            completionHandler(.success(response))
        }).responseJSON({ (json) in
            if !json.isSuccess{
                AppDelegate.shared.createToastMessage(json.status_message)
            }
        })
            
            .responseFailure { (error) in
                print(error)
                completionHandler(.failure(GoferError.failure(error)))
        }
        
    }
    func ratingApi(parms: [AnyHashable: Any],completionHandler : @escaping (Result<JSON,Error>) -> Void)
    {
        guard let params = parms as? JSON else{
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        self.connectionHandler.getRequest(for: APIEnums.jobRating, params: params,showLoader: true)
            .responseJSON({ (json) in
                if json.isSuccess{
                    completionHandler(.success(json))
                }else{
                    completionHandler(.failure(GoferError.failure(json.status_message)))
                }
            })
            .responseFailure { (error) in
                print(error)
                completionHandler(.failure(GoferError.failure(error)))
        }
    }
    
    func getInvoiceDetails(param: JSON,completionHandler : @escaping (Result<JobDetailModel,Error>) -> Void) {
        self.connectionHandler.getRequest(for: .getInvoice, params: param,showLoader: true).responseDecode(to: JobDetailModel.self, { (response) in
            self.jobDetailModel = response
            completionHandler(.success(response))
        })
            .responseFailure { (error) in
                completionHandler(.failure(GoferError.failure(error)))
        }
    }
    
    func caseCollected(param: JSON,completionHandler : @escaping (Result<JSON,Error>) -> Void) {
        self.connectionHandler.getRequest(for: .cashCollected, params: param,showLoader: true).responseJSON({ (json) in
            if json.isSuccess{
                completionHandler(.success(json))
            }else{
                completionHandler(.failure(GoferError.failure(json.status_message)))
                
            }
        })
            .responseFailure { (error) in
                completionHandler(.failure(GoferError.failure(error)))
        }
    }
}
