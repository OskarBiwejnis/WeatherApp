import UIKit

class SearchViewController: UIViewController {

    private enum Constants {
        static let reuseIdentifier = "searchCell"
    }
    
    var searchView = SearchView()
    var searchResults: [String] = []

    override func loadView() {
        searchView.viewController = self
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textChanged(_ text: String) {
        searchResults = []
        guard text != "" else {
            searchView.tableView.reloadData()
            return
        }

        Task {
            do {
                let cities = try await NetworkingUtils.fetchCities(text)
                for city in cities {
                    searchResults.append(city.name)
                }
                searchView.tableView.reloadData()
            } catch NetworkingError.decodingError {
                print(NetworkingError.decodingError)
            } catch NetworkingError.invalidResponse {
                print(NetworkingError.invalidResponse)
            }
        }
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
