import Foundation
import PromiseKit

final class TemporaryStore: Storable {
  // MARK: - Properties
  private lazy var store: [String: Any] = [:]
  
  // MARK: - Methods
  func get<Element: Codable>(forKey key: CacheKey) throws -> Promise<Element?> {
    return Promise { [weak self] seal in
      guard let self = self else { return }
      let element: Element? = (self.store[key.getKey()] as? Element)
      seal.fulfill(element)
    }
  }
  
  func put<Element: Codable>(_ value: Element, forKey key: CacheKey) throws -> Promise<Void> {
    return Promise { [weak self] seal in
      guard let self = self else { return }
      self.store[key.getKey()] = value
      seal.fulfill(())
    }
  }
  
  func delete(forKey key: CacheKey) throws -> Promise<Void> {
    return Promise { [weak self] _ in
      guard let self = self else { return }
      self.store[key.getKey()] = nil
    }
  }
}
