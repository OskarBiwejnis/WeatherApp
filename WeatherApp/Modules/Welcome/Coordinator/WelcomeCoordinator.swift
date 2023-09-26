import Combine
import Swinject
import UIKit

class WelcomeCoordinator: BaseCoordinator {

    private var welcomeViewModel: WelcomeViewModelCoordinatorContract?
    private var subscriptions: [AnyCancellable] = []

    override init(navigationController: UINavigationController)  {
        super.init(navigationController: navigationController)
    }

    override func start() {

        let welcomeViewController = Assembler.shared.resolver.resolve(WelcomeViewController.self).forceResolve()
        let welcomeViewModel = Assembler.shared.resolver.resolve(WelcomeViewModelCoordinatorContract.self)
        self.welcomeViewModel = welcomeViewModel
        bindActions()
        navigationController.pushViewController(welcomeViewController, animated: true)
    }

    private func goToSearchScreen() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        coordinate(to: searchCoordinator)
    }

    private func goToForecastScreen(city: City) {
        let forecastCoordinator = ForecastCoordinator(navigationController: navigationController,
                                                      moduleInput: ForecastViewModel.ModuleInput(city: city))
        coordinate(to: forecastCoordinator)
    }

    private func bindActions() {
        welcomeViewModel?.navigationEventsPublisher
            .sink { [weak self] navigationEvent in
                switch navigationEvent {
                case .openSearchScreen:
                    self?.goToSearchScreen()
                case .openForecastScreen(let city):
                    self?.goToForecastScreen(city: city)
                }
            }
            .store(in: &subscriptions)
    }
    
}
