import Combine
import Foundation

protocol LoginViewModelContract {
    //var eventsInputSubject: PassthroughSubject<LoginViewController.EventInput, Never> { get }
    var viewStatePublisher: AnyPublisher<LoginViewState, Never> { get }
}

protocol LoginViewModelCoordinatorContract {

}

enum LoginNavigationEvent {
    case dismiss
}

enum LoginViewState {
    case success(isPremiumUser: Bool)
    case error(Error)
}

class LoginViewModel  {//: LoginViewModelContract, LoginViewModelCoordinatorContract {
    
//    let eventsInputSubject = PassthroughSubject<LoginViewController.EventInput, Never>()
//
//   // lazy var viewStatePublisher: AnyPublisher<LoginViewState, Never>
//
//    private let userDatabaseService: UserDatabaseServiceType
//
//    init(userDatabaseService: UserDatabaseServiceType) {
//        self.userDatabaseService = userDatabaseService
//    }
//
//    private lazy var loginOutcomePublisher: AnyPublisher<Result<UsefulUserData>, Never> = eventsInputSubject
//        .compactMap { event -> (String, String)? in
//            if case let .loginButtonTap(username, password) = event {
//                return (username, password)
//            } else { return nil }
//        }
//        .flatMap { [weak self] username, password in
//            return self?.userDatabaseService.verifyCredentials(username: username, password: password)
//                .toResult() ?? .emptyOutput
//        }
//        .eraseToAnyPublisher()

}
