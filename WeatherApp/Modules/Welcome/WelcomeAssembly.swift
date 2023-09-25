import Foundation
import Swinject

// swiftlint: disable all

class WelcomeAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WelcomeViewModelContract.self) { resolver in
            let storageService = resolver.resolve(StorageServiceType.self)!
            return WelcomeViewModel(storageService: storageService)
        }.inObjectScope(.weak)
        container.register(WelcomeViewController.self) { resolver in
            let welcomeViewModel = resolver.resolve(WelcomeViewModelContract.self)!
            return WelcomeViewController(welcomeViewModel: welcomeViewModel)
        }
        container.register(WelcomeViewModelCoordinatorContract.self) { resolver in
            return resolver.resolve(WelcomeViewModelContract.self)! as! WelcomeViewModelCoordinatorContract
        }
    }

}
