import Combine
import UIKit

protocol WelcomeViewModelContract {

    var recentCities: [City] { get }

    var appCoordinator: Coordinator? { get }
    var eventsInputSubject: PassthroughSubject<WelcomeViewController.EventInput, Never> { get }
    var reloadRecentCitiesPublisher: AnyPublisher<[City], Never> { get }
    var openSearchScreenPublisher: AnyPublisher<Void, Never> { get }
    var openForecastPublisher: AnyPublisher<City, Never> { get }

}

class WelcomeViewModel: WelcomeViewModelContract {
    
    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    var recentCities: [City] = []
    let eventsInputSubject = PassthroughSubject<WelcomeViewController.EventInput, Never>()

    weak var appCoordinator: Coordinator?
    private let storageService: StorageServiceType

    // MARK: - Initialization -

    init(storageService: StorageServiceType, appCoordinator: AppCoordinator) {
        self.storageService = storageService
        self.appCoordinator = appCoordinator
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
    lazy var openSearchScreenPublisher: AnyPublisher<Void, Never> = eventsInputSubject
        .filter { $0 == .proceedButtonTap }
        .map { _ in return () }
        .eraseToAnyPublisher()
    lazy var openForecastPublisher: AnyPublisher<City, Never> = eventsInputSubject
            .compactMap { [weak self] event in
                if case let .didSelectRecentCity(row) = event { return self?.recentCities[row] } else { return nil }
            }
            .eraseToAnyPublisher()

}
