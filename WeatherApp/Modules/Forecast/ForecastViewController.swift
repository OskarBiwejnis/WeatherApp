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
    private let storageService: StorageServiceType = StorageService()

    // MARK: - Initialization -

    init(city: City) {
        storageService.addRecentCity(city)
        forecastViewModel = ForecastViewModel(city: city, networkingService: NetworkingService())
        super.init(nibName: nil, bundle: nil)
        forecastView.collectionView.delegate = self
        self.title = city.name
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
        forecastViewModel.forecastPublisher
            .receive(on: DispatchQueue.main)
            .bind(subscriber: forecastView.collectionView.itemsSubscriber(cellIdentifier: ForecastCell.reuseIdentifier, cellType: ForecastCell.self, cellConfig: { cell, indexPath, threeHourForecastFormatted in
                cell.setupWith(hour: threeHourForecastFormatted.hour,
                               temperature: threeHourForecastFormatted.temperature,
                               humidity: threeHourForecastFormatted.humidity,
                               wind: threeHourForecastFormatted.wind,
                               skyImage: threeHourForecastFormatted.skyImage)
              }))
            .store(in: &subscriptions)

        forecastViewModel.showErrorPublisher
            .map { error -> UIAlertController in
                let errorAlert = UIAlertController(title: R.string.localizable.error_alert_title(), message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: R.string.localizable.ok_button_text(), style: .default)
                errorAlert.addAction(okButton)
                return errorAlert
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorAlert in
                self?.present(errorAlert, animated: true, completion: nil)
            }
            .store(in: &subscriptions)
    }

}

