import XCTest
import Combine
import Quick
import Nimble

@testable import WeatherApp

class WelcomeViewModelSpec: QuickSpec {

    override class func spec() {
        describe("WelcomeViewModel") {
            describe("proceedButton") {
                it("opens search screen when tapped") {
                    var subscriptions: [AnyCancellable] = []
                    let welcomeViewModel: WelcomeViewModelContract = WelcomeViewModel()
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
        }
    }

}
