/**
* CountryListVC.swift
*
* @package Gofer
* @author Trioangle Product Team
*  
* @link http://trioangle.com
*/

import UIKit
import AVFoundation

protocol CountryListDelegate
{
    func countryCodeChanged(countryCode:String, dialCode:String, flagImg:String)
}


class CountryListVC : BaseVC {

    var delegate: CountryListDelegate?
    var strPreviousCountry = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var accountVM = AccountViewModel()
    var arrCountryList = [CountryModel]()
    var countryList = [CountryCodeList]()
    
    @IBOutlet var countryListview: countryListView!
    //    var staticCountryArray = [CountryCodeList]()
    
    lazy var staticCountryArray : [CountryModel] = {
        let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist")
        let arrCountryList = NSMutableArray(contentsOfFile: path!)!
        let countriesArray : [CountryModel] = arrCountryList
                   .compactMap({$0 as? JSON})
                   .compactMap({CountryModel($0)})
        return countriesArray
    }()
    
    // MARK: - ViewController Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.wsToGetStart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCountryList()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    //MARK:- initWithStory
    class func initWithStory() -> CountryListVC {
        let vc : CountryListVC = UIStoryboard.gojekCommon.instantiateViewController()
        return vc
    }
    //MARK:- UDF
    
//    func getCountryCode() {
//        var params = JSON()
//        if let lang : String = UserDefaults.value(for: .default_language_option){
//            params["language"] = lang
//        }
//
//        self.countryCodeViewModel.CountryCodeApiCall(parms: params) { (result) in
//            switch result {
//            case .success(let json):
//
//                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
//                    appdelegate.makeSplashView(isFirstTime: false)
////                self.countryCodeView.GetCountryCodeFromApi(CountryCodeData: json)
//                self.arrCountryList = json
//
//
//            case .failure(let error):
//                print(error)
//                print(error.localizedDescription)
//                UberSupport.shared.removeProgressInWindow()
//
//
//            }
//        }
//
//
//    }
    
    
    
//    func wsToGetStart() {
//        var param = JSON()
//        if let lang : String = UserDefaults.value(for: .default_language_option){
//          param["language"] = lang
//        }
//
//        self.countryCodeViewModel.getStart(param: param) { (result) in
//            switch result {
//            case .success(let json):
//                if json.isSuccess {
//                    print("alert")
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.makeSplashView(isFirstTime: false)
//
//                    var list = json.array("country_list") as [CountryCodeList]
//
//                    for data in list {
////                        self.staticCountryArray = data as! [CountryModel]
//                        self.staticCountryArray.append(data)
//                    }
//
//
//
//                } else {
//                    print("No Luck Try Again Some Times")
//                }
//            // Fallback on earlier versions
//            case .failure(let error):
//                print(error)
//                print(error.localizedDescription)
//            }
//        }
//    }
//
   
    
    func getCountryList(){
           let uberLoader = UberSupport()
           uberLoader.showProgressInWindow(showAnimation: true)
           self.accountVM.getCountryList(){ result in
               switch result{
               case .success(let countries):
                   self.countryList.removeAll()
                   self.countryList = countries.country_list
                   DispatchQueue.main.async { [weak self] in
                       self?.countryListview.generateDataSource()
                       uberLoader.removeProgressInWindow()
                   }
               case .failure(let error):
                   uberLoader.removeProgressInWindow()
                   AppDelegate.shared.createToastMessage(error.localizedDescription)
               }
               
           }
       }
    
    
    
   
}


extension UIImage{
    class func imageFlagBundleNamed(named:String)->UIImage{
        let image = UIImage(named: "assets.bundle".appendingFormat("/"+(named as String)))!
        return image
    }
}
