import UIKit

class BaseCoordinator {

    var navigationController: UINavigationController
    var children: [BaseCoordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

    }

    func coordinate(to coordinator: BaseCoordinator) {
        children.append(coordinator)
        coordinator.start()
    }

}
