import UIKit

class WelcomeViewModel: NSObject {

    weak var delegate: WelcomeViewModelDelegate?
    let storageService: StorageServiceType = StorageService()

    func proceedButtonTap() {
        delegate?.pushViewController(viewController: SearchViewController())
    }

    func viewWillAppear() {
        delegate?.reloadRecentCities(storageService.getRecentCities())
    }

    func didSelectRecentCity(_ city: City) {
        delegate?.pushViewController(viewController: ForecastViewController(city: city))
    }

}

protocol WelcomeViewModelDelegate: AnyObject {

    func pushViewController(viewController: UIViewController)
    func reloadRecentCities(_  cities: [City])
    
}
