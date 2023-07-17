import Foundation

class NetworkingUtils {

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

        let headers = [
            "X-RapidAPI-Key": "8daecc527cmsh1e37f3348b7206fp1766a0jsnfd5f88ed92f0",
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
        ]
        let url = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?types=CITY&namePrefix=" + prefix + "&sort=-population"
        print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let (data, response) = try await session.data(for: request as URLRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { fatalError("3") }

        let decoder = JSONDecoder()

        guard let decodedData = try? decoder.decode(CitiesData.self, from: data) else { fatalError("2") }
        cities = decodedData.data

        return cities
    }
}
