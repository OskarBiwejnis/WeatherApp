import Foundation

enum NetworkingError: LocalizedError {
    case invalidResponse
    case invalidUrl
    case decodingError
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return R.string.localizable.invalid_response_message()
        case .invalidUrl:
            return R.string.localizable.invalid_url_message()
        case .decodingError:
            return R.string.localizable.decoding_error_message()
        case .unknownError:
            return R.string.localizable.unknown_error_message()
        }
    }
}

