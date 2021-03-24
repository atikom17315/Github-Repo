import Foundation

protocol UserRepositoryListInteractorIO {
  var input: UserRepositoryListInteractorInput { get }
  var output: UserRepositoryListInteractorOutput { get }
}

protocol UserRepositoryListInteractorInput: class {
  func cellSelected()
}

protocol UserRepositoryListInteractorOutput: class {
  var name: Observable<String> { get }
  var description: Observable<String> { get }
  var openURL: Observable<String> { get }
}

class UserRepositoryListViewModel: UserRepositoryListInteractorIO, UserRepositoryListInteractorInput, UserRepositoryListInteractorOutput {
  // MARK: - Properties
  private var repository: Repository
  
  // MARK: - InteractorIO
  var input: UserRepositoryListInteractorInput { return self }
  var output: UserRepositoryListInteractorOutput { return self }
  
  // MARK: - Output
  private(set) lazy var name: Observable<String> = Observable("")
  private(set) lazy var description: Observable<String> = Observable("")
  private(set) lazy var openURL: Observable<String> = Observable("")

  // MARK: - Input
  func cellSelected() {
    guard let htmlUrl = repository.htmlUrl else { return }
    openURL.value = htmlUrl
  }
  
  // MARK: - Initialization
  init(repository: Repository) {
    self.repository = repository
    name.value = repository.name ?? ""
    description.value = repository.description ?? ""
  }
}
