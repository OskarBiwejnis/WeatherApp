import Combine
import Swinject
import SwinjectAutoregistration
import UIKit

class LoginCoordinator: BaseCoordinator {

    private var subscriptions: [AnyCancellable] = []

    override init(navigationController: UINavigationController)  {
        super.init(navigationController: navigationController)
    }

    override func start() {
        let loginViewController = Assembler.shared.resolver.resolve(LoginViewController.self).forceResolve()
        navigationController.pushViewController(loginViewController, animated: false)



   
//        guard let welcomeViewModel = welcomeViewController.welcomeViewModel as? WelcomeViewModelCoordinatorContract
//        else { return }
//        bindActions(welcomeViewModel: welcomeViewModel)

    }

    private func bindActions(  ) {

    }
}
