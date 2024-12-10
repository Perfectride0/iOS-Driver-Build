//
//  ConnectionHandler.swift
//  Sparkl
//
//  Created by Vivek-Dev15 on 01/11/18.
//  Copyright © 2018 Farshore. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import PaymentHelper

//MARK:- Closure
typealias ClosureSingle<T> = (T)->()
typealias CompletionHandler<T> = (Result<T, Error>)->()


final class ConnectionHandler : NSObject{
	static let shared = ConnectionHandler()
    private let alamofireManager : Session
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var preference = UserDefaults.standard
    let strDeviceType = "1"
    let strDeviceToken = Shared.instance.getDeviceToken()
    var support = UberSupport()
    let deliveryAllToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2dvZmVyZGVsaXZlcnlhbGwudHJpb2FuZ2xlZGVtby5jb20vYXBpL2xvZ2luIiwiaWF0IjoxNjI3NDY3Mzg1LCJleHAiOjE2MzAwOTUzODUsIm5iZiI6MTYyNzQ2NzM4NSwianRpIjoiVGc0bEhQaWg0Q2ZkRXRybyIsInN1YiI6MTAwNzIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.BITs5HkB-3_PnQNokk83AfiuTxMp0ghVPUfvuqeAILw"
    
  
    
    let deliveryToken = ""
    let goferToken = ""
    
//    lazy var uberLoader : UberSupport = {
//              return UberSupport()
//          }()

     override init() {
		print("Singleton initialized")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300 // seconds
        configuration.timeoutIntervalForResource = 500
        alamofireManager = Session.init(configuration: configuration, serverTrustManager: .none)//Alamofire.SessionManager(configuration: configuration)
	}
    func networkChecker(with StartTime:Date,
                        EndTime: Date,
                        ContentData: Data?) {
        
        let dataInByte = ContentData?.count
        
        if let dataInByte = dataInByte {
            
            // Standard Values
            let standardMinContentSize : Float = 3
            let standardKbps : Float = 2
            
            // Kb Conversion
            let dataInKb : Float = Float(dataInByte / 1000)
            
            // Time Interval Calculation
            let milSec  = EndTime.timeIntervalSince(StartTime)
            let duration = String(format: "%.01f", milSec)
            let dur: Float = Float(duration) ?? 0
            
            // Kbps Calculation
            let Kbps = dataInKb / dur
            
            if dataInKb > standardMinContentSize {
                if Kbps < standardKbps {
                    print("å:::: Low Network Kbps : \(Kbps)")
//                    self.appDelegate.createToastMessage("LOW NETWORK")
                } else {
                    print("å:::: Normal NetWork Kbps : \(Kbps)")
                }
            } else {
                print("å:::: Small Content : \(Kbps)")
            }
            
        }
    }
   
    
    func getRequest(for api : APIEnums,params : Parameters,showLoader: Bool)-> APIResponseProtocol{
           if api.method == .get{
            return self.getRequest(forAPI:APIUrl+api.rawValue,
                                   params: params,
                                   showLoader: showLoader,
                                   cacheAttribute: api.cacheAttribute ? api : .none)
           }else{
            return self.postRequest(forAPI: APIUrl+api.rawValue,
                                    params: params,
                                    showLoader: showLoader)
           }
       }
    
    func uploadRequest(for api : APIEnums,params : Parameters, data:Data, imageName:String = "image")-> APIResponseProtocol{
        let StartTime = Date()
        let responseHandler = APIResponseHandler()
        var parameters = params
        support.showProgressInWindow(showAnimation: true)
        
        parameters["token"] = preference.string(forKey: USER_ACCESS_TOKEN)
        parameters["user_type"] = Global_UserType
      //  parameters["device_id"] = strDeviceToken
        parameters["device_id"] = Constants().GETVALUE(keyname: USER_DEVICE_TOKEN)//strDeviceToken
        parameters["device_type"] = strDeviceType
        
        
        var newParams = Parameters()
        for key in params.keys {
            if !(params[key] as? String ?? "").isEmpty {
                newParams[key] = params[key]
            }
        }
        print(newParams)
        
        let upload = AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in newParams {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if data != Data(){
                multipartFormData.append(data, withName: imageName, fileName: "\(imageName).png", mimeType: "image/png")
            }
        }, to: "\(APIUrl)\(api.rawValue)")
        
        upload.uploadProgress { (progres) in
            print(progres)
        }
        upload.responseJSON { (response) in
            let EndTime = Date()
            self.networkChecker(with: StartTime, EndTime: EndTime, ContentData: response.data)
            
            switch response.result {
            case .success(let anyData):
                self.support.removeProgressInWindow()
                print("Succesfully uploaded")
                // print(response.request?.url)
                if let err = response.error{
                    
                    responseHandler.handleFailure(value: err.localizedDescription)
                    return
                }
                if let data = response.value ,
                   let json = data as? JSON {
                    if json.status_code == 1{
                        
                        responseHandler.handleSuccess(value: anyData, data: response.data ?? Data())
                    }else{
                        responseHandler.handleFailure(value: json.status_message)
                    }
                }
            case .failure(let error):
                self.support.removeProgressInWindow()
                print("Error in upload: \(error.localizedDescription)")
                if error._code == 13 {
                    responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
        return responseHandler
    }
    
    
    private func postRequest(forAPI api: String, params: JSON,showLoader: Bool) -> APIResponseProtocol {
        if showLoader{
            Shared.instance.showLoaderInWindow()
        }
        let responseHandler = APIResponseHandler()
        let StartTime = Date()
        var parameters = params
        parameters["token"] = preference.string(forKey: USER_ACCESS_TOKEN)
        parameters["user_type"] = Global_UserType
        parameters["device_id"] = strDeviceToken
        parameters["device_type"] = strDeviceType
        alamofireManager.request(api,
                                 method: .post,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: nil)
            .responseJSON { (response) in
                print("Å api : ",response.request?.url ?? ("\(api)\(parameters)"))
                
                let EndTime = Date()
                self.networkChecker(with: StartTime, EndTime: EndTime, ContentData: response.data)
                
                guard response.response?.statusCode != 401 else{//Unauthorized
                    if response.request?.url?.description.contains(APIUrl) ?? false{
                        AppDelegate.shared.logOutDidFinish()
                    }
                    if showLoader{
                        Shared.instance.removeLoaderInWindow()
                    }
                    return
                }
                
                guard response.response?.statusCode != 503 else{//Unauthorized
                    if response.request?.url?.description.contains(APIUrl) ?? false{
                        DispatchQueue.main.async {
                            self.appDelegate.webServiceUnderMaintenance()
                        }
                    }
                    return
                }
                
                switch response.result{
                case .success(let value):
                    let json = value as! JSON
                    let error = json.string("error")
                    guard error.isEmpty else{
                        if error == "user_not_found"
                            && response.request?.url?.description.contains(APIUrl) ?? false{
                            AppDelegate.shared.logOutDidFinish()
                        }
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        return
                    }
                    
                    if json.isSuccess
                        || !api.contains(APIUrl)
                        || response.response?.statusCode == 200{
                        if json.status_code == 1 || json.status_code == 2{
                            if showLoader{
                                Shared.instance.removeLoaderInWindow()
                            }
                            responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                        }
                        else{
                            if showLoader{
                                Shared.instance.removeLoaderInWindow()
                            }
                            responseHandler.handleFailure(value: json.status_message)
                        }
                    }else{
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleFailure(value: json.status_message)
                    }
                case .failure(let error):
                    if showLoader{
                        Shared.instance.removeLoaderInWindow()
                    }
                    if error._code == 13 {
                        responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                    } else {
                        responseHandler.handleFailure(value: error.localizedDescription)
                    }
                    
                }
            }
        
        
        return responseHandler
    }
        

    
    func getRequest(forAPI api: String, params: JSON,showLoader: Bool,cacheAttribute: APIEnums) -> APIResponseProtocol {
        if showLoader {
            Shared.instance.showLoaderInWindow()
        }
        
        let handler = LocalCacheHandler()
        let responseHandler = APIResponseHandler()
        let StartTime  = Date()
        
        
        /// Common Param For All Get Request API
        var parameters = params
        parameters["token"] = preference.string(forKey: USER_ACCESS_TOKEN)
        parameters["user_type"] = Global_UserType
        parameters["device_id"] = Constants().GETVALUE(keyname: USER_DEVICE_TOKEN)//strDeviceToken
  //      parameters["device_id"] = strDeviceToken
        parameters["device_type"] = strDeviceType
        if parameters["language"] == nil,
           let language : String =  UserDefaults.value(for: .default_language_option){
            parameters["language"] = language
        }
        
        
        if cacheAttribute != .none {
            if  cacheAttribute == .getGalleryImages,
                let page = params["page"] as? Int,
                page == 1 {
                handler.getData(key: cacheAttribute.rawValue) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if cacheAttribute == .userFeedBack ||
                        cacheAttribute == .jobWeekDetails,
                      let page = params["page"] as? Int,
                      let businessID = params["business_id"] as? Int,
                      page == 1 {
                let key = cacheAttribute.rawValue + businessID.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if (cacheAttribute == .getPendingJobs ||
                       cacheAttribute == .getCompletedJobs),
                      let page = params["page"] as? Int,
                      let cache = params["cache"] as? Int,
                      let businessID = params["business_id"] as? Int,
                      (page == 1 && cache == 1) {
                let key = cacheAttribute.rawValue + businessID.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if cacheAttribute == .weeklyEarnings,
                      let startDate = params["date"] as? String,
                      let businessID = params["business_id"] as? Int {
                let key = cacheAttribute.rawValue + startDate + "weekly" + businessID.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if cacheAttribute == .dailyEarnings,
                      let startDate = params["date"] as? String,
                      let businessID = params["business_id"] as? Int ,
                      let page = params["page"] as? Int ,
                      page == 1  {
                let key = cacheAttribute.rawValue + startDate + "daily" + businessID.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0 {
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if cacheAttribute == .getServices,
                      let cache = params["cache"] as? Int,
                      let serviceType = params["type"] as? String ,
                      cache == 1 {
                let key = cacheAttribute.rawValue + (serviceType)
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if cacheAttribute == .getServiceCategory,
                      let serviceID = params["service_id"] as? Int,
                      let page = params["page"] as? Int,
                      page == 1 {
                let key = cacheAttribute.rawValue + serviceID.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader {
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if cacheAttribute == .getCategoryItems,
                      let categoryID = params["category_id"] as? Int,
                      let page = params["page"] as? Int,
                      page == 1 {
                let key = cacheAttribute.rawValue + categoryID.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader {
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if cacheAttribute == .getJobDetails,
                      let jobID = params["job_id"] as? Int,
                      let cache = params["cache"] as? Int,
                      let business_id = params["business_id"] as? Int,
                      jobID != 0 &&
                        cache == 1 {
                let key = cacheAttribute.rawValue + jobID.description + business_id.description
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader {
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if cacheAttribute == .providerAvailabilityList,
                      let cache = params["cache"] as? Int,
                      cache == 1 {
                let key = cacheAttribute.rawValue
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader {
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else if cacheAttribute == .getParticlarOrderDetail,
                      let orderID = params["order_id"] as? String{
                let key = cacheAttribute.rawValue + "order" + orderID
                handler.getData(key: key) { (result) in
                    if result.compactMap({$0}).count > 0{
                        if showLoader {
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
                                                      data: (result.first!)?.model ?? Data() )
                    }
                }
            } else {
//                handler.getData(key: cacheAttribute.rawValue) { (result) in
//                    if result.compactMap({$0}).count > 0{
//                        if showLoader{
//                            Shared.instance.removeLoaderInWindow()
//                        }
//                        responseHandler.handleSuccess(value: (result.first!)?.json ?? JSON(),
//                                                      data: (result.first!)?.model ?? Data() )
//                    }
//                }
            }
        }
        
        
        alamofireManager.request(api,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: nil)
            .responseJSON { (response) in
                print("Å api : ",response.request?.url ?? ("\(api)\(parameters)"))

                let EndTime = Date()
                self.networkChecker(with: StartTime, EndTime: EndTime, ContentData: response.data)
                
                guard response.response?.statusCode != 401 else{//Unauthorized
                    if response.request?.url?.description.contains(APIUrl) ?? false{
                        AppDelegate.shared.logOutDidFinish()
                    }
                    if showLoader{
                        Shared.instance.removeLoaderInWindow()
                    }
                    return
                }
                
                guard response.response?.statusCode != 503 else{//Unauthorized
                    if response.request?.url?.description.contains(APIUrl) ?? false{
                        DispatchQueue.main.async {
                            self.appDelegate.webServiceUnderMaintenance()
                        }
                    }
                    return
                }
                
                
                switch response.result{
                case .success(let value):

                    let json = value as! JSON
                    if cacheAttribute != .none {
                        if cacheAttribute == .getCompletedJobs ||
                            cacheAttribute == .getPendingJobs ||
                            cacheAttribute == .userFeedBack ||
                            cacheAttribute == .jobWeekDetails ,
                           let businessID = params["business_id"] as? Int,
                           let page = params["page"] as? Int,
                           page == 1 {
                            let key = cacheAttribute.rawValue + businessID.description
                            handler.store(data: response.data ?? Data() ,
                                          apiName: key,
                                          json: json)
                        } else if cacheAttribute == .getGalleryImages,
                                  let page = params["page"] as? Int,
                                  page == 1 {
                            let key = cacheAttribute.rawValue
                            handler.store(data: response.data ?? Data() ,
                                          apiName: key,
                                          json: json)
                        } else if cacheAttribute == .weeklyEarnings,
                                  let startDate = params["date"] as? String,
                                  let businessID = params["business_id"] as? Int {
                            let key = cacheAttribute.rawValue + startDate + "weekly" + businessID.description
                            handler.store(data: response.data ?? Data() ,
                                          apiName: key,
                                          json: json)
                        } else if cacheAttribute == .dailyEarnings,
                                  let startDate = params["date"] as? String,
                                  let page = params["page"] as? Int,
                                  let businessID = params["business_id"] as? Int,
                                  page == 1 {
                            let key = cacheAttribute.rawValue + startDate + "daily" + businessID.description
                            handler.store(data: response.data ?? Data() ,
                                          apiName: key,
                                          json: json)
                        } else if cacheAttribute == .getServices,
                                  let serviceType = params["type"] as? String{
                            let key = cacheAttribute.rawValue + serviceType
                            handler.store(data: response.data ?? Data() ,
                                          apiName: key,
                                          json: json)
                        } else if cacheAttribute == .getServiceCategory,
                                  let serviceID = params["service_id"] as? Int,
                                  let page = params["page"] as? Int,
                                  page == 1 {
                            let key = cacheAttribute.rawValue + serviceID.description
                            handler.store(data: response.data ?? Data() ,
                                          apiName: key,
                                          json: json)
                        } else if cacheAttribute == .getCategoryItems,
                                  let categoryID = params["category_id"] as? Int,
                                  let page = params["page"] as? Int,
                                  page == 1 {
                            let key = cacheAttribute.rawValue + categoryID.description
                            handler.store(data: response.data ?? Data() ,
                                          apiName: key,
                                          json: json)
                        } else if cacheAttribute == .getJobDetails,
                                  let jobID = params["job_id"] as? Int,
                                  let cache = params["cache"] as? Int ,
                                  let business_id = params["business_id"] as? Int,
                                  jobID != 0 &&
                                    cache == 1 {
                            let key = cacheAttribute.rawValue + jobID.description + business_id.description
                            handler.store(data: response.data ?? Data() ,apiName: key, json: json)
                        }else if cacheAttribute == .providerAvailabilityList,
                                 let cache = params["cache"] as? Int,
                                 cache == 1 {
                           let key = cacheAttribute.rawValue
                            handler.store(data: response.data ?? Data() ,apiName: key, json: json)
                        } else if cacheAttribute == .getParticlarOrderDetail ,
                                  let orderID = params["order_id"] as? String {
                            let key = cacheAttribute.rawValue + "order" + orderID.description
                             handler.store(data: response.data ?? Data() ,apiName: key, json: json)
                        } else {
//                            handler.store(data: response.data ?? Data() ,
//                                          apiName: cacheAttribute.rawValue,
//                                          json: json)
                        }
                    }
                    
                    let error = json.string("error")
                    guard error.isEmpty else{
                        if error == "user_not_found"
                            && response.request?.url?.description.contains(APIUrl) ?? false{
                            AppDelegate.shared.logOutDidFinish()
                        }
                        if showLoader{
                        Shared.instance.removeLoaderInWindow()
                        }
                        return
                    }

                    if json.isSuccess
                        || !api.contains(APIUrl)
                        || response.response?.statusCode == 200{
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                    }else{
                        if showLoader{
                            Shared.instance.removeLoaderInWindow()
                        }
                        responseHandler.handleFailure(value: json.status_message)
                    }
                case .failure(let error):
                    if showLoader{
                        Shared.instance.removeLoaderInWindow()
                        }
                    if error._code == 13 {
                        responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                    } else {
                        responseHandler.handleFailure(value: error.localizedDescription)
                    }
                    
                }
        }
        
        
        return responseHandler
    }
    
    func uploadRequest2(for api : APIEnums,
                        params : Parameters,
                        legalData:Data,
                        legalImageName:String = "image",
                        additionalData:Data,
                        additionalImageName:String = "additional_image")-> APIResponseProtocol{
        let StartTime = Date()
        let responseHandler = APIResponseHandler()
        var parameters = params
        support.showProgressInWindow(showAnimation: true)
        parameters["token"] = preference.string(forKey: USER_ACCESS_TOKEN)
        parameters["user_type"] = Global_UserType
      //  parameters["device_id"] = strDeviceToken
        parameters["device_id"] = Constants().GETVALUE(keyname: USER_DEVICE_TOKEN)//strDeviceToken
        parameters["device_type"] = strDeviceType
        
        var newParams = Parameters()
        for key in params.keys {
            if !(params[key] as? String ?? "").isEmpty {
                newParams[key] = params[key]
            }
        }
        print(newParams)
        
        let upload = AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in newParams {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if legalData != Data(){
                multipartFormData.append(legalData, withName: legalImageName, fileName: "\(legalImageName).png", mimeType: "image/png")
            }
            if additionalData != Data(){
                multipartFormData.append(additionalData, withName: additionalImageName, fileName: "\(additionalImageName).png", mimeType: "image/png")
            }
        }, to: "\(APIUrl)\(api.rawValue)")
        
        upload.uploadProgress { (progres) in
            print(progres)
        }
        upload.responseJSON { (response) in
            let EndTime = Date()
            self.networkChecker(with: StartTime, EndTime: EndTime, ContentData: response.data)
            
            switch response.result {
            case .success(let anyData):
                self.support.removeProgressInWindow()
                print("Succesfully uploaded")
                print(response.request?.url)
                if let err = response.error{
                    
                    responseHandler.handleFailure(value: err.localizedDescription)
                    return
                }
                if let data = response.value ,
                   let json = data as? JSON {
                    if json.status_code == 1{
                        
                        responseHandler.handleSuccess(value: anyData, data: response.data ?? Data())
                    }else{
                        responseHandler.handleFailure(value: json.status_message)
                    }
                }
            case .failure(let error):
                self.support.removeProgressInWindow()
                print("Error in upload: \(error.localizedDescription)")
                if error._code == 13 {
                    responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
        return responseHandler
    }
    func uploadPost(wsMethod:String, paramDict: [String:Any], fileName:String="image", imgsData:[Data]?, viewController:UIViewController, isToShowProgress:Bool, isToStopInteraction:Bool, complete:@escaping (_ response: [String:Any]) -> Void) {
        let StartTime = Date()
        if isToShowProgress {
            UberSupport().showProgressInWindow(showAnimation: true)
        }
        if isToStopInteraction {
          //  UIApplication.shared.beginIgnoringInteractionEvents()
            viewController.view.isUserInteractionEnabled = false
        }
        
        
        print(imgsData)
        print(fileName)
        
        
        AF.upload(multipartFormData: { (multipartFormData) in
            let fileName1 =  String(Date().timeIntervalSince1970 * 1000) + "\(fileName).jpg"
            if let data = imgsData {
                let count = data.count
                for i in 0..<count {
                    if wsMethod == "add_gallery_image" ||  wsMethod == "save_job_image" {
                        multipartFormData.append(data[i], withName: "\(fileName)[\(i)]", fileName: fileName1, mimeType: "image/jpeg")
                    }else{
                        multipartFormData.append(data[i], withName: "\(fileName)", fileName: fileName1, mimeType: "image/jpeg")
                    }
                }
            }
                
            
            
            for (key, value) in paramDict {
                multipartFormData.append(String(describing: value).data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
            }
            print(multipartFormData)
            //Optional for extra parameters
        },to:"\(APIUrl)\(wsMethod)").uploadProgress(closure: { (progres) in
            print(progres.fractionCompleted)
        }).response { resp in
            
            let EndTime = Date()
            self.networkChecker(with: StartTime, EndTime: EndTime, ContentData: resp.data)
            
        switch resp.result {
            case .success(let data):
                if isToShowProgress {
                    UberSupport().removeProgressInWindow()
//                    removeProgress(viewCtrl: viewController)
                }
                if isToStopInteraction {
//                    UIApplication.shared.endIgnoringInteractionEvents()
                    viewController.view.isUserInteractionEnabled = true
                }
                do {
                
                    if let responseDict = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers) as? [String:Any] {
                    guard responseDict["error"] == nil else {
                        self.appDelegate.createToastMessageForAlamofire(responseDict.string("error"), bgColor: .black, textColor: .white, forView: viewController.view)
                        return
                    }
                    
                    guard responseDict.count > 0 else {
                        self.appDelegate.createToastMessageForAlamofire("Image upload failed", bgColor: .black, textColor: .white, forView: viewController.view)
                        return
                    }
                    
                    if (responseDict["status_code"] as? String ?? "" ) == "0" && ((responseDict["success_message"] as? String ?? "") == "Inactive User" || (responseDict["success_message"] as? String ?? "") == "The token has been blacklisted" ||  responseDict["success_message"] as? String ?? "" == "User not found") {
                        //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "k_LogoutUser"), object: nil)
                        self.appDelegate.createToastMessageForAlamofire("We are having trouble fetching the menu. Please try again.", bgColor: .black, textColor: .white, forView: viewController.view)

                    }
                    else {
                        complete(responseDict)
                    }
                    }
                } catch(let error) {
                    print("Error")
                    print(error.localizedDescription)
                }

            case .failure(let encodingError):
                print(encodingError)
                if isToShowProgress {
                    UberSupport().removeProgressInWindow()
//                    removeProgress(viewCtrl: viewController)
                }
//                if encodingError._code == 4 {
//                    self.appDelegate.createToastMessageForAlamofire("We are having trouble fetching the menu. Please try again.", bgColor: .black, textColor: .white, forView: viewController.view)
//                } else if encodingError._code == 13 {
//                    self.appDelegate.createToastMessageForAlamofire("No internet connection.".localizedCapitalized, bgColor: .black, textColor: .white, forView: viewController.view)
//                } else {
//                    self.appDelegate.createToastMessageForAlamofire(encodingError.localizedDescription, bgColor: .black, textColor: .white, forView: viewController.view)
//                }
            }
        }
    }
}

extension ConnectionHandler{
    /**
     function that convet json to respective model of parsed API
     - Author: Abishek Robin
     - Parameters:
        - api: APIEnum
        - json: API json data
     - Returns: ResponseEnum
     */

      func handleEssenetials(json : JSON){
          
        // Firebase Token Storing
        
        let firebase_token = json.string("firebase_token")
        if !firebase_token.isEmpty {
            Constants().STOREVALUE(value: firebase_token, keyname: USER_FIREBASE_TOKEN)
        }
        
        
        
          //Google key
        _ = json.string("google_map_key")
  //        UserDefaults.set(googleKey, for: .google_api_key)
        let reqTime = json.int("request_second")
        if reqTime != 0{
            UserDefaults.set(reqTime, for: .requestTime)
        }
        Shared.instance.isWebPayment = json.bool("is_web_payment")

          //SINCH
          let sinchKey = json.string("sinch_key")
          let sinchSecret = json.string("sinch_secret_key")
          let stripeKey = json.string("stripe_key")
          UserDefaults.standard.set(stripeKey, forKey: USER_STRIPE_KEY)
          if !sinchKey.isEmpty{
              UserDefaults.set(sinchKey, for: .sinch_key)
              UserDefaults.set(sinchSecret, for: .sinch_secret_key)
          }
          let timeIntervel = json.int("update_loc_interval")
          AppWebConstants.locationUpdateTimeIntervel = Double(timeIntervel)
          
          //REferal
          //        let enableReferral = json.bool("enable_referral")
          //        Shared.instance.enableReferral(enableReferral)
          
          let applyExtraFare = json.bool("apply_job_extra_fee")
          Shared.instance.enableExtraFare(applyExtraFare)
         // Shared.instance.currencyConversionRate = json.double("current_rate")
          print(Shared.instance.currencyConversionRate )
          //HEATMAP
          let showHeatMap = json.bool("heat_map")
          Shared.instance.enableHeatMap(showHeatMap)
          
          //initializing sinch manager
          if !self.appDelegate.callKitMediator.isInitialized,     //(Manger is not initialized)
              !sinchKey.isEmpty,                      //(Key is available to call)
              let accessToken : String = UserDefaults.value(for: .access_token),
              !accessToken.isEmpty,                   //User is Still logged in
              let userID : String = UserDefaults.value(for: .user_id) {
              self.appDelegate.callKitMediator.create(withUserId: userID) {error in
                                                      if (error != nil) {
                                                       // os_log("SinchClient started with error: %{public}@",
                                                             //  log: self.customLog, type: .error, error!.localizedDescription)
                                      //                    self.notificationLabel.text = error?.localizedDescription

                                                      } else {
                                                      //  os_log("SinchClient started successfully: (version:%{public}@)",
                                                            //   log: self.customLog, SinchRTC.version())
                                                      }
                                                    }
//              do{
//                  try CallManager
//                      .instance
//                      .initialize(environment: CallManager.Environment.live,//Initialize call manger
//                          for: userID)
//              }catch let error{debug(print: error.localizedDescription)}
          }
          
          
        _ = json.string("gateway_type")
  //           PaymentOptions.setDefaultGateWay(as: defaultPaymentGateWay.first?.lowercased() == "b" ? .brainTree : .stripe)
             let paypalClient = json.string("paypal_client")
             let paypalMode = json.string("paypal_mode")
             if !paypalClient.isEmpty{
                 UserDefaults.set(paypalClient, for: .paypal_client_key)
                 UserDefaults.set(paypalMode, for: .paypal_mode)
  //               PayPalHandler.initPaypalModule()
             }
             let stripe = json.string("stripe_publish_key")
             if !stripe.isEmpty{
                 UserDefaults.set(stripe, for: .stripe_publish_key)
                 StripeHandler.initStripeModule(key: stripe)
             }
             let last4 = json.string("last4")
             let brand = json.string("brand")
             if !last4.isEmpty,!brand.isEmpty{
                 UserDefaults.set(last4, for: .card_last_4)
                 UserDefaults.set(brand, for: .card_brand_name)
              UserDefaults.standard.set(true, forKey: "CARD_DETAILS_GIVEN")
             }
      }

    
}
//MARK:- response handlers

class APIResponseHandler : APIResponseProtocol{
  
    init(){
    }
    var jsonSeq : Closure<JSON>?
    var dataSeq : Closure<Data>?
    var errorSeq : Closure<String>?
    
    func responseDecode<T>(to modal: T.Type, _ result: @escaping Closure<T>) -> APIResponseProtocol where T : Decodable {
        
        let decoder = JSONDecoder()
        self.dataSeq =  decoder.decode(modal, result: result)
        return self
    }
    
    func responseJSON(_ result: @escaping Closure<JSON>) -> APIResponseProtocol {
        self.jsonSeq = result
        return self
    }
    func responseFailure(_ error: @escaping Closure<String>) {
        self.errorSeq = error
        
      }
    func handleSuccess(value : Any,data : Data){
        if let jsonEscaping = self.jsonSeq{
            jsonEscaping(value as! JSON)
        }
        if let dataEscaping = dataSeq{
            dataEscaping(data)
            
        }
    }
    func handleFailure(value : String){
        self.errorSeq?(value)
     }
}


//MARK: extensions

extension JSONDecoder{
    func decode<T : Decodable>(_ model : T.Type,
                               result : @escaping Closure<T>) ->Closure<Data>{
        return { data in
            do{
                let value = try self.decode(model.self, from: data)
                result(value)
            }catch{
                print(error.localizedDescription)
            }
        }
        
    }
}

