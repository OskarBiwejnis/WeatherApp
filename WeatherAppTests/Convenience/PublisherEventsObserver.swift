import Foundation
import Combine

class PublisherEventsObserver<Output> {

    private var subscriptions: [AnyCancellable] = []
    var values: [Output] = []

    init(_ publisher: AnyPublisher<Output, Never>) {
        publisher
            .sink { [weak self] output in
                self?.values.append(output)
            }
            .store(in: &subscriptions)
    }

}
