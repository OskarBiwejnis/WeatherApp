import Foundation

class WelcomeViewModel: NSObject {
    weak var welcomeViewControllerDelegate: WelcomeViewControllerDelegate?

    func proceedButtonTap() {
        welcomeViewControllerDelegate?.pushViewController()
    }
}
