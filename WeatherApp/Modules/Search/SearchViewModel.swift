import Foundation

class SearchViewModel: NSObject {

    private var debounceTimer: Timer?
    var cities: [City] = []
    weak var delegate: SearchViewModelDelegate?

    private enum Constants {
        static let minTimeBetweenFetchCities = 1.2
    }

    func searchTextDidChange(_ text: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: Constants.minTimeBetweenFetchCities, repeats: false) { [weak self] timer in
            self?.fetchCities(text)
        }
    }

    private func fetchCities(_ text: String) {
        guard text != "" else {
            return
        }

        Task {
            do {
                cities = try await NetworkingUtils.fetchCities(text)
                delegate?.reloadTable()
            } catch {
                delegate?.showError(error)
            }
        }
    }

    func didSelectSearchCell(didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        delegate?.pushForecastViewController(city: selectedCity)

        var storedCities: [City] = []
        if let fetchedData = UserDefaults.standard.data(forKey: City.storedCitiesKey),
           let decodedData = try? JSONDecoder().decode([City].self, from: fetchedData) {
            storedCities = decodedData
        }

        if let index = storedCities.firstIndex(of: selectedCity) { storedCities.remove(at: index) }
        storedCities.insert(selectedCity, at: storedCities.startIndex)
        if storedCities.count > 3 { storedCities.removeLast() }

        guard let encodedData = try? JSONEncoder().encode(storedCities) else { return }
        UserDefaults.standard.set(encodedData, forKey: City.storedCitiesKey)
    }

}

protocol SearchViewModelDelegate: AnyObject {

    func reloadTable()
    func pushForecastViewController(city: City)
    func showError(_ error: Error)

}
