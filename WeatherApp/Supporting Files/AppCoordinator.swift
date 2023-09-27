import Combine
import CombineSchedulers
import Swinject
import UIKit

class AppCoordinator: BaseCoordinator {

    override func start() {
        goToWelcomeScreen()
    }

    private func goToWelcomeScreen() {
        let welcomeCoordinator = Assembler.shared.resolver
            .resolve(WelcomeCoordinator.self, argument: navigationController).forceResolve()
        coordinate(to: welcomeCoordinator)
    }
    
}
