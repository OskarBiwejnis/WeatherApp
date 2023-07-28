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

    var forecast3Hour: [ThreeHourForecast] = []
    weak var delegate: ForecastViewModelDelegate?

    func didInitialize(city: City) {
        Task {
            do {
                forecast3Hour = try await NetworkingUtils.fetchForecast3Hour(city: city)
                delegate?.reloadTable()
            } catch {
                delegate?.showError(error)
            }
        }
    }

    func getFormattedForecast3Hour(index: Int) -> FormattedForecast3Hour {
        let hour = String(String(forecast3Hour[index].date.split(separator: Constants.space)[Constants.secondPartOfDateFormat]).prefix(Constants.hourFormatWithoutSeconds))
        let temperature = String(Int(forecast3Hour[index].main.temp - Constants.kelvinUnitOffset)) + Constants.degreeSign
        let humidity = String(forecast3Hour[index].main.humidity) + Constants.percentSign
        let wind = String(Int(forecast3Hour[index].wind.speed)) + Constants.speedUnit
        let skyImage = forecast3Hour[index].weather[Constants.weatherMainPart].weatherType.image

        return FormattedForecast3Hour(hour: hour, temperature: temperature, humidity: humidity, wind: wind, skyImage: skyImage)
    }

}

protocol ForecastViewModelDelegate: AnyObject {

    func reloadTable()
    func showError(_ error: Error)

}

struct FormattedForecast3Hour {
    var hour: String
    var temperature: String
    var humidity: String
    var wind: String
    var skyImage: UIImage?
}
