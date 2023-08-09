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
        XCTAssertFalse(mockWelcomeViewModelDelegate.didCallOpenSearchScreen)
        welcomeViewModel.proceedButtonTap()
        XCTAssertTrue(mockWelcomeViewModelDelegate.didCallOpenSearchScreen)
    }

    func testShouldCallDelegateFunctionWhenViewWillAppear() throws {
        XCTAssertFalse(mockWelcomeViewModelDelegate.didCallReloadRecentCities)
        welcomeViewModel.viewWillAppear()
        XCTAssertTrue(mockWelcomeViewModelDelegate.didCallReloadRecentCities)
    }

    func testShouldCallDelegateFunctionWhendidSelectRecentCity() throws {
        XCTAssertFalse(mockWelcomeViewModelDelegate.didCallOpenCityForecast)
        welcomeViewModel.didSelectRecentCity(City())
        XCTAssertTrue(mockWelcomeViewModelDelegate.didCallOpenCityForecast)
    }

}

class MockWelcomeViewModelDelegate: WelcomeViewModelDelegate {

    var didCallOpenCityForecast = false
    var didCallOpenSearchScreen = false
    var didCallReloadRecentCities = false

    func openCityForecast(_ city: City) {
        didCallOpenCityForecast = true
    }

    func openSearchScreen() {
        didCallOpenSearchScreen = true
    }

    func reloadRecentCities(_ cities: [City]) {
        didCallReloadRecentCities = true
    }

}


