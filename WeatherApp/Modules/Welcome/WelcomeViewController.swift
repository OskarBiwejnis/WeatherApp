import UIKit

class WelcomeViewController: UIViewController {

    private let welcomeView = WelcomeView()
    private let welcomeViewModel = WelcomeViewModel()

    override func loadView() {
        welcomeView.delegate = self
        welcomeViewModel.delegate = self
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        welcomeViewModel.reloadRecents()
    }

}

extension WelcomeViewController: WelcomeViewModelDelegate {

    func pushViewController() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    func reloadRecentsWith(_ cities: [City]) {
        welcomeView.reloadRecentsWith(cities)
    }

}

extension WelcomeViewController: WelcomeViewDelegate {

    func proceedButtonTap() {
        welcomeViewModel.pushViewController()
    }

}
