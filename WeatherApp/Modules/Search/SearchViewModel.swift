import Combine
import Foundation

protocol SearchViewModelContract {

    var cities: [City] { get }

    var eventsInputSubject: PassthroughSubject<SearchViewController.EventInput, Never> { get }
    var reloadTableSubject: PassthroughSubject<Void, Never> { get }
    var showErrorSubject: PassthroughSubject<NetworkingError, Never> { get }
    var openForecastPublisher: AnyPublisher<City, Never>  { get }

}

class SearchViewModel: SearchViewModelContract {

    // MARK: - Constants -

    private enum Constants {
        static let debounceTime = 1.2
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

    let eventsInputSubject = PassthroughSubject<SearchViewController.EventInput, Never>()
    let reloadTableSubject = PassthroughSubject<Void, Never>()
    let showErrorSubject = PassthroughSubject<NetworkingError, Never>()
    lazy var openForecastPublisher: AnyPublisher<City, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .didSelectCity(let row) = event {
                return self?.cities[row]
            } else { return nil }
        }
        .eraseToAnyPublisher()
    private lazy var fetchCitiesPublisher: AnyPublisher<String, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .textChanged(let text) = event {
                return text == "" ? nil : text
            } else { return nil }
        }
        .debounce(for: .seconds(Constants.debounceTime), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()

    private var networkingService: NetworkingServiceType

    // MARK: - Initialization -

    init(networkingService: NetworkingServiceType) {
        self.networkingService = networkingService
        bindActions()
    }

    // MARK: - Private -

    private func bindActions() {
        fetchCitiesPublisher
            .sink { [weak self] text in
                self?.fetchCities(text)
            }
            .store(in: &subscriptions)
    }

    private func fetchCities(_ text: String) {
        networkingService.citiesPublisher(text)
            .catch { [self] error in
                showErrorSubject.send(error)
                return Empty<CitiesData, Never>()
            }
            .assign(to: \.citiesData, on: self)
            .store(in: &subscriptions)
    }
}
