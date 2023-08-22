import Combine
import UIKit

class WelcomeViewController: UIViewController {

    private let welcomeView = WelcomeView()
    private let welcomeViewModel = WelcomeViewModel()
    var recentCities: [City] = []
    var subscriptions: [AnyCancellable] = []
    var didSelectRecentCityPublisher = PassthroughSubject<City, Never>()
    var viewWillAppearPublisher = PassthroughSubject<Void, Never>()

    override func loadView() {
        welcomeViewModel.welcomeViewController = self
        welcomeView.tableView.delegate = self
        welcomeView.tableView.dataSource = self
        view = welcomeView
        welcomeView.proceedButtonTapPublisher
            .sink(receiveValue: {
                self.navigationController?.pushViewController(SearchViewController(), animated: true)
            })
            .store(in: &subscriptions)

        didSelectRecentCityPublisher
            .sink(receiveValue: { city in
                self.navigationController?.pushViewController(ForecastViewController(city: city), animated: true)
            })
            .store(in: &subscriptions)

        welcomeViewModel.reloadRecentCitiesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { cities in
                self.recentCities = cities
                self.welcomeView.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewWillAppearPublisher.send()
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
        didSelectRecentCityPublisher.send(recentCities[indexPath.row])
    }

}
