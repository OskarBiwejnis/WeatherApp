import Foundation
import UIKit

class ForecastViewModel: NSObject {

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

    var forecast3Hour: [Forecast3Hour] = []
    weak var delegate: ForecastViewModelDelegate?

    func didInitialize(city: City) {
        Task {
            do {
                forecast3Hour = try await NetworkingUtils.fetchForecast3Hour(city: city)
                delegate?.reloadTable()
            } catch NetworkingError.decodingError {
                print(NetworkingError.decodingError)
            } catch NetworkingError.invalidResponse {
                print(NetworkingError.invalidResponse)
            } catch NetworkingError.invalidUrl {
                print(NetworkingError.invalidUrl)
            }
        }
    }

    func getFormattedForecast3Hour(index: Int) -> FormattedForecast3Hour {
        let hour = String(String(forecast3Hour[index].dtTxt.split(separator: Constants.space)[Constants.secondPartOfDateFormat]).prefix(Constants.hourFormatWithoutSeconds))
        let temperature = String(Int(forecast3Hour[index].main.temp - Constants.kelvinUnitOffset)) + Constants.degreeSign
        let humidity = String(forecast3Hour[index].main.humidity) + Constants.percentSign
        let wind = String(Int(forecast3Hour[index].wind.speed)) + Constants.speedUnit
        var skyImage: UIImage?

        switch forecast3Hour[index].weather[Constants.weatherMainPart].main  {
        case .thunderstorm:
            skyImage = R.image.thunderstorm()
        case .drizzle:
            skyImage = R.image.drizzle()
        case .rain:
            skyImage = R.image.rain()
        case .snow:
            skyImage = R.image.snow()
        case .atmosphere:
            skyImage = R.image.atmosphere()
        case .clear:
            skyImage = R.image.clear()
        case .clouds:
            skyImage = R.image.clouds()
        }

        return FormattedForecast3Hour(hour: hour, temperature: temperature, humidity: humidity, wind: wind, skyImage: skyImage)
    }

}

protocol ForecastViewModelDelegate: AnyObject {

    func reloadTable()

}

struct FormattedForecast3Hour {
    var hour: String
    var temperature: String
    var humidity: String
    var wind: String
    var skyImage: UIImage?
}
