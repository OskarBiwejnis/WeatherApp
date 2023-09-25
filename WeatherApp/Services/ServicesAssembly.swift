import Foundation
import Swinject

class ServicesAssembly: Assembly {

    func assemble(container: Container) {
        container.register(NetworkingServiceType.self) { _ in
            NetworkingService()
        }.inObjectScope(.container)
        container.register(StorageServiceType.self) { _ in
            StorageService()
        }.inObjectScope(.container)
    }

}
