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
      MSLogger.log(">>> MOCK SERVER Error on initialization")
      return
    }

    server.middleware.append { r in
      return self.processRequest(r)
    }

    server["/static/:path"] = directoryBrowser("/")

    guard (try? server.start(port)) != nil else {
      MSLogger.log(">>> MOCK SERVER Error on start")
      return
    }
    isStarted = true
    MSLogger.log(">>> MOCK SERVER Started on port: \(port)")
  }

  private func processRequest(_ request: HttpRequest) -> HttpResponse {
    MSLogger.log(">>> MOCK SERVER received request at \(request.path)")
    guard let endpoint = request.path.components(separatedBy: "?").first else {
      MSLogger.log(">>> MOCK SERVER error no endpoint")
      return Response.Error.generic
    }

    guard let route = Routes.allRoutes()[endpoint] else {
      MSLogger.log(">>> MOCK SERVER error no route found")
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
