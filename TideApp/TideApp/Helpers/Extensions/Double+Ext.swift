//
//  Double+Ext.swift
//  TideApp
//
//  Created by Dan Smith on 20/05/2021.
//

import Foundation

extension Double {
  /// Returns a string of the value to 2 places or less
  ///  and dropping trailing `0` of the last 2 digits
  /// e.g.  `1.7501` returns `1.75`
  ///     `1.50` returns `1.5`
  ///     `1.0000` returns `1`

  func cleanValue() -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: self)) ?? ""
  }
}
