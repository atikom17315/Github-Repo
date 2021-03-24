import UIKit

protocol UserRepositoryPresentationLogic {
  func presentContent(response: UserRepository.Content.Response)
  func presentNetworkError()
  func presentLoading(response: UserRepository.Loading.Response)
}

class UserRepositoryPresenter {
  weak var viewController: UserRepositoryDisplayLogic?
}

// MARK: - LandingPresentationLogic
extension UserRepositoryPresenter: UserRepositoryPresentationLogic {
  func presentContent(response: UserRepository.Content.Response) {
    let userViewModel = makeViewModel(user: response.user)
    let repositoryViewModels = response.repos.map { makeViewModel(repository: $0) }
      
    let dataBuilder = UserRepositoryDataBuilder()
    let section1 = dataBuilder.buildUser(viewModel: userViewModel)
    let section2 = dataBuilder.buildUserRepositoryList(viewModels: repositoryViewModels)
    let viewModel = UserRepository.Content.ViewModel(dataList: [section1, section2])
    viewController?.displayContent(viewModel: viewModel)
  }
  
  func presentNetworkError() {
    viewController?.displayRetry()
  }
  
  func presentLoading(response: UserRepository.Loading.Response) {
    if response.isShow {
      let dataList = UserRepositoryDataBuilder().buildLoading()
      let viewModel = UserRepository.Content.ViewModel(dataList: dataList)
      viewController?.displayContent(viewModel: viewModel)
    } else {
      let viewModel = UserRepository.Content.ViewModel(dataList: [])
      viewController?.displayContent(viewModel: viewModel)
    }
  }
}

// MARK: - Making ViewModel
private extension UserRepositoryPresenter {
  func makeViewModel(user: User) -> UserListViewModel {
    let viewModel = UserListViewModel(user: user)
    viewModel.output.showFavoriteError = { [weak self] in
      guard let self = self, let viewController = self.viewController else { return }
      viewController.displayError()
    }
    return viewModel
  }
  
  func makeViewModel(repository: Repository) -> UserRepositoryListViewModel {
    let viewModel = UserRepositoryListViewModel(repository: repository)
    return viewModel
  }
}
