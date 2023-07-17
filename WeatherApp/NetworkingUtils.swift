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
}
