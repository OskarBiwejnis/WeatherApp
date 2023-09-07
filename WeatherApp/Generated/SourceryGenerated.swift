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
// MARK: - SearchViewController.EventInput AutoEquatable
extension SearchViewController.EventInput: Equatable {}
internal func == (lhs: SearchViewController.EventInput, rhs: SearchViewController.EventInput) -> Bool {
    switch (lhs, rhs) {
    case let (.textChanged(lhs), .textChanged(rhs)):
        return lhs == rhs
    case let (.didSelectCity(lhs), .didSelectCity(rhs)):
        return lhs == rhs
    default: return false
    }
}
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

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
























class StorageServiceTypeMock: StorageServiceType {




    //MARK: - getRecentCities

    var getRecentCitiesCallsCount = 0
    var getRecentCitiesCalled: Bool {
        return getRecentCitiesCallsCount > 0
    }
    var getRecentCitiesReturnValue: [City]!
    var getRecentCitiesClosure: (() -> [City])?

    func getRecentCities() -> [City] {
        getRecentCitiesCallsCount += 1
        if let getRecentCitiesClosure = getRecentCitiesClosure {
            return getRecentCitiesClosure()
        } else {
            return getRecentCitiesReturnValue
        }
    }

    //MARK: - addRecentCity

    var addRecentCityCallsCount = 0
    var addRecentCityCalled: Bool {
        return addRecentCityCallsCount > 0
    }
    var addRecentCityReceivedCity: City?
    var addRecentCityReceivedInvocations: [City] = []
    var addRecentCityClosure: ((City) -> Void)?

    func addRecentCity(_ city: City) {
        addRecentCityCallsCount += 1
        addRecentCityReceivedCity = city
        addRecentCityReceivedInvocations.append(city)
        addRecentCityClosure?(city)
    }

}
