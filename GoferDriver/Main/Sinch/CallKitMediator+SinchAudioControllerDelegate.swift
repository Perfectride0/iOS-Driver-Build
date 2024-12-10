/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import Foundation
import SinchRTC

//extension CallKitMediator: SinchAudioControllerDelegate {
//  func audioControllerMuted(_ audioController: SinchAudioController) {
//    self.muted = true
//  }
//
//  func audioControllerUnmuted(_ audioController: SinchAudioController) {
//    self.muted = false
//  }
//
//  func audioControllerSpeakerEnabled(_ audioController: SinchAudioController) {}
//
//  func audioControllerSpeakerDisabled(_ audioController: SinchAudioController) {}
//}
extension SinchClientMediator: SinchAudioControllerDelegate {
  func audioControllerMuted(_ audioController: SinchAudioController) {
    self.muted = true
  }

  func audioControllerUnmuted(_ audioController: SinchAudioController) {
    self.muted = false
  }

  func audioControllerSpeakerEnabled(_ audioController: SinchAudioController) {}

  func audioControllerSpeakerDisabled(_ audioController: SinchAudioController) {}
}
