import XCTest
import Combine
import Quick
import Nimble

@testable import WeatherApp

class WelcomeViewModelSpec: QuickSpec {

    override class func spec() {
        describe("WelcomeViewModel") {
            var subscriptions: [AnyCancellable] = []
            var welcomeViewModel: WelcomeViewModelContract = WelcomeViewModel(storageService: MockStorageService)

            beforeEach {
                subscriptions = []
                welcomeViewModel = WelcomeViewModel()
            }

            describe("proceedButton") {
                it("opens search screen when tapped") {
                    var didReceiveCallToOpenSearchScreen = false
                    welcomeViewModel.openSearchScreenPublisher
                        .sink { _ in
                            didReceiveCallToOpenSearchScreen = true
                        }
                        .store(in: &subscriptions)

                    welcomeViewModel.eventsInputSubject.send(.proceedButtonTap)

                    expect(didReceiveCallToOpenSearchScreen).toEventually(beTrue())
                }
            }

            describe("recent cities") {
                it("they get reloaded when view is about to appear") {
                    var didReceiveCallToReloadCities = false
                    welcomeViewModel.reloadRecentCitiesPublisher
                        .sink { _ in
                            didReceiveCallToReloadCities = true
                        }
                        .store(in: &subscriptions)

                    welcomeViewModel.eventsInputSubject.send(.viewWillAppear)

                    expect(didReceiveCallToReloadCities).toEventually(beTrue())
                }

                it("opens forecast when tapped on one") {
                    var didReceiveCallToOpenForecast = false
                    welcomeViewModel.openForecastPublisher
                        .sink { _ in
                            didReceiveCallToOpenForecast = true
                        }
                        .store(in: &subscriptions)

                    welcomeViewModel.eventsInputSubject.send(.didSelectRecentCity(row: 0))

                    expect(didReceiveCallToOpenForecast).toEventually(beTrue())
                }

                it("opens proper forecast for given city") {
                    
                    welcomeViewModel.openForecastPublisher
                        .sink { _ in

                        }
                        .store(in: &subscriptions)

                    welcomeViewModel.eventsInputSubject.send(.didSelectRecentCity(row: 0))

                    expect( ).toEventually(beTrue())
                }
            }


        }
    }

}


