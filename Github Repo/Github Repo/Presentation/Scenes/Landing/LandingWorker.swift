import UIKit

enum LandingWorkerResult {
  enum DeleteFavoriteUser: Equatable {
    case error
    case success
  }
  enum FetchFavoriteUsers: Equatable {
    case error
    case users([User])
  }
  enum FetchListUsers: Equatable {
    case error
    case users([User])
  }
  enum SaveFavoriteUser: Equatable {
    case error
    case success
  }
}

final class LandingWorker {
  // MARK: - Properties
  private let services: UseCaseProtocol
  private lazy var getFavoriteUsersUseCase = services.makeGetFavoriteUsersUseCase()
  private lazy var getListUsersUseCase = services.makeGetListUsersUseCase()
  
  // MARK: - Object Life Cycle
  init(services: UseCaseProtocol = UseCaseProvider()) {
    self.services = services
  }
  
  // MARK: - Methods
  func fetchFavoriteUsers(query: String?, completion: @escaping ((_ result: LandingWorkerResult.FetchFavoriteUsers) -> Void)) {
    getFavoriteUsersUseCase.execute(query: query) { (result) in
      switch result {
      case .error:
        completion(.error)
      case .favoriteUsers(let users):
        completion(.users(users))
      }
    }
  }
  
  func fetchListUsers(query: String?, completion: @escaping ((_ result: LandingWorkerResult.FetchListUsers) -> Void)) {
    getListUsersUseCase.execute(query: query) { (result) in
      switch result {
      case .error:
        completion(.error)
      case .users(let users):
        completion(.users(users))
      }
    }
  }
}
