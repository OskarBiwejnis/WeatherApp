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

        loginViewModel.viewStatePublisher
            .sink { [weak self] viewState in
                if case let .error(error) = viewState {
                    self?.handleErrorState(error)
                }
                self?.loginView.changeState(viewState)
            }
            .store(in: &subscriptions)
    }

    private func handleErrorState(_ error: Error) {
        let errorAlert = UIAlertController(title: R.string.localizable.error_alert_title(), message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: R.string.localizable.ok_button_text(), style: .default)
        errorAlert.addAction(okButton)
        DispatchQueue.main.async {
            self.present(errorAlert, animated: true, completion: nil)
        }
    }

}
