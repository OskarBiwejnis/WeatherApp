import Foundation
import RealmSwift

struct CitiesData: Decodable {
    var data: [City]
}

struct City: Codable, Equatable {
    var name: String
    var country: String
    var latitude: Double
    var longitude: Double

    static func ==(lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name
        && lhs.country == rhs.country
        && lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
    }

    init(from persistedCity: PersistedCity) {
        self.name = persistedCity.name
        self.country = persistedCity.country
        self.latitude = persistedCity.latitude
        self.longitude = persistedCity.longitude
    }

    init() {
        self.name = ""
        self.country = ""
        self.latitude = 0.0
        self.longitude = 0.0
    }
}
