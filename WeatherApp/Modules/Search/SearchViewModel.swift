import Foundation

class SearchViewModel: NSObject {

    private var debounceTimer: Timer?
    var cities: [City] = []
    weak var delegate: SearchViewModelDelegate?
    private var networkingService: NetworkingServiceType

    private enum Constants {
        static let minTimeBetweenFetchCities = 1.2
    }

    init(networkingService: NetworkingServiceType) {
        self.networkingService = networkingService
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
                cities = try await networkingService.fetchCities(text)
                delegate?.reloadTable()
            } catch {
                delegate?.showError(error)
            }
        }
    }

    func didSelectSearchCell(didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        delegate?.openCityForecast(city: selectedCity)

    }

}

protocol SearchViewModelDelegate: AnyObject {

    func reloadTable()
    func openCityForecast(city: City)
    func showError(_ error: Error)

}
