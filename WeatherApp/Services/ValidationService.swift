import Foundation

class ValidationService {

    private enum Constants {
        static let emailPattern = #"^\w+@\w+\.\w+$"#
        static let passwordPattern = #"^.{3,20}$"#
        static let usernamePattern = #"^\w+$"#
        static let wrongEmailMessage = "Email doesn't have expected pattern"
        static let wrongPasswordMessage = "Password must have 3-20 characters"
        static let wrongUsernameMessage = "Username doesn't have expected pattern"

    }

    static func validateEmail(_ email: String) -> String? {
        guard email != "" else { return nil }
        if email.range(of: Constants.emailPattern, options: .regularExpression) != nil {
            return nil
        } else {
            return Constants.wrongEmailMessage
        }
    }

    static func validatePassword(_ password: String) -> String? {
        guard password != "" else { return nil }
        if password.range(of: Constants.passwordPattern, options: .regularExpression) != nil {
            return nil
        } else {
            return Constants.wrongPasswordMessage
        }
    }

    static func validateUsername(_ username: String) -> String? {
        guard username != "" else { return nil }
        if username.range(of: Constants.usernamePattern, options: .regularExpression) != nil {
            return nil
        } else {
            return Constants.wrongUsernameMessage
        }
    }

}
