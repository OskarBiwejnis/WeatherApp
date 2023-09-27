import Foundation
import Swinject
import SwinjectAutoregistration

class SearchAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(SearchViewModelContract.self, initializer: SearchViewModel.init)
            .inObjectScope(.weak)
        container.autoregister(SearchViewController.self, initializer: SearchViewController.init)
        container.autoregister(SearchCoordinator.self, argument: UINavigationController.self, initializer: SearchCoordinator.init)
    }

}
