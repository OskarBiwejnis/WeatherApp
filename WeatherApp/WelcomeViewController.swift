import UIKit

class WelcomeViewController: UIViewController {
    
    var welcomeView = WelcomeView()
    
    override func loadView() {
        super.loadView()
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
