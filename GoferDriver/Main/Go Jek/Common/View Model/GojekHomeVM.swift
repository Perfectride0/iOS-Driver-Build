//
//  gojekHomeVM.swift
//  GoferHandy
//
//  Created by Trioangle on 28/07/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

class GojekHomeVM: BaseViewModel {
    func wsToGetGojekServices(params: JSON,
                              completionHandler : @escaping (Result<GojeckServiceHome,Error>) -> Void) {
        ConnectionHandler.shared
            .getRequest(
                for: .ourService,
                   params: params, showLoader: true)
            .responseDecode(to: GojeckServiceHome.self) { result in
                completionHandler(.success(result))
            }.responseFailure { error in
                completionHandler(.failure((GoferError.failure(error))))
            }
    }
    
    func updateDriverService(param:JSON, completionHandler : @escaping (Result<GojeckServiceHome,Error>) -> Void) {
        Shared.instance.showLoaderInWindow()
        self.connectionHandler.getRequest(for: .updateDriverService,
                                             params: param, showLoader: true)
            
            .responseDecode(to: GojeckServiceHome.self) { result in
                Shared.instance.removeLoaderInWindow()
                completionHandler(.success(result))
            }
//            .responseJSON({ (json) in
//                if json.isSuccess {
//                    result(.success(json))
//                } else {
//                    result(.failure(GoferError.failure(json.status_message)))
//                }
//                Shared.instance.removeLoaderInWindow()
//            })
            .responseFailure({ (error) in
                Shared.instance.removeLoaderInWindow()
                completionHandler(.failure((GoferError.failure(error))))
            })
    }
}
