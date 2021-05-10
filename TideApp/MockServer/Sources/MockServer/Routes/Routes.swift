//
//  Routes.swift
//  
//
//  Created by Marco Guerrieri on 04/05/2021.
//

import Foundation
import Swifter

protocol RoutesProvider {
  static func routes() -> [String: Route]
}

struct Routes {
  static func allRoutes() -> [String: Route] {
    return [
      "/premium/v1/marine.ashx": .jsonFile("marineResp1")
    ]
  }
}

enum Route {
  case jsonFile(_ file: String)
  case mapping(_ map: ((HttpRequest) -> HttpResponse))
  case error(code: Int, message: String)

  func handle(request: HttpRequest) -> HttpResponse {
    switch self {
    case .jsonFile(let fileName):
      guard let filePath = Bundle.module.path(forResource: fileName, ofType: "json") else {
        return Response.Error.generic
      }

      return generateJsonResponse(filePath)

    case .mapping(let handler):
      return handler(request)

    case .error(let code, let message):
      return Response.Error.error(code: code, errorMessage: message)
    }
  }

  private func generateJsonResponse(_ filePath: String) -> HttpResponse {
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
      let response = String(data: data, encoding: .utf8)!
      let _ = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
      return HttpResponse.raw(200, "OK", nil, { try $0.write([UInt8](response.utf8)) })
    } catch {
      assertionFailure("Invalid json format: \(filePath)")
    }
    return Response.Error.generic
  }
}
