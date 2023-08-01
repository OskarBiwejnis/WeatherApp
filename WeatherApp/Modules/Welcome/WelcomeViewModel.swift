import Foundation

class WelcomeViewModel: NSObject {

    weak var delegate: WelcomeViewModelDelegate?

    func pushViewController() {
        delegate?.pushViewController()
    }

    func reloadRecents() {
        delegate?.reloadRecentsWith(getStoredCities())
    }

    private func getStoredCities() -> [City] {
        guard let fetchedData = UserDefaults.standard.data(forKey: City.storedCitiesKey) else { return [] }
        guard let decodedData = try? JSONDecoder().decode([City].self, from: fetchedData) else { return [] }
        return decodedData
    }

}

protocol WelcomeViewModelDelegate: AnyObject {

    func pushViewController()
    func reloadRecentsWith(_ cities: [City])

}
