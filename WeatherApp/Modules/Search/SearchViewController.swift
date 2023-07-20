import UIKit

class SearchViewController: UIViewController {

    private enum Constants {
        static let reuseIdentifier = "searchCell"
    }
    
    private let searchView = SearchView()
    private let searchViewModel = SearchViewModel()

    override func loadView() {
        searchView.delegate = self
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchViewModel.delegate = self
        view = searchView
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier) as? SearchCell else { return SearchCell() }
        cell.label.text = searchViewModel.cities[indexPath.row].name
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchViewModel.didSelectSearchCell(didSelectRowAt: indexPath)
    }

}

extension SearchViewController: SearchViewModelDelegate {

    func reloadTable() {
        DispatchQueue.main.async {
            self.searchView.tableView.reloadData()
        }
    }

    func pushForecastViewController(latitude: Double, longitude: Double, name: String) {
        let forecastViewController = ForecastViewController()
        forecastViewController.latitude = latitude
        forecastViewController.longitude = longitude
        forecastViewController.cityName = name
        navigationController?.pushViewController(forecastViewController, animated: true)
    }

}

extension SearchViewController: SearchViewDelegate {

    func textChanged(_ text: String) {
        searchViewModel.searchTextDidChange(text)
    }

}
