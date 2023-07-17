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
    }

    static func get3FirstGitHubUsers() async throws -> [User]? {
        guard let url = URL(string: "https://api.github.com/users?per_page=3") else { return nil }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let decodedData = try? decoder.decode([User].self, from: data) else { return nil }

        return decodedData
    }

    static func getCitiesWithPrefix(_ prefix: String) async throws -> [City] {

        var cities: [City] = []

        let url = Constants.urlBase + prefix
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: Constants.timeoutInterval)
        request.httpMethod = Constants.httpMethod
        request.allHTTPHeaderFields = Constants.headers

        let session = URLSession.shared
        let (data, response) = try await session.data(for: request as URLRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { fatalError(R.string.localizable.error_message()) }

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(CitiesData.self, from: data) else { fatalError(R.string.localizable.error_message()) }
        cities = decodedData.data

        return cities
    }
}
