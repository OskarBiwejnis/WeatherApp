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
    
}

extension WelcomeViewController: WelcomeViewModelDelegate {

    func pushViewController() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

}

extension WelcomeViewController: WelcomeViewDelegate {

    func proceedButtonTap() {
        welcomeViewModel.pushViewController()
    }

}
