import Foundation

protocol UseCaseProtocol {
  func makeDeleteFavoriteUserUseCase() -> DeleteFavoriteUserUseCase
  func makeGetFavoriteUsersUseCase() -> GetFavoriteUsersUseCase
  func makeGetListRepositoriesForUserUseCase() -> GetListRepositoriesForUserUseCase
  func makeGetListUsersUseCase() -> GetListUsersUseCase
  func makeSaveFavoriteUserUseCase() -> SaveFavoriteUserUseCase
}
