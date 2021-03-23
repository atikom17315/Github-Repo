import AwaitKit
import Foundation
import PromiseKit

protocol DeleteFavoriteUserUseCase {
  func execute(user: User, completion: @escaping ((_ result: DeleteFavoriteUserUseCaseResult) -> Void))
}

enum DeleteFavoriteUserUseCaseResult: Equatable {
  case success
  case error
}

final class DeleteFavoriteUserUseCaseImpl: DeleteFavoriteUserUseCase {
  // MARK: - Properties
  private let gitHubRepository: GitHubRepository
  
  // MARK: - Object Life Cycle
  init(gitHubRepository: GitHubRepository) {
    self.gitHubRepository = gitHubRepository
  }
  
  // MARK: - Methods
  func execute(user: User, completion: @escaping ((_ result: DeleteFavoriteUserUseCaseResult) -> Void)) {
    async { [weak self] in
      guard let self = self else { return }
      do {
        try await(self.gitHubRepository.deleteFavoriteUser(user: user))
        main { completion(.success) }
      } catch {
        main { completion(.error) }
      }
    }
  }
}
