import Combine
import UIKit

class WelcomeViewModel {

    let storageService: StorageServiceType = StorageService()
    var subscriptions: [AnyCancellable] = []
    var reloadRecentCitiesSubject = CurrentValueSubject<[City], Never>([])
    var openSearchScreenSubject = PassthroughSubject<Void, Never>()
    var openForecastSubject = PassthroughSubject<Int, Never>()
    var eventsInputSubject = PassthroughSubject<EventInput, Never>()

    init() {
        eventsInputSubject
            .sink { [self] eventInput in
                switch eventInput {
                case .proceedButtonTap:
                    openSearchScreenSubject.send()
                case .didSelectRecentCity(let row):
                    openForecastSubject.send(row)
                case .viewWillAppear:
                    reloadRecentCitiesSubject.value = storageService.getRecentCities()
                }
            }
            .store(in: &subscriptions)
    }

    enum EventInput: Equatable {
        case proceedButtonTap
        case didSelectRecentCity(row: Int)
        case viewWillAppear
    }
    
}


