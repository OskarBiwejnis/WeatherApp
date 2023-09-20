import Combine
import Foundation

protocol Navigable {
    var navigationEventsPublisher: AnyPublisher<NavigationEvent, Never> { get }
}
