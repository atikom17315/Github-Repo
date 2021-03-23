import AwaitKit
import Foundation
import PromiseKit

final class CacheManager: Cacheable {
  // MARK: - Properties
  private let userDefaults: Storable
  private var temporary: Storable
  
  // MARK: - Object Life Cycle
  init(userDefaults: Storable = UserDefaultsStore(userDefaults: UserDefaults.standard),
       temporary: Storable = TemporaryStore()) {
    self.userDefaults = userDefaults
    self.temporary = temporary
  }
  
  // MARK: - Methods
  func get<Element: Codable>(forKey key: CacheKey) throws -> Promise<Element?> {
    return async { [weak self] in
      guard let self = self else { throw CacheError.unknown }
      let element: Element? = try await(self.getStore(key).get(forKey: key))
      return element
    }
  }
  
  func put<Element: Codable>(_ value: Element, forKey key: CacheKey) throws -> Promise<Void> {
    return async { [weak self] in
      guard let self = self else { return }
      return try await(self.getStore(key).put(value, forKey: key))
    }
  }
  
  func delete(forKey key: CacheKey) throws -> Promise<Void> {
    return Promise { [weak self] _ in
      guard let self = self else { return }
      return try await(self.getStore(key).delete(forKey: key))
    }
  }
}

// MARK: - Helpers
extension CacheManager {
  private func getStore(_ key: CacheKey) -> Storable {
    switch key.getCacheLevel() {
    case .temporary:
      return temporary
    case .noneSensitivePersist:
      return userDefaults
    }
  }
}
