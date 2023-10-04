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
    case success
    case error(Error)
    case invalidCredentials
}

class LoginViewModel: LoginViewModelContract, LoginViewModelCoordinatorContract {

    private enum Constants {
        static let usernamePattern = "[a-zA-Z0-9]{3,20}"
    }

    let eventsInputSubject = PassthroughSubject<LoginViewController.EventInput, Never>()
    private let invalidCredentialsSubject = PassthroughSubject<Void, Never>()

    lazy var viewStatePublisher: AnyPublisher<LoginViewState, Never> = loginErrorPublisher
        .map { .error($0) }
        .merge(with: invalidCredentialsSubject.map { .invalidCredentials })
        .eraseToAnyPublisher()

    lazy var navigationEventsPublisher: AnyPublisher<LoginNavigationEvent, Never> = loginResultPublisher
        .map { .dismiss }
        .eraseToAnyPublisher()

    private let usersDatabaseService: UsersDatabaseServiceType

    init(usersDatabaseService: UsersDatabaseServiceType) {
        self.usersDatabaseService = usersDatabaseService
    }

    private lazy var loginOutcomePublisher: AnyPublisher<Result<Void>, Never> = eventsInputSubject
        .compactMap { [weak self] event -> (String, String)? in
            if case let .loginButtonTap(username, password) = event {
                guard let areCredentialsValid = self?.validateCredentials(username: username, password: password), areCredentialsValid == true
                else {
                    self?.invalidCredentialsSubject.send()
                    return nil }
                return (username, password)
            } else { return nil }
        }
        .flatMap { [weak self] username, password in
            return self?.usersDatabaseService.login(username: username, password: password)
                .toResult() ?? .emptyOutput
        }
        .share()
        .eraseToAnyPublisher()

    private lazy var loginResultPublisher: AnyPublisher<Void, Never> = loginOutcomePublisher
        .extractResult()
        .eraseToAnyPublisher()

    private lazy var loginErrorPublisher: AnyPublisher<Error, Never> = loginOutcomePublisher
        .extractFailure()
        .eraseToAnyPublisher()

    private func validateCredentials(username: String, password: String) -> Bool {
        let result = username.range(of: Constants.usernamePattern, options: .regularExpression)
        let isUsernameValid = (result != nil)
        return isUsernameValid
    }

}
