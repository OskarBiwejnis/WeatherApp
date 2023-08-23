import Combine
import Foundation

class SearchViewModel {

    private enum Constants {
        static let minTimeBetweenFetchCities = 1.2
    }

    var cities: [City] = []
    var citiesData = CitiesData(data: []) {
        didSet {
            cities = citiesData.data
            reloadTableSubject.send()
        }
    }
    private var networkingService: NetworkingServiceType

    private var subscriptions: [AnyCancellable] = []
    var eventsInputSubject = PassthroughSubject<EventInput, Never>()
    var openForecastSubject = PassthroughSubject<City, Never>()
    var fetchCitiesSubject = PassthroughSubject<String, Never>()
    var reloadTableSubject = PassthroughSubject<Void, Never>()
    var showErrorSubject = PassthroughSubject<NetworkingError, Never>()

    init(networkingService: NetworkingServiceType) {
        self.networkingService = networkingService
        bindActions()
    }

    private func bindActions() {
        eventsInputSubject
            .sink { [self] eventInput in
                switch eventInput {
                case .textChanged(let text):
                    fetchCitiesSubject.send(text)
                case .didSelectCity(let row):
                    openForecastSubject.send(cities[row])
                }
            }
            .store(in: &subscriptions)

        fetchCitiesSubject
            .debounce(for: .seconds(1.2), scheduler: DispatchQueue.global())
            .sink { [self] text in
                fetchCities(text)
            }
            .store(in: &subscriptions)
    }

    private func fetchCities(_ text: String) {
        guard text != "" else {
            return
        }

        networkingService.citiesPublisher(text)
            .catch { [self] error in
                showErrorSubject.send(error)
                return Empty<CitiesData, Never>()
            }
            .assign(to: \.citiesData, on: self)
            .store(in: &subscriptions)
    }

    enum EventInput: Equatable {
        case textChanged(text: String)
        case didSelectCity(row: Int)
    }

}
