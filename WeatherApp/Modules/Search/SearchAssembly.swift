import Foundation
import Swinject
import SwinjectAutoregistration

class SearchAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(SearchViewModelContract.self, initializer: SearchViewModel.init)
            .inObjectScope(.weak)
        container.autoregister(SearchViewController.self, initializer: SearchViewController.init)
        container.register(SearchViewModelCoordinatorContract.self) { resolver in
            return resolver.resolve(SearchViewModelContract.self).forceResolve() as SearchViewModelCoordinatorContract
        }
    }

}
