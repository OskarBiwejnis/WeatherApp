import Combine
import CombineExt
import Foundation

class LoginViewModel: LoginViewModelContract, LoginViewModelCoordinatorContract {

    let eventsInputSubject = PassthroughSubject<LoginViewController.EventInput, Never>()
    private var subscriptions: [AnyCancellable] = []
    private let loginService: LoginServiceType

    init(usersDatabaseService: LoginServiceType) {
        self.loginService = usersDatabaseService

    }

    lazy var viewStatePublisher: AnyPublisher<LoginViewState, Never> = loginResultPublisher
        .compactMap { loginResult in
            switch loginResult {
            case .invalidPassword:
                guard let message = LoginResult.invalidPassword.description else { return nil }
                return .issue(message)
            case .usernameDoesntExist:
                guard let message = LoginResult.usernameDoesntExist.description else { return nil }
                return .issue(message)
            default:
                return nil
            }
        }
        .merge(with: validCredentialsPublisher.map { _ in return .loading })
        .merge(with: loginErrorPublisher.map { .error($0) })
        .merge(with: usernameValidationPublisher)
        .merge(with: passwordValidationPublisher)
        .eraseToAnyPublisher()

    lazy var navigationEventsPublisher: AnyPublisher<LoginNavigationEvent, Never> = loginResultPublisher
        .compactMap { loginResult in
            if case .success = loginResult {
                return .dismiss
            } else { return nil }
        }
        .eraseToAnyPublisher()

    private lazy var usernameTextChangedPublisher: AnyPublisher<String, Never> = eventsInputSubject
        .compactMap { event in
            if case let .usernameTextChanged(username) = event {
                return username
            } else { return nil }
        }
        .eraseToAnyPublisher()

    private lazy var passwordTextChangedPublisher: AnyPublisher<String, Never> = eventsInputSubject
        .compactMap { event in
            if case let .passwordTextChanged(password) = event {
                return password
            } else { return nil }
        }
        .eraseToAnyPublisher()

    private lazy var usernameValidationPublisher: AnyPublisher<LoginViewState, Never> = usernameTextChangedPublisher
        .map { username in
            if let message = ValidationService.validateUsername(username) {
                return .usernameValidationError(message)
            } else { return .usernameCorrect }
        }
        .eraseToAnyPublisher()

    private lazy var passwordValidationPublisher: AnyPublisher<LoginViewState, Never> = passwordTextChangedPublisher
        .map { password in
            if let message = ValidationService.validatePassword(password) {
                return .passwordValidationError(message)
            } else { return .passwordCorrect }
        }
        .eraseToAnyPublisher()

    private lazy var loginOutcomePublisher: AnyPublisher<Result<LoginResult>, Never> = validCredentialsPublisher
        .flatMap { [weak self] username, password in
            return self?.loginService.login(username: username, password: password)
                .toResult() ?? .emptyOutput
        }
        .share()
        .eraseToAnyPublisher()

    private lazy var validCredentialsPublisher: AnyPublisher<(String, String), Never> = eventsInputSubject
        .compactMap { event -> Void? in
            if case .loginButtonTap = event {
                return ()
            } else { return nil }
        }
        .withLatestFrom(usernameTextChangedPublisher, passwordTextChangedPublisher)
        .compactMap { [weak self] username, password -> (String, String)? in
            if ValidationService.validateUsername(username) == nil,
               ValidationService.validatePassword(password) == nil {
                return (username, password)
            } else { return nil }
        }
        .eraseToAnyPublisher()

    private lazy var loginResultPublisher: AnyPublisher<LoginResult, Never> = loginOutcomePublisher
        .extractResult()
        .eraseToAnyPublisher()

    private lazy var loginErrorPublisher: AnyPublisher<Error, Never> = loginOutcomePublisher
        .extractFailure()
        .eraseToAnyPublisher()

}
