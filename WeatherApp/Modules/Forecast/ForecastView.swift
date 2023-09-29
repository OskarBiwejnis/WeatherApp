import Combine
import CombineCocoa
import CombineDataSources
import SnapKit
import UIKit

class ForecastView: UIView {

    // MARK: - Constants -

    private enum Constants {
        static let hourLabelOffset = 10
        static let hourLabelWidth = 105
        static let temperatureLabelWidth = 60
        static let humidityLabelWidth = 50
        static let windLabelWidth = 60
        static let collectionViewTopMargin = 10
        static let hourLabelText = "Hour"
        static let temperatureLabelText = "Temp"
        static let humidityLabelText = "Hum"
        static let windLabelText = "Wind"
    }

    // MARK: - Variables -

    @Published private var forecast: [ThreeHourForecastFormatted] = []
    private var subscriptions: [AnyCancellable] = []

    private let itemsController = CollectionViewItemsController<[[ThreeHourForecastFormatted]]>(cellFactory: { _, collectionView, indexPath, threeHourForecastFormatted -> UICollectionViewCell in
        guard let cell: ForecastCell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as? ForecastCell
        else { return UICollectionViewCell() }
        cell.setupWith(hour: threeHourForecastFormatted.hour,
                       temperature: threeHourForecastFormatted.temperature,
                       humidity: threeHourForecastFormatted.humidity,
                       wind: threeHourForecastFormatted.wind,
                       skyImage: threeHourForecastFormatted.skyImage)
        return cell
    })

    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseIdentifier)
        return collectionView
    }()

    let hourLabel = Label(text: Constants.hourLabelText)
    let temperatureLabel = Label(text: Constants.temperatureLabelText)
    let humidityLabel = Label(text: Constants.humidityLabelText)
    let windLabel = Label(text: Constants.windLabelText)

    // MARK: - Initialization -

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public -

    func changeState(_ viewState: ForecastViewState) {
        if case .forecast(let forecastFormatted) = viewState {
            self.forecast = forecastFormatted
        }
    }

    // MARK: - Private -
    
    private func setupView() {
        backgroundColor = .systemGray6
        addSubview(hourLabel)
        addSubview(temperatureLabel)
        addSubview(humidityLabel)
        addSubview(windLabel)
        addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make -> Void in
            make.top.equalTo(hourLabel.snp.bottom).offset(Constants.collectionViewTopMargin)
            make.bottom.left.right.equalToSuperview()
        }

        hourLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(Constants.hourLabelOffset)
            make.width.equalTo(Constants.hourLabelWidth)
        }

        temperatureLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(hourLabel.snp.right)
            make.width.equalTo(Constants.temperatureLabelWidth)
        }

        humidityLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(temperatureLabel.snp.right)
            make.width.equalTo(Constants.humidityLabelWidth)
        }

        windLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(humidityLabel.snp.right)
            make.width.equalTo(Constants.windLabelWidth)
        }
    }

    private func setupCollectionView() {
        $forecast
            .receive(on: DispatchQueue.main)
            .bind(subscriber: collectionView.itemsSubscriber(itemsController))
            .store(in: &subscriptions)
    }

}
