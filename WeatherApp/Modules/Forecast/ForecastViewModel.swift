import Combine
import Foundation
import UIKit

protocol ForecastViewModelContract {

    var forecastPublisher: AnyPublisher<[ThreeHourForecastFormatted], Never> { get }
    var showErrorPublisher: AnyPublisher<Error, Never> { get }

}

class ForecastViewModel: ForecastViewModelContract {

    // MARK: - Constants -

    private enum Constants {
        static let degreeSign = "°"
        static let percentSign = "%"
        static let speedUnit = " kmh"
        static let hourFormatWithoutSeconds = 5
        static let space = " "
        static let secondPartOfDateFormat = 1
        static let kelvinUnitOffset = 273.15
        static let weatherMainPart = 0
        static let numberOfDisplayedForecasts = 15
    }

    // MARK: - Variables -

    private let city: City
    private var subscriptions: [AnyCancellable] = []

    private let networkingService: NetworkingServiceType

    // MARK: - Initialization -

    init(city: City, networkingService: NetworkingServiceType) {
        self.networkingService = networkingService
        self.city = city
    }

    // MARK: - Public -

    lazy var forecastPublisher: AnyPublisher<[ThreeHourForecastFormatted], Never> = fetchResultPublisher
        .extractResult()
        .map { forecastData in
            let forecasts = forecastData.list
            var formattedForecasts: [ThreeHourForecastFormatted] = []

            for forecast in forecasts.prefix(Constants.numberOfDisplayedForecasts){
                formattedForecasts.append(self.getThreeHourForecastFormatted(forecast: forecast))
            }
            return formattedForecasts
        }
        .eraseToAnyPublisher()

    lazy var showErrorPublisher: AnyPublisher<Error, Never> = fetchResultPublisher
        .extractFailure()
        .eraseToAnyPublisher()


    // MARK: - Private -

    private lazy var fetchResultPublisher = networkingService.fetchThreeHourForecast(city: city).toResult()

    private func getThreeHourForecastFormatted(forecast: ThreeHourForecast) -> ThreeHourForecastFormatted {
       let hour = String(String(forecast.date
           .split(separator: Constants.space)[Constants.secondPartOfDateFormat])
           .prefix(Constants.hourFormatWithoutSeconds))
       let temperature = String(Int(forecast.main.temp - Constants.kelvinUnitOffset)) + Constants.degreeSign
       let humidity = String(forecast.main.humidity) + Constants.percentSign
       let wind = String(Int(forecast.wind.speed)) + Constants.speedUnit
       let skyImage = forecast.weather[Constants.weatherMainPart].weatherType.image

       return ThreeHourForecastFormatted(hour: hour, temperature: temperature, humidity: humidity, wind: wind, skyImage: skyImage)
   }

}
