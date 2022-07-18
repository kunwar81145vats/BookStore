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
