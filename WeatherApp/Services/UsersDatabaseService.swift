import Combine
import Foundation

protocol UsersDatabaseServiceType {
    func verifyCredentials(username: String, password: String) -> AnyPublisher<Void, DatabaseError>
}

class UsersDatabaseService: UsersDatabaseServiceType {

    func verifyCredentials(username: String, password: String) -> AnyPublisher<Void, DatabaseError> {
        return Just(()).setFailureType(to: DatabaseError.self).eraseToAnyPublisher()

    }

}
