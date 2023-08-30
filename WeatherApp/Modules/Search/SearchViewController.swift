import Combine
import CombineCocoa
import CombineDataSources
import UIKit

class SearchViewController: UIViewController {

    // MARK: - Constants -

    // sourcery: AutoEquatable
    enum EventInput {
        case textChanged(text: String)
        case didSelectCity(row: Int)
    }
    
    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    private let searchView = SearchView()
    private let searchViewModel: SearchViewModelContract = SearchViewModel(networkingService: NetworkingService())

    // MARK: - Public -

    override func loadView() {
        searchView.tableView.delegate = self
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }
}

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchViewModel.eventsInputSubject.send(.didSelectCity(row: indexPath.row))
    }

}

    // MARK: - Private -

extension SearchViewController {

    private func bindActions() {
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
            .bind(subscriber: searchView.tableView.rowsSubscriber(cellIdentifier: SearchCell.reuseIdentifier, cellType: SearchCell.self, cellConfig: { cell, indexPath, model in
                cell.label.text = model.name
            }))
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

