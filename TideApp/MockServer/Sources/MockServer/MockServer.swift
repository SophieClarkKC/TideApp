//
//  MockServer.swift
//
//
//  Created by Marco Guerrieri on 04/05/2021.
//

import Foundation
import Swifter

public class MockServer {
  private var server: HttpServer?
  private var isStarted = false

  public init() {}

  public func start(port: UInt16 = 8123) {
    guard !isStarted else { return }

    server = HttpServer()

    guard let server = server else {
      MSLogger.log("Error on server initialization")
      return
    }

    server.middleware.append { r in
      return self.processRequest(r)
    }

    server["/static/:path"] = directoryBrowser("/")

    do {
      try server.start(port)
    } catch let error as NSError {
      MSLogger.log("Error on start (\(error.description))")
      return
    }

    isStarted = true
    MSLogger.log("Started on port \(port)")
  }

  public func stop() {
    server?.stop()
    isStarted = false
  }

  private func processRequest(_ request: HttpRequest) -> HttpResponse {
    MSLogger.log("Received request at \(request.path)")
    guard let endpoint = request.path.components(separatedBy: "?").first else {
      MSLogger.log("Error no endpoint found on path \(request.path)")
      return Response.Error.generic
    }

    guard let route = Routes.allRoutes()[endpoint] else {
      MSLogger.log("Error no route found for endpoint \(endpoint)")
      return Response.Error.generic
    }

    sleep(1) // just to give a fake loading time

    return route.handle(request: request)
  }
}

struct MSLogger {
  static func log(_ message: String) {
    print(">>> MOCK SERVER: \(message)")
  }
}
