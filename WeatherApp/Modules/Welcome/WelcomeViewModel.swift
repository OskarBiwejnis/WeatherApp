import Combine
import UIKit

protocol WelcomeViewModelContract {

    var recentCities: [City] { get }

    var eventsInputSubject: PassthroughSubject<WelcomeViewController.EventInput, Never> { get }
    var reloadRecentCitiesPublisher: AnyPublisher<[City], Never> { get }

}

protocol WelcomeViewModelCoordinatorContract {

    var navigationEventsPublisher: AnyPublisher<WelcomeNavigationEvent, Never> { get }

}

enum WelcomeNavigationEvent {
    case didSelectRecentCity(city: City)
    case proceedButtonTap
}

class WelcomeViewModel: WelcomeViewModelContract, WelcomeViewModelCoordinatorContract {
    
    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    var recentCities: [City] = []
    let eventsInputSubject = PassthroughSubject<WelcomeViewController.EventInput, Never>()

    private let storageService: StorageServiceType

    // MARK: - Initialization -

    init(storageService: StorageServiceType) {
        self.storageService = storageService
    }
    
    // MARK: - Public -

    lazy var reloadRecentCitiesPublisher: AnyPublisher<[City], Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .viewWillAppear = event {
                let recentCities = self?.storageService.getRecentCities() ?? []
                self?.recentCities = recentCities
                return recentCities
            } else { return nil }
        }
        .eraseToAnyPublisher()

    lazy var navigationEventsPublisher: AnyPublisher<WelcomeNavigationEvent, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .didSelectRecentCity(let row) = event, let city = self?.recentCities[row] {
                return WelcomeNavigationEvent.didSelectRecentCity(city: city)
            } else if case .proceedButtonTap = event {
                return WelcomeNavigationEvent.proceedButtonTap
            } else { return nil }
        }
        .eraseToAnyPublisher()

}
