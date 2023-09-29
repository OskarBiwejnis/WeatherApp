import Combine
import CombineCocoa
import CombineDataSources
import UIKit

class SearchViewController: UIViewController {

    // MARK: - Constants -

    enum EventInput: AutoEquatable {
        case textChanged(text: String)
        case didSelectCity(row: Int)
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    private let searchView = SearchView()
    let searchViewModel: SearchViewModelContract

    // MARK: - Initialization -

    init(searchViewModel: SearchViewModelContract) {
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public -

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }
}

    // MARK: - Private -

extension SearchViewController {

    private func bindActions() {

        searchView.didSelectRowPublisher
            .sink { [weak self] row in
                self?.searchViewModel.eventsInputSubject.send(.didSelectCity(row: row))
            }
            .store(in: &subscriptions)

        searchView.searchTextField.textPublisher
            .sink { [weak self] text in
                self?.searchViewModel.eventsInputSubject.send(.textChanged(text: text ?? ""))
            }
            .store(in: &subscriptions)

        searchViewModel.viewStatePublisher
            .sink { [weak self] viewState in
                switch viewState {
                case .cities(let _):
                    self?.searchView.changeState(viewState)
                case .error(let error):
                    self?.handleErrorState(error)
                }
            }
            .store(in: &subscriptions)
    }

    private func handleErrorState(_ error: Error) {
        let errorAlert = UIAlertController(title: R.string.localizable.error_alert_title(), message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: R.string.localizable.ok_button_text(), style: .default)
        errorAlert.addAction(okButton)
        DispatchQueue.main.async {
            self.present(errorAlert, animated: true, completion: nil)
        }
    }

}
