import Foundation

struct Forecast3HourData: Decodable {
    var list: [Forecast3Hour]
}
struct Forecast3Hour: Decodable {
    var main: Forecast3HourMain
    var weather: [Forecast3HourWeather]
    var wind: Forecast3HourWind
    var dtTxt: String
}

struct Forecast3HourMain: Decodable {
    var temp: Double
    var humidity: Int
}

struct Forecast3HourWeather: Decodable {
    var id: Int
    var main: String
}

struct Forecast3HourWind: Decodable {
    var speed: Double
}


