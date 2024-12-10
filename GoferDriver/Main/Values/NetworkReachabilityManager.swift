//
//  NetworkReachabilityManager.swift
//  GoferDriver
//
//  Created by trioangle on 16/04/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager{
    static let instance = NetworkManager()
    
    private var timer : Timer?
    private var networkReachable : Bool?{
        didSet{
            guard let networkReachableState = self.networkReachable else{return}
            self.updateToastStatus(networkReachableState)
            NotificationCenter.default.post(name: .networkStateChanged,
                                            object: networkReachableState)
            
        }
    }
    var window : UIWindow?
    var isNetworkReachable :Bool{
        return self.networkReachable ?? false
    }
    private var toastLabel : UILabel?
    private init(){
        self.initToastLable()
    }
    private func initToastLable(){
        let windowKey = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        self.window = windowKey
        guard self.window != nil else{return}
        toastLabel = UILabel()
        toastLabel?.tag = 29
        toastLabel?.textColor = .PrimaryTextColor
        toastLabel?.backgroundColor = .PrimaryColor
        toastLabel?.font = .MediumFont(size: 15)
        toastLabel?.textAlignment = NSTextAlignment.center
        toastLabel?.numberOfLines = 0
        toastLabel?.layer.shadowColor = UIColor.PrimaryColor.cgColor;
        toastLabel?.layer.shadowOffset = CGSize(width:0, height:1.0);
        toastLabel?.layer.shadowOpacity = 0.5;
        toastLabel?.layer.shadowRadius = 1.0;
        toastLabel?.frame = CGRect(x: 0,
                                   y: window!.frame.height - 70,
                                   width: window!.frame.width,
                                   height: 70)
        toastLabel?.text = CommonError.connection.localizedDescription
        
    }
    
    func observeReachability(_ val : Bool) {
        if val{
            startNetworkReachabilityObserver()
            self.timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(startNetworkReachabilityObserver), userInfo: nil, repeats: true)
        }else{
            self.timer = nil
        }
    }
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    @objc func startNetworkReachabilityObserver() {
        /*if reachabilityManager?.startListening() ?? false{
            if let reachability = reachabilityManager,
                reachability.isReachable || reachability.isReachableOnWWAN || reachability.isReachableOnEthernetOrWiFi{
                self.networkReachable = true
            }else{
                self.networkReachable = false
            }
        }else{
            self.networkReachable = false
        }
        */
        
        reachabilityManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                self.networkReachable = false
            case .unknown :
                self.networkReachable = false
            case .reachable(.ethernetOrWiFi):
                self.networkReachable = true
            case .reachable(.cellular):
                self.networkReachable = true
            }
        })
        
//        reachabilityManager?.listener = { status in
//            switch status {
//            case .notReachable:
//                self.networkReachable = false
//            case .unknown :
//                self.networkReachable = false
//            case .reachable(.ethernetOrWiFi):
//                self.networkReachable = true
//            case .reachable(.wwan):
//                self.networkReachable = true
//            }
//        }
        self.updateToastStatus(self.isNetworkReachable)
//        reachabilityManager?.startListening()
    }
    
    private func updateToastStatus(_ val : Bool){
        let windowKey = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        guard let window = windowKey else{ return}
        guard self.toastLabel != nil else{
            self.initToastLable()
            return
        }
        if !window.subviews.contains(self.toastLabel!){
            window.addSubview(self.toastLabel!)
            window.bringSubviewToFront(self.toastLabel!)
            self.toastLabel!.transform = CGAffineTransform(translationX: 0, y: 70)
        }
        UIView.animate(withDuration: 0.3) {
            if val && self.toastLabel?.transform == .identity{//has net
                self.toastLabel!.transform = CGAffineTransform(translationX: 0, y: 70)
            }else if !val && self.toastLabel?.transform != .identity{//no net
                self.toastLabel!.transform = .identity
            }
            
        }
    }
}
