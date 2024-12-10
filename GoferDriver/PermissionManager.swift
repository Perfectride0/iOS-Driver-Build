//
//  PermissionManager.swift
//  GoferDriver
//
//  Created by trioangle on 20/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation


import AVFoundation
import Photos

enum Permissions{
    case allowed
    case denied
    case ignored
    case none
}

protocol PermissionConfiguration
{
    var title : String{get}
    var reason : String{get}
    var getState : Permissions{get}
}
class LocationConfig : PermissionConfiguration {
    var title: String
    var reason: String
    
    var getState: Permissions {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case  .restricted, .denied:
                return .denied
            case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
                return .allowed
            @unknown default:
                fatalError()
            }
        } else {
            return .denied
        }
    }
    
    init(){
        self.title = LangCommon.locationService
        self.reason = LangCommon.tracking
    }
    
}

@available(iOS 14.0, *)
class PreciseLocationConfig : PermissionConfiguration {
    var title: String
    var reason: String
    private let manager : CLLocationManager
    var getState: Permissions {
            switch manager.accuracyAuthorization {
            case  .reducedAccuracy:
                return .denied
            case .fullAccuracy:
                return .allowed

            @unknown default:
                return .denied
            }

    }


    init(manager : CLLocationManager){
        self.manager  = manager
        self.title = LangCommon.locationService
        self.reason = LangCommon.tracking
    }

}
class MicrophoneConfig : PermissionConfiguration{
    var title: String
    var reason: String
    
    var getState: Permissions{
        switch AVAudioSession.sharedInstance().recordPermission {
            case AVAudioSession.RecordPermission.granted:
                return .allowed
            case AVAudioSession.RecordPermission.denied:
                return .denied
            case AVAudioSession.RecordPermission.undetermined:
                return .allowed
            /*AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    return .allowed
                } else {
                    return .denied
                }
            })*/
            default:
                return .denied
        }
    }
    
    init() {
        self.title = LangCommon.microphoneSerivce
        self.reason = LangCommon.inAppCall
    }
    
}
class MediaConfig : PermissionConfiguration {
    var title: String {
        return "\(self.sourceType == .camera ? "\(LangCommon.camera.capitalized)" : "\(LangCommon.photoLibrary.capitalized)") \(LangCommon.service.capitalized)"
    }
    var reason: String
    private var sourceType : UIImagePickerController.SourceType
    var getState: Permissions {
        if sourceType == .camera{
            let cameraMediaType = AVMediaType.video
            let authorization = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            
            return authorization == .authorized ? .allowed : authorization == .notDetermined ? .allowed : .denied
        }else{
            let authorized = [.notDetermined,.authorized].contains(PHPhotoLibrary.authorizationStatus())
            return authorized ? .allowed : .denied
            
        }
    }
    
    
    init(_ sourceType : UIImagePickerController.SourceType){
        self.sourceType = sourceType
        self.reason = LangCommon.app.capitalized
    }
}

class PermissionManager {
    let viewController : UIViewController
    let config : PermissionConfiguration
    init(_ view : UIViewController,_ config : PermissionConfiguration){
        self.viewController = view
        self.config = config
    }
    var isEnabled : Bool{
        return self.config.getState == .allowed
    }
    func forceEnableService(){
        if !self.isEnabled{
            self.showSettingsToService()
        }
    }
    private func showSettingsToService(){
        //TRVicky
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        if let commonAlertView = window?.subviews.lastIndex(where: {$0 is DeletePHIAlertview}) {
            window?.subviews[commonAlertView].removeFromSuperview()
//            commonAlertView.removeFromSuperview()
        }

        let commonAlert = CommonAlert()
        commonAlert.setupAlert(alert: appName,
                               alertDescription: LangCommon.locationPermissionDescription
                                + " "
                                + appName
                                + " "
                                + LangCommon.toAccessYourLocation,
                               okAction: LangCommon.ok,
                               cancelAction: LangCommon.cancel, userImage: nil)
        commonAlert.addAdditionalOkAction(isForSingleOption: false) {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        commonAlert.addAdditionalCancelAction {
            print(" Cancel The Force Popup ")
        }
        
        
        
        
        
        

        
    }
    
}
