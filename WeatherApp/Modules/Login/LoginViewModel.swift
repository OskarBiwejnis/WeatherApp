import Combine
import Foundation

protocol LoginViewModelContract {
    var eventsInputSubject: PassthroughSubject<LoginViewController.EventInput, Never> { get }
    //var viewStatePublisher: AnyPublisher<LoginViewState, Never> { get }
}

protocol LoginViewModelCoordinatorContract {

    var navigationEventsPublisher: AnyPublisher<LoginNavigationEvent, Never> { get }

}

enum LoginNavigationEvent {
    case dismiss
}

enum LoginViewState {
    case success(isPremiumUser: Bool)
    case error(Error)
}

class LoginViewModel: LoginViewModelContract, LoginViewModelCoordinatorContract {
    
    let eventsInputSubject = PassthroughSubject<LoginViewController.EventInput, Never>()

    lazy var viewStatePublisher: AnyPublisher<LoginViewState, Never> = loginFailurePublisher
        .map { .error($0) }
        .eraseToAnyPublisher()

    lazy var navigationEventsPublisher: AnyPublisher<LoginNavigationEvent, Never> = loginSuccessfulPublisher
        .map { .dismiss }
        .eraseToAnyPublisher()

    private let usersDatabaseService: UsersDatabaseServiceType

    init(usersDatabaseService: UsersDatabaseServiceType) {
        self.usersDatabaseService = usersDatabaseService
    }

    private lazy var loginOutcomePublisher: AnyPublisher<Result<Void>, Never> = eventsInputSubject
        .compactMap { event -> (String, String)? in
            if case let .loginButtonTap(username, password) = event {
                return (username, password)
            } else { return nil }
        }
        .flatMap { [weak self] username, password in
            return self?.usersDatabaseService.verifyCredentials(username: username, password: password)
                .toResult() ?? .emptyOutput
        }
        .share()
        .eraseToAnyPublisher()

    private lazy var loginSuccessfulPublisher: AnyPublisher<Void, Never> = loginOutcomePublisher
        .extractResult()
        .eraseToAnyPublisher()

    private lazy var loginFailurePublisher: AnyPublisher<Error, Never> = loginOutcomePublisher
        .extractFailure()
        .eraseToAnyPublisher()
}
