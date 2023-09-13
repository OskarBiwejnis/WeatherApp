import Combine
import CombineCocoa
import CombineDataSources
import UIKit

class SearchViewController: UIViewController {

    // MARK: - Constants -

    enum EventInput: AutoEquatable {
        case textChanged(text: String)
        case didSelectCity(row: Int)
    }

    // MARK: - Variables -
    private let itemsController = TableViewItemsController<[[City]]>(cellFactory: { _, tableView, indexPath, model -> UITableViewCell in
        guard let cell: SearchCell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseIdentifier, for: indexPath) as? SearchCell
        else { return UITableViewCell() }
        cell.label.text = model.name
        return cell
    })
    private var subscriptions: [AnyCancellable] = []

    private let searchView = SearchView()
    private let searchViewModel: SearchViewModelContract = SearchViewModel(networkingService: NetworkingService(), scheduler: DispatchQueue.main.eraseToAnyScheduler())

    // MARK: - Public -

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }
}

    // MARK: - Private -

extension SearchViewController {

    private func bindActions() {

        searchView.tableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                self?.searchViewModel.eventsInputSubject.send(.didSelectCity(row: indexPath.row))
            }
            .store(in: &subscriptions)

        searchView.searchTextField.textPublisher
            .sink { [weak self] text in
                self?.searchViewModel.eventsInputSubject.send(.textChanged(text: text ?? ""))
            }
            .store(in: &subscriptions)

        searchViewModel.openForecastPublisher
            .receive(on: DispatchQueue.main)
            .sink {  [weak self] city in
                self?.navigationController?.pushViewController(ForecastViewController(city: city), animated: true)
            }
            .store(in: &subscriptions)

        searchViewModel.foundCitiesPublisher
            .receive(on: DispatchQueue.main)
            .bind(subscriber: searchView.tableView.rowsSubscriber(itemsController))
            .store(in: &subscriptions)

        searchViewModel.showErrorPublisher
            .map { error -> UIAlertController in
                let errorAlert = UIAlertController(title: R.string.localizable.error_alert_title(), message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: R.string.localizable.ok_button_text(), style: .default)
                errorAlert.addAction(okButton)
                return errorAlert
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorAlert in
                self?.present(errorAlert, animated: true, completion: nil)
            }
            .store(in: &subscriptions)
    }

}

