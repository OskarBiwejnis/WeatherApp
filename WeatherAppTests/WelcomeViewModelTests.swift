import Combine
import Difference
import Nimble
import Quick
import SwiftyMocky
import XCTest
@testable import WeatherApp

class WelcomeViewModelSpec: QuickSpec {

    override class func spec() {
        var storageServiceMock = StorageServiceTypeMock()
        var welcomeViewModel: WelcomeViewModelContract = WelcomeViewModel(storageService: storageServiceMock)
        var openSearchScreenPublisherObserver: PublisherEventsObserver<Void>!
        var reloadTablePublisherObserver: PublisherEventsObserver<[City]>!
        var openForecastPublisherObserver: PublisherEventsObserver<City>!
        var stubCity: City!
        var differentStubCity: City!
        var stubCities: [City]!

        beforeEach {
            storageServiceMock = StorageServiceTypeMock()
            welcomeViewModel = WelcomeViewModel(storageService: storageServiceMock)
            stubCity = City()
            differentStubCity = City()
            stubCity.name = "xyz"
            differentStubCity.name = "zyx"
            stubCities = [stubCity, differentStubCity, stubCity]
        }

        describe("WelcomeViewModel") {
            context("sending navigationEvents") {
                context("when proceedButton tapped") {
                    beforeEach {
                        openSearchScreenPublisherObserver = PublisherEventsObserver(welcomeViewModel.openSearchScreenPublisher)
                        welcomeViewModel.eventsInputSubject.send(.proceedButtonTap)
                    }

                    it("opens search screen") {
                        expect(openSearchScreenPublisherObserver.values).toNot(beEmpty())
                    }
                }

                context("when view is about to appear") {
                    beforeEach {
                        Given(storageServiceMock, .getRecentCities(willReturn: stubCities))
                        reloadTablePublisherObserver = PublisherEventsObserver(welcomeViewModel.reloadRecentCitiesPublisher)
                        welcomeViewModel.eventsInputSubject.send(.viewWillAppear)
                    }

                    it("reloads table view") {
                        expect(reloadTablePublisherObserver.values).toNot(beEmpty())
                    }
                    it("reloads table view with proper cities") {
                        expect(reloadTablePublisherObserver.values) == [stubCities]
                    }

                    context("when view has appeared") {
                        context("when recent city selected") {
                            beforeEach {
                                openForecastPublisherObserver = PublisherEventsObserver(welcomeViewModel.openForecastPublisher)
                                welcomeViewModel.eventsInputSubject.send(.didSelectRecentCity(row: 1))
                            }

                            it("opens forecast screen") {
                                expect(openForecastPublisherObserver.values).toNot(beEmpty())
                            }
                            it("opens proper forecast for that city") {
                                expect(openForecastPublisherObserver.values) == [differentStubCity]
                            }
                        }
                    }
                }
            }
        }
    }

}
