import UIKit

protocol LandingPresentationLogic {
  func presentContent(response: Landing.Content.Response)
  func presentError()
  func presentNetworkError()
  func presentLoading(response: Landing.Loading.Response)
}

class LandingPresenter {
  weak var viewController: LandingDisplayLogic?
}

// MARK: - LandingPresentationLogic
extension LandingPresenter: LandingPresentationLogic {
  func presentContent(response: Landing.Content.Response) {
    let userViewModels = response.users.map { makeViewModel(user: $0) }
    let section = LandingDataBuilder().buildUserList(viewModels: userViewModels)
    let viewModel = Landing.Content.ViewModel(dataList: [section])
    viewController?.displayContent(viewModel: viewModel)
  }
  
  func presentError() {
    viewController?.displayError()
  }

  func presentNetworkError() {
    viewController?.displayRetry()
  }
  
  func presentLoading(response: Landing.Loading.Response) {
    if response.isShow {
      let section = LandingDataBuilder().buildLoading()
      let viewModel = Landing.Content.ViewModel(dataList: [section])
      viewController?.displayContent(viewModel: viewModel)
    } else {
      let viewModel = Landing.Content.ViewModel(dataList: [])
      viewController?.displayContent(viewModel: viewModel)
    }
  }
}

// MARK: - Making ViewModel
private extension LandingPresenter {
  func makeViewModel(user: User) -> UserListViewModel {
    let viewModel = UserListViewModel(user: user)
    viewModel.output.showFavoriteError = { [weak self] in
      guard let self = self, let viewController = self.viewController else { return }
      viewController.displayError()
    }
    viewModel.output.showUserRepository = { [weak self] (user) in
      guard let self = self, let viewController = self.viewController else { return }
      viewController.displayUserRepositoryScene(viewModel: Landing.UserSelected.ViewModel(user: user))
    }
    return viewModel
  }
}
