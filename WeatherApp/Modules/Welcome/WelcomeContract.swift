import Combine
import Foundation

protocol WelcomeViewModelContract {

    var eventsInputSubject: PassthroughSubject<WelcomeViewController.EventInput, Never> { get }
    var viewStatePublisher: AnyPublisher<WelcomeViewState, Never> { get }

}

protocol WelcomeViewModelCoordinatorContract {

    var navigationEventsPublisher: AnyPublisher<WelcomeNavigationEvent, Never> { get }

}

enum WelcomeViewState {
    case cities([City])
}

enum WelcomeNavigationEvent {
    case openLoginScreen
    case openForecastScreen(city: City)
    case openSearchScreen
}
