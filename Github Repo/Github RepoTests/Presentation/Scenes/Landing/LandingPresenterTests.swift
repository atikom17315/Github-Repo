@testable import Github_Repo
import XCTest

class LandingPresenterTests: XCTestCase {
  var sut: LandingPresenter!
  
  // MARK: - Test lifecycle
  override func setUp() {
    super.setUp()
    setupLandingPresenter()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - Test doubles
  class LandingDisplayLogicSpy: LandingDisplayLogic {
    var displayContentCalled = false
    func displayContent(viewModel: Landing.Content.ViewModel) {
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
    
    var displayUserRepositorySceneCalled = false
    func displayUserRepositoryScene(viewModel: Landing.UserSelected.ViewModel) {
      displayUserRepositorySceneCalled = true
    }
  }
  
  // MARK: - Test setup
  func setupLandingPresenter() {
    sut = LandingPresenter()
  }
  
  // MARK: - Tests
  func testPresentContent() {
    let spy = LandingDisplayLogicSpy()
    sut.viewController = spy
    let users = MockGitHub().getUsers()
    let response = Landing.Content.Response(users: users)

    sut.presentContent(response: response)
    
    XCTAssertTrue(spy.displayContentCalled, "presentContent(response:) should ask the view controller to display the result")
  }
  
  func testPresentError() {
    let spy = LandingDisplayLogicSpy()
    sut.viewController = spy

    sut.presentError()
    
    XCTAssertTrue(spy.displayErrorCalled, "presentError() should ask the view controller to display the result")
  }
  
  func testPresentNetworkError() {
    let spy = LandingDisplayLogicSpy()
    sut.viewController = spy

    sut.presentNetworkError()
    
    XCTAssertTrue(spy.displayRetryCalled, "presentNetworkError() should ask the view controller to display the result")
  }
  
  func testPresentShowLoading() {
    let spy = LandingDisplayLogicSpy()
    sut.viewController = spy

    let response = Landing.Loading.Response(isShow: true)
    sut.presentLoading(response: response)
    
    XCTAssertTrue(spy.displayContentCalled, "presentLoading() should ask the view controller to display the result")
  }
  
  func testPresentHideLoading() {
    let spy = LandingDisplayLogicSpy()
    sut.viewController = spy

    let response = Landing.Loading.Response(isShow: false)
    sut.presentLoading(response: response)
    
    XCTAssertTrue(spy.displayContentCalled, "presentLoading() should ask the view controller to display the result")
  }
}
