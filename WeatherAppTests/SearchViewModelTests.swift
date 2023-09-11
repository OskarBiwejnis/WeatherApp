import Combine
import Difference
import Nimble
import Quick
import SwiftyMocky
import XCTest
@testable import WeatherApp

class SearchViewModelSpec: QuickSpec {
    
    override class func spec() {
        var testScheduler = DispatchQueue.test
        var networkingServiceMock: NetworkingServiceTypeMock!
        var searchViewModel: SearchViewModelContract!
        var foundCitiesPublisherObserver: PublisherEventsObserver<[City]>!
        var showErrorPublisherObserver: PublisherEventsObserver<Error>!
        var openForecastPublisherObserver: PublisherEventsObserver<City>!
        var stubCity: City!
        var differentStubCity: City!
        var stubCities: [City]!
        var stubCitiesData: CitiesData!
        var fetchCitiesReturnValue: AnyPublisher<CitiesData, NetworkingError>!

        beforeEach {
            networkingServiceMock = NetworkingServiceTypeMock()
            searchViewModel = SearchViewModel(networkingService: networkingServiceMock, scheduler: testScheduler.eraseToAnyScheduler())
            stubCity = City()
            differentStubCity = City()
            stubCity.name = "xyz"
            differentStubCity.name = "zyx"
            stubCities = [stubCity, differentStubCity, stubCity]
            stubCitiesData = CitiesData(data: stubCities)
            fetchCitiesReturnValue = Just(stubCitiesData).setFailureType(to: NetworkingError.self).eraseToAnyPublisher()
        }
        
        describe("SearchViewModel") {
            context("sending navigationEvents") {
                context("when search text entered") {
                    beforeEach {
                        Given(networkingServiceMock, .fetchCities("abc", willReturn: fetchCitiesReturnValue))
                        foundCitiesPublisherObserver = PublisherEventsObserver(searchViewModel.foundCitiesPublisher)
                        searchViewModel.eventsInputSubject.send(.textChanged(text: "abc"))
                        testScheduler.advance(by: 2)
                    }

                    it("reloads table") {
                        expect(foundCitiesPublisherObserver.values).to(equalDiff([stubCities]))
                    }

                    context("when table loaded") {
                        context("when city selected") {
                            beforeEach {
                                openForecastPublisherObserver = PublisherEventsObserver(searchViewModel.openForecastPublisher)
                                searchViewModel.eventsInputSubject.send(.didSelectCity(row: 1))
                            }

                            it("opens forecast") {
                                expect(openForecastPublisherObserver.values).toNot(beEmpty())
                            }
                            it("opens proper forecast for given city") {
                                expect(openForecastPublisherObserver.values).to(equalDiff([differentStubCity]))
                            }
                        }
                    }
                }

                context("when error occured") {
                    beforeEach {
                        Given(networkingServiceMock, .fetchCities("err",willReturn: Fail(error: NetworkingError.unknownError)
                            .eraseToAnyPublisher()))
                        showErrorPublisherObserver = PublisherEventsObserver(searchViewModel.showErrorPublisher)
                        searchViewModel.eventsInputSubject.send(.textChanged(text: "err"))
                        testScheduler.advance(by: 2)
                    }

                    it("shows an error") {
                        expect(showErrorPublisherObserver.values).toNot(beEmpty())
                    }
                }
            }
        }
    }
    
}
