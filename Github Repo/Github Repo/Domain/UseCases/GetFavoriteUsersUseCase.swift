import AwaitKit
import Foundation
import PromiseKit

protocol GetFavoriteUsersUseCase {
  func execute(query: String?, completion: @escaping ((_ result: GetFavoriteUsersUseCaseResult) -> Void))
}

enum GetFavoriteUsersUseCaseResult: Equatable {
  case favoriteUsers([User])
  case error
}

final class GetFavoriteUsersUseCaseImpl: GetFavoriteUsersUseCase {
  // MARK: - Properties
  private let gitHubRepository: GitHubRepository
  
  // MARK: - Object Life Cycle
  init(gitHubRepository: GitHubRepository) {
    self.gitHubRepository = gitHubRepository
  }
  
  // MARK: - Methods
  func execute(query: String? = nil, completion: @escaping ((_ result: GetFavoriteUsersUseCaseResult) -> Void)) {
    async { [weak self] in
      guard let self = self else { return }
      do {
        var favoriteUsers: [User] = []
        let users: [User] = try await(self.gitHubRepository.getFavoriteUsers())
        
        favoriteUsers = users.filter { (user) in
          guard let query = query, !query.isEmpty else { return true }
          return (user.username.range(of: query, options: .caseInsensitive) != nil)
        }.reduce([]) { (result, user) -> [User] in
          var favoriteUser = user
          favoriteUser.isFavorite = true
          return result + [favoriteUser]
        }
        
        main { completion(.favoriteUsers(favoriteUsers)) }
      } catch {
        main { completion(.error) }
      }
    }
  }
}
