import Combine
import Foundation
import UIKit

protocol ForecastViewModelContract {
    var city: City { get }
    var viewStatePublisher: AnyPublisher<ForecastViewState, Never> { get }
}

enum ForecastViewState {
    case forecast([ThreeHourForecastFormatted])
    case error(Error)
}


class ForecastViewModel: ForecastViewModelContract {

    // MARK: - Constants -

    private enum Constants {
        static let numberOfDisplayedForecasts = 15
    }

    struct ModuleInput {
        let city: City
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    let city: City

    private let networkingService: NetworkingServiceType
    private let storageService: StorageServiceType

    // MARK: - Initialization -

    init(moduleInput: ModuleInput,
         networkingService: NetworkingServiceType,
         storageService: StorageServiceType) {
        self.city = moduleInput.city
        self.networkingService = networkingService
        self.storageService = storageService
        storageService.addRecentCity(city)
    }

    // MARK: - Public -

    lazy var viewStatePublisher: AnyPublisher<ForecastViewState, Never> = forecastPublisher
        .map { .forecast($0) }
        .merge(with: showErrorPublisher.map { .error($0) })
        .eraseToAnyPublisher()


    // MARK: - Private -

    private lazy var fetchResultPublisher = networkingService.fetchThreeHourForecast(city: city).toResult()

    private lazy var forecastPublisher: AnyPublisher<[ThreeHourForecastFormatted], Never> = fetchResultPublisher
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

    private lazy var showErrorPublisher: AnyPublisher<Error, Never> = fetchResultPublisher
        .extractFailure()
        .eraseToAnyPublisher()

}
