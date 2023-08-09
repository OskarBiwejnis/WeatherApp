import XCTest
@testable import WeatherApp

final class SearchViewModelTests: XCTestCase {

    var searchViewModel: SearchViewModel!
    var mockSearchViewModelDelegate: MockSearchViewModelDelegate!

    override func setUpWithError() throws {
        searchViewModel = SearchViewModel()
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
        let cityZero = City()
        let cityOne = City()
        let cityTwo = City()
        searchViewModel.cities = [cityZero, cityOne, cityTwo]
        XCTAssertNil(mockSearchViewModelDelegate.city)

        searchViewModel.didSelectSearchCell(didSelectRowAt: IndexPath(row: 1, section: 0))

        XCTAssertNotNil(mockSearchViewModelDelegate.city)
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



    func testShouldShowErrorInvalidUrlWhenSearchTextDidChangeWithIncorrectText() throws {
        XCTAssertFalse(mockSearchViewModelDelegate.didCallShowError)
        let expectation = self.expectation(description: "Show Error")
        mockSearchViewModelDelegate.expectationShowError = expectation

        searchViewModel.searchTextDidChange("6^& ćż [[")

        waitForExpectations(timeout: 5)
        XCTAssertTrue(mockSearchViewModelDelegate.didCallShowError)
        XCTAssertEqual(mockSearchViewModelDelegate.error as? NetworkingError, NetworkingError.invalidUrl)
    }

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
