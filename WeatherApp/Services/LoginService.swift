import Combine
import Foundation

protocol LoginServiceType {
    func login(username: String, password: String) -> AnyPublisher<LoginResult, LoginError>
}

enum LoginResult {
    case success
    case invalidPassword
    case usernameDoesntExist

    var description: String? {
        switch self {
        case .success:
            return nil
        case .invalidPassword:
            return R.string.localizable.invalid_password_message()
        case .usernameDoesntExist:
            return R.string.localizable.username_doesnt_exist_message()
        }
    }
}

class LoginService: LoginServiceType {

    private enum Constants {
        static let restrictedUsername = "admin"
        static let randomNumberRange = 1...4
        static let failureNumber = 4
        static let registeredUsers = ["gutek": "film123", "alojzy": "trzewiki", "kazimierz": "korbka"]
    }

    func login(username: String, password: String) -> AnyPublisher<LoginResult, LoginError> {
        guard username != Constants.restrictedUsername
        else { return Fail(outputType: LoginResult.self, failure: LoginError.usernameRestricted)
            .delayTwoSeconds().eraseToAnyPublisher() }

        let randomNumber = Int.random(in: Constants.randomNumberRange)
        if randomNumber == Constants.failureNumber {
            return Fail(outputType: LoginResult.self, failure: LoginError.unknown)
                .delayTwoSeconds().eraseToAnyPublisher()
        } else {
            if Constants.registeredUsers.keys.contains(username) {
                if password == Constants.registeredUsers[username] {
                    return Just(.success).setFailureType(to: LoginError.self)
                        .delayTwoSeconds().eraseToAnyPublisher()
                } else {
                    return Just(.invalidPassword).setFailureType(to: LoginError.self)
                        .delayTwoSeconds().eraseToAnyPublisher()
                }
            } else {
                return Just(.usernameDoesntExist).setFailureType(to: LoginError.self)
                    .delayTwoSeconds().eraseToAnyPublisher()
            }
        }
    }

}
