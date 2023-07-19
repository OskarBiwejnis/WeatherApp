import Foundation

class WelcomeViewModel: NSObject {

    weak var welcomeViewControllerDelegate: WelcomeViewControllerDelegate?

    func pushViewController() {
        welcomeViewControllerDelegate?.pushViewController()
    }
    
}
