import Combine
import Swinject
import UIKit

class ForecastCoordinator: BaseCoordinator {

    private let moduleInput: ForecastViewModel.ModuleInput

    init(navigationController: UINavigationController, moduleInput: ForecastViewModel.ModuleInput) {
        self.moduleInput = moduleInput
        super.init(navigationController: navigationController)
    }

    override func start() {
        let forecastViewController = Assembler.shared.resolver.resolve(ForecastViewController.self, argument: moduleInput).forceResolve()
        navigationController.pushViewController(forecastViewController, animated: true)
    }

}
