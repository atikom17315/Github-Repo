import AwaitKit
import Foundation
import PromiseKit

protocol GetListUsersUseCase {
  func execute(query: String?, completion: @escaping ((_ result: GetListUsersUseCaseResult) -> Void))
}

enum GetListUsersUseCaseResult: Equatable {
  case users([User])
  case error
}

class GetListUsersUseCaseImpl: GetListUsersUseCase {
  // MARK: - Properties
  private let gitHubRepository: GitHubRepository
  
  // MARK: - Object Life Cycle
  init(gitHubRepository: GitHubRepository) {
    self.gitHubRepository = gitHubRepository
  }
  
  // MARK: - Methods
  func execute(query: String? = nil, completion: @escaping ((_ result: GetListUsersUseCaseResult) -> Void)) {
    async { [weak self] in
      guard let self = self else { return }
      do {
        let favoriteUsers: [User] = try await(self.gitHubRepository.getFavoriteUsers())
        var users: [User] = []
        
        if let query = query, !query.isEmpty {
          users = try await(self.gitHubRepository.searchUsers(query: query))
        } else {
          users = try await(self.gitHubRepository.getUsers())
        }

        for favoriteUser in favoriteUsers where !users.isEmpty {
          guard let index = users.firstIndex(where: { $0.id == favoriteUser.id }) else { continue }
          var user = users[index]
          user.isFavorite = true
          users[index] = user
        }
        
        main { completion(.users(users)) }
      } catch NetworkError.permission {
        main { completion(.users([])) }
      } catch {
        main { completion(.error) }
      }
    }
  }
}
