import Foundation

class SearchViewModel: NSObject {

    private var debounceTimer: Timer?
    var cities: [City] = []
    weak var delegate: SearchViewModelDelegate?

    private enum Constants {
        static let minTimeBetweenFetchCities = 0.35
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
            } catch NetworkingError.decodingError {
                print(NetworkingError.decodingError)
            } catch NetworkingError.invalidResponse {
                print(NetworkingError.invalidResponse)
            }
        }
    }

    func didSelectSearchCell(didSelectRowAt indexPath: IndexPath) {
        delegate?.pushForecastViewController(city: cities[indexPath.row])
    }

}

protocol SearchViewModelDelegate: AnyObject {

    func reloadTable()
    func pushForecastViewController(city: City)

}
