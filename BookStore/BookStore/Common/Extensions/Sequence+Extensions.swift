//
//  Sequence+Extensions.swift
//  BookStore
//
//  Created by Kunwar Vats on 11/08/22.
//

import UIKit

extension Sequence  {
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T { reduce(.zero) { $0 + predicate($1) } }
}
