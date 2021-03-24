@testable import Github_Repo
import XCTest

class DeleteFavoriteUserUseCaseSpy: DeleteFavoriteUserUseCase {
  // MARK: - Properties
  var mockResult: DeleteFavoriteUserUseCaseResult!
  
  // MARK: - Methods
  func execute(user: User, completion: @escaping ((_ result: DeleteFavoriteUserUseCaseResult) -> Void)) {
    completion(mockResult)
  }
}
