//
//  Flag.swift
//  Gofer
//
//  Created by Trioangle Technologies on 19/01/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit

class CountryModel{
    var country_code : String
    var dial_code : String
    var flag : String
    var name : String
    private let plist = Bundle.contentsOfFileArray(plistName: "CallingCodes.plist")
    private var is_accurate = false
    var isAccurate : Bool{
        return self.is_accurate
    }
    static var `default` : CountryModel = {
        let dial_code = UserDefaults.standard.string(forKey: USER_DIAL_CODE)
        return CountryModel(forDialCode: dial_code, withCountry: nil)
        
    }()
    init(_ json : JSON){
        self.name = json.string("name")
        self.dial_code = json.string("dial_code")
        self.country_code = json.string("code")
        
        
//        if let bundlePath = Bundle.main.path(forResource: "assets", ofType: "bundle"),
//            let bundle = Bundle(path: bundlePath){
//            self.flag = UIImage(named: "\(self.country_code.lowercased())", in: bundle, compatibleWith: nil)!
//        }else{
//            self.flag = UIImage(named: "us")!
//        }
        self.flag = json.string("flag")//UIImage(named: "\(self.country_code.lowercased())") ?? UIImage(named: "us")!

    }
    init(forDialCode d_code : String? = nil,withCountry c_code : String? =  nil){
        let code_matching_countries = self.plist.filter { (country) -> Bool in
            let dial = country["dial_code"] as? String ?? String()
            return  dial.replacingOccurrences(of: "+", with: "") == d_code?.replacingOccurrences(of: "+", with: "")
        }
        switch code_matching_countries.count {
        case 1:
            self.country_code = code_matching_countries.first?["code"] as? String ?? String()
            self.dial_code = code_matching_countries.first?["dial_code"] as? String ?? String()
            self.name = code_matching_countries.first?["name"] as? String ?? String()
            self.is_accurate = true
        case let x where x > 1 ://got more possibility
            self.is_accurate = false
            if let _cCode = c_code,
                let country = code_matching_countries
                    .filter({_cCode == ($0["code"] as? String)})
                    .first{
                
                self.country_code = country["code"] as? String ?? String()
                self.dial_code = country["dial_code"] as? String ?? String()
                self.name = country["name"] as? String ?? String()
                self.is_accurate = true
            }else{
                fallthrough
            }
        case 0:
            self.is_accurate = false
            if let _cCode = c_code,
                let country = self.plist
                    .filter({_cCode == ($0["code"] as? String)})
                    .first{
                
                self.country_code = country["code"] as? String ?? String()
                self.dial_code = country["dial_code"] as? String ?? String()
                self.name = country["name"] as? String ?? String()
                self.flag = country["flag"] as? String ?? String()
                self.is_accurate = true
            }else{
                fallthrough
            }
        default:
            self.country_code = "US"
            self.dial_code = "+1"
            self.name = "United States"
            self.is_accurate = false
        }
//        if let bundlePath = Bundle.main.path(forResource: "assets", ofType: "bundle"),
//            let bundle = Bundle(path: bundlePath){
//            self.flag = UIImage(named: "\(self.country_code.lowercased())", in: bundle, compatibleWith: nil)!
//        }else{
//            self.flag = UIImage(named: "us")!
//        }
       // self.flag = UIImage(named: "\(self.country_code.lowercased())") ?? UIImage(named: "us")!
        let result = Shared.instance.countryList.filter({$0.country_code == c_code})
//        if result.count != 0{
//            self.flag = result[0].flag ?? ""
//        }else{
//            self.flag = ""
//        }
        self.dial_code = result.count != 0 ? "+\(result[0].dial_code)" : "+1"
        self.flag = result.count != 0 ? result[0].flag : "https://flagsapi.com/US/flat/64.png"
    }
    func store(){
        let preference = UserDefaults.standard
        preference.set(self.dial_code, forKey: USER_DIAL_CODE)
        preference.set(self.country_code,forKey : USER_COUNTRY_CODE)
    }
}

class CountryCodeModel : Codable {
    
    var status_message : String = ""
    var status_code : String = ""
    var country_list : [CountryCodeList]
 
   
    
    enum CodingKeys: String, CodingKey {
        case status_message = "status_message"
        case status_code = "status_code"
        case country_list = "country_list"
//
        
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status_message = container.safeDecodeValue(forKey: .status_message)
        self.status_code = container.safeDecodeValue(forKey: .status_code)
        self.country_list = container.safeDecodeValue(forKey: .country_list)
    
        
    }
    
}

class CountryCodeList : Codable {
    var id: Int = 0
    var name: String = ""
    var country_code: String = ""
    var dial_code: String = ""
    var flag: String = ""
    
    enum CodingKeys: String,CodingKey {
        case id = "id"
        case name = "country_name"
        case country_code = "country_code"
        case dial_code = "phone_code"
        case flag = "flag_url"
    }
    
    required init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.name = container.safeDecodeValue(forKey: .name)
        self.country_code = container.safeDecodeValue(forKey: .country_code)
        self.dial_code = container.safeDecodeValue(forKey: .dial_code)
        self.flag = container.safeDecodeValue(forKey: .flag)
    }
    
}

public extension Bundle {
    static func contentsOfFileArray(plistName: String, bundle: Bundle? = nil) -> [[String: Any]] {
        let fileParts = plistName.components(separatedBy: ".")
        
        guard fileParts.count == 2,
            let resourcePath = (bundle ?? Bundle.main).path(forResource: fileParts[0], ofType: fileParts[1]),
            let contents = NSArray(contentsOfFile: resourcePath)
            else { return [[String:Any]]() }
        
        return contents as! [[String : Any]]
    }
}
