import Combine
import Foundation

protocol UsersDatabaseServiceType {
    func login(username: String, password: String) -> AnyPublisher<Void, DatabaseError>
}

class UsersDatabaseService: UsersDatabaseServiceType {

    private enum Constants {
        static let restrictedUsername = "admin"
        static let randomNumberRange = 1...4
        static let failureNumber = 4
    }

    func login(username: String, password: String) -> AnyPublisher<Void, DatabaseError> {
        guard username != Constants.restrictedUsername
        else { return Fail(outputType: Void.self, failure: DatabaseError.usernameRestricted).eraseToAnyPublisher() }

        let randomNumber = Int.random(in: Constants.randomNumberRange)
        if randomNumber == Constants.failureNumber {
            return Fail(outputType: Void.self, failure: DatabaseError.passwordIncorrect).eraseToAnyPublisher()
        } else {
            return Just(()).setFailureType(to: DatabaseError.self).eraseToAnyPublisher()
        }
    }

}
