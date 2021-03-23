import Foundation

struct SearchUserResponse: Codable, Equatable {
  let totalCount: Int?
  let incompleteResults: Bool?
  let items: [User]?
  
  var isFavorite: Bool = false
  
  enum CodingKeys: String, CodingKey {
    case totalCount = "total_count"
    case incompleteResults = "incomplete_results"
    case items
  }
}
