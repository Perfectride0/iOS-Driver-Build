/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import Foundation

@discardableResult
public func synchronized<T>(_ lock: Any, closure: () -> T) -> T {
  objc_sync_enter(lock)
  defer { objc_sync_exit(lock) }
  return closure()
}
