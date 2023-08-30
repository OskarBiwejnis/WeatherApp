import Combine
import CombineCocoa
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
        searchView.tableView.dataSource = self
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseIdentifier) as? SearchCell else { return SearchCell() }
        cell.label.text = searchViewModel.cities[indexPath.row].name

        return cell
    }

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

        searchViewModel.reloadTablePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.searchView.tableView.reloadData()
            }
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

