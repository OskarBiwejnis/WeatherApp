import Combine
import CombineCocoa
import UIKit

class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    private let searchViewModel = SearchViewModel(networkingService: NetworkingService())
    var subscriptions: [AnyCancellable] = []
    var textChangedPublisher = CurrentValueSubject<String, Never>("")
    var didSelectSearchCellPublisher = PassthroughSubject<Int, Never>()

    override func loadView() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchViewModel.delegate = self
        searchViewModel.searchViewController = self
        view = searchView

        searchView.searchTextFieldPublisher
            .sink(receiveValue: { text in
                self.textChangedPublisher.send(text ?? "")
            })
            .store(in: &subscriptions)

        searchViewModel.openCityForecastPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { city in
                self.navigationController?.pushViewController(ForecastViewController(city: city), animated: true)
            })
            .store(in: &subscriptions)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        didSelectSearchCellPublisher.send(indexPath.row)
    }

}

extension SearchViewController: SearchViewModelDelegate {

    func reloadTable() {
        DispatchQueue.main.async {
            self.searchView.tableView.reloadData()
        }
    }

    func showError(_ error: Error) {
        let errorAlert = UIAlertController(title: R.string.localizable.error_alert_title(), message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: R.string.localizable.ok_button_text(), style: .default)
        errorAlert.addAction(okButton)
        DispatchQueue.main.async {
            self.present(errorAlert, animated: true, completion: nil)
        }
    }

}
