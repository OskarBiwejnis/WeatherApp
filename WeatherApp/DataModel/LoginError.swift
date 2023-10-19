import Foundation

enum LoginError: LocalizedError {
    case unknown
    case usernameRestricted

    var errorDescription: String? {
        switch self {
        case .unknown:
            return R.string.localizable.unknown_error_message()
        case .usernameRestricted:
            return R.string.localizable.username_restricted_message()
        }
    }
}
