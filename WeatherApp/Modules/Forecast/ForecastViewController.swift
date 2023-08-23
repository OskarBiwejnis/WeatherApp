import Combine
import UIKit

class ForecastViewController: UIViewController {

    private enum Constants {
        static let rowHeight: CGFloat = 75
        static let numberOfCells = 8
        static let noCells = 0
    }
    
    let forecastView = ForecastView()
    let forecastViewModel: ForecastViewModel
    let storageService: StorageServiceType = StorageService()

    private var subscriptions: [AnyCancellable] = []
    

    init(city: City) {
        storageService.addRecentCity(city)
        forecastViewModel = ForecastViewModel(city: city, networkingService: NetworkingService())
        super.init(nibName: nil, bundle: nil)
        forecastView.collectionView.delegate = self
        forecastView.collectionView.dataSource = self
        self.title = city.name

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = forecastView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindActions()
    }

    private func bindActions() {
        forecastViewModel.reloadTableSubject
            .receive(on: DispatchQueue.main)
            .sink { [self] in
                forecastView.collectionView.reloadData()
            }
            .store(in: &subscriptions)

        forecastViewModel.showErrorSubject
            .map { error -> UIAlertController in
                let errorAlert = UIAlertController(title: R.string.localizable.error_alert_title(), message: error.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: R.string.localizable.ok_button_text(), style: .default)
                errorAlert.addAction(okButton)
                return errorAlert
            }
            .receive(on: DispatchQueue.main)
            .sink { [self] errorAlert in
                present(errorAlert, animated: true, completion: nil)
            }
            .store(in: &subscriptions)
    }

}

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastViewModel.threeHourForecasts.isEmpty ? Constants.noCells : Constants.numberOfCells
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier,
            for: indexPath) as? ForecastCell else { return ForecastCell() }
        let threeHourForecastFormatted = forecastViewModel.getThreeHourForecastFormatted(index: indexPath.row)
        cell.setupWith(hour: threeHourForecastFormatted.hour,
                       temperature: threeHourForecastFormatted.temperature,
                       humidity: threeHourForecastFormatted.humidity,
                       wind: threeHourForecastFormatted.wind,
                       skyImage: threeHourForecastFormatted.skyImage)

        return cell
    }

}

extension ForecastViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: forecastView.frame.width, height: Constants.rowHeight)
    }

}
