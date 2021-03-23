import Foundation

enum UseCaseError: Swift.Error {
  case unknown
}

extension UseCaseError: LocalizedError {
  var errorDescription: String? {
    return NSLocalizedString("error_common_description", comment: "")
  }
}
