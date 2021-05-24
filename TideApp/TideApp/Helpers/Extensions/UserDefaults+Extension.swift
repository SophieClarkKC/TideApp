//
//  UserDefaults+Extension.swift
//  TideApp
//
//  Created by Marco Guerrieri on 21/05/2021.
//

import Foundation

extension UserDefaults {
  public static var shared: UserDefaults {
    return UserDefaults(suiteName: "group.com.kinandcarta.TideApp")!
  }
}
