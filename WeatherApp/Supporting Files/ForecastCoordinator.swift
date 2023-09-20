import Combine
import UIKit

class ForecastCoordinator: BaseCoordinator {

    init(navigationController: UINavigationController, parentCoordinator: BaseCoordinator?, city: City) {
        let forecastViewModel = ForecastViewModel(city: city,
                                                  networkingService: NetworkingService(),
                                                  storageService: StorageService())
        let forecastViewController = ForecastViewController(forecastViewModel: forecastViewModel)
        super.init(navigationController: navigationController, parentCoordinator: parentCoordinator)
        navigationController.pushViewController(forecastViewController, animated: true)
    }

}
