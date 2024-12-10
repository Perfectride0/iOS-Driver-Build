/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import Foundation
import OSLog
import SinchRTC
import UIKit
import AVFoundation
import AudioToolbox
import MediaPlayer
@IBDesignable
class AudioCall: UIViewController{
   
    
    enum ScreenMode {
        case fullScreen
        case toast
    }
   
    @IBOutlet weak var calllcut: UIButton!
    @IBOutlet weak var calllcutbtn: UIButton!
    @IBOutlet weak var declien_IV: UIImageView!
    @IBOutlet weak var answer_IV: UIImageView!
    @IBOutlet weak var mic_IV: UIImageView!
    @IBOutlet weak var speaker_IV: UIImageView!
    @IBOutlet weak var callResponseStackView: UIStackView!
    @IBOutlet weak var callerIV: UIImageView!
    @IBOutlet weak var imageHolderView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var transparentContentView: UIVisualEffectView!
    @IBOutlet var remoteUsername: UILabel!
    @IBOutlet var callStateLabel: UILabel!
    private var screenMode = ScreenMode.fullScreen
    private var hostWindow : UIWindow?
    private var durationTimer: Timer?
        let micOnIcon = UIImage(named: "mic_on")
        let micOffIcon = UIImage(named : "mic_off")
    let speakerOnIcon = UIImage(named: "speaker_on")
       let speakerOffIcon = UIImage(named: "speaker_off")
    var call: SinchCall!
    private weak var client: SinchClient!
    private let customLog = OSLog(subsystem: "com.sinch.sdk.app", category: "AudioCall")
   // weak var delegate : UICallHandlingDelegate?
  weak var callKitMediator: SinchClientMediator! {
    didSet {
      self.callKitMediator.addObserver(self)
    }
  }
    class func initWithStory() -> AudioCall{
        let callView = AudioCall(nibName: "CallViewController", bundle: nil)
        return callView
    }
    
    @IBAction func callDeclineAction(_ sender: Any) {
        
        
        self.callKitMediator.end(call: self.call)
        
        //self.callKitMediator.sinchClient?.audioController.mute()
        //self.callKitMediator.sinchClient?.audioController.unmute()

    }
    
    func muteMic(_ mute : Bool){
        guard let audioCtrlr = self.self.callKitMediator.sinchClient?.audioController else{return}
            if mute{
                audioCtrlr.mute()
            }else{
                audioCtrlr.unmute()
            }
        }
    
    func refreshView(){
        
             DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                 self.imageHolderView.isRoundCorner = true
                 self.callerIV.isRoundCorner = true
             }
             self.transparentContentView.elevate(self.screenMode != .fullScreen ? 4 : 0)
             
             
             self.transparentContentView.isClippedCorner = self.screenMode != .fullScreen
             
             //        self.backgroundColor = self.screenMode == .fullScreen ? .white : .clear
             self.headerStackView.axis = self.screenMode == .fullScreen ? .vertical : .horizontal
             self.speaker_IV.isHidden = true
             self.mic_IV.isHidden = true
           //  self.updateComponents()
             self.mic_IV.isClippedCorner = true
             self.speaker_IV.isClippedCorner = true
             
             self.speaker_IV.elevate(4)
             self.mic_IV.elevate(4)
             
             
             self.callResponseStackView.layoutIfNeeded()
             self.footerView.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    func attach(with mode : ScreenMode){
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive || $0.activationState == .background || $0.activationState == .foregroundInactive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        guard let window = keyWindow else { return }
        self.hostWindow = window
        self.setScreenMode(to: mode, on: window)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let root = appDelegate.window?.rootViewController as? UINavigationController {
            self.modalPresentationStyle = .overFullScreen
            root.presentedViewController?.dismiss(animated: false, completion: nil)
            root.present(self, animated: true, completion: nil)
        }
    }
    
    func setScreenMode(to mode : ScreenMode,on window : UIWindow){
        self.screenMode = mode
        let alpha : CGFloat
        if mode == .fullScreen{
            self.view.frame = window.bounds
            alpha = 1
            self.transparentContentView.transform = .identity
            
            self.transparentContentView.elevate(1)
        }else{
            self.view.frame = CGRect(x: 0,
                                y: 0,
                                width: window.frame.width,
                                height: window.frame.height * 0.22)
            alpha = 0
            self.transparentContentView
                .transform = CGAffineTransform(scaleX: 0.95,
                                               y: 0.95)
                    .concatenating(CGAffineTransform(translationX: 0,
                                                     y: 20))
            
            self.transparentContentView.elevate(2)
            
        }
        
        self.mic_IV.alpha = alpha
        self.mic_IV.isUserInteractionEnabled = alpha == 1
        self.speaker_IV.alpha = alpha
        self.speaker_IV.isUserInteractionEnabled = alpha == 1
//        self.callDurationLbl.alpha = alpha
        self.callStateLabel.isUserInteractionEnabled = alpha == 1
    }
    
    
  override func awakeFromNib() {
    self.modalTransitionStyle = .coverVertical
    self.modalPresentationStyle = .fullScreen
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  
      self.client = self.callKitMediator.sinchClient
      //            self.apiInteractor?.getResponse(forAPI: APIEnums.getCallerDetails,
      //                                            params: ["user_id":callerID]).shouldLoad(false)
//                             self.apiInteractor?.getRequest(for: APIEnums.getCallerDetails, params: ["user_id":callerID])
//                                 .responseJSON({ (json) in
//                                     if json.isSuccess {
//                                      let name = json.string("first_name")
//                                         + " " + json.string("last_name")
//                                      let image = json.string("profile_image")
//                                      self.remoteUsername.text = name
//                                      if let url = URL(string: image){
//                                       //                self.callerIV.sd_imageTransition = .curlUp
//                                          self.callerIV.sd_setImage(with: url, completed: nil)
//                                      }
//                                     }else{
//                                         AppDelegate.shared.createToastMessage(json.status_message)
//                                     }
//                                 })
//                                 .responseFailure({ (error) in
//                                     AppDelegate.shared.createToastMessage(error)
//
//                                 })
//
//              }
      self.setupForCall(withDirection: call.direction)

              self.mic_IV.addAction(for: .tap) { [weak self] in
                  guard let welf = self else{return}
                  let isOn = welf.mic_IV.image == welf.micOnIcon
                  welf.mic_IV.image = isOn ? welf.micOffIcon : welf.micOnIcon
                  welf.muteMic(isOn)
              }
      self.speaker_IV.addAction(for: .tap) { [weak self] in
                  guard let welf = self else{return}
                  let isOn = welf.speaker_IV.image == welf.speakerOnIcon
                  welf.speaker_IV.image = isOn ? welf.speakerOffIcon : welf.speakerOnIcon
         // self?.callKitMediator.sinchClient?.loud
                  welf.disableLoudSpeaker(isOn)
         
              }
      calllcut.setTitle("", for: .normal)
  }
        func disableLoudSpeaker(_ disable : Bool){
            let session = AVAudioSession.sharedInstance()
            do{
                if !disable{
    //                try session.setCategory(AVAudioSession.Category.playback)
                    try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                }else{
    //                try session.setCategory(.playAndRecord)
                    try session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
                }
                try session.setActive(true, options: .notifyOthersOnDeactivation)
    
    
            }catch(let error){
    
                debug(print: error.localizedDescription)
            }
        }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
     
//      self.apiInteractor?
//                    .getRequest(for: .getCallerDetails,params: ["user_id":self.call.remoteUserId])
//                    .responseJSON({ (json) in
//                        if json.isSuccess{
//                            let name = json.string("first_name") + " " + json.string("last_name")
//                            let image = json.string("profile_image")
//                            self.remoteUsername.text = name
//                            if let url = URL(string: image){
//                                self.callerIV.sd_setImage(with: url, completed: nil)
//                            }
//                        }else{
//                        }
//                    }).responseFailure({ (error) in
//                    })
      Shared.instance.showLoaderInWindow()
      ConnectionHandler.shared.getRequest(for: .getCallerDetails,
                                             params: ["user_id":self.call.remoteUserId], showLoader: true)
          .responseJSON({ json in
              if json.isSuccess {
                  let name = json.string("first_name") + " " + json.string("last_name")
                                          let image = json.string("profile_image")
                                          self.remoteUsername.text = name
                                          if let url = URL(string: image){
                                              self.callerIV.sd_setImage(with: url, completed: nil)
                                          }
              } else {
                  AppDelegate.shared.createToastMessage(json.status_message)
              }
              Shared.instance.removeLoaderInWindow()
          }).responseFailure({ error in
              print(error)
              Shared.instance.removeLoaderInWindow()
          })
      
   // self.remoteUsername.text = self.call.remoteUserId
  }

  @IBAction func hangup(_ sender: UIButton) {
    os_log("User pressed hangup", log: self.customLog)
    self.callKitMediator.end(call: self.call)
  }

  // MARK: Implementation

  private func setupForCall(withDirection direction: SinchCall.Direction) {
    switch direction {
    case .incoming:
      self.setupIncomingUI()
    case .outgoing:
      self.setupOutgoingUI()
    }
  }

  private func setupIncomingUI() {
    if self.callKitMediator.callExists(withId: self.call.callId) {
      // Enter from CallKit lock screen
      if self.call.state == .established {
        os_log("Setup UI for CallKit lock screen", log: self.customLog)
        self.startCallDurationTimer()
       // self.showButtonLayout(.hangup)
      } else {
        // Enter from CallKit but not lock screen
        os_log("Setup UI for CallKit not lock screen", log: self.customLog)
        self.callStateLabel.text = ""
       // self.showButtonLayout(.wakenByCallKit)
        //self.showRemoteVideoView()
      }
    } else {
      // Enter the view from normal incoming call. Can't happen with CallKit
      os_log("Setup UI for normal incoming call", log: self.customLog, type: .fault)
      assert(false, "Setup UI for normal incoming call not possible with CallKit. Call should exist in registry.")
    }
  }

  private func setupOutgoingUI() {
    self.callStateLabel.text = "calling..."
 //   self.showButtonLayout(.hangup)
  }


  func pathForResource(_ name: String) -> String? {
    return Bundle.main.path(forResource: name, ofType: nil)
  }

  func playSoundFile(_ name: String) {
    do {
      try self.client.audioController.startPlayingSoundFile(withPath: self.pathForResource(name), looping: true)
    } catch {
      os_log("WARNING: path for resource %{public}@ not found in the main bundle", log: self.customLog, type: .error, name)
    }
  }

  @IBAction func onSwitchCameraTapped(_ sender: Any) {
    self.client.videoController.captureDevicePosition.toggle()
  }

  @IBAction func onFullScreenTapped(_ sender: Any) {
    guard let gestureRec = sender as? UIGestureRecognizer else { return }
    guard let view = gestureRec.view else { return }

    if view.sin_isFullscreen() {
      view.contentMode = .scaleAspectFit
      view.sinDisableFullscreen(animated: true)
    } else {
      view.contentMode = .scaleAspectFill
      view.sinEnableFullscreen(animated: true)
    }
  }
}

// MARK: SinchCallDelegate

extension AudioCall: SinchClientMediatorObserver {
    func callDidProgress(_ call: SinchCall) {
        self.callStateLabel.text = "ringing..."

        playSoundFile("ringback.wav")
      }

      func callDidEstablish(_ call: SinchCall) {
          self.startCallDurationTimer()
       //   self.showButtonLayout(.hangup)
          self.client.audioController.stopPlayingSoundFile()

      }

      func callDidEnd(_ call: SinchCall) {
        dismiss(animated: true)
          self.client.audioController.stopPlayingSoundFile()
          self.stopCallDurationTimer()
          self.client.audioController.disableSpeaker()
          self.callKitMediator.removeObserver(self)
      }
}

// MARK: UI controls

private extension AudioCall {
  enum ButtonLayout {
    case hangup
    case wakenByCallKit
  }

//  func showButtonLayout(_ layout: ButtonLayout) {
//    switch layout {
//    case .hangup:
//      self.endCallButton.isHidden = false
//
//    case .wakenByCallKit:
//      self.endCallButton.isHidden = true
//    }
//  }

  func startCallDurationTimer() {
    guard self.durationTimer == nil else { return }
    self.durationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
      let interval = Date().timeIntervalSince(self.call.details.establishedTime!)
      self.setDuration(seconds: Int(interval))
    })
  }

  func stopCallDurationTimer() {
    guard self.durationTimer != nil else { return }
    self.durationTimer!.invalidate()
    self.durationTimer = nil
  }

  func setDuration(seconds: Int) {
    self.callStateLabel.text = String(format: "%02d:%02d", Int(seconds / 60), Int(seconds % 60))
  }
}
