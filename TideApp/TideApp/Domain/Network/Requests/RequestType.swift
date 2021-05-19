//
//  RequestType.swift
//  TideApp
//
//  Created by John Sanderson on 19/05/2021.
//

import Foundation
import Combine

protocol RequestType {

  associatedtype Output

  func perform() -> AnyPublisher<Output, Error>
}
