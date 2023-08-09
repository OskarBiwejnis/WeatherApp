import XCTest
@testable import WeatherApp

final class WelcomeViewModelTests: XCTestCase {

    var welcomeViewController: WelcomeViewController!
    var navigationController: UINavigationController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        welcomeViewController = WelcomeViewController()
        welcomeViewController.loadViewIfNeeded()
        navigationController = UINavigationController(rootViewController: welcomeViewController)
    }

    override  func tearDown() {
        welcomeViewController = nil
        navigationController = nil
        super.tearDown()
    }

    func testShouldOpenSearchViewWhenProceedButtonTap() throws {
        let topViewControllerBefore = navigationController.topViewController

        welcomeViewController.proceedButtonTap()

        let topViewControllerAfter = navigationController.topViewController
        XCTAssertNotEqual(topViewControllerBefore, topViewControllerAfter)
        XCTAssertNotIdentical(topViewControllerBefore, topViewControllerAfter)
        XCTAssert(topViewControllerAfter is SearchViewController)
    }

}
