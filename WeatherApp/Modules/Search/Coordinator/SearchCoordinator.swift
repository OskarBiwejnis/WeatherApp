import Combine
import UIKit

class SearchCoordinator: BaseCoordinator {

    private var searchViewModel: SearchViewModelCoordinatorContract?
    private var subscriptions: [AnyCancellable] = []

    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }

    override func start() {
        let searchViewModel = SearchViewModel(networkingService: NetworkingService(),
                                              scheduler: DispatchQueue.main.eraseToAnyScheduler())
        let searchViewController = SearchViewController(searchViewModel: searchViewModel)
        self.searchViewModel = searchViewModel as SearchViewModelCoordinatorContract
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
                if case .didSelectCity(let city) = navigationEvent {
                    self?.goToForecastScreen(city: city)
                }
            }
            .store(in: &subscriptions)
    }
}
