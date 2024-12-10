/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import UIKit

class PaddedTextField: UITextField {
  override func awakeFromNib() {
    super.awakeFromNib()
    self.textColor = UIColor(named: "sinchTextColor")
  }

  private func paddingInsets() -> UIEdgeInsets {
    return UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
  }

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return super.textRect(forBounds: bounds.inset(by: self.paddingInsets()))
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return super.editingRect(forBounds: bounds.inset(by: self.paddingInsets()))
  }
}
