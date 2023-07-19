import Foundation

class SearchViewModel: NSObject {
    
    var debounceTimer: Timer?
    var searchResults: [String] = []
    weak var searchViewControllerDelegate: SearchViewControllerDelegate?

    private enum Constants {
        static let minTimeBetweenFetchCities = 1.1
    }

    func searchTextDidChange(_ text: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: Constants.minTimeBetweenFetchCities, repeats: false) { [weak self] timer in
            self?.fetchCities(text)
        }
    }

    private func fetchCities(_ text: String) {
        searchResults = []
        guard text != "" else {
            return
        }

        Task {
            do {
                let cities = try await NetworkingUtils.fetchCities(text)
                for city in cities {
                    searchResults.append(city.name)
                }
                searchViewControllerDelegate?.reloadTable()
            } catch NetworkingError.decodingError {
                print(NetworkingError.decodingError)
            } catch NetworkingError.invalidResponse {
                print(NetworkingError.invalidResponse)
            }
        }
    }

}
