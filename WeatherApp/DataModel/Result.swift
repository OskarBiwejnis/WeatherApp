import Foundation

protocol ResultProtocol {

    associatedtype T

}

enum Result<T>: ResultProtocol {

    case success(T)
    case failure(Error)

      var value: T? {
          if case let .success(value) = self {
              return value
          } else {
              return nil
          }
      }

      var error: Error? {
          if case let .failure(error) = self {
              return error
          } else {
              return nil
          }
      }

}
