import UIKit

protocol UserRepositoryBusinessLogic {
  func fetchListRepositoriesForUser()
  func fetchRetry()
}

protocol UserRepositoryDataStore {
  var user: User! { get set }
}

class UserRepositoryInteractor: UserRepositoryDataStore {
  var presenter: UserRepositoryPresentationLogic?
  var worker: UserRepositoryWorker?
  
  // MARK: - Properties
  
  // MARK: - UserRepositoryDataStore
  var user: User!
}

// MARK: - LandingBusinessLogic
extension UserRepositoryInteractor: UserRepositoryBusinessLogic {
  func fetchListRepositoriesForUser() {
    presenter?.presentLoading(response: UserRepository.Loading.Response(isShow: true))
    worker?.fetchListRepositoriesForUser(username: user.username) { [weak self] (result) in
      guard let self = self, let presenter = self.presenter else { return }
      presenter.presentLoading(response: UserRepository.Loading.Response(isShow: false))
      switch result {
      case .error:
        presenter.presentNetworkError()
      case .repos(let repos):
        presenter.presentContent(response: UserRepository.Content.Response(user: self.user, repos: repos))
      }
    }
  }
  
  func fetchRetry() {
    fetchListRepositoriesForUser()
  }
}
