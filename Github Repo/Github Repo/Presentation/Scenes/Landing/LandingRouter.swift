import UIKit

@objc protocol LandingRoutingLogic {
  func routeToUserRepository(segue: UIStoryboardSegue?)
}

protocol LandingDataPassing {
  var dataStore: LandingDataStore? { get }
}

class LandingRouter: NSObject, LandingRoutingLogic, LandingDataPassing {
  weak var viewController: LandingViewController?
  var dataStore: LandingDataStore?
  
  // MARK: - Routing
  func routeToUserRepository(segue: UIStoryboardSegue?) {
    if let segue = segue {
      guard let destinationVC = segue.destination as? UserRepositoryViewController,
            let dataStore = dataStore,
            var destinationDS = destinationVC.router?.dataStore
      else { return }
      passDataToUserRepository(source: dataStore, destination: &destinationDS)
    } else {
      let destinationVC: UserRepositoryViewController = UserRepositoryViewController.instantiate()
      guard let viewController = viewController,
            let dataStore = dataStore,
            var destinationDS = destinationVC.router?.dataStore
      else { return }
      passDataToUserRepository(source: dataStore, destination: &destinationDS)
      navigateToUserRepository(source: viewController, destination: destinationVC)
    }
  }
}

// MARK: - Navigation
extension LandingRouter {
  func navigateToUserRepository(source: LandingViewController,
                                destination: UserRepositoryViewController) {
    source.show(destination, sender: nil)
  }
}

// MARK: - Passing data
extension LandingRouter {
  func passDataToUserRepository(source: LandingDataStore,
                                destination: inout UserRepositoryDataStore) {
    destination.user = source.userSelected
  }
}
