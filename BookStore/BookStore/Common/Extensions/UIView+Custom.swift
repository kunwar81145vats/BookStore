//
//  UIView+Extensions.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import Foundation
import UIKit

@IBDesignable public class BorderView: UIView {

@IBInspectable var borderColor: UIColor = .white{
   didSet {
       layer.borderColor = borderColor.cgColor
   }
}

@IBInspectable var borderWidth: CGFloat = 2.0 {
   didSet {
       layer.borderWidth = borderWidth
   }
}

@IBInspectable var cornerRadius: CGFloat = 10.0 {
   didSet {
       layer.cornerRadius = cornerRadius
   }
}

override public func layoutSubviews() {
   super.layoutSubviews()
   clipsToBounds = true
  }
}

class PaddedTextField: UITextField
{
    var textPadding = UIEdgeInsets(
          top: 0,
          left: 20,
          bottom: 0,
          right: 0
      )

      override func textRect(forBounds bounds: CGRect) -> CGRect {
          let rect = super.textRect(forBounds: bounds)
          return rect.inset(by: textPadding)
      }

      override func editingRect(forBounds bounds: CGRect) -> CGRect {
          let rect = super.editingRect(forBounds: bounds)
          return rect.inset(by: textPadding)
      }
}
