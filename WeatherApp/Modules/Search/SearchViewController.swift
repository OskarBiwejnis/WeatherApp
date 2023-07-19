import UIKit

class SearchViewController: UIViewController {

    private enum Constants {
        static let reuseIdentifier = "searchCell"
    }
    
    var searchView = SearchView()
    var searchViewModel = SearchViewModel()

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
        return searchViewModel.searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier) as? SearchCell else { return SearchCell() }
        cell.label.text = searchViewModel.searchResults[indexPath.row]

        return cell
    }
}

protocol SearchViewControllerDelegate: AnyObject {

    func reloadTable()
    
}

extension SearchViewController: SearchViewControllerDelegate {

    func reloadTable() {
        DispatchQueue.main.async {
            self.searchView.tableView.reloadData()
        }
    }

}
