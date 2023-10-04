import Combine
import Swinject
import SwinjectAutoregistration
import UIKit

class LoginCoordinator: BaseCoordinator {

    private var subscriptions: [AnyCancellable] = []

    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
    }

    override func start() {
        let loginViewController = Assembler.shared.resolver.resolve(LoginViewController.self).forceResolve()
        navigationController.pushViewController(loginViewController, animated: false)
        guard let loginViewModel = loginViewController.loginViewModel as? LoginViewModelCoordinatorContract
        else { return }
        bindActions(loginViewModel: loginViewModel)
    }

    private func dismissItself() {
        navigationController.popViewController(animated: false)
    }

    private func bindActions(loginViewModel: LoginViewModelCoordinatorContract) {
        loginViewModel.navigationEventsPublisher
            .sink { [weak self] navigationEvent in
                if case .dismiss = navigationEvent {
                    self?.dismissItself()
                }
            }
            .store(in: &subscriptions)
    }
}
