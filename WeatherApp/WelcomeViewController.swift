import UIKit

class WelcomeViewController: UIViewController {

    var welcomeView = WelcomeView()
    var mainViewController = MainViewController()

    override func loadView() {
        welcomeView.viewController = self
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tappedButton() {
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}
