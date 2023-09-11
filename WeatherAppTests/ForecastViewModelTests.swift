import Combine
import Difference
import Nimble
import Quick
import SwiftyMocky
import XCTest
@testable import WeatherApp

class ForecastViewModelSpec: QuickSpec {

    override class func spec() {
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
