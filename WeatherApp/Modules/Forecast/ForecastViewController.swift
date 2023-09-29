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
                self?.forecastView.changeState(viewState)
            }
            .store(in: &subscriptions)

        forecastView.errorOccuredPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorAlert in
                self?.present(errorAlert, animated: true, completion: nil)
            }
            .store(in: &subscriptions)
    }

}
