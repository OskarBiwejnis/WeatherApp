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

    func getRecentCityName(index: Int) -> String {
        guard let recentCity = storageService.getStoredCity(index: index) else { return "" }
        return recentCity.name
    }

    func getNumberOfRecentCities() -> Int {
        return storageService.getNumberOfStoredCities()
    }

    func didSelectRecentCityCell(didSelectRowAt indexPath: IndexPath) {
        guard let recentCity = storageService.getStoredCity(index: indexPath.row) else { return }
        delegate?.pushViewController(viewController: ForecastViewController(city: recentCity))
    }

}

protocol WelcomeViewModelDelegate: AnyObject {

    func reloadRecentCities(_ cities: [City])
    func pushViewController(viewController: UIViewController)
    
}
