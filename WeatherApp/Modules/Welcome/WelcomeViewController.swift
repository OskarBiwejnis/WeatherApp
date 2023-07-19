import UIKit

class WelcomeViewController: UIViewController {

    private let welcomeView = WelcomeView()
    private let welcomeViewModel = WelcomeViewModel()
    private let mainViewController = SearchViewController()

    override func loadView() {
        welcomeView.viewController = self
        welcomeViewModel.welcomeViewControllerDelegate = self
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func proceedButtonTap() {
        welcomeViewModel.pushViewController()
    }

}

protocol WelcomeViewControllerDelegate: AnyObject {

    func pushViewController()
    
}

extension WelcomeViewController: WelcomeViewControllerDelegate {

    func pushViewController() {
        navigationController?.pushViewController(mainViewController, animated: true)
    }

}
