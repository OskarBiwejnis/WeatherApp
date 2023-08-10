import UIKit

class WelcomeViewModel: NSObject {

    weak var delegate: WelcomeViewModelDelegate?
    let storageService: StorageServiceType = StorageService()

    func proceedButtonTap() {
        delegate?.openSearchScreen()
    }

    func viewWillAppear() {
        delegate?.reloadRecentCities(storageService.getRecentCities())
    }

    func didSelectRecentCity(_ city: City) {
        delegate?.openCityForecast(city)
    }

}

protocol WelcomeViewModelDelegate: AnyObject {

    func openCityForecast(_ city: City)
    func openSearchScreen()
    func reloadRecentCities(_  cities: [City])
    
}
