@testable import Github_Repo
import XCTest

class MockGitHub: XCTestCase {
  func getFavoriteUsers() -> [User] {
    let data = Data(ofResource: GitHubAPI.ResponseFavoriteUsers200, withExtension: "json")
    let response: [User] = NetworkParser.parseDataResponse(data: data)!
    return response
  }
  
  func getRepositories() -> [Repository] {
    let data = Data(ofResource: GitHubAPI.ResponseUserRepos200, withExtension: "json")
    let response: [Repository] = NetworkParser.parseDataResponse(data: data)!
    return response
  }
  
  func getUsers() -> [User] {
    let data = Data(ofResource: GitHubAPI.ResponseUsers200, withExtension: "json")
    let response: [User] = NetworkParser.parseDataResponse(data: data)!
    return response
  }
  
  func getSearchUsers() -> [User] {
    let data = Data(ofResource: GitHubAPI.ResponseSearchUsers200, withExtension: "json")
    let response: SearchUserResponse = NetworkParser.parseDataResponse(data: data)!
    return response.items!
  }
}
