//
//  String+Date.swift
//  TideApp
//
//  Created by Sophie Clark on 07/05/2021.
//

import Foundation

extension String {
  enum DateFormat: String {
    case dateTime = "yyyy-MM-dd HH:mm" // i.e. 2021-04-29 03:28
    case time = "HH:mm a" // i.e 09:15 AM
    case timeNoColon = "hhmm" // i.e. 300 which is 3AM
    
    func dateFormatter() -> DateFormatter {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = self.rawValue
      dateFormatter.timeZone = .current
      dateFormatter.locale = .current
      return dateFormatter
    }
  }
  
  func date(with format: DateFormat) -> Date? {
    return format.dateFormatter().date(from: self)
  }
}
