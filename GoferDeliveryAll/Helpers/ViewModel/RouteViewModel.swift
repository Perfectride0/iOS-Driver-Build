import Foundation
class RouteViewModel: BaseViewModel {
    func getTripDetails(param:JSON,_ result : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler.getRequest(for: .getDeliveryDetail, params: param, showLoader: true).responseJSON({ (json) in
            if json.isSuccess {
                result(.success(json))
            } else {
                result(.failure(GoferError.failure(json.status_message)))
            }
        }).responseFailure({ (error) in
            result(.failure(GoferError.failure(error)))
        })
    }
    
    func getDriverAcceptedOrders(param:JSON,_ result : @escaping Closure<Result<JSON,Error>>) {
        self.connectionHandler.getRequest(for: .driverAcceptedOrders, params: param, showLoader: true).responseJSON({ (json) in
            if json.isSuccess {
                result(.success(json))
            } else {
                result(.failure(GoferError.failure(json.status_message)))
            }
        }).responseFailure({ (error) in
            result(.failure(GoferError.failure(error)))
        })
    }
    func wsToAcceptRequest(params: JSON, completionHandler : @escaping (Result<OrderDetailHolder,Error>) -> Void) {
        ConnectionHandler.shared
            .getRequest(
                for: .ourService,
                   params: params, showLoader: true)
            .responseDecode(to: OrderDetailHolder.self) { result in
                completionHandler(.success(result))
            }.responseFailure { error in
                completionHandler(.failure((GoferError.failure(error))))
            }
    }

}
