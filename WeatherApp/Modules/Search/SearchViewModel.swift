import Foundation

class SearchViewModel: NSObject {
    var searchResults: [String] = []
    weak var searchViewControllerDelegate: SearchViewControllerDelegate?

    func searchTextDidChange(_ text: String) {
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
                await searchViewControllerDelegate?.reloadTable()
            } catch NetworkingError.decodingError {
                print(NetworkingError.decodingError)
            } catch NetworkingError.invalidResponse {
                print(NetworkingError.invalidResponse)
            }
        }
    }
}
