import AwaitKit
import Foundation
import PromiseKit

protocol SaveFavoriteUserUseCase {
  func execute(user: User, completion: @escaping ((_ result: SaveFavoriteUserUseCaseResult) -> Void))
}

enum SaveFavoriteUserUseCaseResult: Equatable {
  case success
  case error
}

final class SaveFavoriteUserUseCaseImpl: SaveFavoriteUserUseCase {
  // MARK: - Properties
  private let gitHubRepository: GitHubRepository
  
  // MARK: - Object Life Cycle
  init(gitHubRepository: GitHubRepository) {
    self.gitHubRepository = gitHubRepository
  }
  
  // MARK: - Methods
  func execute(user: User, completion: @escaping ((_ result: SaveFavoriteUserUseCaseResult) -> Void)) {
    async { [weak self] in
      guard let self = self else { return }
      do {
        try await(self.gitHubRepository.saveFavoriteUser(user: user))
        main { completion(.success) }
      } catch {
        main { completion(.error) }
      }
    }
  }
}
