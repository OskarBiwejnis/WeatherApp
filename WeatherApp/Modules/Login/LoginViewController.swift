import Combine
import UIKit

class LoginViewController: UIViewController {

    private var subscriptions: [AnyCancellable] = []

    private let loginView = LoginView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }

    private func bindActions() {

    }

}
