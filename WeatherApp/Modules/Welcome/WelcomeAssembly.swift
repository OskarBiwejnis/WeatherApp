import Foundation
import Swinject
import SwinjectAutoregistration

class WelcomeAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(WelcomeViewModelContract.self, initializer: WelcomeViewModel.init)
            .inObjectScope(.weak)
        container.autoregister(WelcomeViewController.self, initializer: WelcomeViewController.init)
        container.register(WelcomeViewModelCoordinatorContract.self) { resolver in
            return resolver.resolve(WelcomeViewModelContract.self).forceResolve() as WelcomeViewModelCoordinatorContract
        }
    }

}
