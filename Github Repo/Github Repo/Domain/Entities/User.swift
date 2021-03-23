import Foundation

struct User: Codable, Equatable {
  let avatarUrl: String?
  let htmlUrl: String?
  let id: Int
  let username: String

  var isFavorite: Bool = false
  
  enum CodingKeys: String, CodingKey {
    case avatarUrl = "avatar_url"
    case htmlUrl = "html_url"
    case id
    case username = "login"
  }
}
