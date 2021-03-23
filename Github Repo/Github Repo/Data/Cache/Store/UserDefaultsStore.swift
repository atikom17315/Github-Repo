import Foundation
import PromiseKit

final class UserDefaultsStore: Storable {
  // MARK: - Properties
  private let userDefaults: UserDefaults
  
  // MARK: - Object Life Cycle
  init(userDefaults: UserDefaults = UserDefaults.standard) {
    self.userDefaults = userDefaults
  }
  
  // MARK: - Methods
  func get<Element: Codable>(forKey key: CacheKey) throws -> Promise<Element?> {
    return Promise { [weak self] seal in
      guard let self = self else { return }
      let element: Element? = self.userDefaults.codable(forKey: key.getKey())
      seal.fulfill(element)
    }
  }
  
  func put<Element: Codable>(_ value: Element, forKey key: CacheKey) throws -> Promise<Void> {
    return Promise { [weak self] seal in
      guard let self = self else { return }
      self.userDefaults.set(value: value, forKey: key.getKey())
      seal.fulfill(())
    }
  }
  
  func delete(forKey key: CacheKey) throws -> Promise<Void> {
    return Promise { [weak self] _ in
      guard let self = self else { return }
      self.userDefaults.removeObject(forKey: key.getKey())
    }
  }
}
