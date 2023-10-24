import Combine
import CombineSchedulers
import Foundation
import Swinject
import SwinjectAutoregistration

class ServicesAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(NetworkingServiceType.self, initializer: NetworkingService.init)
            .inObjectScope(.container)
        container.autoregister(StorageServiceType.self, initializer: StorageService.init)
            .inObjectScope(.container)
        container.register(AnySchedulerOf<DispatchQueue>.self) { _ in
            return DispatchQueue.main.eraseToAnyScheduler()
        }
        container.autoregister(LoginServiceType.self, initializer: LoginService.init)
    }

}
