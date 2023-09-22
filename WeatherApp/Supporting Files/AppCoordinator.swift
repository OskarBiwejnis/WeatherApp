import Combine
import CombineSchedulers
import UIKit

class AppCoordinator: BaseCoordinator {

    override func start() {
        goToWelcomeScreen()
    }

    private func goToWelcomeScreen() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
        coordinate(to: welcomeCoordinator)
    }
    
}
