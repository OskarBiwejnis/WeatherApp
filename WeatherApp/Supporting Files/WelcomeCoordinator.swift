import Combine
import UIKit

class WelcomeCoordinator: BaseCoordinator {

    private let welcomeNavigable: Navigable
    private var subscriptions: [AnyCancellable] = []

    override init(navigationController: UINavigationController, parentCoordinator: BaseCoordinator?)  {
        let welcomeViewModel = WelcomeViewModel(storageService: StorageService())
        let welcomeViewController = WelcomeViewController(welcomeViewModel: welcomeViewModel)
        welcomeNavigable = welcomeViewModel as Navigable
        super.init(navigationController: navigationController, parentCoordinator: parentCoordinator)
        bindActions()
        navigationController.pushViewController(welcomeViewController, animated: true)
    }

    private func goToSearchScreen() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController,
                                                  parentCoordinator: self)
        children.append(searchCoordinator)
    }

    private func goToForecastScreen(city: City) {
        let forecastCoordinator = ForecastCoordinator(navigationController: navigationController,
                                                      parentCoordinator: self,
                                                      city: city)
        children.append(forecastCoordinator)
    }

    private func bindActions() {
        welcomeNavigable.navigationEventsPublisher
            .sink { [weak self] navigationEvent in
                switch navigationEvent {
                case .proceedButtonTap:
                    self?.goToSearchScreen()
                case .didSelectCity(let city):
                    self?.goToForecastScreen(city: city)
                }
            }
            .store(in: &subscriptions)
    }
    
}
