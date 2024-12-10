//
//  CancelReasonModel.swift
//  GoferDriver
//
//  Created by Trioangle on 19/09/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
//class CancelReason {
//    let id: Int
//    let reason: String
//    let cancelled_by : String
//    let status : String
//    init(_ json:JSON){
//        self.id = json.int("id")
//        self.cancelled_by = json.string("cancelled_by")
//        self.reason = json.string("reason")
//        self.status = json.string("status")
//    }
//}


class CancelReasonModelData : Codable {
       let status_code: String
       let status_message : String
       let cancel_reasons : [CancelReason]

    enum CodingKeys: String, CodingKey {
        case status_message = "status_message"
        case status_code = "status_code"
        case cancel_reasons = "cancel_reasons"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        let cancelReason = try container.decodeIfPresent([CancelReason].self, forKey: .cancel_reasons)
        self.cancel_reasons = cancelReason ?? []
    }
}

class CancelReason : Codable {
       let id: Int
       let reason: String
       let cancelled_by : String
       let status : String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case reason = "reason"
        case cancelled_by, status
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.reason = container.safeDecodeValue(forKey: .reason)
        self.cancelled_by = container.safeDecodeValue(forKey: .cancelled_by)
        self.status = container.safeDecodeValue(forKey: .status)
    }
}


extension CancelReason : CustomStringConvertible{
    var description: String{
        return self.reason
    }
}
extension CancelReason : CustomDebugStringConvertible{
    var debugDescription: String{
        return "id : \(self.id), reason : \(self.reason)"
    }
}

class CancelReasonModel: BaseViewModel {
    override init() {
        super.init()
    }
    func getCancelReasons(parm: JSON,completionHandler: @escaping (Result<[CancelReason],Error>) -> Void) {
        ConnectionHandler.shared.getRequest(for: APIEnums.cancelReasons, params: parm, showLoader: true)
            .responseDecode(to: CancelReasonModelData.self) { (json) in
                let reasons = json.cancel_reasons

            if json.status_code == "1" {
                Shared.instance.removeLoaderInWindow()
                 completionHandler(.success(reasons))
            } else {
                completionHandler(.failure(GoferError.failure("")))
            }
          }
            
//            .responseJSON( { (json) in
//            let reasons = json.array("cancel_reasons").compactMap({CancelReason($0)})
//
//        if json.isSuccess {
//            Shared.instance.removeLoaderInWindow()
//          completionHandler(.success(reasons))
//        } else {
//            completionHandler(.failure(GoferError.failure("")))
//        }
//      })

            .responseFailure({ (error) in
          print(error)
      })
    }
}
