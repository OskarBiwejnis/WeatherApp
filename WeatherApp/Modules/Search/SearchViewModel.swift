import Combine
import CombineExt
import CombineDataSources
import Foundation

protocol SearchViewModelContract {

    var cities: [City] { get }

    var eventsInputSubject: PassthroughSubject<SearchViewController.EventInput, Never> { get }
    var foundCitiesPublisher: AnyPublisher<[City], Never> { get }
    var showErrorPublisher: AnyPublisher<Error, Never> { get }
    var openForecastPublisher: AnyPublisher<City, Never> { get }

}

class SearchViewModel: SearchViewModelContract {

    // MARK: - Constants -

    private enum Constants {
        static let debounceTime = 1.2
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    var cities: [City] = []

    let eventsInputSubject = PassthroughSubject<SearchViewController.EventInput, Never>()

    private var networkingService: NetworkingServiceType

    // MARK: - Initialization -

    init(networkingService: NetworkingServiceType) {
        self.networkingService = networkingService
    }

    // MARK: - Public -

    lazy var openForecastPublisher: AnyPublisher<City, Never> = eventsInputSubject
        .compactMap { [weak self] event in
            if case .didSelectCity(let row) = event {
                return self?.cities[row]
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
        //.debounce(for: .seconds(Constants.debounceTime), scheduler: DispatchQueue.global())
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
