import AwaitKit
import Foundation
import PromiseKit

protocol SearchUsersUseCase {
  func execute(query: String, completion: @escaping ((_ result: SearchUsersUseCaseResult) -> Void))
}

enum SearchUsersUseCaseResult: Equatable {
  case users([User])
  case error
}

final class SearchUsersUseCaseImpl: SearchUsersUseCase {
  // MARK: - Properties
  private let gitHubRepository: GitHubRepository
  
  // MARK: - Object Life Cycle
  init(gitHubRepository: GitHubRepository) {
    self.gitHubRepository = gitHubRepository
  }
  
  // MARK: - Methods
  func execute(query: String, completion: @escaping ((_ result: SearchUsersUseCaseResult) -> Void)) {
    async { [weak self] in
      guard let self = self else { return }
      do {
        let users = try await(self.gitHubRepository.searchUsers(query: query))
        main { completion(.users(users)) }
      } catch {
        main { completion(.error) }
      }
    }
  }
}
