//
//  ResourceType.swift
//  TideApp
//
//  Created by John Sanderson on 19/05/2021.
//

import Foundation

protocol ResourceType {

  associatedtype Output: Decodable

  var pathComponent: String { get }
  var queryItems: [URLQueryItem] { get }
  var method: HTTPMethod { get }
  var jsonDecoder: JSONDecoder { get }
}

extension ResourceType {

  var queryItems: [URLQueryItem] { [] }
  var method: HTTPMethod { .get }
  var jsonDecoder: JSONDecoder { JSONDecoder() }

  var urlRequest: URLRequest? {
    var urlComponents = URLComponents(url: AppConfig.baseURL, resolvingAgainstBaseURL: true)
    urlComponents?.path = pathComponent
    urlComponents?.queryItems = queryItems
    guard let url = urlComponents?.url else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue.uppercased()
    return request
  }
}
