import Combine
import Difference
import Nimble
import Quick
import SwiftyMocky
import XCTest
@testable import WeatherApp

class ForecastViewModelSpec: QuickSpec {

    override class func spec() {
        var networkingServiceMock: NetworkingServiceTypeMock!
        var stubCity: City!
        var forecastViewModel: ForecastViewModelContract!
        var showErrorPublisherObserver: PublisherEventsObserver<Error>!
        var forecastPublisherObserver: PublisherEventsObserver<[ThreeHourForecastFormatted]>!
        var stubThreeHourForecast: ThreeHourForecast!
        var stubThreeHourForecastData: ThreeHourForecastData!
        var fetchForecastReturnValue: AnyPublisher<ThreeHourForecastData, NetworkingError>!

        beforeEach {
            networkingServiceMock = NetworkingServiceTypeMock()
            stubCity = City()
            stubCity.name = "stub"
            forecastViewModel = ForecastViewModel(city: stubCity, networkingService: networkingServiceMock)
            stubThreeHourForecast = ThreeHourForecast(main: ThreeHourForecastMain(temp: 1.23, humidity: 123),
                                                      weather: [ThreeHourForecastWeather(id: 123, weatherType: .clear)],
                                                      wind: ThreeHourForecastWind(speed: 1.23),
                                                      date: "112233 112233")
            stubThreeHourForecastData = ThreeHourForecastData(list: [stubThreeHourForecast])
            fetchForecastReturnValue = Just(stubThreeHourForecastData).setFailureType(to: NetworkingError.self).eraseToAnyPublisher()
        }

        describe("ForecastViewModel") {
            context("when intialized correctly") {
                beforeEach {
                    Given(networkingServiceMock, .fetchThreeHourForecast(city: .value(stubCity), willReturn: fetchForecastReturnValue))
                    forecastPublisherObserver = PublisherEventsObserver(forecastViewModel.forecastPublisher)
                    forecastViewModel = ForecastViewModel(city: stubCity, networkingService: networkingServiceMock)
                }


                it("sends formatted forecast") {
                    expect(forecastPublisherObserver.values).toNot(beEmpty())
                }

                it("sends formatted forecast with proper weather") {
                    expect(forecastPublisherObserver.values)
                        .to(equalDiff([[ThreeHourForecastFormatted(from: stubThreeHourForecast)]]))
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
                it("shows an error of proper kind") {
                    guard let networkingError = showErrorPublisherObserver.values.first as? NetworkingError
                    else { fail(); return }
                    expect(networkingError).to(equalDiff(NetworkingError.unknownError))
                }
            }
        }
    }
}
