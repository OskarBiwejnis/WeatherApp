import Foundation
import UIKit

struct ThreeHourForecastData: Decodable {
    var list: [ThreeHourForecast]
}

struct ThreeHourForecast: Decodable {
    var main: ThreeHourForecastMain
    var weather: [ThreeHourForecastWeather]
    var wind: ThreeHourForecastWind
    var date: String

    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case wind
        case date = "dtTxt"
    }
}

struct ThreeHourForecastMain: Decodable {
    var temp: Double
    var humidity: Int
}

struct ThreeHourForecastWeather: Decodable {
    var id: Int
    var weatherType: WeatherType

    enum CodingKeys: String, CodingKey {
        case id
        case weatherType = "main"
    }
}

struct ThreeHourForecastWind: Decodable {
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

    var image: UIImage! {
        switch self {
        case .thunderstorm:
            return R.image.thunderstorm()
        case .drizzle:
            return R.image.drizzle()
        case .rain:
            return R.image.rain()
        case .snow:
            return R.image.snow()
        case .atmosphere:
            return R.image.atmosphere()
        case .clear:
            return R.image.clear()
        case .clouds:
            return R.image.clouds()
        }
    }
}
