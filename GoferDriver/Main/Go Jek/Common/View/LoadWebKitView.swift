//
//  LoadWebKitView.swift
//  GoferHandyProvider
//
//  Created by trioangle on 24/08/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import UIKit
import MessageUI
import Social
import WebKit

class LoadWebKitSubView: BaseView {
    @IBOutlet weak var headerView: HeaderView!
//    @IBOutlet weak var backArrBtn: CustomBackBtn!
    @IBOutlet var webCommon: WKWebView?
    @IBOutlet var lblTitle: PrimarySubHeaderThemeLabel!
    @IBOutlet weak var bgView: TopCurvedView!
    
    var viewController:LoadWebKitView!
    
    var strPageTitle = ""
    var strCancellationFlexible = ""
    var isFromTrip = Bool()
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate

    override func didLoad(baseVC: BaseVC) {
        super.didLoad(baseVC: baseVC)
        self.viewController = baseVC as? LoadWebKitView
        self.initFunctions()
    }
    override func darkModeChange() {
        super.darkModeChange()
        self.setTheme()
    }
    
    func initFunctions(){
        self.webCommon?.navigationDelegate = self
        self.webCommon?.uiDelegate = self
        lblTitle.text = strPageTitle
        let request = URLRequest(url: URL(string: viewController.strWebUrl)!)
        webCommon?.load(request)
        self.lblTitle.text = LangCommon.paymentDetails.capitalized
        self.setStyle()
        self.bgView.customColorsUpdate()
    }
    
    func setTheme(){
        self.headerView.customColorsUpdate()
       // self.backArrBtn.customColorsUpdate()
        self.lblTitle.customColorsUpdate()
        self.bgView.customColorsUpdate()
        webCommon?.isOpaque = false
    }
    
    func setStyle(){
      
    }
    
    func goBack(){
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onAddTitleTapped(_ sender:UIButton!)
    {
        
    }

    @IBAction func onAddSummaryTapped(_ sender:UIButton!)
    {
        
    }

    @IBAction func onBackTapped(_ sender:UIButton!){
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
}

extension LoadWebKitSubView: WKNavigationDelegate,WKUIDelegate {

    // 1. Decides whether to allow or cancel a navigation.
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {

        print("*********************************************************navigationAction load:\(String(describing: navigationAction.request.url))")
        let str = String(describing: navigationAction.request.url)
        if str.contains("/challenge/complete"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "subcription_complete"), object: self, userInfo: nil)
               self.goBack()
        }
        }
        decisionHandler(.allow)
    }
    
    // 2. Start loading web address
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start load:\(String(describing: webView.url))")
       UberSupport().showProgress(viewCtrl: viewController, showAnimation: true)
    }
    
    // 3. Fail while loading with an error
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        print("fail with error: \(error.localizedDescription)")
    }
    
    // For Http Handling
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil) ; return }
            let exceptions = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, exceptions)
            completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
    
    // 4. WKWebView finish loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish loading")
        UberSupport().removeProgress(viewCtrl: viewController)
        webView.evaluateJavaScript("document.getElementById('data').innerHTML", completionHandler: { result, error in
            if let userAgent = result as? String {

                if let resFinal = self.convertStringToDictionary(text: userAgent) as? JSON{
                    print("*****************")
                    print(resFinal)
                    let statCode = resFinal["status_code"] as! String
                    let statMessage = resFinal["status_message"] as! String
                    var payAmount = ""
                    if !self.isFromTrip{
                        payAmount = resFinal.string("owe_amount")
                    }
                    if statCode == "1"{
                        if !self.isFromTrip{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PayToGoferApi"), object: self, userInfo: ["status": statMessage,"pay_to_gofer":payAmount])
//                            self.appDelegate.createToastMessage(statMessage)
                        }
                        self.goBack()
                    }else{
                        self.appDelegate.createToastMessage(statMessage)
                        self.goBack()
                    }
                    
                   
                }
                
            }
        })

        print("didFinish")
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}

