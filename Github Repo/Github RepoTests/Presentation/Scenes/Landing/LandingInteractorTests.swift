@testable import Github_Repo
import XCTest

class LandingInteractorTests: XCTestCase {
  var sut: LandingInteractor!
  
  // MARK: - Test lifecycle
  override func setUp() {
    super.setUp()
    setupLandingInteractor()
  }
  
  override func tearDown() {
    super.tearDown()
  }
    
  // MARK: - Test setup
  func setupLandingInteractor() {
    sut = LandingInteractor()
  }
  
  // MARK: - Test doubles
  class LandingPresentationLogicSpy: LandingPresentationLogic {
    var presentContentCalled = false
    var presentContentResponse: Landing.Content.Response!
    func presentContent(response: Landing.Content.Response) {
      presentContentCalled = true
      presentContentResponse = response
    }
    
    var presentErrorCalled = false
    func presentError() {
      presentErrorCalled = true
    }
    
    var presentNetworkErrorCalled = false
    func presentNetworkError() {
      presentNetworkErrorCalled = true
    }
    
    var presentLoadingCalled = false
    func presentLoading(response: Landing.Loading.Response) {
      presentLoadingCalled = true
    }
  }
  
  class LandingWorkerSpy: LandingWorker {
    var mockFetchFavoriteUsersResponse: LandingWorkerResult.FetchFavoriteUsers?
    override func fetchFavoriteUsers(query: String?,
                                     completion: @escaping ((_ result: LandingWorkerResult.FetchFavoriteUsers) -> Void)) {
      guard let response = mockFetchFavoriteUsersResponse else { return }
      completion(response)
    }
    
    var mockFetchListUsersResponse: LandingWorkerResult.FetchListUsers?
    override func fetchListUsers(query: String?,
                                 completion: @escaping ((_ result: LandingWorkerResult.FetchListUsers) -> Void)) {
      guard let response = mockFetchListUsersResponse else { return }
      completion(response)
    }
  }
  
  // MARK: - Tests
  func testFetchFavoriteUsersWithSuccessResponse() {
    let presenterSpy = LandingPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = LandingWorkerSpy()
    sut.worker = workerSpy
    let users = MockGitHub().getFavoriteUsers()
    workerSpy.mockFetchFavoriteUsersResponse = .users(users)

    sut.favoriteUser(request: Landing.FavoriteUser.Request(isShowFavoriteUser: true))
    sut.fetchFavoriteUsers()
    
    XCTAssertTrue(presenterSpy.presentContentCalled, "fetchFavoriteUsers() should ask the presenter to format the result")
    XCTAssertTrue((presenterSpy.presentContentResponse.users.count == 3), "The mocking data should be 3 users")
  }
  
  func testFetchFavoriteUsersWithErrorResponse() {
    let presenterSpy = LandingPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = LandingWorkerSpy()
    sut.worker = workerSpy
    workerSpy.mockFetchFavoriteUsersResponse = .error

    sut.favoriteUser(request: Landing.FavoriteUser.Request(isShowFavoriteUser: true))
    sut.fetchFavoriteUsers()

    XCTAssertTrue(presenterSpy.presentErrorCalled, "fetchFavoriteUsers() should ask the presenter to format the result")
  }
  
  func testIsShowFavoriteUser() {
    let presenterSpy = LandingPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = LandingWorkerSpy()
    sut.worker = workerSpy
    let users = MockGitHub().getUsers()
    workerSpy.mockFetchFavoriteUsersResponse = .users(users)

    sut.favoriteUser(request: Landing.FavoriteUser.Request(isShowFavoriteUser: true))

    XCTAssertTrue(presenterSpy.presentContentCalled, "favoriteUser(request:) should ask the presenter to format the result")
    XCTAssertTrue((presenterSpy.presentContentResponse.users.count == 30), "The mocking data should be 30 users")
  }
  
  func testNotShowFavoriteUser() {
    let presenterSpy = LandingPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = LandingWorkerSpy()
    sut.worker = workerSpy
    let users = MockGitHub().getFavoriteUsers()
    workerSpy.mockFetchListUsersResponse = .users(users)

    sut.favoriteUser(request: Landing.FavoriteUser.Request(isShowFavoriteUser: false))
    
    XCTAssertTrue(presenterSpy.presentContentCalled, "favoriteUser(request:) should ask the presenter to format the result")
    XCTAssertTrue((presenterSpy.presentContentResponse.users.count == 3), "The mocking data should be 3 users")
  }
  
  func testFetchListUsersWithSuccessResponse() {
    let presenterSpy = LandingPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = LandingWorkerSpy()
    sut.worker = workerSpy
    let users = MockGitHub().getUsers()
    workerSpy.mockFetchListUsersResponse = .users(users)

    sut.fetchListUsers()
    
    XCTAssertTrue(presenterSpy.presentContentCalled, "fetchListUsers() should ask the presenter to format the result")
    XCTAssertTrue((presenterSpy.presentContentResponse.users.count == 30), "The mocking data should be 30 users")
  }
  
  func testFetchListUsersWithErrorResponse() {
    let presenterSpy = LandingPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = LandingWorkerSpy()
    sut.worker = workerSpy
    workerSpy.mockFetchListUsersResponse = .error

    sut.fetchListUsers()
    
    XCTAssertTrue(presenterSpy.presentNetworkErrorCalled, "fetchListUsers() should ask the presenter to format the result")
  }
  
  func testFetchRetry() {
    let presenterSpy = LandingPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = LandingWorkerSpy()
    sut.worker = workerSpy
    let users = MockGitHub().getUsers()
    workerSpy.mockFetchListUsersResponse = .users(users)

    sut.fetchRetry()
    
    XCTAssertTrue(presenterSpy.presentContentCalled, "fetchListUsers() should ask the presenter to format the result")
    XCTAssertTrue((presenterSpy.presentContentResponse.users.count == 30), "The mocking data should be 30 users")
  }
  
  func testSearchUsers() {
    let presenterSpy = LandingPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = LandingWorkerSpy()
    sut.worker = workerSpy
    let users = MockGitHub().getSearchUsers()
    workerSpy.mockFetchListUsersResponse = .users(users)

    sut.searchUsers(request: Landing.SearchUser.Request(query: "P"))
    
    XCTAssertTrue(presenterSpy.presentContentCalled, "fetchListUsers() should ask the presenter to format the result")
    XCTAssertTrue((presenterSpy.presentContentResponse.users.count == 30), "The mocking data should be 30 users")
  }
}
