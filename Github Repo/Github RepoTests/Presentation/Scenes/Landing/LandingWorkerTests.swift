@testable import Github_Repo
import XCTest

class LandingWorkerTests: XCTestCase {
  var sut: LandingWorker!
  
  // MARK: - Test lifecycle
  override func setUp() {
    super.setUp()
    setupLandingWorker()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - Test setup
  func setupLandingWorker() {
    sut = LandingWorker()
  }
  
  // MARK: - Tests
  func testFetchFavoriteUsersInSuccessCase() {
    let usecaseSpy = GetFavoriteUsersUseCaseSpy()
    sut.getFavoriteUsersUseCase = usecaseSpy
    let mockUsers = MockGitHub().getFavoriteUsers()
    usecaseSpy.mockResult = .favoriteUsers(mockUsers)
    
    sut.fetchFavoriteUsers(query: "") { (result) in
      switch result {
      case .error:
        XCTAssert(false, #function + " failed")
      case .users(let users):
        XCTAssertEqual(mockUsers, users, #function + " failed")
      }
    }
  }
  
  func testFetchFavoriteUsersInErrorCase() {
    let usecaseSpy = GetFavoriteUsersUseCaseSpy()
    sut.getFavoriteUsersUseCase = usecaseSpy
    usecaseSpy.mockResult = .error
    
    sut.fetchFavoriteUsers(query: "") { (result) in
      switch result {
      case .error: break
      default: XCTAssert(false, #function + " failed")
      }
    }
  }
  
  func testFetchListUsersInSuccessCase() {
    let usecaseSpy = GetListUsersUseCaseSpy()
    sut.getListUsersUseCase = usecaseSpy
    let mockUsers = MockGitHub().getUsers()
    usecaseSpy.mockResult = .users(mockUsers)
    
    sut.fetchListUsers(query: "") { (result) in
      switch result {
      case .error:
        XCTAssert(false, #function + " failed")
      case .users(let users):
        XCTAssertEqual(mockUsers, users, #function + " failed")
      }
    }
  }

  func testFetchListUsersInErrorCase() {
    let usecaseSpy = GetListUsersUseCaseSpy()
    sut.getListUsersUseCase = usecaseSpy
    usecaseSpy.mockResult = .error
    
    sut.fetchListUsers(query: "") { (result) in
      switch result {
      case .error: break
      default: XCTAssert(false, #function + " failed")
      }
    }
  }
}
