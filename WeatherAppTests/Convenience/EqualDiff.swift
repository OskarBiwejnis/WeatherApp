import Difference
import Nimble
import XCTest
import Foundation


public func equalDiff<T: Equatable>(_ expectedValue: T?) -> Predicate<T> {
    return Predicate.define { actualExpression in
        let receivedValue = try actualExpression.evaluate()

        if receivedValue == nil {
            var message = ExpectationMessage.fail("")
            if let expectedValue = expectedValue {
                message = ExpectationMessage.expectedCustomValueTo("equal <\(expectedValue)>", actual: "nil")
            }
            return PredicateResult(status: .fail, message: message)
        }
        if expectedValue == nil {
            return PredicateResult(status: .fail, message: ExpectationMessage.fail("").appendedBeNilHint())
        }

        return PredicateResult(bool: receivedValue == expectedValue, message: ExpectationMessage.fail("Found difference for " + diff(expectedValue, receivedValue).joined(separator: ", ")))
    }
}
