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
        let searchViewController = Assembler.shared.resolver.resolve(SearchViewController.self).forceResolve()
        guard let searchViewModel = searchViewController.searchViewModel as? SearchViewModelCoordinatorContract
        else { return }
        bindActions(searchViewModel: searchViewModel)
        navigationController.pushViewController(searchViewController, animated: true)
    }


    private func goToForecastScreen(city: City) {
        let forecastCoordinator = Assembler.shared.resolver
            .resolve(ForecastCoordinator.self,
                     arguments: navigationController, ForecastViewModel.ModuleInput(city: city)).forceResolve()
        coordinate(to: forecastCoordinator)
    }

    private func bindActions(searchViewModel: SearchViewModelCoordinatorContract) {
        searchViewModel.navigationEventsPublisher
            .sink{ [weak self] navigationEvent in
                if case .openForecastScreen(let city) = navigationEvent {
                    self?.goToForecastScreen(city: city)
                }
            }
            .store(in: &subscriptions)
    }

}
