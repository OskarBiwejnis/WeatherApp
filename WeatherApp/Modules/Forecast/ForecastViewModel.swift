import Combine
import Foundation
import UIKit

protocol ForecastViewModelContract {

    var threeHourForecasts: [ThreeHourForecast] { get }
    var reloadTableSubject: PassthroughSubject<Void, Never> { get }
    var showErrorSubject: PassthroughSubject<NetworkingError, Never> { get }

    func getThreeHourForecastFormatted(index: Int) -> ThreeHourForecastFormatted 

}

class ForecastViewModel: ForecastViewModelContract {

    // MARK: - Constants -

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

    

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []
    private var threeHourForecastData = ThreeHourForecastData(list: []) {
        didSet {
            threeHourForecasts = threeHourForecastData.list
            reloadTableSubject.send()
        }
    }

    var threeHourForecasts: [ThreeHourForecast] = []
    let reloadTableSubject = PassthroughSubject<Void, Never>()
    let showErrorSubject = PassthroughSubject<NetworkingError, Never>()

    private let networkingService: NetworkingServiceType

    // MARK: - Initialization -

    init(city: City, networkingService: NetworkingServiceType) {
        self.networkingService = networkingService
        loadWeather(city: city)

    }

    //MARK: - Public -

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

    // MARK: - Private -

    private func loadWeather(city: City) {
        networkingService.threeHourForecastPublisher(city: city)
            .catch { [self] error in
                showErrorSubject.send(error)
                return Empty<ThreeHourForecastData, Never>()
            }
          .assign(to: \.threeHourForecastData, on: self)
          .store(in: &subscriptions)
    }

}

