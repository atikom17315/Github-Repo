import Foundation

enum LandingSectionType {
  case none
}

enum LandingCellType {
  case loading
  case user(viewModel: UserListViewModel)
}

// MARK: - DataBuilder
final class LandingDataBuilder {
  func buildLoading() -> LandingDataSection {
    let elements = [LandingCellType.loading]
    return LandingDataSection(type: .none, elements: elements)
  }
  
  func buildUserList(viewModels: [UserListViewModel]) -> LandingDataSection {
    let elements = viewModels.map { LandingCellType.user(viewModel: $0) }
    return LandingDataSection(type: .none, elements: elements)
  }
}

// MARK: - DataSection
final class LandingDataSection {
  let type: LandingSectionType
  var elements: [LandingCellType]
  
  init(type: LandingSectionType, elements: [LandingCellType]) {
    self.type = type
    self.elements = elements
  }
}
