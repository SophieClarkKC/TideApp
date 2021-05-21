//
//  GlobalDependencies.swift
//  TideApp
//
//  Created by Marco Guerrieri on 21/05/2021.
//

import Foundation

final class GlobalDependencies {
  static let shared = GlobalDependencies()

  let favouritesManager = FavouritesManager()

  private init() { }

}
