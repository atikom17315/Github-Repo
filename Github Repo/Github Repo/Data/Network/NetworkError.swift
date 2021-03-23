import Foundation

enum NetworkError: Swift.Error, Equatable {
  case permission
  case parseData
  case unknown
}

extension NetworkError: LocalizedError {
  var errorDescription: String? {
    return NSLocalizedString("error_common_description", comment: "")
  }
}
