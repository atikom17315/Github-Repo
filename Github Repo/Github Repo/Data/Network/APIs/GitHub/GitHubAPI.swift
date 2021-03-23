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
    return "".data(using: .utf8)!
  }
  
  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }
}
