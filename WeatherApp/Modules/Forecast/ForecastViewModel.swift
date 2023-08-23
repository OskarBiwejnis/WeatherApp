import Combine
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

    var threeHourForecastData = ThreeHourForecastData(list: []) {
        didSet {
            threeHourForecasts = threeHourForecastData.list
            reloadTableSubject.send()
        }
      }
    var threeHourForecasts: [ThreeHourForecast] = []
    private let networkingService: NetworkingServiceType
    
    private var subscriptions: [AnyCancellable] = []
    var reloadTableSubject = PassthroughSubject<Void, Never>()
    var showErrorSubject = PassthroughSubject<NetworkingError, Never>()
    
    init(city: City, networkingService: NetworkingServiceType) {
        self.networkingService = networkingService
        super.init()
        loadWeather(city: city)

    }

    private func loadWeather(city: City) {
        networkingService.threeHourForecastPublisher(city: city)
            .catch { [self] error in
                showErrorSubject.send(error)
                return Empty<ThreeHourForecastData, Never>()
            }
          .assign(to: \.threeHourForecastData, on: self)
          .store(in: &subscriptions)
    }

    func getThreeHourForecastFormatted(index: Int) -> ThreeHourForecastFormatted {
        let hour = String(String(threeHourForecasts[index].date
            .split(separator: Constants.space)[Constants.secondPartOfDateFormat])
            .prefix(Constants.hourFormatWithoutSeconds))
        let temperature = String(Int(threeHourForecasts[index].main.temp - Constants.kelvinUnitOffset)) + Constants.degreeSign
        let humidity = String(threeHourForecasts[index].main.humidity) + Constants.percentSign
        let wind = String(Int(threeHourForecasts[index].wind.speed)) + Constants.speedUnit
        let skyImage = threeHourForecasts[index].weather[Constants.weatherMainPart].weatherType.image

        return ThreeHourForecastFormatted(hour: hour, temperature: temperature, humidity: humidity, wind: wind, skyImage: skyImage)
    }

}

struct ThreeHourForecastFormatted {
    var hour: String
    var temperature: String
    var humidity: String
    var wind: String
    var skyImage: UIImage?
}
