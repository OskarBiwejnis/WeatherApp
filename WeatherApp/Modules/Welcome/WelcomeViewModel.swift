import Combine
import UIKit

protocol WelcomeViewModelContract {

    var recentCities: [City] { get }

    var eventsInputSubject: PassthroughSubject<WelcomeViewController.EventInput, Never> { get }
    var reloadRecentCitiesPublisher: AnyPublisher<[City], Never> { get }

}

class WelcomeViewModel: WelcomeViewModelContract, Navigable {
    
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

    lazy var navigationEventsPublisher: AnyPublisher<NavigationEvent, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .didSelectRecentCity(let row) = event, let city = self?.recentCities[row] {
                return NavigationEvent.didSelectCity(city: city)
            } else if case .proceedButtonTap = event {
                return NavigationEvent.proceedButtonTap
            } else { return nil }
        }
        .eraseToAnyPublisher()

}
