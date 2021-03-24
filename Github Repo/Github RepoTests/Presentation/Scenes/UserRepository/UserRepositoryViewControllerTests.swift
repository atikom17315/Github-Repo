@testable import Github_Repo
import XCTest

class UserRepositoryViewControllerTests: XCTestCase {
  var sut: UserRepositoryViewController!
  var window: UIWindow!
  
  // MARK: - Test lifecycle
  override func setUp() {
    super.setUp()
    window = UIWindow()
    setupUserRepositoryViewController()
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
  }
  
  // MARK: - Test setup
  func setupUserRepositoryViewController() {
    sut = UserRepositoryViewController.instantiate()
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: - Test doubles
  class UserRepositoryBusinessLogicSpy: UserRepositoryBusinessLogic {
    var fetchListRepositoriesForUserCalled = false
    func fetchListRepositoriesForUser() {
      fetchListRepositoriesForUserCalled = true
    }
    
    var fetchRetryCalled = false
    func fetchRetry() {
      fetchRetryCalled = true
    }
  }
  
  // MARK: - Tests
  func testShouldFetchListUsersWhenViewIsLoaded() {
    let spy = UserRepositoryBusinessLogicSpy()
    sut.interactor = spy
    
    loadView()

    XCTAssertTrue(spy.fetchListRepositoriesForUserCalled,
                  "viewWillAppear() should ask the interactor to fetchListRepositoriesForUser")
  }
  
  func testDisplayContent() {
    let spy = UserRepositoryBusinessLogicSpy()
    sut.interactor = spy

    let user = MockGitHub().getUsers()[0]
    let repositories = MockGitHub().getRepositories()
    let userViewModel = UserListViewModel(user: user)
    let repositoryViewModels = repositories.map { UserRepositoryListViewModel(repository: $0) }
    let dataBuilder = UserRepositoryDataBuilder()
    let section1 = dataBuilder.buildUser(viewModel: userViewModel)
    let section2 = dataBuilder.buildUserRepositoryList(viewModels: repositoryViewModels)
    let viewModel = UserRepository.Content.ViewModel(dataList: [section1, section2])
    
    loadView()
    sut.displayContent(viewModel: viewModel)
    
    XCTAssertEqual(sut.tableViewManager.dataList.count, viewModel.dataList.count, #function)
  }
}
