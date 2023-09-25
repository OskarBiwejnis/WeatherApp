import Combine
import Swinject
import UIKit

class SearchCoordinator: BaseCoordinator {

    private var searchViewModel: SearchViewModelCoordinatorContract?
    private var subscriptions: [AnyCancellable] = []

    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }

    override func start() {
        let searchViewController = Assembler.shared.resolver.resolve(SearchViewController.self)!
        let searchViewModel = Assembler.shared.resolver.resolve(SearchViewModelCoordinatorContract.self)
        self.searchViewModel = searchViewModel
        bindActions()
        navigationController.pushViewController(searchViewController, animated: true)
    }


    private func goToForecastScreen(city: City) {
        let forecastCoordinator = ForecastCoordinator(navigationController: navigationController,
                                                      city: city)
        coordinate(to: forecastCoordinator)
    }

    private func bindActions() {
        searchViewModel?.navigationEventsPublisher
            .sink{ [weak self] navigationEvent in
                if case .openForecastScreen(let city) = navigationEvent {
                    self?.goToForecastScreen(city: city)
                }
            }
            .store(in: &subscriptions)
    }

}
