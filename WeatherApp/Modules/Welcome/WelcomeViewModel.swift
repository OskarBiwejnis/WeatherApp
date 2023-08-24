import Combine
import UIKit

protocol WelcomeViewModelContract {

    var eventsInputSubject: PassthroughSubject<WelcomeViewController.EventInput, Never> { get }
    var reloadRecentCitiesPublisher: AnyPublisher<Void, Never> { get }
    var openSearchScreenPublisher: AnyPublisher<Void, Never> { get }
    var openForecastPublisher: AnyPublisher<City, Never> { get }

}

class WelcomeViewModel: WelcomeViewModelContract {
    
    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    var recentCities: [City] = []
    let eventsInputSubject = PassthroughSubject<WelcomeViewController.EventInput, Never>()

    lazy var reloadRecentCitiesPublisher: AnyPublisher<Void, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .viewWillAppear = event {
                self?.recentCities = self?.storageService.getRecentCities() ?? []
                return ()
            } else { return nil }
        }
        .eraseToAnyPublisher()
    lazy var openSearchScreenPublisher: AnyPublisher<Void, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .proceedButtonTap = event { return () }
            else { return nil }
        }
        .eraseToAnyPublisher()
    lazy var openForecastPublisher: AnyPublisher<City, Never> = eventsInputSubject
            .compactMap { [weak self] event in
                if case let .didSelectRecentCity(row) = event { return self?.recentCities[row] }
                else { return nil }
            }
            .eraseToAnyPublisher()

    private let storageService: StorageServiceType = StorageService()
    
}
