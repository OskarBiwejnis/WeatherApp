import UIKit

class ForecastViewController: UIViewController {

    private enum Constants {
        static let warsawLatitude = 52.23
        static let warsawLongitude = 21.01
        static let forecastReuseIdentifier = "forecastCell"
    }
    
    let forecastView = ForecastView()
    let forecastViewModel = ForecastViewModel()

    init(city: City) {
        super.init(nibName: nil, bundle: nil)
        forecastViewModel.delegate = self
        forecastView.tableView.delegate = self
        forecastView.tableView.dataSource = self
        self.title = city.name
        forecastViewModel.didInitialize(city: city)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = forecastView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastViewModel.forecast3Hour.isEmpty ? 0 : 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.forecastReuseIdentifier) as? ForecastCell else { return ForecastCell() }
        let formattedForecast3Hour = forecastViewModel.getFormattedForecast3Hour(index: indexPath.row)
        cell.setupWith(hour: formattedForecast3Hour.hour,
                       temperature: formattedForecast3Hour.temperature,
                       humidity: formattedForecast3Hour.humidity,
                       wind: formattedForecast3Hour.wind,
                       skyImage: formattedForecast3Hour.skyImage)
        
        return cell
    }

}

extension ForecastViewController: ForecastViewModelDelegate {

    func reloadTable() {
        DispatchQueue.main.async {
            self.forecastView.tableView.reloadData()
        }
    }

    func showError(_ error: Error) {
        let errorAlert = UIAlertController(title: R.string.localizable.error_alert_title(), message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        errorAlert.addAction(okButton)
        DispatchQueue.main.async {
            self.present(errorAlert, animated: true, completion: nil)
        }
    }

}
