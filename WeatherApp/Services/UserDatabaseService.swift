import Combine
import Foundation

protocol UserDatabaseServiceType {
    func verifyCredentials(username: String, password: String) -> AnyPublisher<UsefulUserData, DatabaseError>
}

class UserDatabaseService: UserDatabaseServiceType {

    func verifyCredentials(username: String, password: String) -> AnyPublisher<UsefulUserData, DatabaseError> {
        return Just(UsefulUserData(isPremiumUser: true)).setFailureType(to: DatabaseError.self).eraseToAnyPublisher()
    }

}
