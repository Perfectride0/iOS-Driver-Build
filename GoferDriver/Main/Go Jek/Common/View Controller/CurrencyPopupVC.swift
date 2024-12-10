//
//  CurrencyPopupVC.swift
//  GoferHandyProvider
//
//  Created by trioangle1 on 26/09/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit
protocol currencyListDelegate
{
    func onCurrencyChanged(currencyCode:String,symbol : String)
}
class CurrencyPopupVC: BaseVC {

    @IBOutlet var currencyPopupView: CurrencyPopupView!
    var arrCurrencyData = [CurrencyList]()
    var callback: ((String?)->())?
    var delegate: currencyListDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    //MARK: - Init with Storyboard
    class func initWithStory() -> CurrencyPopupVC{
        let view : CurrencyPopupVC = UIStoryboard.gojekCommon.instantiateViewController()
        
        return view
    }
    func callCurrencyAPI(){
        ConnectionHandler.shared
            .getRequest(for: APIEnums.getCurrencyList,params: [:], showLoader: true)
            .responseDecode(to: CurrencyModel.self) { (json) in
                UberSupport.shared.removeProgressInWindow()
                if json.statusCode != "0"{
                    self.arrCurrencyData = json.currencyList
                    self.currencyPopupView.currencyTable.reloadData()
                }else{
                    AppDelegate.shared.createToastMessage(json.statusMessage)
                }
            }
        
        
        
//            .responseJSON({ (json) in
//                UberSupport.shared.removeProgressInWindow()
//                if json.isSuccess{
//                    let currencies = json
//                        .array("currency_list")
//                        .compactMap({CurrencyModel(from: $0)})
//                    self.arrCurrencyData = currencies
//                    self.currencyPopupView.currencyTable.reloadData()
//                }else{
//                    AppDelegate.shared.createToastMessage(json.status_message)
//                }
//            })
            .responseFailure({ (error) in
                UberSupport.shared.removeProgressInWindow()
                //AppDelegate.shared.createToastMessage(error)
            })
    }

   
}
