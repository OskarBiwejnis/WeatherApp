import Foundation

class ForecastViewModel: NSObject {

    var forecasts3Hour: [Forecast3Hour] = []
    weak var delegate: ForecastViewModelDelegate?

    func didStartLoadingView(latitude: Double, longitude: Double){

        Task {
            do {
                forecasts3Hour = try await NetworkingUtils.fetchForecast3Hour(latitude: latitude, longitude: longitude)
                delegate?.reloadTable()
            } catch {
                print("some error")
            }
        }

    }

}

protocol ForecastViewModelDelegate: AnyObject {

    func reloadTable()

}
