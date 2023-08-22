import Combine
import UIKit

class WelcomeViewModel: NSObject {

    weak var welcomeViewController: WelcomeViewController? {
        didSet {
            welcomeViewController!.viewWillAppearPublisher
                .sink(receiveValue: {
                    self.reloadRecentCitiesPublisher.value = self.storageService.getRecentCities()
                })
                .store(in: &subscriptions)
        }
    }

    let storageService: StorageServiceType = StorageService()
    var subscriptions: [AnyCancellable] = []
    var reloadRecentCitiesPublisher = CurrentValueSubject<[City], Never>([])

}
