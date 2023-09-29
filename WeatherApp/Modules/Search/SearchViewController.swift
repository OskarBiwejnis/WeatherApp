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
                self?.searchView.changeState(viewState)
            }
            .store(in: &subscriptions)

        searchView.errorOccuredPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorAlert in
                self?.present(errorAlert, animated: true, completion: nil)
            }
            .store(in: &subscriptions)
    }

}
