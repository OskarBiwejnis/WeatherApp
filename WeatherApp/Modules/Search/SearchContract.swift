import Combine
import Foundation

protocol SearchViewModelContract {
    var eventsInputSubject: PassthroughSubject<SearchViewController.EventInput, Never> { get }
    var viewStatePublisher: AnyPublisher<SearchViewState, Never> { get }
}

protocol SearchViewModelCoordinatorContract {

    var navigationEventsPublisher: AnyPublisher<SearchNavigationEvent, Never> { get }

}

enum SearchViewState {
    case cities([City])
    case error(Error)
}

enum SearchNavigationEvent {
    case openForecastScreen(city: City)
}
