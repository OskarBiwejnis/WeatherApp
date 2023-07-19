import UIKit

class SearchViewController: UIViewController {

    private enum Constants {
        static let reuseIdentifier = "searchCell"
    }
    
    let searchView = SearchView()
    private let searchViewModel = SearchViewModel()

    override func loadView() {
        searchView.viewController = self
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchViewModel.searchViewControllerDelegate = self
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textChanged(_ text: String) {
        searchViewModel.searchTextDidChange(text)
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

protocol SearchViewControllerDelegate: AnyObject {

    func reloadTable()
    func pushForecastViewController(latitude: Double, longitude: Double)
    
}

extension SearchViewController: SearchViewControllerDelegate {

    func reloadTable() {
        DispatchQueue.main.async {
            self.searchView.tableView.reloadData()
        }
    }

    func pushForecastViewController(latitude: Double, longitude: Double) {
        let forecastNavigationController = ForecastViewController()
        forecastNavigationController.latitude = latitude
        forecastNavigationController.longitude = longitude
        navigationController?.pushViewController(forecastNavigationController, animated: true)
    }

}
