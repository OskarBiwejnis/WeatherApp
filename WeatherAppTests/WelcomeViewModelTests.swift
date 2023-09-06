import XCTest
import Combine
import Quick
import Nimble

@testable import WeatherApp

class WelcomeViewModelSpec: QuickSpec {

    override class func spec() {
        describe("WelcomeViewModel") {
            var subscriptions: [AnyCancellable] = []
            var storageService = StorageServiceTypeMock()
            var welcomeViewModel: WelcomeViewModelContract = WelcomeViewModel(storageService: storageService)
            
            beforeEach {
                subscriptions = []
                storageService = StorageServiceTypeMock()
                welcomeViewModel = WelcomeViewModel(storageService: storageService)
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
                    storageService.getRecentCitiesReturnValue = []
                    var didReceiveCallToReloadCities = false
                    welcomeViewModel.reloadRecentCitiesPublisher
                        .sink { _ in
                            didReceiveCallToReloadCities = true
                        }
                        .store(in: &subscriptions)

                    welcomeViewModel.eventsInputSubject.send(.viewWillAppear)

                    expect(didReceiveCallToReloadCities).toEventually(beTrue())
                }
            }
        }
    }

}
