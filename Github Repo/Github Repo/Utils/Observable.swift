import Foundation

class Observable<T> {
  // MARK: - Typealias or Enum
  typealias Observer = (T) -> Void
  
  // MARK: - Properties
  private var observer: Observer?
  
  var value: T {
    didSet {
      observer?(value)
    }
  }
  
  // MARK: - Object Life Cycle
  init(_ value: T) {
    self.value = value
  }
  
  // MARK: - Methods
  func observe(_ observer: Observer?) {
    self.observer = observer
    observer?(value)
  }
}
