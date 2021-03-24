@testable import Github_Repo
import XCTest

class UserRepositoryInteractorTests: XCTestCase {
  var sut: UserRepositoryInteractor!
  
  // MARK: - Test lifecycle
  override func setUp() {
    super.setUp()
    setupUserRepositoryInteractor()
  }
  
  override func tearDown() {
    super.tearDown()
  }
    
  // MARK: - Test setup
  func setupUserRepositoryInteractor() {
    sut = UserRepositoryInteractor()
    let mockUser = MockGitHub().getUsers()[0]
    sut.user = mockUser
  }
  
  // MARK: - Test doubles
  class UserRepositoryPresentationLogicSpy: UserRepositoryPresentationLogic {
    var presentContentCalled = false
    var presentContentResponse: UserRepository.Content.Response!
    func presentContent(response: UserRepository.Content.Response) {
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
    func presentLoading(response: UserRepository.Loading.Response) {
      presentLoadingCalled = true
    }
  }
  
  class UserRepositoryWorkerSpy: UserRepositoryWorker {
    var mockFetchListRepositoriesResponse: UserRepositoryWorkerResult.FetchListRepositories?
    override func fetchListRepositoriesForUser(username: String,
                                               completion: @escaping ((UserRepositoryWorkerResult.FetchListRepositories) -> Void)) {
      guard let response = mockFetchListRepositoriesResponse else { return }
      completion(response)
    }
  }
  
  // MARK: - Tests
  func testFetchListRepositoriesForUserWithSuccessResponse() {
    let presenterSpy = UserRepositoryPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = UserRepositoryWorkerSpy()
    sut.worker = workerSpy
    let mokeRepos = MockGitHub().getRepositories()
    workerSpy.mockFetchListRepositoriesResponse = .repos(mokeRepos)

    sut.fetchListRepositoriesForUser()
    
    XCTAssertTrue(presenterSpy.presentContentCalled, "fetchListRepositoriesForUser() should ask the presenter to format the result")
    XCTAssertEqual(presenterSpy.presentContentResponse.repos, mokeRepos, "The mocking data should same as mokeRepos")
  }
  
  func testFetchListRepositoriesForUserWithErrorResponse() {
    let presenterSpy = UserRepositoryPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = UserRepositoryWorkerSpy()
    sut.worker = workerSpy
    workerSpy.mockFetchListRepositoriesResponse = .error

    sut.fetchListRepositoriesForUser()
    
    XCTAssertTrue(presenterSpy.presentNetworkErrorCalled,
                  "fetchListRepositoriesForUser() should ask the presenter to format the result")
  }
  
  func testFetchRetry() {
    let presenterSpy = UserRepositoryPresentationLogicSpy()
    sut.presenter = presenterSpy
    let workerSpy = UserRepositoryWorkerSpy()
    sut.worker = workerSpy
    let mokeRepos = MockGitHub().getRepositories()
    workerSpy.mockFetchListRepositoriesResponse = .repos(mokeRepos)

    sut.fetchRetry()
    
    XCTAssertTrue(presenterSpy.presentContentCalled, "fetchListRepositoriesForUser() should ask the presenter to format the result")
    XCTAssertEqual(presenterSpy.presentContentResponse.repos, mokeRepos, "The mocking data should same as mokeRepos")
  }
}
