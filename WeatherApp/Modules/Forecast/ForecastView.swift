import SnapKit
import UIKit

class ForecastView: UIView {

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


    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
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

}
