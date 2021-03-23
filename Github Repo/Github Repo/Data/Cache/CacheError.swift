import Foundation

enum CacheError: Swift.Error {
  case unknown
}

extension CacheError: LocalizedError {
  var errorDescription: String? {
    return NSLocalizedString("error_common_description", comment: "")
  }
}
