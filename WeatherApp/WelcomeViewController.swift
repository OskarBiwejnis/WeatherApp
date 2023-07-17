import UIKit

class WelcomeViewController: UIViewController {

    var welcomeView = WelcomeView()
    var mainViewController = SearchViewController()

    override func loadView() {
        welcomeView.viewController = self
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func proceedButtonTap() {
        navigationController?.pushViewController(mainViewController, animated: true)

        Task {
            do {
                let users = try await NetworkingUtils.get3FirstGitHubUsers()

                if let users {
                    print(users)
                }
            } catch {
                print("error")
            }
        }
    }
}
