import Combine
import Foundation

extension Publisher {

    func emptyOutput() -> AnyPublisher<Output, Never> {
        return Empty<Output, Never>().eraseToAnyPublisher()
    }

    func toResult() -> AnyPublisher<Result<Output>, Never> {
        self.map { output in
            return Result.success(output)
        }
        .catch { error in
            return Just(Result.failure(error))
        }
        .eraseToAnyPublisher()
    }

    func handleOutputEvents(_ handler: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        return map { output in
            handler(output)
            return output
        }
        .eraseToAnyPublisher()
    }

}


extension Publisher where Output: ResultProtocol, Failure == Never {

    func extractResult<T>() -> AnyPublisher<T, Never> {
        return compactMap { resultProtocol in
            if let result = resultProtocol as? Result<T>,
                case let .success(resultItem) = result {
                return resultItem
            } else {
                return nil
            }
        }
        .eraseToAnyPublisher()
    }

    func extractFailure() -> AnyPublisher<Error, Never> {
        return compactMap { resultProtocol in
            if let result = resultProtocol as? Result<Output.T> {
                return result.error
            } else {
                return nil
            }
        }
        .eraseToAnyPublisher()
    }

}
