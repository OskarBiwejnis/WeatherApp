import UIKit

class SearchViewModel: NSObject {
    var searchResults: [String] = []
    var didFetchSearchResults: ( ([String]) async -> Void ) = { _ in }

    func fetchSearchResults(_ text: String) {
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
                await didFetchSearchResults(searchResults)
            } catch NetworkingError.decodingError {
                print(NetworkingError.decodingError)
            } catch NetworkingError.invalidResponse {
                print(NetworkingError.invalidResponse)
            }
        }
    }
}
