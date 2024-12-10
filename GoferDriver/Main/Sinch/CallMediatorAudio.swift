//
//  CallMediatorAudio.swift
//  VideoCallKitSwift
//
//  Created by trioangle on 16/09/22.
//  Copyright © 2022 Sinch. All rights reserved.
//

import Foundation
import SinchRTC
import OSLog
import CallKit
//audio


class SinchClientMediator : NSObject {
    typealias ClientCreationCallback = (_ error: Error?) -> Void
      var clientCreationCallback: ClientCreationCallback!
      var sinchClient: SinchClient?
      let customLog = OSLog(subsystem: "com.sinch.sdk.app", category: "SinchClientMediator")
    static let userIDKey: String = "com.sinch.userId"

      func create(withUserId userId:String,
                  andCallback callback:@escaping (_ error: Error?) -> Void) {
        do {
          sinchClient = try SinchRTC.client(withApplicationKey: APPLICATION_KEY,
              environmentHost: ENVIRONMENT_HOST,
              userId: userId)
        }
        catch let error as NSError {
          os_log("Failed to create sinchClient", log: customLog, type: .info,
                error.localizedDescription)
          callback(error)
        }
        clientCreationCallback = callback;
        sinchClient?.delegate = self
          sinchClient?.callClient.delegate = self
          self.sinchClient!.audioController.delegate = self
          sinchClient?.enableManagedPushNotifications()
        sinchClient?.start()
      }
    func createClientIfNeeded() {
      if let userId = UserDefaults.standard.string(forKey: SinchClientMediator.userIDKey) {
        // We are sure userId is downcastable to String
//        self.createClient(withUserId: userId) { error in
          self.create(withUserId: userId) { error in
          if let err = error {
            os_log("SinchClient started with error: %{public}@", log: self.customLog, type: .error, err.localizedDescription)
          } else {
            os_log("SinchClient started successfully: (version:%{public}@)", log: self.customLog, SinchRTC.version())
          }
        }

      } else {
        os_log("No saved userId to create SinchClient", log: self.customLog)
      }
    }
  typealias CallStartedCallback = (Result<SinchCall, Error>) -> Void
    var observers: [Observation] = []

  var callStartedCallback: CallStartedCallback!
  let callController: CXCallController! = CXCallController()
    var callRegistry = CallRegistry()
    var muted: Bool = false
    var isInitialized : Bool {
        return self.sinchClient?.isStarted ?? false
    }
  var provider: CXProvider!
    weak var delegate: SinchClientMediatorDelegate!

    init(delegate: SinchClientMediatorDelegate,supportsVideo: Bool) {
    super.init()
    // set up CXProvider
      self.delegate = delegate
        let config = CXProviderConfiguration(localizedName: "Sinch")
        config.maximumCallGroups = 1
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.generic]
        config.supportsVideo = supportsVideo
        config.ringtoneSound = "incoming.wav"
    provider = CXProvider(configuration: config)
    provider.setDelegate(self, queue: nil)

  }

    func call(userId destination:String,
              withCallback callback: @escaping CallStartedCallback) {
      let handle = CXHandle(type: .generic, value: destination)
      let initiateCallAction = CXStartCallAction(call: UUID(), handle: handle)
      initiateCallAction.isVideo = false
      let initOutgoingCall = CXTransaction(action: initiateCallAction)
      // store for later use
      callStartedCallback = callback

      callController.request(initOutgoingCall, completion: { error in
        if let err = error {
          os_log("Error requesting start call transaction: %{public}@",
              log: self.customLog, type: .error, err.localizedDescription)
          DispatchQueue.main.async {
            self.callStartedCallback(.failure(err))
            self.callStartedCallback = nil
          }
        }
      })
    }
    func callExists(withId callId: String) -> Bool {
      return self.callRegistry.sinchCall(forCallId: callId) != nil
    }
     func fanoutDelegateCall(_ callback: (
             _ observer: SinchClientMediatorObserver) -> Void) {
        // Remove dangling before calling
        observers.removeAll(where: { $0.observer == nil })
        observers.forEach { callback($0.observer!) }
      }

      class Observation {
        init(_ observer: SinchClientMediatorObserver) {
          self.observer = observer
        }

        weak var observer: SinchClientMediatorObserver?
      }

      func addObserver(_ observer: SinchClientMediatorObserver) {
        guard observers.firstIndex(where: { $0.observer === observer }) != nil else {
          observers.append(Observation(observer))
          return
        }
      }

      func removeObserver(_ observer: SinchClientMediatorObserver) {
        if let idx = observers.firstIndex(where: { $0.observer === observer }) {
          observers.remove(at: idx)
        }
      }
    
    func reportIncomingCall(withPushPayload payload: [AnyHashable: Any],
          withCompletion completion: @escaping (Error?) -> Void) {
     
        // Extract call information from the push payload
        let notification = queryPushNotificationPayload(payload)
        if notification.isCall && notification.isValid {
          let callNotification = notification.callResult

          guard callRegistry.callKitUUID(
                      forSinchId: callNotification.callId) == nil else {
            return
          }
          let cxCallId = UUID()
          callRegistry.map(callKitId: cxCallId,
                           toSinchCallId: callNotification.callId)

          os_log("reportNewIncomingCallToCallKit: ckid:%{public}@ callId:%{public}@",
              log: customLog, cxCallId.description, callNotification.callId)
          // Request SinchClientProvider to report new call to CallKit
          let update = CXCallUpdate()
          update.remoteHandle = CXHandle(type: .generic,
                                         value: callNotification.remoteUserId)
          update.hasVideo = callNotification.isVideoOffered

          // Reporting the call to CallKit
          provider.reportNewIncomingCall(with: cxCallId, update: update) {
              (error: Error?) in
            if error != nil {
              // If we get an error here from the OS,
              // it is possibly the callee's phone has
              // "Do Not Disturb" turned on;
              // check CXErrorCodeIncomingCallError in CXError.h
              self.hangupCallOnError(withId: callNotification.callId)
            }
            completion(error)
          }
        
      }
    }

    private func hangupCallOnError(withId callId: String) {
      guard let call = callRegistry.sinchCall(forCallId: callId) else {
        os_log("Unable to find sinch call for callId: %{public}@", log: customLog,
               type: .error, callId)
        return
      }
      call.hangup()
      callRegistry.removeSinchCall(withId: callId)
    }
    func end(call: SinchCall) {
      guard let uuid = callRegistry.callKitUUID(forSinchId: call.callId) else {
        return
      }

      let endCallAction = CXEndCallAction(call: uuid)
      let transaction = CXTransaction()
      transaction.addAction(endCallAction)

      callController.request(transaction, completion: { error in
        if let err = error {
          os_log("Error requesting end call transaction: %{public}@",
                 log: self.customLog, type: .error, err.localizedDescription)
        }
        self.callStartedCallback = nil
      })
    }
    func logout(withCompletion completion: () -> Void) {
      defer {
        completion()
      }

      guard let client = sinchClient else { return }

      if client.isStarted {
        // Remove push registration from Sinch backend
        client.unregisterPushNotificationDeviceToken()
        client.terminateGracefully()
      }
      sinchClient = nil
    }
//    typealias CallStartedCallback = (Result<SinchCall, Error>) -> Void
    var callStarted: CallStartedCallback!

    func startOutgoingVideoCall(to destination: String,
                                withCompletion completion: @escaping CallStartedCallback) {
      let handle = CXHandle(type: .generic, value: destination)
      let initiateCallAction = CXStartCallAction(call: UUID(), handle: handle)
      initiateCallAction.isVideo = true
      let initOutgoingCall = CXTransaction(action: initiateCallAction)

      self.callStarted = completion

      self.callController.request(initOutgoingCall, completion: { error in
        if let err = error {
          os_log("Error requesting start call transaction: %{public}@",
                 log: self.customLog, type: .error, err.localizedDescription)
          DispatchQueue.main.async {
            completion(.failure(err))
            self.callStarted = nil
          }
        }
      })
    }
      func currentCall() -> SinchCall? {
        let calls = self.callRegistry.activeSinchCalls()
        if !calls.isEmpty {
          let call = calls[0]
          if call.state == .initiating || call.state == .established {
            return call
          }
        }
        return nil
      }

}
protocol SinchClientMediatorDelegate: AnyObject {
  func handleIncomingCall(_ call: SinchCall)
}
protocol SinchClientMediatorObserver: SinchCallDelegate {}
