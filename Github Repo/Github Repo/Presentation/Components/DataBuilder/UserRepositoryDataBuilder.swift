import Foundation

enum UserRepositorySectionType {
  case none
}

enum UserRepositoryCellType {
  case loading
  case user(viewModel: UserListViewModel)
  case userRepository(viewModel: UserRepositoryListViewModel)
}

// MARK: - DataBuilder
class UserRepositoryDataBuilder {
  func buildLoading() -> [UserRepositoryDataSection] {
    let elements = [UserRepositoryCellType.loading]
    return [UserRepositoryDataSection(type: .none, elements: elements)]
  }
  
  func buildUser(viewModel: UserListViewModel) -> UserRepositoryDataSection {
    let elements = [UserRepositoryCellType.user(viewModel: viewModel)]
    return UserRepositoryDataSection(type: .none, elements: elements)
  }
  
  func buildUserRepositoryList(viewModels: [UserRepositoryListViewModel]) -> UserRepositoryDataSection {
    let elements = viewModels.map { UserRepositoryCellType.userRepository(viewModel: $0) }
    return UserRepositoryDataSection(type: .none, elements: elements)
  }
}

// MARK: - DataSection
class UserRepositoryDataSection {
  let type: UserRepositorySectionType
  var elements: [UserRepositoryCellType]
  
  init(type: UserRepositorySectionType, elements: [UserRepositoryCellType]) {
    self.type = type
    self.elements = elements
  }
}
