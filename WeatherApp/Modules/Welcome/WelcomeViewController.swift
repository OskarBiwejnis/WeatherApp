import Combine
import CombineDataSources
import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Constants -

    enum EventInput: AutoEquatable {
        case proceedButtonTap
        case didSelectRecentCity(row: Int)
        case viewWillAppear
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    private let welcomeView = WelcomeView()
    let welcomeViewModel: WelcomeViewModelContract

    // MARK: - Public -

    override func loadView() {
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        welcomeViewModel.eventsInputSubject.send(.viewWillAppear)
    }

    // MARK: - Initialization -

    init(welcomeViewModel: WelcomeViewModelContract) {
        self.welcomeViewModel = welcomeViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private -

    private func bindActions() {
        welcomeView.proceedButton.tapPublisher
            .sink { [weak self] in
                self?.welcomeViewModel.eventsInputSubject.send(.proceedButtonTap)
            }
            .store(in: &subscriptions)

        welcomeView.didSelectRowPublisher
            .sink { [weak self] row in
                self?.welcomeViewModel.eventsInputSubject.send(.didSelectRecentCity(row: row))
            }
            .store(in: &subscriptions)

        welcomeViewModel.viewStatePublisher
            .sink { [weak self] viewState in
                self?.welcomeView.changeState(viewState)
            }
            .store(in: &subscriptions)
    }

}
