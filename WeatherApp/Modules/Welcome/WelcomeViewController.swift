import UIKit

class WelcomeViewController: UIViewController {

    var welcomeView = WelcomeView()
    var welcomeViewModel = WelcomeViewModel()
    var mainViewController = SearchViewController()

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
