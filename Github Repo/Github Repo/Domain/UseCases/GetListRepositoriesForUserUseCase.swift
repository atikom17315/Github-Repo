import AwaitKit
import Foundation
import PromiseKit

protocol GetListRepositoriesForUserUseCase {
  func execute(username: String, completion: @escaping ((_ result: GetListRepositoriesForUserUseCaseResult) -> Void))
}

enum GetListRepositoriesForUserUseCaseResult: Equatable {
  case error
  case repos([Repository])
}

class GetListRepositoriesForUserUseCaseImpl: GetListRepositoriesForUserUseCase {
  // MARK: - Properties
  private let gitHubRepository: GitHubRepository
  
  // MARK: - Object Life Cycle
  init(gitHubRepository: GitHubRepository) {
    self.gitHubRepository = gitHubRepository
  }
  
  // MARK: - Methods
  func execute(username: String, completion: @escaping ((_ result: GetListRepositoriesForUserUseCaseResult) -> Void)) {
    async { [weak self] in
      guard let self = self else { return }
      do {
        let repos = try await(self.gitHubRepository.getUserRepos(username: username))
        main { completion(.repos(repos)) }
      } catch {
        main { completion(.error) }
      }
    }
  }
}
