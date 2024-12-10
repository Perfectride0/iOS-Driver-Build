//
//  AppWebConstants.swift
//  Handyman
//
//  Created by trioangle1 on 05/08/20.
//  Copyright © 2020 trioangle. All rights reserved.
//

import Foundation
import Alamofire

/**
 __Access Content of AppWebConstants by__
 __Eg:__ _AppWebConstants.instance.businessType_ (Used to get the current Buinesstype of the project)
 - note : __AppwebConstants__  Contains the Shared Variables for Project
 */
class AppWebConstants : NSObject {
    
    ///  Local initalisation of the __AppwebConstants__
    /// - note : Used to Access the __Shared Variables__  for this __Project__
    private override init(){super.init()}
    
    /// __instance__ is Instance Variable
    /// - note : Used to __Easy Access__ of the Inside __elements__ of Appwebconstants
    static let instance = AppWebConstants()
    
    /// __businessType__ is Shared Variable
    /// - note : Used to Update the __Current businessType__  of the __project__
    static let businessType : BusinessType = .Delivery
    
    /// __currentBusinessType__ is Shared Variable
    /// - note : Used to Update the __Current businessType__  of the __project__
    static var currentBusinessType : BusinessType = .Gojek
    
    /// __selectedBusinessType__ is Shared Variable
    /// - note : Used to Store the __Selected Business Type__ of the __driver__
    static var selectedBusinessType : [GojekService] = []
    
    /// __availableBusinessType__ is Shared Variable
    /// - note : Used to Store the __Available Business types__ From __Admin__
    /// - warning : _need To Handle the Single Application Based on this Varaible, also Empty_  __availableBusinessType__ _Need to
    /// handle in_ __Menu Page__
    static var availableBusinessType : [GojekService] = []
    
    /// __locationUpdateTimeIntervel__ is Shared Variable
    /// - note : Used to Update the __Current location__ of the driver for __live tracking__ functionality
    static var locationUpdateTimeIntervel : Double = 0.0
    
}

extension UIFont {
    open class func lightFont(size: CGFloat) -> UIFont {
        return UIFont(name: G_RegularFont,
                      size: size) ?? .systemFont(ofSize: 14,
                                                 weight: .light)
    }
    
    open class func MediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: G_MediumFont,
                      size: size) ?? .systemFont(ofSize: 14,
                                                 weight: .medium)
    }
    
    open class func BoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: G_BoldFont,
                      size: size) ?? .systemFont(ofSize: 14,
                                                 weight: .bold)
    }
}


//MARK: - HTTP methods
enum HTTPMethods:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//MARK: - Header Constants
enum HTTPHeaderField:String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case MutipartType = "image/png"
}


//MARK: - Content Type Constants
enum ContentType:String {
    case json = "application/json"
}


//MARK: - API Configurations
protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

//MARK: Identifier constants
struct ReusableIdentifier {
    struct ReuseID {
        static let ServicesCell = "DropDownTableCell"
        static let ServicesDetailCell = "ServicesTableViewCell"
        static let GalleryCollectionCell = "GalleryCollectionViewCell"
        static let ServiceItemTVC = "ServiceItemTVC"
        static let PaymentTVC = "PaymentTVC"
        static let PaymentTitleTVC = "PaymentTitleTVC"
        static let PaymentTotalTVC = "PaymentTotalTVC"
    }
    struct XIBName {
        static let ServicesXIB = "DropDownTableCell"
        static let ServicesDetailXIB = "ServicesTableViewCell"
        static let ServiceItemTVC = "ServiceItemTVC"
        static let PaymentTVC = "PaymentTVC"
        static let PaymentTitleTVC = "PaymentTitleTVC"
        static let PaymentTotalTVC = "PaymentTotalTVC"
        static let HandyLocationTypePopupView = "HandyLocationTypePopupView"
        static let DeletePHIXIB = "DeletePHIAlertview"
        static let CustomGalleryTypeView = "CustomGalleryTypeView"
    }
}
