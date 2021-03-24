@testable import Github_Repo
import XCTest

class UserRepositoryWorkerTests: XCTestCase {
  var sut: UserRepositoryWorker!
  
  // MARK: - Test lifecycle
  override func setUp() {
    super.setUp()
    setupUserRepositoryWorker()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - Test setup
  func setupUserRepositoryWorker() {
    sut = UserRepositoryWorker()
  }
  
  // MARK: - Tests
  func testFetchListRepositoriesForUserInSuccessCase() {
    let usecaseSpy = GetListRepositoriesForUserUseCaseSpy()
    sut.getListRepositoriesForUserUseCase = usecaseSpy
    let mockRepositories = MockGitHub().getRepositories()
    usecaseSpy.mockResult = .repos(mockRepositories)
    
    sut.fetchListRepositoriesForUser(username: "") { (result) in
      switch result {
      case .error:
        XCTAssert(false, #function + " failed")
      case .repos(let repos):
        XCTAssertEqual(mockRepositories, repos, #function + " failed")
      }
    }
  }
  
  func testFetchListRepositoriesForUserInErrorCase() {
    let usecaseSpy = GetListRepositoriesForUserUseCaseSpy()
    sut.getListRepositoriesForUserUseCase = usecaseSpy
    usecaseSpy.mockResult = .error
    
    sut.fetchListRepositoriesForUser(username: "") { (result) in
      switch result {
      case .error: break
      default: XCTAssert(false, #function + " failed")
      }
    }
  }
}
