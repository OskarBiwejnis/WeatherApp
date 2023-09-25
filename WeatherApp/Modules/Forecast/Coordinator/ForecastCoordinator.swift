import Combine
import Swinject
import UIKit

class ForecastCoordinator: BaseCoordinator {

    private let city: City

    init(navigationController: UINavigationController, city: City) {
        self.city = city
        super.init(navigationController: navigationController)
    }

    override func start() {
        let forecastViewController = Assembler.shared.resolver.resolve(ForecastViewController.self, argument: city)!
        navigationController.pushViewController(forecastViewController, animated: true)
    }

}
