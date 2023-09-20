import Combine
import UIKit

class WelcomeCoordinator: BaseCoordinator {

    private var welcomeViewModel: WelcomeViewModelCoordinatorContract?
    private var subscriptions: [AnyCancellable] = []

    override init(navigationController: UINavigationController)  {
        super.init(navigationController: navigationController)
    }

    override func start() {
        let welcomeViewModel = WelcomeViewModel(storageService: StorageService())
        let welcomeViewController = WelcomeViewController(welcomeViewModel: welcomeViewModel)
        self.welcomeViewModel = welcomeViewModel as WelcomeViewModelCoordinatorContract
        bindActions()
        navigationController.pushViewController(welcomeViewController, animated: true)
    }

    private func goToSearchScreen() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        coordinate(to: searchCoordinator)
    }

    private func goToForecastScreen(city: City) {
        let forecastCoordinator = ForecastCoordinator(navigationController: navigationController,
                                                      city: city)
        coordinate(to: forecastCoordinator)
    }

    private func bindActions() {
        welcomeViewModel?.navigationEventsPublisher
            .sink { [weak self] navigationEvent in
                switch navigationEvent {
                case .proceedButtonTap:
                    self?.goToSearchScreen()
                case .didSelectRecentCity(let city):
                    self?.goToForecastScreen(city: city)
                }
            }
            .store(in: &subscriptions)
    }
    
}
