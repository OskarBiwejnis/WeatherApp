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

struct ThreeHourForecastFormatted: Hashable {

    private enum Constants {
        static let degreeSign = "°"
        static let percentSign = "%"
        static let speedUnit = " kmh"
        static let hourFormatWithoutSeconds = 5
        static let space = " "
        static let secondPartOfDateFormat = 1
        static let kelvinUnitOffset = 273.15
        static let weatherMainPart = 0
    }

    var hour: String
    var temperature: String
    var humidity: String
    var wind: String
    var skyImage: UIImage?

    init(from forecast: ThreeHourForecast) {
        self.hour = String(String(forecast.date
               .split(separator: Constants.space)[Constants.secondPartOfDateFormat])
               .prefix(Constants.hourFormatWithoutSeconds))
        self.temperature = String(Int(forecast.main.temp - Constants.kelvinUnitOffset)) + Constants.degreeSign
        self.humidity = String(forecast.main.humidity) + Constants.percentSign
        self.wind = String(Int(forecast.wind.speed)) + Constants.speedUnit
        self.skyImage = forecast.weather[Constants.weatherMainPart].weatherType.image
    }
    
}
