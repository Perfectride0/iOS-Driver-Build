/**
* UberServiceRequest.swift
*
* @package Gofer
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import Alamofire

class UberServiceRequest: NSObject {
    //MARK: API REQUEST - GET METHOD
    private lazy var appDelegate : AppDelegate? = {
        return UIApplication.shared.delegate as? AppDelegate
    }()
    func getBlockServerResponseForparam(_ params: [AnyHashable: Any], method: NSString, withSuccessionBlock successBlock: @escaping (_ response: Any) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void)
    {
        let strURL = UberCreateUrl().serializeURL(params: params as NSDictionary, methodName: method) as String
        
        
       print(strURL)
       
        let params = Parameters()
        
        AF.request(strURL,
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: nil)
            .responseJSON { (response) in
                print("Å API: ",response.request?.url ?? "\(iApp.APIBaseUrl+method.description) : \(params)")
                guard response.response?.statusCode != 401 else{//Unauthorized
                    self.appDelegate?.logOutDidFinish()
                    return
                }
                switch response.result{
                case .success(let value):
                    if let json = value as? JSON{
                        successBlock(UberSeparateParam()
                            .separate(params:  json as NSDictionary,
                                      methodName: method))
                    }else{
                        failureBlock(APIErrors.JSON_InCompatable)
                    }
                case .failure(let error):
                    failureBlock(error)
                }
        }
    }
    
    
    
    
}

