import Foundation

enum DatabaseError: Error {
    case passwordIncorrect
    case usernameRestricted
}
