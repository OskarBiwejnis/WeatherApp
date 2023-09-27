import Foundation
import Swinject
import SwinjectAutoregistration

class WelcomeAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(WelcomeViewModelContract.self, initializer: WelcomeViewModel.init)
            .inObjectScope(.weak)
        container.autoregister(WelcomeViewController.self, initializer: WelcomeViewController.init)
        container.autoregister(WelcomeCoordinator.self, argument: UINavigationController.self, initializer: WelcomeCoordinator.init)
    }

}
