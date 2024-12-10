//
//  EarningsVM.swift
//  GoferHandyProvider
//
//  Created by trioangle on 08/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class EarningsVM: BaseViewModel {

    func wsToGetPendingJobs(needCache: Bool,pendingJobHistoryModel :GoferDataModel?, completionHandler : @escaping (Result<GoferDataModel,Error>) -> Void) {
        var parms = JSON()
        parms["currency_code"] = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
               if let pending = pendingJobHistoryModel{
                   parms["page"] = pending.currentPage + 1
               }else{
                   parms["page"] = 1
               }
        if needCache {
            parms["cache"] = 1
        }
        // Handy Splitup Start
        parms["business_id"] = AppWebConstants.currentBusinessType.rawValue
        // Handy Splitup End
        self.connectionHandler.getRequest(for: .getPendingJobs, params: parms, showLoader: false) .responseDecode(to: GoferDataModel.self, { (response) in
                          if let existingItems = pendingJobHistoryModel{
                            
                            if response.currentPage > 1 {
                                existingItems.updateWithNewData(response)
                                completionHandler(.success(existingItems))
                            }else if response.currentPage == 0 {
                                completionHandler(.success(existingItems))
                            }
                            else{
                                
                                existingItems.data.removeAll()
                                existingItems.updateWithNewData(response)
                                completionHandler(.success(existingItems))
                            }
                                 
                                }else{
                                    completionHandler(.success(response))
                                }
                     }).responseFailure { (error) in
            completionHandler(.failure(GoferError.failure(error)))
        }
    }
    func wsToGetCompletedJobs(needCache: Bool,
                              completedJobHistoryModel :GoferDataModel?,
                              completionHandler : @escaping (Result<GoferDataModel,Error>) -> Void) {
        var parms = JSON()
        parms["currency_code"] = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        if let completed = completedJobHistoryModel{
            parms["page"] = completed.currentPage + 1
        }else{
            parms["page"] = 1
        }
        if needCache {
            parms["cache"] = 1
        }
        // Handy Splitup Start
        parms["business_id"] = AppWebConstants.currentBusinessType.rawValue
        // Handy Splitup End
        self.connectionHandler.getRequest(for: .getCompletedJobs,
                                             params: parms,
                                             showLoader: false)
            .responseDecode(to: GoferDataModel.self, { (response) in
                if let existingItems = completedJobHistoryModel {
                    print("Array data: -> ",response.data)
                    if response.currentPage > 1 {
                        existingItems.updateWithNewData(response)
                        completionHandler(.success(existingItems))
                    } else if response.currentPage == 0 {
                        completionHandler(.success(existingItems))
                    } else {
                        existingItems.data.removeAll()
                        existingItems.updateWithNewData(response)
                        completionHandler(.success(existingItems))
                    }
                } else {
                    completionHandler(.success(response))
                }                     })
            .responseFailure { (error) in
            completionHandler(.failure(GoferError.failure(error)))
        }
    }
    func wsToGetWeeklyEarningDetails(_ json:JSON, completion: @escaping CompletionHandler<EarningsModel>) {
        self.connectionHandler.getRequest(for: .getEarningDetail, params: json, showLoader: true)
//            .responseJSON { (response) in
//            completion(.success(response))
//        }
            .responseDecode(to: EarningsModel.self) { (json) in
                completion(.success(json))
            }
        
            .responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    func wsToAcceptJobs(_ json:JSON, completion: @escaping CompletionHandler<JSON>) {
        self.connectionHandler.getRequest(for: .getCompletedJobs, params: json, showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
}
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
