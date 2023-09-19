import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    init(navigationController: UINavigationController)

    func start()
    func goToWelcomeScreen()
    func goToSearchScreen()
    func goToForecastScreen(city: City)
}
