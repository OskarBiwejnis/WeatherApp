import Foundation

struct CitiesData: Decodable {
    var data: [City]
}

struct City: Decodable {
    var name: String
    var country: String
    var latitude: Double
    var longitude: Double
}
