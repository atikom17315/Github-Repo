import Foundation

protocol LandingBusinessLogic {
  func favoriteUser(request: Landing.FavoriteUser.Request)
  func fetchListUsers()
  func fetchRetry()
  func searchUsers(request: Landing.SearchUser.Request)
  func userSelected(request: Landing.UserSelected.Request)
}

protocol LandingDataStore {
  var userSelected: User? { get set }
}

class LandingInteractor: LandingDataStore {
  var presenter: LandingPresentationLogic?
  var worker: LandingWorker?
  
  // MARK: - Properties
  private var isShowFavoriteUser: Bool = false
  private var query: String?
  
  // MARK: - LandingDataStore
  var userSelected: User?
  
  // MARK: - Methods
  func reloadData() {
    if isShowFavoriteUser {
      fetchFavoriteUsers()
    } else {
      fetchListUsers()
    }
  }
}

// MARK: - LandingBusinessLogic
extension LandingInteractor: LandingBusinessLogic {
  func favoriteUser(request: Landing.FavoriteUser.Request) {
    isShowFavoriteUser = request.isShowFavoriteUser
    reloadData()
  }
  
  func fetchFavoriteUsers() {
    presenter?.presentLoading(response: Landing.Loading.Response(isShow: true))
    worker?.fetchFavoriteUsers(query: query) { [weak self] (result) in
      guard let self = self, let presenter = self.presenter, self.isShowFavoriteUser else { return }
      presenter.presentLoading(response: Landing.Loading.Response(isShow: false))
      switch result {
      case .error:
        presenter.presentError()
      case .users(let users):
        presenter.presentContent(response: Landing.Content.Response(users: users))
      }
    }
  }

  func fetchListUsers() {
    presenter?.presentLoading(response: Landing.Loading.Response(isShow: true))
    worker?.fetchListUsers(query: query) { [weak self] (result) in
      guard let self = self, let presenter = self.presenter, !self.isShowFavoriteUser else { return }
      presenter.presentLoading(response: Landing.Loading.Response(isShow: false))
      
      switch result {
      case .error:
        presenter.presentNetworkError()
      case .users(let users):
        presenter.presentContent(response: Landing.Content.Response(users: users))
      }
    }
  }
  
  func fetchRetry() {
    reloadData()
  }
  
  func searchUsers(request: Landing.SearchUser.Request) {
    self.query = request.query.trim()
    reloadData()
  }
  
  func userSelected(request: Landing.UserSelected.Request) {
    userSelected = request.user
  }
}
