import UIKit

class SearchViewController: UIViewController {

    var searchView = SearchView()

    override func loadView() {
        searchView.viewController = self
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
