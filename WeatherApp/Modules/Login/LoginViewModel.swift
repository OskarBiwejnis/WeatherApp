import Combine
import Foundation

protocol LoginViewModelContract {
    var eventsInputSubject: PassthroughSubject<LoginViewController.EventInput, Never> { get }
    var viewStatePublisher: AnyPublisher<LoginViewState, Never> { get }
}

protocol LoginViewModelCoordinatorContract {
    var navigationEventsPublisher: AnyPublisher<LoginNavigationEvent, Never> { get }
}

enum LoginNavigationEvent {
    case dismiss
}

enum LoginViewState {
    case normal
    case loading
    case issue(_ message: String)
    case error(_ error: Error)
    case usernameCorrect
    case usernameValidationError(_ message: String)
    case passwordCorrect
    case passwordValidationError(_ message: String)
}

class LoginViewModel: LoginViewModelContract, LoginViewModelCoordinatorContract {

    let eventsInputSubject = PassthroughSubject<LoginViewController.EventInput, Never>()

    private let loginService: LoginServiceType

    init(usersDatabaseService: LoginServiceType) {
        self.loginService = usersDatabaseService
    }

    lazy var viewStatePublisher: AnyPublisher<LoginViewState, Never> = loginResultPublisher
        .compactMap { loginResult in
            switch loginResult {
            case .invalidPassword:
                return .issue(LoginResult.invalidPassword.rawValue)
            case .usernameDoesntExist:
                return .issue(LoginResult.usernameDoesntExist.rawValue)
            default:
                return nil
            }
        }
        .merge(with: loadingPublisher.map { .loading })
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

    private lazy var usernameValidationPublisher: AnyPublisher<LoginViewState, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case let .usernameTextChanged(username) = event {
                if let message = ValidationService.validateUsername(username) {
                    return .usernameValidationError(message)
                } else { return .usernameCorrect }
            } else { return nil }
        }
        .eraseToAnyPublisher()

    private lazy var passwordValidationPublisher: AnyPublisher<LoginViewState, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case let .passwordTextChanged(password) = event {
                if let message = ValidationService.validatePassword(password) {
                    return .passwordValidationError(message)
                } else { return .passwordCorrect }
            } else { return nil }
        }
        .eraseToAnyPublisher()

    private lazy var loginOutcomePublisher: AnyPublisher<Result<LoginResult>, Never> = eventsInputSubject
        .compactMap { [weak self] event -> (String, String)? in
            if case let .loginButtonTap(username, password) = event {
                return (username, password)
            } else { return nil }
        }
        .flatMap { [weak self] username, password in
            return self?.loginService.login(username: username, password: password)
                .toResult() ?? .emptyOutput
        }
        .share()
        .eraseToAnyPublisher()

    private lazy var loginResultPublisher: AnyPublisher<LoginResult, Never> = loginOutcomePublisher
        .extractResult()
        .eraseToAnyPublisher()

    private lazy var loginErrorPublisher: AnyPublisher<Error, Never> = loginOutcomePublisher
        .extractFailure()
        .eraseToAnyPublisher()

    private lazy var loadingPublisher: AnyPublisher<Void, Never> = eventsInputSubject
        .compactMap { event in
            if case .loginButtonTap = event {
                return ()
            } else { return nil }
        }
        .eraseToAnyPublisher()

}
