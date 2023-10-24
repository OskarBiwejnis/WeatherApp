import Combine
import UIKit

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
            switch event {
            case .loginButtonTap:
                return WelcomeNavigationEvent.openLoginScreen
            case let .didSelectRecentCity(row):
                guard let city = self?.recentCities[row] else { return nil }
                return WelcomeNavigationEvent.openForecastScreen(city: city)
            case .proceedButtonTap:
                return WelcomeNavigationEvent.openSearchScreen
            default:
                return nil
            }
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
