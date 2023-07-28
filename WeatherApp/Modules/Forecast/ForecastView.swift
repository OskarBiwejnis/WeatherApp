import SnapKit
import UIKit

class ForecastView: UIView {

    private enum Constants {
        static let hourLabelOffset = 10
        static let temperatureLabelOffset = 105
        static let humidityLabelOffset = 60
        static let windLabelOffset = 50
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

    let hourLabel = {
        let hourLabel = UILabel()
        hourLabel.text = Constants.hourLabelText
        return hourLabel
    }()

    let temperatureLabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.text = Constants.temperatureLabelText
        return temperatureLabel
    }()

    let humidityLabel = {
        let humidityLabel = UILabel()
        humidityLabel.text = Constants.humidityLabelText

        return humidityLabel
    }()

    let windLabel = {
        let windLabel = UILabel()
        windLabel.text = Constants.windLabelText
        return windLabel
    }()


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
        }

        temperatureLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(hourLabel).offset(Constants.temperatureLabelOffset)
        }

        humidityLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(temperatureLabel).offset(Constants.humidityLabelOffset)
        }

        windLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(humidityLabel).offset(Constants.windLabelOffset)
        }
    }

}
