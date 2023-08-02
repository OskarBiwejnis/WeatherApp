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
        welcomeViewModel.viewWillAppear()
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

    func recentButtonTap(tag: Int) {
        welcomeViewModel.recentButtonTap(tag: tag)
    }
}
