import UIKit

class WelcomeViewController: UIViewController {

    private let welcomeView = WelcomeView()
    private let welcomeViewModel = WelcomeViewModel()

    override func loadView() {
        welcomeView.delegate = self
        welcomeViewModel.delegate = self
        welcomeView.tableView.delegate = self
        welcomeView.tableView.dataSource = self
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.welcomeView.tableView.reloadData()
        }
    }

}

extension WelcomeViewController: WelcomeViewModelDelegate {

    func pushViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    func reloadRecentCities(_ cities: [City]) {
        welcomeView.reloadRecentCities(cities)
    }

}

extension WelcomeViewController: WelcomeViewDelegate {

    func proceedButtonTap() {
        welcomeViewModel.proceedButtonTap()
    }
}


extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return welcomeViewModel.getNumberOfRecentCities()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentCityCell.reuseIdentifier) as? RecentCityCell else { return RecentCityCell() }
        cell.label.text = welcomeViewModel.getRecentCityName(index: indexPath.row)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        welcomeViewModel.didSelectRecentCityCell(didSelectRowAt: indexPath)
    }

}
