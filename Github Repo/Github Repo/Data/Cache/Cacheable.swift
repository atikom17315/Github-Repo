import Foundation
import PromiseKit

protocol Cacheable {
  func get<Element: Codable>(forKey key: CacheKey) throws -> Promise<Element?>
  func put<Element: Codable>(_ value: Element, forKey key: CacheKey) throws -> Promise<Void>
  func delete(forKey key: CacheKey) throws -> Promise<Void>
}
