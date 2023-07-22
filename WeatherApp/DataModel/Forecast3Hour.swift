import Foundation

struct Forecast3HourData: Decodable {
    var list: [Forecast3Hour]
}

struct Forecast3Hour: Decodable {
    var main: Forecast3HourMain
    var weather: [Forecast3HourWeather]
    var wind: Forecast3HourWind
    var date: String

    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case wind
        case date = "dtTxt"
    }
}

struct Forecast3HourMain: Decodable {
    var temp: Double
    var humidity: Int
}

struct Forecast3HourWeather: Decodable {
    var id: Int
    var weatherType: WeatherType

    enum CodingKeys: String, CodingKey {
        case id
        case weatherType = "main"
    }
}

struct Forecast3HourWind: Decodable {
    var speed: Double
}

enum WeatherType: String, Decodable {
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case atmosphere = "Atmosphere"
    case clear = "Clear"
    case clouds = "Clouds"
}
