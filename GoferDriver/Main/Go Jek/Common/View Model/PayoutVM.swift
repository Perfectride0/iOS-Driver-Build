//
//  AddPayoutVM.swift
//  GoferHandyProvider
//
//  Created by trioangle on 03/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
import Alamofire

typealias Closure<T> = (T)->()

enum PayoutFetchOption{
       case fetch
       case setDefault(id : Int)
       case delete(id : Int)
   }

class PayoutVM: BaseViewModel {
    override init() {
        super.init()
    }
   
    
   
    //MARK: ListPayout VC
    func getPayoutList(params:JSON, _ completion:@escaping ([PayoutItemModel])->()) {
        
        self.connectionHandler.getRequest(for: .getPayoutList, params: params, showLoader: true).responseJSON { (response) in
            print(response)
            let model = response.setModelArray("payout_methods", type: PayoutItemModel.self)
            completion(model)
            
        }.responseFailure { (error) in
            print(error)
            completion([PayoutItemModel]())
        }
    }
    
    
    
    
    //MARK: ADDPAYOUT VC
    func getCountryNameList(_ completion:@escaping ([CountryList])->()) {
        var params = Parameters()
        params["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        self.connectionHandler.getRequest(for: .stripeCountries, params: params, showLoader: true).responseJSON { (response) in
            print(response)
            let model = response.setModel(type: CountryResponse.self)
            completion(model.countryList)
            
        }.responseFailure { (error) in
            print(error)
            completion([CountryList]())
        }
        
        
        
    }
    
    func getAllcountryNameList(_ completion:@escaping ([CountryList])->()){
        var params = Parameters()
        params["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        self.connectionHandler.getRequest(for: .allCountries, params: params, showLoader: true).responseJSON { (response) in
            print(response)
            let model = response.setModel(type: CountryResponse.self)
            completion(model.countryList)
            
        }.responseFailure { (error) in
            print(error)
            completion([CountryList]())
        }
        
    }
    
    func updatePayoutDetails(requestParams: [String:Any], legalData:Data, legalImageName:String,additionalData:Data, additionalImageName:String,_ completion:@escaping CompletionHandler<JSON> ) {
        self.connectionHandler.uploadRequest2(for: .updatePayoutData, params: requestParams, legalData: legalData, legalImageName: legalImageName,additionalData: additionalData,additionalImageName: additionalImageName).responseJSON { (response) in
            completion(.success(response))

        }.responseFailure { (error) in
             //UberSupport.shared.removeProgressInWindow()
            completion(.failure(GoferError.failure(error)))
        }


        }
    

    
    func addBankDetails(_ param:JSON,_ completion:@escaping CompletionHandler<JSON>) {
        var parameters = param
        parameters["token"] = UserDefaults.prefernce.string(forKey: USER_ACCESS_TOKEN)
       parameters["user_type"] = "driver"
        self.connectionHandler.getRequest(for: .updatePayoutData, params: parameters, showLoader: true).responseJSON { (response) in
            
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
//    MARK: Change Payment VC
    func getPaymentOptions(_ param:JSON,_ completion:@escaping CompletionHandler<JSON>) {
        self.connectionHandler.getRequest(for: .getPaymentOptions, params: param, showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
//    MARK: Add Stripe Card VC
    func addStripeCard(_ param:JSON,_ completion:@escaping CompletionHandler<JSON>) {
        self.connectionHandler.getRequest(for: .addStripeCard, params: param, showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
    func getStripeCard(_ completion:@escaping CompletionHandler<JSON>) {
        self.connectionHandler.getRequest(for: .getStripeCard, params: JSON(), showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
    // MARK: Make Payment VC
    
    func caseCollected(_ param:JSON,_ completion:@escaping CompletionHandler<JSON>) {
        self.connectionHandler.getRequest(for: .cashCollected, params: param, showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
    func getInvoiceDetails(_ param:JSON,_ completion:@escaping CompletionHandler<JSON>) {
        self.connectionHandler.getRequest(for: .getInvoice, params: param, showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
    
    // MARK: PaymentEmailVC
    
    func addPayoutDetails(_ json:JSON,_ completion:@escaping CompletionHandler<JSON>) {
        self.connectionHandler.getRequest(for: .addUpdatePayout, params: json, showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
    // MARK: PayStatement VC
    
    func getWeeklyTripDetails(_ json:JSON,_ completionHandler:@escaping (Result<WeeklyJobModel,Error>) -> Void) {
        self.connectionHandler.getRequest(for: .jobWeekDetails, params: json, showLoader: false)
            .responseDecode(to: WeeklyJobModel.self) { (response) in
                completionHandler(.success(response))
        }.responseFailure { (error) in
            completionHandler(.failure(GoferError.failure(error)))
        }
    }
    
    //MARK: PayToGoferVC
    func currencyConversation(_ json:JSON,_ completion:@escaping CompletionHandler<JSON>) {
        self.connectionHandler.getRequest(for: .currencyConversion, params: json, showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
    func payToAdmin(_ json:JSON,_ completion:@escaping CompletionHandler<JSON>) {
        self.connectionHandler.getRequest(for: .payToAdmin, params: json, showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    
    func getProviderProfile(_ completion:@escaping CompletionHandler<JSON>) {
        
        var param = JSON()
        let userCurrencyCode = Constants().GETVALUE(keyname: USER_CURRENCY_ORG_splash)
        let userCurrencySym = Constants().GETVALUE(keyname: USER_CURRENCY_SYMBOL_ORG_splash)
        param["currency_code"] = userCurrencyCode
        param["currency_symbol"] = userCurrencySym
        self.connectionHandler.getRequest(for: .getProviderProfile, params: param, showLoader: true).responseJSON { (response) in
            completion(.success(response))
        }.responseFailure { (error) in
            completion(.failure(GoferError.failure(error)))
        }
    }
    

}
