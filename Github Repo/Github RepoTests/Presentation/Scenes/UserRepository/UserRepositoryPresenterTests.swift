@testable import Github_Repo
import XCTest

class UserRepositoryPresenterTests: XCTestCase {
  var sut: UserRepositoryPresenter!
  
  // MARK: - Test lifecycle
  override func setUp() {
    super.setUp()
    setupUserRepositoryPresenter()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - Test doubles
  class UserRepositoryDisplayLogicSpy: UserRepositoryDisplayLogic {
    var displayContentCalled = false
    func displayContent(viewModel: UserRepository.Content.ViewModel) {
      displayContentCalled = true
    }
    
    var displayErrorCalled = false
    func displayError() {
      displayErrorCalled = true
    }
    
    var displayRetryCalled = false
    func displayRetry() {
      displayRetryCalled = true
    }
  }
  
  // MARK: - Test setup
  func setupUserRepositoryPresenter() {
    sut = UserRepositoryPresenter()
  }
  
  // MARK: - Tests
  func testPresentContent() {
    let spy = UserRepositoryDisplayLogicSpy()
    sut.viewController = spy
    let mockUser = MockGitHub().getUsers()[0]
    let mockRepositories = MockGitHub().getRepositories()
    let response = UserRepository.Content.Response(user: mockUser, repos: mockRepositories)

    sut.presentContent(response: response)
    
    XCTAssertTrue(spy.displayContentCalled, "presentContent(response:) should ask the view controller to display the result")
  }
  
  func testPresentNetworkError() {
    let spy = UserRepositoryDisplayLogicSpy()
    sut.viewController = spy

    sut.presentNetworkError()
    
    XCTAssertTrue(spy.displayRetryCalled, "presentNetworkError() should ask the view controller to display the result")
  }
  
  func testPresentShowLoading() {
    let spy = UserRepositoryDisplayLogicSpy()
    sut.viewController = spy

    let response = UserRepository.Loading.Response(isShow: true)
    sut.presentLoading(response: response)
    
    XCTAssertTrue(spy.displayContentCalled, "presentLoading() should ask the view controller to display the result")
  }
  
  func testPresentHideLoading() {
    let spy = UserRepositoryDisplayLogicSpy()
    sut.viewController = spy

    let response = UserRepository.Loading.Response(isShow: false)
    sut.presentLoading(response: response)
    
    XCTAssertTrue(spy.displayContentCalled, "presentLoading() should ask the view controller to display the result")
  }
}
