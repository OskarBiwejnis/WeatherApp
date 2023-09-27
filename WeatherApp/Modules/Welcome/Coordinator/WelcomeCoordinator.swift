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
        guard let welcomeViewModel = welcomeViewController.welcomeViewModel as? WelcomeViewModelCoordinatorContract
        else { return }
        bindActions(welcomeViewModel: welcomeViewModel)
        navigationController.pushViewController(welcomeViewController, animated: true)
    }

    private func goToSearchScreen() {
        let searchCoordinator = Assembler.shared.resolver
            .resolve(SearchCoordinator.self, argument: navigationController).forceResolve()
        coordinate(to: searchCoordinator)
    }

    private func goToForecastScreen(city: City) {
        let forecastCoordinator = Assembler.shared.resolver
            .resolve(ForecastCoordinator.self,
                     arguments: navigationController, ForecastViewModel.ModuleInput(city: city)).forceResolve()
        coordinate(to: forecastCoordinator)
    }

    private func bindActions(welcomeViewModel: WelcomeViewModelCoordinatorContract) {
        welcomeViewModel.navigationEventsPublisher
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
