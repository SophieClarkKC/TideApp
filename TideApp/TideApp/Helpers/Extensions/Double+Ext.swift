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
    let valueString = String(format:"%.2f", self)
    let lastDigits = valueString.suffix(2)

    if lastDigits == "00" {
      return "\(Int(self))"
    }
    if lastDigits.last == "0"{
      return "\(valueString.dropLast())"
    }
    return valueString
  }
}
