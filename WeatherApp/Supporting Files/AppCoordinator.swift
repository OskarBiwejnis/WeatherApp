import Combine
import CombineSchedulers
import UIKit

class AppCoordinator: BaseCoordinator {

    func start() {
        goToWelcomeScreen()
    }

    private func goToWelcomeScreen() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController, parentCoordinator: self)

        children.append(welcomeCoordinator)
    }
    
}
