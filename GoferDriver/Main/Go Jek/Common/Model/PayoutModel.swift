//
//  PayoutModel.swift
//  GoferDriver
//
//  Created by Trioangle Technologies on 24/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Alamofire

enum PayoutEditOption : String{
    case setAsDefault = "default"
    case delete = "delete"
}
class PaymentInteractor{
    private init(){}
    static let instance = PaymentInteractor()
    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
    let uberSupport = UberSupport()
    
    func getPayoutList(response : @escaping ([PayoutDetail])->()){
        var params = Parameters()
        params["token"]   = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        uberSupport.showProgressInWindow(showAnimation: true)
        AF.request("\(APIUrl)\(APIEnums.getPayoutDetails.rawValue)",
            method: .get,
            parameters: params)
              .validate()
              .responseJSON { responseJSON in
                self.uberSupport.removeProgressInWindow()
                  switch responseJSON.result {
                  case .success(let value):
                     if let data = value as? Data{
                      do{
                          let payoutlistResponse = try JSONDecoder().decode(PayoutListResponse.self,from: data)
//                          let json = value as! JSON
//                          print(json)
                          if payoutlistResponse.statusCode == "1"{
                              response(payoutlistResponse.payoutDetails )
                          }else{
                              response(payoutlistResponse.payoutDetails )
                              self.appDelegate.createToastMessage(payoutlistResponse.successMessage , bgColor: .black, textColor: .white)
                              if ["token_invalid","user_not_found","Authentication Failed"].contains(payoutlistResponse.successMessage){
                                  self.appDelegate.logOutDidFinish()
                              }
                          }
                      }catch {
                          print(error)
                        self.appDelegate.createToastMessage(LangCommon.serverIssueError, bgColor: .black, textColor: .white)
                          response([PayoutDetail]())
                          
                      }
                    }
                  case .failure(let error):
                      print(error)
                      self.appDelegate.createToastMessage(LangCommon.serverIssueError, bgColor: .black, textColor: .white)
                      response([PayoutDetail]())
                  }
          }
        
    }
    func getCountry(response : @escaping ([CountryList])->()){
        var params = Parameters()
        params["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        uberSupport.showProgressInWindow(showAnimation: true)
        
        
        AF.request("\(APIUrl)country_list",
            method: .get,
            parameters: params)
            .validate()
            .responseJSON {(jsonResponse) in
                self.uberSupport.removeProgressInWindow()
                switch jsonResponse.result{
                case .success( _):
                    if let data = jsonResponse.data,
                        let countryResponse = try? JSONDecoder().decode(CountryResponse.self,
                                                                        from: data){
                
                        if countryResponse.statusCode == "1"{
                            response(countryResponse.countryList)
                        }else{
                            response(countryResponse.countryList)
                            self.appDelegate.createToastMessage(countryResponse.successMessage, bgColor: .black, textColor: .white)
                            if ["token_invalid","user_not_found","Authentication Failed"].contains(countryResponse.successMessage){
                                self.appDelegate.logOutDidFinish()
                            }
                        }
                    }else{
                        self.appDelegate.createToastMessage( LangCommon.serverIssueError, bgColor: .black, textColor: .white)
                        response([CountryList]())
                    }
                case .failure( _):
                    self.appDelegate.createToastMessage( LangCommon.serverIssueError, bgColor: .black, textColor: .white)
                    response([CountryList]())
                }
                
        }
    }
    
    func getStripeCountry(response : @escaping ([CountryList])->()){
        var params = Parameters()
        params["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        uberSupport.showProgressInWindow(showAnimation: true)
        
        AF.request("\(APIUrl)\(APIEnums.stripeCountries.rawValue)",
            method: .get,
            parameters: params)
            .validate()
            .responseJSON {(jsonResponse) in
                self.uberSupport.removeProgressInWindow()
                print(jsonResponse.request?.url ?? "")
                switch jsonResponse.result{
                case .success( _):
                    if let data = jsonResponse.data,
                        let countryResponse = try? JSONDecoder().decode(CountryResponse.self,
                                                                        from: data){
                        if countryResponse.statusCode == "1"{
                            response(countryResponse.countryList)
                        }else{
                            response(countryResponse.countryList)
                            self.appDelegate.createToastMessage(countryResponse.successMessage, bgColor: .black, textColor: .white)
                            if ["token_invalid","user_not_found","Authentication Failed"].contains(countryResponse.successMessage){
                                self.appDelegate.logOutDidFinish()
                            }
                        }
                    }else{
                        self.appDelegate.createToastMessage(LangCommon.serverIssueError, bgColor: .black, textColor: .white)
                        response([CountryList]())
                    }
                case .failure(let error):
                    self.appDelegate.createToastMessage(error.localizedDescription , bgColor: .black, textColor: .white)
                    response([CountryList]())
                }
          
        }
    }
    
    func addPayout(withDetails params: Parameters ,imageName : String = String(),data : Data = Data(),result : @escaping (Bool)->()){
        
        print(params)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if data != Data(){
                multipartFormData.append(data, withName: "document", fileName: imageName, mimeType: "image/png")
            }
        }, to: "\(APIUrl)\("update_payout_preference")").response { results in
            switch results.result{
                           
                       case .success(let anyData):
                               print("Succesfully uploaded")
                               if let err = results.error{
                                   result(false)
                                   self.appDelegate.createToastMessage(err.localizedDescription, bgColor: .black, textColor: .white)
                                   return
                               }
                               if let data = anyData,
                                let json = JSON(data){
                                   if json.status_code == 1{
                                       result(true)
                                   }else{
                                       self.appDelegate.createToastMessage(json.status_message,
                                                                           bgColor: .black,
                                                                           textColor: .white)
                                       result(false)
                                   }
                               }
                       case .failure(let error):
                           print("Error in upload: \(error.localizedDescription)")
                           self.appDelegate.createToastMessage(error.localizedDescription, bgColor: .black, textColor: .white)
                           result(false)
                       }
        }
       
    }
    
    func editPayout(withId id : Int,option : PayoutEditOption,response : @escaping (Bool)->()){
        var params = Parameters()
        params["token"] = Constants().GETVALUE(keyname: USER_ACCESS_TOKEN)
        params["type"] = option.rawValue
        params["payout_id"] = id
        if option == .delete{
            params["type"] = "delete"
        }else {
            params["type"] = "default"
        }
        params["payout_id"] = id
        
        AF.request("\(APIUrl)\(APIEnums.updatePayoutChanges.rawValue)",
            method: .get,
            parameters: params)
            .validate()
            .responseJSON {
                (responseJSON) in
                switch responseJSON.result{
                case .success(let anyData):
                    guard let data = anyData as? Data,
                        let json = JSON(data) else{
                        response(false)
                        return
                    }
                    if json.status_code == 1{
                        response(true)
                    }else{
                        response(false)
                        self.appDelegate.createToastMessage(json.status_message, bgColor: .black, textColor: .white)
                    }
                case .failure( _):
                    response(false)
                }
                
        }
    }
}




// MARK: Countrylist model
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

 class CountryResponse: Codable {
    var successMessage = String()
    var statusCode = String()
    var countryList = [CountryList]()
    
    enum CodingKeys: String, CodingKey {
        case successMessage = "status_message"
        case statusCode = "status_code"
        case countryList = "country_list"
    }
    init(){}
    init(successMessage: String, statusCode: String, countryList: [CountryList]) {
        self.successMessage = successMessage
        self.statusCode = statusCode
        self.countryList = countryList
    }
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.successMessage = container.safeDecodeValue(forKey: .successMessage)
        self.statusCode = container.safeDecodeValue(forKey: .statusCode)
        self.countryList = container.safeDecodeValue(forKey: .countryList)
    }
}

class CountryList: Codable {
    var countryID = Int()
    var (countryName, countryCode) = (String(),String())
    var currencyCode : [String]? = [String]()
    
    enum CodingKeys: String, CodingKey {
        case countryID = "country_id"
        case countryName = "country_name"
        case countryCode = "country_code"
        case currencyCode = "currency_code"
    }
    
    init(countryID: Int, countryName: String, countryCode: String, currencyCode: [String]?) {
        self.countryID = countryID
        self.countryName = countryName
        self.countryCode = countryCode
        self.currencyCode = currencyCode
    }
}
extension CountryList : Equatable{
    static func == (lhs: CountryList, rhs: CountryList) -> Bool {
        return lhs.countryID == rhs.countryID
    }
    
    
}
//MARK: Payout list model
fileprivate class PayoutListResponse: Codable {
    var (successMessage, statusCode) = (String(),String())
    var payoutDetails = [PayoutDetail]()
    
    enum CodingKeys: String, CodingKey {
        case successMessage = "status_message"
        case statusCode = "status_code"
        case payoutDetails = "payout_details"
    }
    
    init(successMessage: String, statusCode: String, payoutDetails: [PayoutDetail]) {
        self.successMessage = successMessage
        self.statusCode = statusCode
        self.payoutDetails = payoutDetails
    }
}

class PayoutDetail: Codable {
    var payoutID = Int()
    var userID = Int()
    var payoutMethod = String()
    var paypalEmail = String()
    var setDefault = String()
    
    enum CodingKeys: String, CodingKey {
        case payoutID = "payout_id"
        case userID = "user_id"
        case payoutMethod = "payout_method"
        case paypalEmail = "paypal_email"
        case setDefault = "set_default"
    }
    
    init(payoutID: Int, userID: Int, payoutMethod: String, paypalEmail: String, setDefault: String) {
        self.payoutID = payoutID
        self.userID = userID
        self.payoutMethod = payoutMethod
        self.paypalEmail = paypalEmail
        self.setDefault = setDefault
    }
}
