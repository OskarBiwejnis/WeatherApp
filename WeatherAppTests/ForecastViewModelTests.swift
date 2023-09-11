import Combine
import Difference
import Nimble
import Quick
import SwiftyMocky
import XCTest
@testable import WeatherApp

class ForecastViewModelSpec: QuickSpec {

    override class func spec() {
        var testScheduler = TestScheduler<TimeInterval, Any>(now: TimeInterval())
        var networkingServiceMock = NetworkingServiceTypeMock()
        var stubCity = City()
        stubCity.name = "stub"
        var forecastViewModel: ForecastViewModelContract = ForecastViewModel(city: stubCity, networkingService: networkingServiceMock)
        var showErrorPublisherObserver: PublisherEventsObserver<Error>!
        var forecastPublisherObserver: PublisherEventsObserver<[ThreeHourForecastFormatted]>!
        var stubThreeHourForecastData = ThreeHourForecastData(list: [])
        var fetchForecastReturnValue: AnyPublisher<ThreeHourForecastData, NetworkingError> = Just(stubThreeHourForecastData).setFailureType(to: NetworkingError.self).eraseToAnyPublisher()

        describe("ForecastViewModel") {
            context("when intialized correctly") {
                beforeEach {
                    Given(networkingServiceMock, .fetchThreeHourForecast(city: .value(stubCity), willReturn: fetchForecastReturnValue))
                    forecastPublisherObserver = PublisherEventsObserver(forecastViewModel.forecastPublisher)
                    forecastViewModel = ForecastViewModel(city: stubCity, networkingService: networkingServiceMock)
                }


                it("sends formatted forecast for given city") {
                    expect(forecastPublisherObserver.values).toNot(beEmpty())
                }
            }

            context("when initialized wrong") {
                beforeEach {
                    Given(networkingServiceMock, .fetchThreeHourForecast(city: .value(stubCity), willReturn: Fail(error: NetworkingError.unknownError)
                        .eraseToAnyPublisher()))
                    showErrorPublisherObserver = PublisherEventsObserver(forecastViewModel.showErrorPublisher)
                    forecastViewModel = ForecastViewModel(city: stubCity, networkingService: networkingServiceMock)
                }

                it("shows an error") {
                    expect(showErrorPublisherObserver.values).toNot(beEmpty())
                }
            }
        }
    }
}
















//import XCTest
//@testable import WeatherApp
//
//final class ForecastViewModelTests: XCTestCase {
//
//    var forecastViewModel: ForecastViewModel!
//    var mockForecastViewModelDelegate: MockForecastViewModelDelegate!
//    var mockNetworkingService: MockNetworkingService!
//    var mockCity: City!
//
//    override func setUpWithError() throws {
//        mockNetworkingService = MockNetworkingService()
//        mockCity = City()
//        mockCity.name = "Miasto"
//        mockCity.country = "PL"
//        mockCity.latitude = 123.123
//        mockCity.longitude = 321.321
//        mockForecastViewModelDelegate = MockForecastViewModelDelegate()
//    }
//
//    override func tearDown() {
//        forecastViewModel = nil
//        mockForecastViewModelDelegate = nil
//        mockNetworkingService = nil
//        mockCity = nil
//        super.tearDown()
//    }
//
//    func testShouldCallDelegateFunctionWhenInitializing() throws {
//        XCTAssertFalse(mockForecastViewModelDelegate.didCallReloadTable)
//        let expectation = self.expectation(description: "Reloading Table")
//        mockForecastViewModelDelegate.expectationReloadTable = expectation
//
//        forecastViewModel = ForecastViewModel(city: mockCity, networkingService: mockNetworkingService)
//        forecastViewModel.delegate = mockForecastViewModelDelegate
//
//        waitForExpectations(timeout: 5)
//        XCTAssertTrue(mockForecastViewModelDelegate.didCallReloadTable)
//    }
//
//
//
//    func testShouldShowErrorWhenInitializingWentWrong() throws {
//        XCTAssertFalse(mockForecastViewModelDelegate.didCallShowError)
//        let expectation = self.expectation(description: "Show Error")
//        mockForecastViewModelDelegate.expectationShowError = expectation
//        var cityThatThrowsError = City()
//        cityThatThrowsError.name = MockNetworkingService.nameThatThrowsError
//
//        forecastViewModel = ForecastViewModel(city: cityThatThrowsError, networkingService: mockNetworkingService)
//        forecastViewModel.delegate = mockForecastViewModelDelegate
//
//        waitForExpectations(timeout: 5)
//        XCTAssertTrue(mockForecastViewModelDelegate.didCallShowError)
//    }
//
//
//    class MockForecastViewModelDelegate: ForecastViewModelDelegate {
//
//        var didCallReloadTable = false
//        var didCallShowError = false
//        var expectationReloadTable: XCTestExpectation?
//        var expectationShowError: XCTestExpectation?
//        var error: Error?
//
//        func reloadTable() {
//            didCallReloadTable = true
//            expectationReloadTable?.fulfill()
//        }
//
//        func showError(_ error: Error) {
//            didCallShowError = true
//            expectationShowError?.fulfill()
//            self.error = error
//        }
//
//    }
//
//    class MockNetworkingService: NetworkingServiceType {
//
//        static let nameThatThrowsError = "IWillThrowError"
//
//        func fetchCities(_ searchText: String) async throws -> [City] {
//            return []
//        }
//
//        func fetchThreeHourForecast(city: WeatherApp.City) async throws -> [ThreeHourForecast] {
//            var cityThatThrowsError = City()
//            cityThatThrowsError.name = Self.nameThatThrowsError
//            if city == cityThatThrowsError { throw MockError() }
//            return []
//        }
//
//    }
//
//    class MockError: Error {
//
//    }
//
//}
//
//
