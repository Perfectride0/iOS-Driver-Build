//
//  feedBackModel.swift
//  GoferHandyProvider
//
//  Created by trioangle on 29/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import Foundation

class feedBackModel: BaseViewModel {

    var feedBack: userFeedbackModel? = nil
    
//    var currentPage : Int = 1
    func userFeedBackRequestApi(page: Int,params: JSON, completionHandler: @escaping (Result<userFeedbackModel,Error>) -> Void) {
        if page == 1 {
            self.feedBack?.userFeedback.removeAll()
            self.feedBack = nil
        }
        var param = params
        param["page"] = page
        self.connectionHandler.getRequest(for: APIEnums.userFeedBack,
                                             params: param,
                                             showLoader: false)
            .responseDecode(to: userFeedbackModel.self) { (response) in
                completionHandler(.success(response))
        }
        .responseFailure { (error) in
            print(error)
            completionHandler(.failure(GoferError.failure(error)))
        }
    }
    
}
