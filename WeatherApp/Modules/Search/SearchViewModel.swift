import Combine
import CombineExt
import CombineDataSources
import CombineSchedulers
import Foundation

protocol SearchViewModelContract {

    var cities: [City] { get }

    var eventsInputSubject: PassthroughSubject<SearchViewController.EventInput, Never> { get }
    var foundCitiesPublisher: AnyPublisher<[City], Never> { get }
    var showErrorPublisher: AnyPublisher<Error, Never> { get }

}

protocol SearchViewModelCoordinatorContract {

    var navigationEventsPublisher: AnyPublisher<SearchNavigationEvent, Never> { get }

}

enum SearchNavigationEvent {
    case didSelectCity(city: City)
}

class SearchViewModel: SearchViewModelContract, SearchViewModelCoordinatorContract {

    // MARK: - Constants -

    private enum Constants {
        static let debounceTime = 1.2
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []
    private let scheduler: AnySchedulerOf<DispatchQueue>

    var cities: [City] = []

    let eventsInputSubject = PassthroughSubject<SearchViewController.EventInput, Never>()

    private var networkingService: NetworkingServiceType

    // MARK: - Initialization -

    init(networkingService: NetworkingServiceType, scheduler: AnySchedulerOf<DispatchQueue>) {
        self.networkingService = networkingService
        self.scheduler = scheduler
    }

    // MARK: - Public -

    lazy var navigationEventsPublisher: AnyPublisher<SearchNavigationEvent, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .didSelectCity(let row) = event, let city = self?.cities[row] {

                return SearchNavigationEvent.didSelectCity(city: city)
            } else { return nil }
        }
        .eraseToAnyPublisher()

    // MARK: - Private -

    private lazy var searchResultPublisher: AnyPublisher<Result<CitiesData>, Never> =
        eventsInputSubject
        .compactMap { [weak self] event in
            if case .textChanged(let text) = event {
                return text == "" ? nil : text
            } else { return nil }
        }
        .debounce(for: .seconds(Constants.debounceTime), scheduler: scheduler)
        .flatMapLatest { [weak self] text in
            self?.networkingService.fetchCities(text).toResult() ?? .emptyOutput
        }
        .share()
        .eraseToAnyPublisher()


    lazy var foundCitiesPublisher: AnyPublisher<[City], Never> = searchResultPublisher
        .extractResult()
        .map { citiesData in
            return citiesData.data
        }
        .handleOutputEvents { cities in
                self.cities = cities
        }
        .eraseToAnyPublisher()

    lazy var showErrorPublisher: AnyPublisher<Error, Never> = searchResultPublisher
        .extractFailure()
        .eraseToAnyPublisher()

}
