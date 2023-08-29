import Combine
import Foundation

protocol NetworkingServiceType {
    func fetchCities(_ searchText: String) -> AnyPublisher<CitiesData, NetworkingError>
    func threeHourForecastPublisher(city: City) -> AnyPublisher<ThreeHourForecastData, NetworkingError>
}


class NetworkingService: NetworkingServiceType {

    private enum Constants {
        static let geoDbHeaders = [
            "X-RapidAPI-Key": "8daecc527cmsh1e37f3348b7206fp1766a0jsnfd5f88ed92f0",
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
        ]
        static let geoDbUrlBase = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?types=CITY&minPopulation=20000&sort=-population&namePrefix="
        static let geoDbHttpMethod = "GET"
        static let geoDbTimeoutInterval = 10.0
        static let acceptedResponses = [200, 204]

        static let openWeatherUrlBase = "https://api.openweathermap.org/data/2.5/forecast?lat="
        static let openWeatherUrlLongitudePart = "&lon="
        static let openWeatherUrlApiKeyPart = "&appid=ac65470224290f0854e9e6a757500205"
    }

    func fetchCities(_ searchText: String) -> AnyPublisher<CitiesData, NetworkingError> {
        guard let url = URL(string: Constants.geoDbUrlBase + searchText) else { return Fail<CitiesData, NetworkingError>(error: .invalidUrl).eraseToAnyPublisher() }
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: Constants.geoDbTimeoutInterval)
        request.httpMethod = Constants.geoDbHttpMethod
        request.allHTTPHeaderFields = Constants.geoDbHeaders
        let decoder = JSONDecoder()

        return URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, Constants.acceptedResponses.contains(response.statusCode) else { throw NetworkingError.invalidResponse }
                return data
            }
            .decode(type: CitiesData.self, decoder: decoder)
            .mapError { error -> NetworkingError in
                switch error {
                case is URLError:
                    return .invalidUrl
                case is DecodingError:
                    return .decodingError
                case is NetworkingError:
                    return .invalidResponse
                default:
                    return .unknownError
                }
            }
            .eraseToAnyPublisher()
    }

    func threeHourForecastPublisher(city: City) -> AnyPublisher<ThreeHourForecastData, NetworkingError> {
        let urlString = Constants.openWeatherUrlBase + String(city.latitude) + Constants.openWeatherUrlLongitudePart + String(city.longitude) + Constants.openWeatherUrlApiKeyPart
        guard let url = URL(string: urlString) else { return Fail<ThreeHourForecastData, NetworkingError>(error: .invalidUrl).eraseToAnyPublisher() }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, Constants.acceptedResponses.contains(response.statusCode) else { throw NetworkingError.invalidResponse }
                return data
            }
            .decode(type: ThreeHourForecastData.self, decoder: decoder)
            .mapError { error -> NetworkingError in
                switch error {
                case is URLError:
                    return .invalidUrl
                case is DecodingError:
                    return .decodingError
                case is NetworkingError:
                    return .invalidResponse
                default:
                    return .unknownError
                }
            }
            .eraseToAnyPublisher()
    }

}
