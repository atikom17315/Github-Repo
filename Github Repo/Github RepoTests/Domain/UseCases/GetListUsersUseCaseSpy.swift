@testable import Github_Repo
import XCTest

class GetListUsersUseCaseSpy: GetListUsersUseCase {
  // MARK: - Properties
  var mockResult: GetListUsersUseCaseResult!
  
  // MARK: - Methods
  func execute(query: String? = nil, completion: @escaping ((_ result: GetListUsersUseCaseResult) -> Void)) {
    completion(mockResult)
  }
}
