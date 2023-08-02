import UIKit

class WelcomeViewModel: NSObject {

    weak var delegate: WelcomeViewModelDelegate?
    let storageService: StorageServiceType = StorageService()

    func proceedButtonTap() {
        delegate?.pushViewController(viewController: SearchViewController())
    }

    func viewWillAppear() {
        delegate?.reloadRecentCities(storageService.getStoredCities())
    }

    func recentButtonTap(tag: Int) {
        let storedCities = storageService.getStoredCities()
        delegate?.pushViewController(viewController: ForecastViewController(city: storedCities[tag]))
    }
}

protocol WelcomeViewModelDelegate: AnyObject {

    func reloadRecentCities(_ cities: [City])
    func pushViewController(viewController: UIViewController)
    
}
