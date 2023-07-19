import UIKit

class ForecastViewController: UIViewController {

    private enum Constants {
        static let warsawLatitude = 52.23
        static let warsawLongitude = 21.01
    }
    let forecastView = ForecastView()
    let forecastViewModel = ForecastViewModel()
    var latitude: Double?
    var longitude: Double?


    override func loadView() {
        forecastViewModel.didStartLoadingView(latitude: latitude ?? Constants.warsawLatitude, longitude: longitude ?? Constants.warsawLatitude)
        forecastViewModel.delegate = self

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
        let cell = UITableViewCell()

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
