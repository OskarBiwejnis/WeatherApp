import Foundation
import Swinject
import SwinjectAutoregistration

class ForecastAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(ForecastViewModelContract.self, argument: ForecastViewModel.ModuleInput.self, initializer: ForecastViewModel.init)
            .inObjectScope(.weak)
        container.register(ForecastViewController.self) { (resolver, moduleInput: ForecastViewModel.ModuleInput) in
            let forecastViewModel = resolver.resolve(ForecastViewModelContract.self, argument: moduleInput).forceResolve()
            return ForecastViewController(forecastViewModel: forecastViewModel)
        }
    }

}
