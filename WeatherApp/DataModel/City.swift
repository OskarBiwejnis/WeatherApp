import Foundation

struct CitiesData: Decodable {
    var data: [City]
}

struct City: Codable, Equatable {
    var name: String
    var country: String
    var latitude: Double
    var longitude: Double

    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
        && lhs.country == rhs.country
        && lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
    }
}
