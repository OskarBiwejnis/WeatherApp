import UIKit

class BaseCoordinator {

    weak var parentCoordinator: BaseCoordinator?
    var children: [BaseCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, parentCoordinator: BaseCoordinator?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }

}
