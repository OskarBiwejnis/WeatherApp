import Combine
import UIKit

class WelcomeViewModel {

    let storageService: StorageServiceType = StorageService()
    private var subscriptions: [AnyCancellable] = []
    let reloadRecentCitiesSubject = CurrentValueSubject<[City], Never>([])
    let openSearchScreenSubject = PassthroughSubject<Void, Never>()
    let openForecastSubject = PassthroughSubject<Int, Never>()
    let eventsInputSubject = PassthroughSubject<EventInput, Never>()

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


