import UIKit

protocol LandingDisplayLogic: class {
  func displayContent(viewModel: Landing.Content.ViewModel)
  func displayError()
  func displayRetry()
  func displayUserRepositoryScene(viewModel: Landing.UserSelected.ViewModel)
}

private enum ContentType {
  case all
  case favoriteList
}

class LandingViewController: UIViewController, Storyboarded {
  var interactor: LandingBusinessLogic?
  var router: (NSObjectProtocol & LandingRoutingLogic & LandingDataPassing)?
    
  // MARK: - Properties
  private var tableViewManager: LandingTableViewManager!
  private var contentType: ContentType!
  private var searchTask: DispatchWorkItem?
  
  // MARK: - IBOutlet
  @IBOutlet private var favoriteButton: UIButton!
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var searchBar: UISearchBar!
  
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
    let interactor = LandingInteractor()
    let presenter = LandingPresenter()
    let router = LandingRouter()
    let worker = LandingWorker()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  private func setupFavoriteButton() {
    contentType = .all
    favoriteButton.isSelected = false
  }
  
  private func setupSearchBar() {
    searchBar.delegate = self
  }
  
  private func setupTableView() {
    tableViewManager = LandingTableViewManager(tableView: tableView)
  }
  
  // MARK: Routing
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
    setupFavoriteButton()
    setupSearchBar()
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    interactor?.fetchListUsers()
  }
  
  // MARK: - Methods
  @IBAction private func pressButton(_ sender: Any) {
    switch contentType {
    case .all:
      contentType = .favoriteList
      favoriteButton.isSelected = true
      
      let request = Landing.FavoriteUser.Request(isShowFavoriteUser: true)
      interactor?.favoriteUser(request: request)
    case .favoriteList:
      contentType = .all
      favoriteButton.isSelected = false
      
      let request = Landing.FavoriteUser.Request(isShowFavoriteUser: false)
      interactor?.favoriteUser(request: request)
    default: break
    }
  }
}

// MARK: - UISearchBarDelegate
extension LandingViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchTask?.cancel()
    let task = DispatchWorkItem { [weak self] in
      guard let self = self, let interactor = self.interactor else { return }
      let request = Landing.SearchUser.Request(query: searchText)
      interactor.searchUsers(request: request)
    }
    searchTask = task
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
    let request = Landing.SearchUser.Request(query: searchBar.text ?? "")
    interactor?.searchUsers(request: request)
  }
}

// MARK: - LandingDisplayLogic
extension LandingViewController: LandingDisplayLogic {
  func displayContent(viewModel: Landing.Content.ViewModel) {
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
  
  func displayUserRepositoryScene(viewModel: Landing.UserSelected.ViewModel) {
    let request = Landing.UserSelected.Request(user: viewModel.user)
    interactor?.userSelected(request: request)
    
    router?.routeToUserRepository(segue: nil)
  }
}
