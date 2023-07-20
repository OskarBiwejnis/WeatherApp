import Foundation

class ForecastViewModel: NSObject {

    var forecast3Hour: [Forecast3Hour] = []
    weak var delegate: ForecastViewModelDelegate?

    func didStartLoadingView(latitude: Double, longitude: Double) {
        
        Task {
            do {
                forecast3Hour = try await NetworkingUtils.fetchForecast3Hour(latitude: latitude, longitude: longitude)
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

}

protocol ForecastViewModelDelegate: AnyObject {

    func reloadTable()

}
