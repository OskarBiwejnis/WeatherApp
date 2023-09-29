import Combine
import UIKit

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
    case openForecastScreen(city: City)
    case openSearchScreen
}

class WelcomeViewModel: WelcomeViewModelContract, WelcomeViewModelCoordinatorContract {
    
    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []
    private var recentCities: [City] = []

    let eventsInputSubject = PassthroughSubject<WelcomeViewController.EventInput, Never>()

    private let storageService: StorageServiceType

    // MARK: - Initialization -

    init(storageService: StorageServiceType) {
        self.storageService = storageService
    }
    
    // MARK: - Public -

    lazy var viewStatePublisher: AnyPublisher<WelcomeViewState, Never> = reloadRecentCitiesPublisher
        .map { .cities($0) }
        .eraseToAnyPublisher()

    lazy var navigationEventsPublisher: AnyPublisher<WelcomeNavigationEvent, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .didSelectRecentCity(let row) = event, let city = self?.recentCities[row] {
                return WelcomeNavigationEvent.openForecastScreen(city: city)
            } else if case .proceedButtonTap = event {
                return WelcomeNavigationEvent.openSearchScreen
            } else { return nil }
        }
        .eraseToAnyPublisher()

    // MARK: - Private -

    private lazy var reloadRecentCitiesPublisher: AnyPublisher<[City], Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .viewWillAppear = event {
                let recentCities = self?.storageService.getRecentCities() ?? []
                self?.recentCities = recentCities
                return recentCities
            } else { return nil }
        }
        .eraseToAnyPublisher()

}
