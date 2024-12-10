/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import Foundation
import UIKit

@IBDesignable
class SinchDefaultButton: UIButton {
  private static let minimalWidth: CGFloat = 160.0
  private static let widthAddition: CGFloat = 2 * 20.0

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setup()
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    if self.backgroundColor == nil {
      self.backgroundColor = UIColor(named: "sinchDefaultButtonColor")
      self.tintColor = UIColor(named: "sinchDefaultButtonTextColor")
    }
  }

  private func setup() {
    self.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 20.0)

    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.clear.cgColor
    self.layer.cornerRadius = self.bounds.height / 2.0
  }

  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    let newWidth = size.width + Self.widthAddition
    return CGSize(width: max(newWidth, Self.minimalWidth), height: size.height)
  }
}
