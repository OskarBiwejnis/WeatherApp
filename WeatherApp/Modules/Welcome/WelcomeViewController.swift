import Combine
import CombineDataSources
import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Constants -

    enum EventInput: AutoEquatable {
        case proceedButtonTap
        case didSelectRecentCity(row: Int)
        case viewWillAppear
    }

    // MARK: - Variables -
    private let itemsController = TableViewItemsController<[[City]]>(cellFactory: { _, tableView, indexPath, model -> UITableViewCell in
        guard let cell: RecentCityCell = tableView.dequeueReusableCell(withIdentifier: RecentCityCell.reuseIdentifier, for: indexPath) as? RecentCityCell
        else { return UITableViewCell() }
        cell.label.text = model.name
        return cell
    })
    private var subscriptions: [AnyCancellable] = []

    private let welcomeView = WelcomeView()
    private let welcomeViewModel: WelcomeViewModelContract

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

    // MARK: - Initialization -

    init(welcomeViewModel: WelcomeViewModel) {
        self.welcomeViewModel = welcomeViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private -

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
                self?.welcomeViewModel.appCoordinator?.goToSearchScreen()
            }
            .store(in: &subscriptions)

        welcomeViewModel.openForecastPublisher
            .sink { [weak self] city in
                self?.welcomeViewModel.appCoordinator?.goToForecastScreen(city: city)
            }
            .store(in: &subscriptions)

        welcomeViewModel.reloadRecentCitiesPublisher
            .receive(on: DispatchQueue.main)
            .bind(subscriber: welcomeView.tableView.rowsSubscriber(itemsController))
            .store(in: &subscriptions)
    }

}
