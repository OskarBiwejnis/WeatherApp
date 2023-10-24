import Combine
import Foundation

protocol ForecastViewModelContract {
    var city: City { get }
    var viewStatePublisher: AnyPublisher<ForecastViewState, Never> { get }
}

enum ForecastViewState {
    case forecast([ThreeHourForecastFormatted])
    case error(Error)
}


