import UIKit

class SearchViewController: UIViewController {

    private enum Constants {
        static let reuseIdentifier = "searchCell"
    }
    var searchView = SearchView()
    var searchTexts: [String] = []

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
        searchTexts = []
        guard text != "" else {
            searchView.tableView.reloadData()
            return
        }

        Task {
            do {

                let cities = try await NetworkingUtils.getCitiesWithPrefix(text)
                for city in cities {
                    searchTexts.append(city.name)
                }
                searchView.tableView.reloadData()
            } catch {
                fatalError(R.string.localizable.error_message())
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTexts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier) as? SearchCell else { return SearchCell() }
        cell.label.text = searchTexts[indexPath.row]

        return cell
    }
}
