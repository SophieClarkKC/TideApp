//
//  NetworkError.swift
//  TideApp
//
//  Created by John Sanderson on 19/05/2021.
//

import Foundation

enum NetworkError: Error {
  case invalidRequest
  case urlError(URLError)
}
