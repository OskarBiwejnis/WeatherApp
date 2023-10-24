import Foundation
import Swinject
import SwinjectAutoregistration

class LoginAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(LoginViewModelContract.self, initializer: LoginViewModel.init)
        container.autoregister(LoginViewController.self, initializer: LoginViewController.init)
        container.autoregister(LoginCoordinator.self, argument: UINavigationController.self, initializer: LoginCoordinator.init)
    }
    
}