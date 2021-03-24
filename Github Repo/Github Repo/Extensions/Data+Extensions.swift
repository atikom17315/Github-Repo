import Foundation

extension Data {
  init(ofResource name: String, withExtension ext: String?) {
    do {
      guard let url =  Bundle.main.url(forResource: name, withExtension: ext) else {
        fatalError("Please check your file or filename")
      }
      try self.init(contentsOf: url)
    } catch {
      fatalError("Please check your file with error `\(error)`")
    }
  }
}
