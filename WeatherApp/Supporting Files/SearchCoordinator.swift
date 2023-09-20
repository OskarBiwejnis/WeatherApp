import Combine
import UIKit

class SearchCoordinator: BaseCoordinator {

    private let searchNavigable: Navigable
    private var subscriptions: [AnyCancellable] = []

    override init(navigationController: UINavigationController, parentCoordinator: BaseCoordinator?) {
        let searchViewModel = SearchViewModel(networkingService: NetworkingService(),
                                              scheduler: DispatchQueue.main.eraseToAnyScheduler())
        let searchViewController = SearchViewController(searchViewModel: searchViewModel)
        self.searchNavigable = searchViewModel as Navigable
        super.init(navigationController: navigationController, parentCoordinator: parentCoordinator)
        bindActions()
        navigationController.pushViewController(searchViewController, animated: true)
    }



    private func goToForecastScreen(city: City) {
        let forecastCoordinator = ForecastCoordinator(navigationController: navigationController,
                                                      parentCoordinator: self,
                                                      city: city)
        children.append(forecastCoordinator)
    }

    private func bindActions() {
        searchNavigable.navigationEventsPublisher
            .sink{ [weak self] navigationEvent in
                if case .didSelectCity(let city) = navigationEvent {
                    self?.goToForecastScreen(city: city)
                }
            }
            .store(in: &subscriptions)
    }
}
