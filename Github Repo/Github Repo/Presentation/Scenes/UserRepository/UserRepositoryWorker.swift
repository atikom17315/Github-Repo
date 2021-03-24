import UIKit

enum UserRepositoryWorkerResult {
  enum FetchListRepositories: Equatable {
    case error
    case repos([Repository])
  }
}

class UserRepositoryWorker {
  // MARK: - Properties
  private let services: UseCaseProtocol
  lazy var getListRepositoriesForUserUseCase = services.makeGetListRepositoriesForUserUseCase()
  
  // MARK: - Object Life Cycle
  init(services: UseCaseProtocol = UseCaseProvider()) {
    self.services = services
  }
  
  // MARK: - Methods
  func fetchListRepositoriesForUser(username: String,
                                    completion: @escaping ((_ result: UserRepositoryWorkerResult.FetchListRepositories) -> Void)) {
    getListRepositoriesForUserUseCase.execute(username: username) { (result) in
      switch result {
      case .error:
        completion(.error)
      case .repos(let repos):
        completion(.repos(repos))
      }
    }
  }
}
