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
