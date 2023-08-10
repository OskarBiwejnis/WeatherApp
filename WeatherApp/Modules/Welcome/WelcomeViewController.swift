import UIKit

class WelcomeViewController: UIViewController {

    private let welcomeView = WelcomeView()
    private let welcomeViewModel = WelcomeViewModel()
    var recentCities: [City] = []

    override func loadView() {
        welcomeView.delegate = self
        welcomeViewModel.delegate = self
        welcomeView.tableView.delegate = self
        welcomeView.tableView.dataSource = self
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        welcomeViewModel.viewWillAppear()
    }

}

extension WelcomeViewController: WelcomeViewModelDelegate {

    func openCityForecast(_ city: City) {
        navigationController?.pushViewController(ForecastViewController(city: city), animated: true)
    }

    func openSearchScreen() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    func reloadRecentCities(_ cities: [City]) {
        recentCities = cities
        DispatchQueue.main.async { [weak self] in
            self?.welcomeView.tableView.reloadData()
        }
    }

}

extension WelcomeViewController: WelcomeViewDelegate {

    func proceedButtonTap() {
        welcomeViewModel.proceedButtonTap()
    }
}


extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentCityCell.reuseIdentifier) as? RecentCityCell else { return RecentCityCell() }
        cell.label.text = recentCities[indexPath.row].name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        welcomeViewModel.didSelectRecentCity(recentCities[indexPath.row])
    }

}
