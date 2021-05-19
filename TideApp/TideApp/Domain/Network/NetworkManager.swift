//
//  NetworkManager.swift
//  TideApp
//
//  Created by John Sanderson on 19/05/2021.
//

import Foundation
import Combine

protocol NetworkManagerType {

  func fetch<R: ResourceType>(_ resource: R) -> AnyPublisher<R.Output, Error>
}

final class NetworkManager: NetworkManagerType {

  // MARK: - Properties -
  // MARK: Private

  private let session: URLSession

  // MARK: - Initialiser -

  init(session: URLSession = .shared) {
    self.session = session
  }

  // MARK: - Functions -
  // MARK: Internal

  func fetch<R: ResourceType>(_ resource: R) -> AnyPublisher<R.Output, Error> {
    guard let urlRequest = resource.urlRequest else {
      return Fail(error: NetworkError.invalidRequest)
        .eraseToAnyPublisher()
    }
    return session.dataTaskPublisher(for: urlRequest)
      .mapError(NetworkError.urlError)
      .map(\.data)
      .decode(type: R.Output.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
