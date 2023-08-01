import UIKit

class WelcomeViewModel: NSObject {

    weak var delegate: WelcomeViewModelDelegate?

    func proceedButtonTap() {
        delegate?.pushViewController(viewController: SearchViewController())
    }

    func viewWillAppear() {
        delegate?.reloadRecentsWith(getStoredCities())
    }

    private func getStoredCities() -> [City] {
        guard let fetchedData = UserDefaults.standard.data(forKey: City.storedCitiesKey) else { return [] }
        guard let decodedData = try? JSONDecoder().decode([City].self, from: fetchedData) else { return [] }
        return decodedData
    }

    func recentButtonTap(tag: Int) {
        let storedCities = getStoredCities()
        delegate?.pushViewController(viewController: ForecastViewController(city: storedCities[tag]))
    }
}

protocol WelcomeViewModelDelegate: AnyObject {

    func reloadRecentsWith(_ cities: [City])
    func pushViewController(viewController: UIViewController)
    
}
