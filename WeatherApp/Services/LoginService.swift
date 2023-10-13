import Combine
import Foundation

protocol LoginServiceType {
    func login(username: String, password: String) -> AnyPublisher<LoginResult, DatabaseError>
}

enum LoginResult: String {
    case success
    case invalidPassword = "Password is invalid"
    case usernameDoesntExist = "Username doesn't exist"
}

class LoginService: LoginServiceType {

    private enum Constants {
        static let restrictedUsername = "admin"
        static let randomNumberRange = 1...4
        static let failureNumber = 4
        static let registeredUsers = ["gutek": "film123", "alojzy": "trzewiki", "kazimierz": "korbka"]
    }

    func login(username: String, password: String) -> AnyPublisher<LoginResult, DatabaseError> {
        guard username != Constants.restrictedUsername
        else { return Fail(outputType: LoginResult.self, failure: DatabaseError.usernameRestricted)
            .delayTwoSeconds().eraseToAnyPublisher() }

        let randomNumber = Int.random(in: Constants.randomNumberRange)
        if randomNumber == Constants.failureNumber {
            return Fail(outputType: LoginResult.self, failure: DatabaseError.unknown)
                .delayTwoSeconds().eraseToAnyPublisher()
        } else {
            if Constants.registeredUsers.keys.contains(username) {
                if password == Constants.registeredUsers[username] {
                    return Just(.success).setFailureType(to: DatabaseError.self)
                        .delayTwoSeconds().eraseToAnyPublisher()
                } else {
                    return Just(.invalidPassword).setFailureType(to: DatabaseError.self)
                        .delayTwoSeconds().eraseToAnyPublisher()
                }
            }
            else {
                return Just(.usernameDoesntExist).setFailureType(to: DatabaseError.self)
                    .delayTwoSeconds().eraseToAnyPublisher()
            }
        }
    }

}
