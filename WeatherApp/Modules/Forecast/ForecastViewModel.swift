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
                formattedForecasts.append(ThreeHourForecastFormatted(from: forecast))
            }
            return formattedForecasts
        }
        .eraseToAnyPublisher()

    lazy var showErrorPublisher: AnyPublisher<Error, Never> = fetchResultPublisher
        .extractFailure()
        .eraseToAnyPublisher()


    // MARK: - Private -

    private lazy var fetchResultPublisher = networkingService.fetchThreeHourForecast(city: city).toResult()

}
