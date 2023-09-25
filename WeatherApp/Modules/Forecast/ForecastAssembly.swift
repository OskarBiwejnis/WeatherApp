import Foundation
import Swinject

class ForecastAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ForecastViewModelContract.self) { (resolver, city: City) in
            let networkingService = resolver.resolve(NetworkingServiceType.self)!
            let storageService = resolver.resolve(StorageServiceType.self)!
            return ForecastViewModel(city: city, networkingService: networkingService, storageService: storageService)
        }.inObjectScope(.weak)
        container.register(ForecastViewController.self) { (resolver, city: City) in
            let forecastViewModel = resolver.resolve(ForecastViewModelContract.self, argument: city)!
            return ForecastViewController(forecastViewModel: forecastViewModel)
        }
    }

}
