@testable import Github_Repo
import XCTest

class LandingViewControllerTests: XCTestCase {
  var sut: LandingViewController!
  var window: UIWindow!
  
  // MARK: - Test lifecycle
  override func setUp() {
    super.setUp()
    window = UIWindow()
    setupLandingViewController()
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
  }
  
  // MARK: - Test setup
  func setupLandingViewController() {
    sut = LandingViewController.instantiate()
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: - Test doubles
  class LandingBusinessLogicSpy: LandingBusinessLogic {
    var favoriteUserCalled = false
    func favoriteUser(request: Landing.FavoriteUser.Request) {
      favoriteUserCalled = true
    }
    
    var fetchListUsersCalled = false
    func fetchListUsers() {
      fetchListUsersCalled = true
    }
    
    var fetchRetryCalled = false
    func fetchRetry() {
      fetchRetryCalled = true
    }
    
    var searchUsersCalled = false
    func searchUsers(request: Landing.SearchUser.Request) {
      searchUsersCalled = true
    }
    
    var userSelectedCalled = false
    func userSelected(request: Landing.UserSelected.Request) {
      userSelectedCalled = true
    }
  }
  
  // MARK: - Tests
  func testShouldFetchListUsersWhenViewIsLoaded() {
    let spy = LandingBusinessLogicSpy()
    sut.interactor = spy
    
    loadView()

    XCTAssertTrue(spy.fetchListUsersCalled, "viewWillAppear() should ask the interactor to fetchListUsers")
  }
  
  func testDisplayContent() {
    let spy = LandingBusinessLogicSpy()
    sut.interactor = spy
    let users = MockGitHub().getUsers()
    let userViewModels = users.map { UserListViewModel(user: $0) }
    let section = LandingDataBuilder().buildUserList(viewModels: userViewModels)
    let viewModel = Landing.Content.ViewModel(dataList: [section])
    
    loadView()
    sut.displayContent(viewModel: viewModel)
    
    XCTAssertEqual(sut.tableViewManager.dataList.count, viewModel.dataList.count, #function)
  }
}
