import UIKit

class ForecastViewController: UIViewController {

    private enum Constants {
        static let warsawLatitude = 52.23
        static let warsawLongitude = 21.01
        static let forecastReuseIdentifier = "forecastCell"

    }
    let forecastView = ForecastView()
    let forecastViewModel = ForecastViewModel()
    var latitude: Double?
    var longitude: Double?


    override func loadView() {
        print("lat: \(latitude), lon: \(longitude)")
        forecastViewModel.didStartLoadingView(latitude: latitude ?? Constants.warsawLatitude, longitude: longitude ?? Constants.warsawLatitude)
        forecastViewModel.delegate = self
        forecastView.tableView.delegate = self
        forecastView.tableView.dataSource = self
        
        view = forecastView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastViewModel.forecast3Hour.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.forecastReuseIdentifier) as? ForecastCell else { return ForecastCell() }
        let givenForecast3Hour = forecastViewModel.forecast3Hour[indexPath.row]
        cell.setupValues(hour: givenForecast3Hour.dtTxt,
                         temperature: givenForecast3Hour.main.temp,
                         humidity: givenForecast3Hour.main.humidity,
                         wind: givenForecast3Hour.wind.speed,
                         sky: givenForecast3Hour.weather[0].main)
        
        return cell
    }

}

extension ForecastViewController: ForecastViewModelDelegate {

    func reloadTable() {
        DispatchQueue.main.async {
            self.forecastView.tableView.reloadData()
        }
    }

}
