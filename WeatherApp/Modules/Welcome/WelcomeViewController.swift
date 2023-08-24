import Combine
import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Constants -

    //sourcery: AutoEquatable
    enum EventInput {
        case proceedButtonTap
        case didSelectRecentCity(row: Int)
        case viewWillAppear
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    private let welcomeView = WelcomeView()
    private let welcomeViewModel: WelcomeViewModelContract = WelcomeViewModel()

    // MARK: - Public -

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
        welcomeViewModel.eventsInputSubject.send(EventInput.viewWillAppear)
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
        welcomeViewModel.eventsInputSubject.send(EventInput.didSelectRecentCity(row: indexPath.row))
    }

}

    // MARK: - Private -

extension WelcomeViewController {

    private func bindActions() {
        welcomeView.proceedButton.tapPublisher
            .sink { [weak self] in
                self?.welcomeViewModel.eventsInputSubject.send(EventInput.proceedButtonTap)
            }
            .store(in: &subscriptions)

        welcomeViewModel.openSearchScreenPublisher
            .sink { [weak self] in
                self?.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .store(in: &subscriptions)

        welcomeViewModel.openForecastPublisher
            .sink { [weak self] city in
                self?.navigationController?.pushViewController(ForecastViewController(city: city), animated: true)
            }
            .store(in: &subscriptions)

        welcomeViewModel.reloadRecentCitiesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cities in
                self?.welcomeView.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }

}
