//
//  DeilveryRouteVM.swift
//  GoferHandyProvider
//
//  Created by trioangle on 19/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
class DeliveryRouteVM: BaseViewModel {
    var jobDetailModel : DeliveryOrderDetail?
    func wsToGetDriverOrderReceivedDetails(params: JSON,
                              completionHandler : @escaping (Result<RequestRecieved,Error>) -> Void) {
        ConnectionHandler.shared
            .getRequest(
                for: .driver_received_order,
                   params: params, showLoader: true)
            .responseDecode(to: RequestRecieved.self) { result in
                completionHandler(.success(result))
            }.responseFailure { error in
                completionHandler(.failure((GoferError.failure(error))))
            }
    }
    func getJobApi(parms: [AnyHashable: Any],
                   completionHandler : @escaping (Result<OrderDetailHolder,Error>) -> Void) {
        guard let params = parms as? JSON else {
            AppDelegate.shared.createToastMessage(LangCommon.internalServerError)
            return
        }
        self.connectionHandler.getRequest(for: APIEnums.getJobDetails,
                                             params: params,
                                             showLoader: true)
            .responseDecode(to: OrderDetailHolder.self, { res in
                self.jobDetailModel = res.orderDetails
                completionHandler(.success(res))
            })
            .responseFailure { (error) in
                print(error)
                completionHandler(.failure(GoferError.failure(error)))
            }
    }
}
