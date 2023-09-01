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
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        welcomeViewModel.eventsInputSubject.send(.viewWillAppear)
    }

}

    // MARK: - Private -

extension WelcomeViewController {

    private func bindActions() {
        welcomeView.tableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                self?.welcomeViewModel.eventsInputSubject.send(.didSelectRecentCity(row: indexPath.row))
                self?.welcomeView.tableView.deselectRow(at: indexPath, animated: false)
            }
            .store(in: &subscriptions)

        welcomeView.proceedButton.tapPublisher
            .sink { [weak self] in
                self?.welcomeViewModel.eventsInputSubject.send(.proceedButtonTap)
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
            .bind(subscriber: welcomeView.tableView.rowsSubscriber(cellIdentifier: RecentCityCell.reuseIdentifier, cellType: RecentCityCell.self, cellConfig: { cell, indexPath, model in
                cell.label.text = model.name
              }))
            .store(in: &subscriptions)
    }

}
