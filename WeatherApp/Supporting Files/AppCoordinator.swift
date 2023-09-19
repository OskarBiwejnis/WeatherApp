import Combine
import CombineSchedulers
import UIKit

class AppCoordinator: Coordinator {

    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        goToWelcomeScreen()
    }

    func goToWelcomeScreen() {
        let welcomeViewModel = WelcomeViewModel(storageService: StorageService(), appCoordinator: self)
        let welcomeViewController = WelcomeViewController(welcomeViewModel: welcomeViewModel)
        navigationController.pushViewController(welcomeViewController, animated: true)
    }

    func goToSearchScreen() {
        let searchViewModel = SearchViewModel(networkingService: NetworkingService(),
                                              scheduler: DispatchQueue.main.eraseToAnyScheduler(),
                                              appCoordinator: self)
        let searchViewController = SearchViewController(searchViewModel: searchViewModel)
        navigationController.pushViewController(searchViewController, animated: true)
    }

    func goToForecastScreen(city: City) {
        let forecastViewModel = ForecastViewModel(city: city,
                                                  networkingService: NetworkingService(),
                                                  storageService: StorageService(),
                                                  appCoordinator: self)
        let forecastViewController = ForecastViewController(forecastViewModel: forecastViewModel)
        navigationController.pushViewController(forecastViewController, animated: true)
    }
}
