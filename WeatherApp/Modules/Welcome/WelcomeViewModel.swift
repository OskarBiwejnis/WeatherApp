import Combine
import UIKit

class WelcomeViewModel {

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    var recentCities: [City] = []
    let eventsInputSubject = PassthroughSubject<EventInput, Never>()
    let reloadRecentCitiesSubject = CurrentValueSubject<[City], Never>([])
    let openSearchScreenSubject = PassthroughSubject<Void, Never>()
    let openForecastSubject = PassthroughSubject<Int, Never>()

    private let storageService: StorageServiceType = StorageService()

    // MARK: - Initialization -
    
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


