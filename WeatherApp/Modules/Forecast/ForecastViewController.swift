import Combine
import CombineDataSources
import UIKit

class ForecastViewController: UIViewController {

    // MARK: - Constants -

    private enum Constants {
        static let rowHeight: CGFloat = 75
        static let numberOfCells = 8
        static let noCells = 0
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    private let forecastView = ForecastView()
    private let forecastViewModel: ForecastViewModelContract
    

    // MARK: - Initialization -

    init(forecastViewModel: ForecastViewModelContract) {
        self.forecastViewModel = forecastViewModel
        super.init(nibName: nil, bundle: nil)
        self.title = forecastViewModel.city.name
        forecastView.collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public -

    override func loadView() {
        view = forecastView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }

}

extension ForecastViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: forecastView.frame.width, height: Constants.rowHeight)
    }

}

    // MARK: - Private -

extension ForecastViewController {

    private func bindActions() {
        forecastViewModel.viewStatePublisher
            .sink { [weak self] viewState in
                switch viewState {
                case .forecast(let _):
                    self?.forecastView.changeState(viewState)
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
