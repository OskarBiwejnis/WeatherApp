import Foundation
import Swinject

// swiftlint: disable all

class SearchAssembly: Assembly {

    func assemble(container: Container) {
        container.register(SearchViewModelContract.self) { resolver in
            let networkingService = resolver.resolve(NetworkingServiceType.self)!
            let scheduler = DispatchQueue.main.eraseToAnyScheduler()
            return SearchViewModel(networkingService: networkingService, scheduler: scheduler)
        }.inObjectScope(.weak)
        container.register(SearchViewController.self) { resolver in
            let searchViewModel = resolver.resolve(SearchViewModelContract.self)!
            return SearchViewController(searchViewModel: searchViewModel)
        }
        container.register(SearchViewModelCoordinatorContract.self) { resolver in
            return resolver.resolve(SearchViewModelContract.self)! as! SearchViewModelCoordinatorContract
        }
    }

}
