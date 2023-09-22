import Combine
import UIKit

class ForecastCoordinator: BaseCoordinator {

    private let city: City

    init(navigationController: UINavigationController, city: City) {
        self.city = city
        super.init(navigationController: navigationController)
    }

    override func start() {
        let forecastViewModel = ForecastViewModel(city: city,
                                                  networkingService: NetworkingService(),
                                                  storageService: StorageService())
        let forecastViewController = ForecastViewController(forecastViewModel: forecastViewModel)
        navigationController.pushViewController(forecastViewController, animated: true)
    }
}
