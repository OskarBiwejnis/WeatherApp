import Foundation

class NetworkingUtils {

    private enum Constants {
        static let headers = [
            "X-RapidAPI-Key": "8daecc527cmsh1e37f3348b7206fp1766a0jsnfd5f88ed92f0",
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
        ]
        static let urlBase = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?types=CITY&minPopulation=20000&sort=-population&namePrefix="
        static let httpMethod = "GET"
        static let timeoutInterval = 10.0
        static let acceptedResponses = [200, 204]


        static let openWeatherUrlBase = ""
        static let openWeatherUrlLongitudePart = ""
        static let openWeatherUrlApiKeyPart = ""
    }

    static func fetchCities(_ searchText: String) async throws -> [City] {
        var cities: [City] = []

        let url = Constants.urlBase + searchText
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: Constants.timeoutInterval)
        request.httpMethod = Constants.httpMethod
        request.allHTTPHeaderFields = Constants.headers

        let session = URLSession.shared
        let (data, response) = try await session.data(for: request as URLRequest)
        guard let response = response as? HTTPURLResponse, Constants.acceptedResponses.contains(response.statusCode) else { throw NetworkingError.invalidResponse }

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(CitiesData.self, from: data) else { throw NetworkingError.decodingError }
        cities = decodedData.data

        return cities
    }

    static func fetchForecast3Hour(latitude: Double, longitude: Double) async throws -> [Forecast3Hour] {
        var forecast3Hour: [Forecast3Hour] = []

        let urlString = Constants.openWeatherUrlBase + String(latitude) + Constants.openWeatherUrlLongitudePart + String(longitude) + Constants.openWeatherUrlApiKeyPart

        guard let url = URL(string: urlString) else {
            print("Incorrect coordinates")
            return []
        }

        let session = URLSession.shared
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse, Constants.acceptedResponses.contains(response.statusCode) else { throw NetworkingError.invalidResponse }

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(Forecast3HourData.self, from: data) else { throw NetworkingError.decodingError}
        forecast3Hour = decodedData.list

        return forecast3Hour
    }

}
