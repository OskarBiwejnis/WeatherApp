import Combine
import Foundation

class SearchViewModel: NSObject {

    var cities: [City] = []
    var citiesData = CitiesData(data: []) {
        didSet {
            cities = citiesData.data
            delegate?.reloadTable()
        }
    }

    private var subscriptions: [AnyCancellable] = []
    var openCityForecastPublisher = PassthroughSubject<City, Never>()
    weak var delegate: SearchViewModelDelegate?
    weak var searchViewController: SearchViewController? {
        didSet {
            searchViewController?.textChangedPublisher
                .debounce(for: .seconds(1.2), scheduler: DispatchQueue.global())
                .sink(receiveValue: { text in
                    self.fetchCities(text)
                })
                .store(in: &subscriptions)

            searchViewController?.didSelectSearchCellPublisher
                .sink(receiveValue: { row in
                    self.openCityForecastPublisher.send(self.cities[row])
                })
                .store(in: &subscriptions)
        }
    }

    private var networkingService: NetworkingServiceType

    private enum Constants {
        static let minTimeBetweenFetchCities = 1.2
    }

    init(networkingService: NetworkingServiceType) {
        self.networkingService = networkingService

    }

    private func fetchCities(_ text: String) {
        guard text != "" else {
            return
        }

        networkingService.citiesPublisher(text)
            .catch {
                self.delegate?.showError($0)
                return Empty<CitiesData, Never>()
            }
            .assign(to: \.citiesData, on: self)
            .store(in: &subscriptions)
    }


}

protocol SearchViewModelDelegate: AnyObject {

    func reloadTable()
    func showError(_ error: Error)

}
