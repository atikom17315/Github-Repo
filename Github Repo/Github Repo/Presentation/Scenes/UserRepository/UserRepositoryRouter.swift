import UIKit

@objc protocol UserRepositoryRoutingLogic {
}

protocol UserRepositoryDataPassing {
  var dataStore: UserRepositoryDataStore? { get }
}

class UserRepositoryRouter: NSObject, UserRepositoryRoutingLogic, UserRepositoryDataPassing {
  weak var viewController: UserRepositoryViewController?
  var dataStore: UserRepositoryDataStore?
}
