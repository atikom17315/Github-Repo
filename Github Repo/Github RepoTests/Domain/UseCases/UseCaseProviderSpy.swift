@testable import Github_Repo
import XCTest

class UseCaseProviderSpy: UseCaseProtocol {
  // MARK: - Methods
  func makeDeleteFavoriteUserUseCase() -> DeleteFavoriteUserUseCase {
    return DeleteFavoriteUserUseCaseSpy()
  }
  
  func makeGetFavoriteUsersUseCase() -> GetFavoriteUsersUseCase {
    return GetFavoriteUsersUseCaseSpy()
  }
  
  func makeGetListRepositoriesForUserUseCase() -> GetListRepositoriesForUserUseCase {
    return GetListRepositoriesForUserUseCaseSpy()
  }
  
  func makeGetListUsersUseCase() -> GetListUsersUseCase {
    return GetListUsersUseCaseSpy()
  }
  
  func makeSaveFavoriteUserUseCase() -> SaveFavoriteUserUseCase {
    return SaveFavoriteUserUseCaseSpy()
  }
}
