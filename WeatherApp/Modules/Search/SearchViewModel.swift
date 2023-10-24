import Combine
import CombineExt
import CombineDataSources
import CombineSchedulers
import Foundation

class SearchViewModel: SearchViewModelContract, SearchViewModelCoordinatorContract {

    // MARK: - Constants -

    private enum Constants {
        static let debounceTime = 1.2
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []
    private let scheduler: AnySchedulerOf<DispatchQueue>

    private var cities: [City] = []

    let eventsInputSubject = PassthroughSubject<SearchViewController.EventInput, Never>()

    private var networkingService: NetworkingServiceType

    // MARK: - Initialization -

    init(networkingService: NetworkingServiceType, scheduler: AnySchedulerOf<DispatchQueue>) {
        self.networkingService = networkingService
        self.scheduler = scheduler
    }

    // MARK: - Public -

    lazy var viewStatePublisher: AnyPublisher<SearchViewState, Never> = foundCitiesPublisher
        .map { .cities($0) }
        .merge(with: showErrorPublisher.map { .error($0) })
        .eraseToAnyPublisher()

    lazy var navigationEventsPublisher: AnyPublisher<SearchNavigationEvent, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .didSelectCity(let row) = event, let city = self?.cities[row] {

                return SearchNavigationEvent.openForecastScreen(city: city)
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


    private lazy var foundCitiesPublisher: AnyPublisher<[City], Never> = searchResultPublisher
        .extractResult()
        .map { citiesData in
            return citiesData.data
        }
        .handleOutputEvents { cities in
                self.cities = cities
        }
        .eraseToAnyPublisher()

    private lazy var showErrorPublisher: AnyPublisher<Error, Never> = searchResultPublisher
        .extractFailure()
        .eraseToAnyPublisher()

}
