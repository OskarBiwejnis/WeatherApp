import Foundation

protocol NetworkingServiceType {
    func fetchCities(_ searchText: String) async throws -> [City]
    func fetchThreeHourForecast(city: City) async throws -> [ThreeHourForecast]
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

    func fetchCities(_ searchText: String) async throws -> [City] {
        var cities: [City] = []

        guard let url = URL(string: Constants.geoDbUrlBase + searchText) else { throw NetworkingError.invalidUrl}
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: Constants.geoDbTimeoutInterval)
        request.httpMethod = Constants.geoDbHttpMethod
        request.allHTTPHeaderFields = Constants.geoDbHeaders

        let session = URLSession.shared
        let (data, response) = try await session.data(for: request as URLRequest)
        guard let response = response as? HTTPURLResponse, Constants.acceptedResponses.contains(response.statusCode) else { throw NetworkingError.invalidResponse }

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(CitiesData.self, from: data) else { throw NetworkingError.decodingError }
        cities = decodedData.data

        return cities
    }

    func fetchThreeHourForecast(city: City) async throws -> [ThreeHourForecast] {
        var threeHourForecast: [ThreeHourForecast] = []

        let urlString = Constants.openWeatherUrlBase + String(city.latitude) + Constants.openWeatherUrlLongitudePart + String(city.longitude) + Constants.openWeatherUrlApiKeyPart
        guard let url = URL(string: urlString) else { throw NetworkingError.invalidUrl }

        let session = URLSession.shared
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse, Constants.acceptedResponses.contains(response.statusCode) else { throw NetworkingError.invalidResponse }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let decodedData = try? decoder.decode(ThreeHourForecastData.self, from: data) else { throw NetworkingError.decodingError }
        threeHourForecast = decodedData.list
        
        return threeHourForecast
    }

}
