@testable import Github_Repo
import XCTest

class SaveFavoriteUserUseCaseSpy: SaveFavoriteUserUseCase {
  // MARK: - Properties
  var mockResult: SaveFavoriteUserUseCaseResult!
  
  // MARK: - Methods
  func execute(user: User, completion: @escaping ((_ result: SaveFavoriteUserUseCaseResult) -> Void)) {
    completion(mockResult)
  }
}
