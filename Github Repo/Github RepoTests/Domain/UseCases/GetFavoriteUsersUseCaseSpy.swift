@testable import Github_Repo
import XCTest

class GetFavoriteUsersUseCaseSpy: GetFavoriteUsersUseCase {
  // MARK: - Properties
  var mockResult: GetFavoriteUsersUseCaseResult!

  // MARK: - Methods
  func execute(query: String? = nil, completion: @escaping ((_ result: GetFavoriteUsersUseCaseResult) -> Void)) {
    completion(mockResult)
  }
}
