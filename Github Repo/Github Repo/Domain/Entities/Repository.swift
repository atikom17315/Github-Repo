import Foundation

struct Repository: Codable, Equatable {
  let description: String?
  let id: Int
  let htmlUrl: String?
  let name: String?
    
  enum CodingKeys: String, CodingKey {
    case description
    case id
    case htmlUrl = "html_url"
    case name
  }
}
