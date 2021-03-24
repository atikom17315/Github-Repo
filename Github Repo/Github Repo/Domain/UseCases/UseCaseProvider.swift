import Foundation

class UseCaseProvider: UseCaseProtocol {
  // MARK: - Properties
  private let cache: Cacheable
  private let network: Networkable
  private lazy var gitHubRepository = GitHubRepositoryImpl(cache: cache, network: network)

  // MARK: - Object Life Cycle
  #if LOCAL
  init(cache: Cacheable = CacheManager(),
       network: Networkable = NetworkManager(environment: .local)) {
    self.cache = cache
    self.network = network
  }
  #else
  init(cache: Cacheable = CacheManager(),
       network: Networkable = NetworkManager(environment: .server)) {
    self.cache = cache
    self.network = network
  }
  #endif

  // MARK: - Methods
  func makeDeleteFavoriteUserUseCase() -> DeleteFavoriteUserUseCase {
    return DeleteFavoriteUserUseCaseImpl(gitHubRepository: gitHubRepository)
  }
  
  func makeGetFavoriteUsersUseCase() -> GetFavoriteUsersUseCase {
    return GetFavoriteUsersUseCaseImpl(gitHubRepository: gitHubRepository)
  }
  
  func makeGetListRepositoriesForUserUseCase() -> GetListRepositoriesForUserUseCase {
    return GetListRepositoriesForUserUseCaseImpl(gitHubRepository: gitHubRepository)
  }
  
  func makeGetListUsersUseCase() -> GetListUsersUseCase {
    return GetListUsersUseCaseImpl(gitHubRepository: gitHubRepository)
  }
  
  func makeSaveFavoriteUserUseCase() -> SaveFavoriteUserUseCase {
    return SaveFavoriteUserUseCaseImpl(gitHubRepository: gitHubRepository)
  }
}
