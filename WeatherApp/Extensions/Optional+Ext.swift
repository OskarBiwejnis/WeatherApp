import Foundation
import Swinject

extension Optional {

    func forceResolve() -> Wrapped {
        if case let .some(value) = self {
            return value
        } else {
            fatalError("Couldn't resolve object of type: \(Wrapped.self)")
        }
    }

}
