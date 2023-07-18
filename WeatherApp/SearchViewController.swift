import UIKit

class SearchViewController: UIViewController {

    private enum Constants {
        static let reuseIdentifier = "searchCell"
    }
    
    var searchView = SearchView()
    var searchViewModel = SearchViewModel()
    var searchResults: [String] = []

    override func loadView() {
        searchView.viewController = self
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        searchViewModel.didFetchSearchResults = self.didFetchSearchResults(searchResults:)
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textChanged(_ text: String) {
        searchViewModel.fetchSearchResults(text)
    }

    func didFetchSearchResults(searchResults: [String]) async {
        self.searchResults = searchResults
        searchView.tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier) as? SearchCell else { return SearchCell() }
        cell.label.text = searchResults[indexPath.row]

        return cell
    }
}
