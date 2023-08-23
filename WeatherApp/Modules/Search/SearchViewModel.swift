import Combine
import Foundation

class SearchViewModel {

    // MARK: - Constants -

    private enum Constants {
        static let minTimeBetweenFetchCities = 1.2
    }

    enum EventInput: Equatable {
        case textChanged(text: String)
        case didSelectCity(row: Int)
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []
    private var citiesData = CitiesData(data: []) {
        didSet {
            cities = citiesData.data
            reloadTableSubject.send()
        }
    }

    var cities: [City] = []

    let eventsInputSubject = PassthroughSubject<EventInput, Never>()
    let openForecastSubject = PassthroughSubject<City, Never>()
    let fetchCitiesSubject = PassthroughSubject<String, Never>()
    let reloadTableSubject = PassthroughSubject<Void, Never>()
    let showErrorSubject = PassthroughSubject<NetworkingError, Never>()

    private var networkingService: NetworkingServiceType

    // MARK: - Initialization -

    init(networkingService: NetworkingServiceType) {
        self.networkingService = networkingService
        bindActions()
    }

    // MARK: - Private -

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

}
