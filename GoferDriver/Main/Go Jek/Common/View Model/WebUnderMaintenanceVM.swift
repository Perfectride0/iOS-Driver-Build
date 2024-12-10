//
//  WebUnderMaintenanceVM.swift
//  GoferHandy
//
//  Created by trioangle on 03/06/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
class WebUnderMaintenanceVM: BaseViewModel {
    func getStart(param:JSON,_ result : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler.getRequest(for: .force_update, params: param, showLoader: false).responseJSON({ (json) in
            if json.status_code != 0{
                result(.success(json))
            }
        }).responseFailure({ (error) in
            result(.failure(GoferError.failure(error)))
        })
    }
}
