import Foundation

class WelcomeViewModel: NSObject {

    weak var delegate: WelcomeViewModelDelegate?

    func pushViewController() {
        delegate?.pushViewController()
    }
    
}

protocol WelcomeViewModelDelegate: AnyObject {

    func pushViewController()

}
