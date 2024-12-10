//
//  FlutterWaveVC.swift
//  FlutterWave
//
//  Created by trioangle on 22/08/22.
//

import UIKit
import WebKit

class FlutterWaveVC: UIViewController {


    @IBOutlet var webView: WKWebView!
    
       override func viewDidLoad() {
           super.viewDidLoad()
           
           webView.uiDelegate = self
           webView.navigationDelegate = self
           webView.allowsBackForwardNavigationGestures = true
           
           let myURL = URL(string:"https://app.flutterwave.com/login")
           let myRequest = URLRequest(url: myURL!)
           webView.load(myRequest)
       }
       
    @IBAction func onBackTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension FlutterWaveVC : WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        guard let redirectURL = (navigationAction.request.url) else {
            decisionHandler(.cancel)
            return
        }
        
        if (redirectURL.absoluteString.contains("tel:") ) {
            UIApplication.shared.open(redirectURL, options: [:], completionHandler: nil)
        }
        
        if (redirectURL.absoluteString.contains("whatsapp") ) {
            
            
            UIApplication.shared.open(redirectURL, options: [:], completionHandler: nil)
        }
        
        decisionHandler(.allow)
    }
}

extension FlutterWaveVC : WKUIDelegate{
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

            guard let url = navigationAction.request.url else {
                return nil
            }

            guard let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame else {
                webView.load(URLRequest(url: url))
                return nil
            }
            return nil
        }
}
