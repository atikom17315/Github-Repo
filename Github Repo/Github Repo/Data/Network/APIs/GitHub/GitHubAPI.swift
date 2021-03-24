import Foundation
import Moya

enum GitHubAPI {
  case searchUsers(query: String)
  case userRepos(username: String)
  case users
}

extension GitHubAPI: TargetType {
  
  var baseURL: URL {
    guard let baseUrlString = AppConstants.getConfig(config: .baseUrl),
          let url = URL(string: baseUrlString)
    else { fatalError("Please check `GR_BASE_URL` in info.plist!") }
    return url
  }
  
  var path: String {
    switch self {
    case .searchUsers: return "/search/users"
    case .userRepos(let username): return "/users/\(username.urlEscaped)/repos"
    case .users: return "/users"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .searchUsers,
         .userRepos,
         .users:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .searchUsers(let query):
      return .requestParameters(parameters: ["q": "user:\(query)"], encoding: URLEncoding.queryString)
    case .userRepos, .users:
      return .requestPlain
    }
  }
  
  var validationType: ValidationType {
    return .successAndRedirectCodes
  }
  
  var sampleData: Data {
    let fileName: String
    switch self {
    case .searchUsers: fileName = GitHubAPI.ResponseSearchUsers200
    case .userRepos: fileName = GitHubAPI.ResponseUserRepos200
    case .users: fileName = GitHubAPI.ResponseUsers200
    }
    return Data(ofResource: fileName, withExtension: "json")
  }
  
  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }
}

extension GitHubAPI {
  static let ResponseFavoriteUsers200 = "github-favorite-users-200"
  static let ResponseSearchUsers200 = "github-search-users-200"
  static let ResponseUserRepos200 = "github-user-repos-200"
  static let ResponseUsers200 = "github-users-200"
}
