// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}


// MARK: - AutoEquatable for classes, protocols, structs

// MARK: - AutoEquatable for Enums
// MARK: - WelcomeViewController.EventInput AutoEquatable
extension WelcomeViewController.EventInput: Equatable {}
internal func == (lhs: WelcomeViewController.EventInput, rhs: WelcomeViewController.EventInput) -> Bool {
    switch (lhs, rhs) {
    case (.proceedButtonTap, .proceedButtonTap):
        return true
    case let (.didSelectRecentCity(lhs), .didSelectRecentCity(rhs)):
        return lhs == rhs
    case (.viewWillAppear, .viewWillAppear):
        return true
    default: return false
    }
}
