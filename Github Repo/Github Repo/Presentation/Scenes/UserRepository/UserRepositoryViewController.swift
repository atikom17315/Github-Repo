import UIKit

protocol UserRepositoryDisplayLogic: class {
  func displayContent(viewModel: UserRepository.Content.ViewModel)
  func displayError()
  func displayRetry()
}

class UserRepositoryViewController: UIViewController, Storyboarded {
  var interactor: UserRepositoryBusinessLogic?
  var router: (NSObjectProtocol & UserRepositoryRoutingLogic & UserRepositoryDataPassing)?
  
  // MARK: - Properties
  var tableViewManager: UserRepositoryTableViewManager!

  // MARK: - IBOutlet
  @IBOutlet private var tableView: UITableView!
  
  // MARK: - Object Life Cycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Setup
  private func setup() {
    let viewController = self
    let interactor = UserRepositoryInteractor()
    let presenter = UserRepositoryPresenter()
    let router = UserRepositoryRouter()
    let worker = UserRepositoryWorker()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  private func setupTableView() {
    tableViewManager = UserRepositoryTableViewManager(tableView: tableView)
  }
  
  // MARK: - Routing
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    interactor?.fetchListRepositoriesForUser()
  }
}

// MARK: - UserRepositoryDisplayLogic
extension UserRepositoryViewController: UserRepositoryDisplayLogic {
  func displayContent(viewModel: UserRepository.Content.ViewModel) {
    tableViewManager.dataList = viewModel.dataList
  }
  
  func displayError() {
    let alert = UIAlertController(
      title: "Error",
      message: "Something went wrong please try again later",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
  
  func displayRetry() {
    let alert = UIAlertController(
      title: "Error",
      message: "Oops, something went wrong. please try again",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
      guard let self = self else { return }
      self.interactor?.fetchRetry()
    })
    present(alert, animated: true)
  }
}
