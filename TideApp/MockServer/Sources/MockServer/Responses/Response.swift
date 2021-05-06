//
//  Response.swift
//  
//
//  Created by Marco Guerrieri on 04/05/2021.
//

import Foundation
import Swifter

struct Response {
  struct Error {
    public static let generic: HttpResponse = Response.Error.error(code: 400, errorMessage: "{ \"Error\":\"GENERIC ERROR\" }")

    static func error(code: Int = 400, errorMessage: String = "ERROR") -> HttpResponse {
      let reply = "{ \"Error\":\"\(errorMessage)\" }"
      return HttpResponse.raw(code, "FAILURE", nil, {try $0.write([UInt8](reply.utf8))})
    }
  }
}
