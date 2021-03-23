import Foundation

extension String {
  func trim() -> String {
      return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  var urlEscaped: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}
