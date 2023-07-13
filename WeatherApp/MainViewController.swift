import UIKit

class MainViewController: UIViewController {

    var mainView = MainView()

    override func loadView() {
        mainView.viewController = self
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
