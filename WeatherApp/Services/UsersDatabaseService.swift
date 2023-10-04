import Combine
import Foundation

protocol UsersDatabaseServiceType {
    func login(username: String, password: String) -> AnyPublisher<Bool, DatabaseError>
}

class UsersDatabaseService: UsersDatabaseServiceType {

    private enum Constants {
        static let restrictedUsername = "admin"
        static let randomNumberRange = 1...4
        static let failureNumber = 4
        static let registeredUsers = ["gutek": "film123", "alojzy": "trzewiki", "kazimierz": "korbka"]
        static let delay = 2
    }

    func login(username: String, password: String) -> AnyPublisher<Bool, DatabaseError> {
        guard username != Constants.restrictedUsername
        else { return Fail(outputType: Bool.self, failure: DatabaseError.usernameRestricted).delay(for: .seconds(Constants.delay), scheduler: DispatchQueue.main).eraseToAnyPublisher() }

        let randomNumber = Int.random(in: Constants.randomNumberRange)
        if randomNumber == Constants.failureNumber {
            return Fail(outputType: Bool.self, failure: DatabaseError.unknown).delay(for: .seconds(Constants.delay), scheduler: DispatchQueue.main).eraseToAnyPublisher()
        } else {
            if password == Constants.registeredUsers[username] {
                return Just(true).setFailureType(to: DatabaseError.self).delay(for: .seconds(Constants.delay), scheduler: DispatchQueue.main).eraseToAnyPublisher()
            } else {
                return Just(false).setFailureType(to: DatabaseError.self).delay(for: .seconds(Constants.delay), scheduler: DispatchQueue.main).eraseToAnyPublisher()
            }
        }
    }

}
