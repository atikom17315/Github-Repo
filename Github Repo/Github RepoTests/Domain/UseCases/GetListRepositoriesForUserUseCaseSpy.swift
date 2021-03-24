@testable import Github_Repo
import XCTest

class GetListRepositoriesForUserUseCaseSpy: GetListRepositoriesForUserUseCase {
  // MARK: - Properties
  var mockResult: GetListRepositoriesForUserUseCaseResult!

  // MARK: - Methods
  func execute(username: String, completion: @escaping ((_ result: GetListRepositoriesForUserUseCaseResult) -> Void)) {
    completion(mockResult)
  }
}
