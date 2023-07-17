import UIKit

class SearchViewController: UIViewController {

    var searchView = SearchView()
    var searchTexts: [String] = []

    override func loadView() {
        Task {
            do {
                let users = try await NetworkingUtils.get3FirstGitHubUsers()

                if let users {
                    for user in users {
                        searchTexts.append(user.login)
                    }
                    print(users)
                    print(searchTexts)
                    searchView.tableView.reloadData()
                }
            } catch {
                fatalError(R.string.localizable.errorMessage())
            }
        }

        searchView.viewController = self
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTexts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.string.localizable.reuseIdentifier()) as? SearchCell else { return SearchCell() }
        cell.set(text: searchTexts[indexPath.row])

        return cell
    }
}
