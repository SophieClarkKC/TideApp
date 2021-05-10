//
//  AppConfig.swift
//  TideApp
//
//  Created by Marco Guerrieri on 04/05/2021.
//

import Foundation

class AppConfig {
  static let baseURL = ConfigLoader.parsedConfig.baseURL
  static let isTestEnv = ConfigLoader.parsedConfig.config == "Mock"
  static let isProdEnv = ConfigLoader.parsedConfig.config == "Prod"
}

struct AppConfiguration: Decodable {
  let config: String
  let baseURL: URL

  enum CodingKeys: String, CodingKey {
    case config, baseURL
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.baseURL = try URL(string: container.decode(String.self, forKey: .baseURL))!
    self.config = try container.decode(String.self, forKey: .config)
  }
}

private class ConfigLoader {
  static let ConfigName = "Config.plist"
  static var parsedConfig: AppConfiguration = parseFile()

  static func parseFile(named fileName: String = ConfigName) -> AppConfiguration {
    guard let filePath = Bundle.main.path(forResource: fileName, ofType: nil),
          let fileData = FileManager.default.contents(atPath: filePath)
    else {
      fatalError("Config file '\(fileName)' not loadable!")
    }

    do {
      return try PropertyListDecoder().decode(AppConfiguration.self,
                                              from: fileData)
    } catch {
      fatalError("Configuration not decodable from '\(fileName)': \(error)")
    }
  }
}
