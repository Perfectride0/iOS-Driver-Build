//
//  AppUtilities.swift
//  Handyman
//
//  Created by trioangle1 on 05/08/20.
//  Copyright © 2020 trioangle. All rights reserved.
//

import Foundation
import UIKit
import AVKit
//import MBProgressHUD
class AppUtilities {
    var player: AVAudioPlayer?
    func playSound(_ fileName: String/*,duration:Int*/) {
        
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player,
                  !player.isPlaying else { return }
//            self.player?.numberOfLoops = duration
           
            player.prepareToPlay()
            player.play()
            debug(print: fileName)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopPlayingSound() {
        self.player?.stop()
    }
    //
    //MARK: - Common Utility functions
    //
    func updateMainQueue (_ updates : @escaping() -> Void) {        //main queue updates
        DispatchQueue.main.async {
            updates()
        }
    }
    
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
         DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
              closure()
         }
    }
    //Instantiate Controllers
    func instantiateVC(storyboardName: String , storyboardId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: String(describing: storyboardName), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: storyboardId))
    }
    
    // Load NIB
    func loadNibwithName(name:String) -> UIView {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    
   // MARK:- MBProgress
    
//    func showProgress (currentView:UIView) -> Void{         //Show progress
//        updateMainQueue {
//            let mbProgress = MBProgressHUD.showAdded(to: currentView, animated: true)
//            mbProgress.mode = MBProgressHUDMode.indeterminate
//            mbProgress.label.text = "Loading"
//            mbProgress.bezelView.color = UIColor.white
//        }
//    }
//    func hideProgress (currentView:UIView) -> Void{         //Hide progress
//        updateMainQueue {
//            MBProgressHUD.hide(for: currentView, animated: true)
//        }
//    }
    
    
    //Check network connection
        func checkNetwork () -> Bool{
            do {
                let reachability: Reachability =  Reachability()!
                let networkStatus =  String (describing: reachability.currentReachabilityStatus)
                if (networkStatus == "No Connection"){
                    customCommonAlertView(titleString: "No Connection", messageString: "Connection failed, Please try again later")
                    return false
                }
                return true
            }
        }
    //get Json Data
       func getJsonData(data:Data?) {
           guard data != nil else { return }          //check data is nil or not
               do {
                   let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                   print("Response :\(String(describing: json))")
               } catch {
                   print(error)
               }
       }
    func customCommonAlertView (titleString:String, messageString:String) -> Void {
        //TRVicky
        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: titleString,alertDescription: messageString, okAction: LangCommon.ok.capitalized)

    }
    func cornerRadiusWithShadow(view: UIView){
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true;
        
        if #available(iOS 12.0, *) {
            if view.traitCollection.userInterfaceStyle == .light {
                view.backgroundColor = .SecondaryColor
                view.layer.shadowColor = UIColor.TertiaryColor.cgColor
            } else {
                view.backgroundColor = .DarkModeBackground
                view.layer.shadowColor = UIColor.TertiaryColor.withAlphaComponent(0.5).cgColor
            }
        } else {
            view.backgroundColor = UIColor.white
            view.layer.shadowColor = UIColor.lightGray.cgColor
            // Fallback on earlier versions
        }
        
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 6.0
        view.layer.masksToBounds = false
    }
    func setFloatingView(view: FloatRatingView,parentView: BaseView){
           view.emptyImage = UIImage(named: "star-grey")
           view.fullImage = UIImage(named: "star-yellow")
            // Optional params
        view.delegate = parentView as? FloatRatingViewDelegate
           view.contentMode = UIView.ContentMode.scaleAspectFit
           view.maxRating = 5
           view.minRating = 0
           view.rating = 0.0
           view.editable = false
       }
       
}
