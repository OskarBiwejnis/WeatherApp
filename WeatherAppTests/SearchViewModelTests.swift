import XCTest
@testable import WeatherApp

final class SearchViewModelTests: XCTestCase {

    var searchViewModel: SearchViewModel!
    var mockSearchViewModelDelegate: MockSearchViewModelDelegate!
    var mockNetworkingService: MockNetworkingService!

    override func setUpWithError() throws {
        mockNetworkingService = MockNetworkingService()
        searchViewModel = SearchViewModel(networkingService: mockNetworkingService)
        mockSearchViewModelDelegate = MockSearchViewModelDelegate()
        searchViewModel.delegate = mockSearchViewModelDelegate
    }

    override func tearDown() {
        searchViewModel = nil
        mockSearchViewModelDelegate = nil
        super.tearDown()
    }

    func testShouldCallDelegateFunctionWhenDidSelectSearchCell() throws {
        searchViewModel.cities = [City(), City(), City()]
        XCTAssertFalse(mockSearchViewModelDelegate.didCallOpenCityForecast)

        searchViewModel.didSelectSearchCell(didSelectRowAt: IndexPath(row: 1, section: 0))

        XCTAssertTrue(mockSearchViewModelDelegate.didCallOpenCityForecast)
    }

    func testShouldSelectProperCityWhenDidSelectSearchCell() throws {
        var cityZero = City()
        cityZero.name = "Zero"
        cityZero.latitude = 0.0
        var cityOne = City()
        cityOne.name = "One"
        cityOne.latitude = 1.1
        var cityTwo = City()
        cityTwo.name = "Two"
        cityTwo.latitude = 2.2
        searchViewModel.cities = [cityZero, cityOne, cityTwo]
        XCTAssertNotEqual(cityZero, cityOne)
        XCTAssertNotEqual(cityOne, cityTwo)
        XCTAssertNil(mockSearchViewModelDelegate.city)

        searchViewModel.didSelectSearchCell(didSelectRowAt: IndexPath(row: 1, section: 0))

        XCTAssertEqual(mockSearchViewModelDelegate.city, cityOne)
    }

    func testShouldCallDelegateFunctionWhenSearchTextDidChange() throws {
        XCTAssertFalse(mockSearchViewModelDelegate.didCallReloadTable)
        let expectation = self.expectation(description: "Reloading Table")
        mockSearchViewModelDelegate.expectationReloadTable = expectation

        searchViewModel.searchTextDidChange("War")

        waitForExpectations(timeout: 5)
        XCTAssertTrue(mockSearchViewModelDelegate.didCallReloadTable)
    }



    func testShouldShowErrorWhenSearchTextDidChangeWithIncorrectText() throws {
        XCTAssertFalse(mockSearchViewModelDelegate.didCallShowError)
        let expectation = self.expectation(description: "Show Error")
        mockSearchViewModelDelegate.expectationShowError = expectation

        searchViewModel.searchTextDidChange(MockNetworkingService.stringThatThrowsError)

        waitForExpectations(timeout: 5)
        XCTAssertTrue(mockSearchViewModelDelegate.didCallShowError)
        XCTAssert(mockSearchViewModelDelegate.error is MockError)
    }

    class MockSearchViewModelDelegate: SearchViewModelDelegate {

        var didCallOpenCityForecast = false
        var didCallReloadTable = false
        var didCallShowError = false
        var city: City?
        var expectationReloadTable: XCTestExpectation?
        var expectationShowError: XCTestExpectation?
        var error: Error?

        func openCityForecast(city: City) {
            didCallOpenCityForecast = true
            self.city = city
        }

        func reloadTable() {
            didCallReloadTable = true
            expectationReloadTable?.fulfill()
        }

        func showError(_ error: Error) {
            didCallShowError = true
            expectationShowError?.fulfill()
            self.error = error
        }

    }

    class MockNetworkingService: NetworkingServiceType {

        static let stringThatThrowsError = "ThisStringThrowsError"

        func fetchCities(_ searchText: String) async throws -> [City] {
            if searchText == Self.stringThatThrowsError { throw MockError() }
            return []
        }

        func fetchThreeHourForecast(city: WeatherApp.City) async throws -> [ThreeHourForecast] {
            return []
        }

    }

    class MockError: Error {

    }

}

