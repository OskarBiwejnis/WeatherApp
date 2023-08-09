import XCTest
@testable import WeatherApp

final class WelcomeViewModelTests: XCTestCase {

    var welcomeViewModel: WelcomeViewModel!
    var mockWelcomeViewModelDelegate: MockWelcomeViewModelDelegate!

    override func setUpWithError() throws {
        try super.setUpWithError()
        welcomeViewModel = WelcomeViewModel()
        mockWelcomeViewModelDelegate = MockWelcomeViewModelDelegate()
        welcomeViewModel.delegate = mockWelcomeViewModelDelegate
    }

    override  func tearDown() {
        welcomeViewModel = nil
        mockWelcomeViewModelDelegate = nil
        super.tearDown()
    }

    func testShouldCallDelegateFunctionWhenProceedButtonTap() throws {
        XCTAssertFalse(mockWelcomeViewModelDelegate.didCallPushViewController)
        welcomeViewModel.proceedButtonTap()
        XCTAssertTrue(mockWelcomeViewModelDelegate.didCallPushViewController)
    }

    func testShouldCallDelegateFunctionWhenViewWillAppear() throws {
        XCTAssertFalse(mockWelcomeViewModelDelegate.didCallReloadRecentCities)
        welcomeViewModel.viewWillAppear()
        XCTAssertTrue(mockWelcomeViewModelDelegate.didCallReloadRecentCities)
    }

    func testShouldCallDelegateFunctionWhendidSelectRecentCity() throws {
        XCTAssertFalse(mockWelcomeViewModelDelegate.didCallPushViewController)
        welcomeViewModel.didSelectRecentCity(City())
        XCTAssertTrue(mockWelcomeViewModelDelegate.didCallPushViewController)
    }

}

class MockWelcomeViewModelDelegate: WelcomeViewModelDelegate {

    var didCallPushViewController = false
    var didCallReloadRecentCities = false

    func pushViewController(viewController: UIViewController) {
        didCallPushViewController = true
    }

    func reloadRecentCities(_ cities: [City]) {
        didCallReloadRecentCities = true
    }

}


