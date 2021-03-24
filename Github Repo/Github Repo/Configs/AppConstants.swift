//
//  AppConstants.swift
//  Github Repo
//
//  Created by Atikom Tancharoen on 20/3/2564 BE.
//

import Foundation

enum AppConfig: String {
  case appBundleIdentifier = "AppBundleIdentifier"
  case baseUrl = "BaseUrl"
}

class AppConstants {
  // MARK: - Methods
  static func getConfig(config: AppConfig) -> String? {
    guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary,
          let appConfigDict = infoDictionary["AppConfig"] as? NSDictionary,
          let value = appConfigDict["\(config.rawValue)"] as? String
    else { return nil }
    return value.replacingOccurrences(of: "\\", with: "")
  }
}
