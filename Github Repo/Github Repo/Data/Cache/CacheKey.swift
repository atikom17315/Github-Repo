import Foundation

enum CacheKey: String, CaseIterable {
  case favoriteUser
  case users
  
  func getKey() -> String {
    return rawValue
  }
  
  func getCacheLevel() -> CacheLevel {
    switch self {
    case .favoriteUser: return .noneSensitivePersist
    case .users: return .temporary
    }
  }
}

enum CacheLevel {
  case temporary              // Non Persist & Not sensitive, In memory
  case noneSensitivePersist   // UserDefault
}
