import Combine
import CombineExt
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Constants -

    enum EventInput {
        case loginButtonTap
        case usernameTextChanged(_ username: String)
        case passwordTextChanged(_ password: String)
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    let loginViewModel: LoginViewModelContract
    private let loginView = LoginView()

    // MARK: - Initialization -

    init(loginViewModel: LoginViewModelContract) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public -

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }

    // MARK: - Private -

    private func bindActions() {
        loginView.loginButton.tapPublisher
            .sink { [weak self] in
                self?.loginViewModel.eventsInputSubject.send(.loginButtonTap)
            }
            .store(in: &subscriptions)

        loginView.usernameTextFieldView.textField.textPublisher
            .sink { [weak self] username in
                guard let username else { return }
                self?.loginViewModel.eventsInputSubject.send(.usernameTextChanged(username))
            }
            .store(in: &subscriptions)

        loginView.passwordTextFieldView.textField.textPublisher
            .sink { [weak self] password in
                guard let password else { return }
                self?.loginViewModel.eventsInputSubject.send(.passwordTextChanged(password))
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
