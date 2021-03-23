import Foundation

protocol UserListInteractorIO {
  var input: UserListInteractorInput { get }
  var output: UserListInteractorOutput { get }
}

protocol UserListInteractorInput: class {
  func cellSelected()
  func favoriteSelected()
}

protocol UserListInteractorOutput: class {
  var isFavorite: Observable<Bool> { get }
  var githubUrl: Observable<String> { get }
  var imageUrl: Observable<String> { get }
  var username: Observable<String> { get }
  
  var showFavoriteError: (() -> Void)? { get set }
  var showUserRepository: ((_ user: User) -> Void)? { get set }
}

final class UserListViewModel: UserListInteractorIO, UserListInteractorInput, UserListInteractorOutput {
  // MARK: - Properties
  private var user: User
  
  private let services: UseCaseProtocol
  private lazy var deleteFavoriteUserUseCase = services.makeDeleteFavoriteUserUseCase()
  private lazy var saveFavoriteUserUseCase = services.makeSaveFavoriteUserUseCase()
  
  // MARK: - InteractorIO
  var input: UserListInteractorInput { return self }
  var output: UserListInteractorOutput { return self }
  
  // MARK: - Output
  private(set) lazy var isFavorite: Observable<Bool> = Observable(false)
  private(set) lazy var githubUrl: Observable<String> = Observable("")
  private(set) lazy var imageUrl: Observable<String> = Observable("")
  private(set) lazy var username: Observable<String> = Observable("")
  
  var showFavoriteError: (() -> Void)?
  var showUserRepository: ((_ user: User) -> Void)?
  
  // MARK: - Input
  func cellSelected() {
    output.showUserRepository?(user)
  }
  
  func favoriteSelected() {
    if user.isFavorite {
      user.isFavorite = false
      isFavorite.value = false
      deleteFavoriteUser()
    } else {
      user.isFavorite = true
      isFavorite.value = true
      saveFavoriteUser()
    }
  }
  
  // MARK: - Initialization
  init(services: UseCaseProtocol = UseCaseProvider(), user: User) {
    self.services = services
    self.user = user
    isFavorite.value = user.isFavorite
    githubUrl.value = user.htmlUrl ?? ""
    imageUrl.value = user.avatarUrl ?? ""
    username.value = user.username 
  }
  
  // MARK: - Methods
  private func deleteFavoriteUser() {
    deleteFavoriteUserUseCase.execute(user: user) { [weak self] (result) in
      guard let self = self else { return }
      if case .error = result {
        self.user.isFavorite = true
        self.isFavorite.value = true
        self.showFavoriteError?()
      }
    }
  }
  
  private func saveFavoriteUser() {
    saveFavoriteUserUseCase.execute(user: user) { [weak self] (result) in
      guard let self = self else { return }
      if case .error = result {
        self.user.isFavorite = false
        self.isFavorite.value = false
        self.showFavoriteError?()
      }
    }
  }
}
