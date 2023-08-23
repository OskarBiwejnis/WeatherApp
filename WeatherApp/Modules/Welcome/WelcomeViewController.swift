import Combine
import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    private let welcomeView = WelcomeView()
    private let welcomeViewModel = WelcomeViewModel()



    override func loadView() {
        welcomeView.tableView.delegate = self
        welcomeView.tableView.dataSource = self
        view = welcomeView

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        welcomeViewModel.eventsInputSubject.send(WelcomeViewModel.EventInput.viewWillAppear)
    }

    private func bindActions() {
        welcomeView.proceedButton.tapPublisher
            .sink { [self] in
                welcomeViewModel.eventsInputSubject.send(WelcomeViewModel.EventInput.proceedButtonTap)
            }
            .store(in: &subscriptions)

        welcomeViewModel.openSearchScreenSubject
            .sink { [self] in
                navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .store(in: &subscriptions)

        welcomeViewModel.openForecastSubject
            .sink { [self] row in
                navigationController?.pushViewController(ForecastViewController(city: welcomeViewModel.recentCities[row]), animated: true)
            }
            .store(in: &subscriptions)

        welcomeViewModel.reloadRecentCitiesSubject
            .receive(on: DispatchQueue.main)
            .sink { [self] cities in
                welcomeViewModel.recentCities = cities
                welcomeView.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }

}

extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return welcomeViewModel.recentCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentCityCell.reuseIdentifier) as? RecentCityCell else { return RecentCityCell() }
        cell.label.text = welcomeViewModel.recentCities[indexPath.row].name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        welcomeViewModel.eventsInputSubject.send(WelcomeViewModel.EventInput.didSelectRecentCity(row: indexPath.row))
    }

}
