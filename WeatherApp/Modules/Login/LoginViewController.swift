import Combine
import UIKit

class LoginViewController: UIViewController {

    enum EventInput {
        case loginButtonTap(username: String, password: String)
    }

    private var subscriptions: [AnyCancellable] = []

    let loginViewModel: LoginViewModelContract
    private let loginView = LoginView()

    init(loginViewModel: LoginViewModelContract) {
        self.loginViewModel = loginViewModel
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
        loginView.loginButton.tapPublisher
            .sink { [weak self] in
                guard let username = self?.loginView.usernameTextField.text,
                      let password = self?.loginView.passwordTextField.text
                else { return }
                self?.loginViewModel.eventsInputSubject.send(.loginButtonTap(username: username, password: password))
            }
            .store(in: &subscriptions)
    }

}
