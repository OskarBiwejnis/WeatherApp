import SnapKit
import UIKit

class ForecastCell: UICollectionViewCell {

    static let reuseIdentifier = Constants.reuseIdentifier

    private enum Constants {
        static let spacingBetweenElements = 15

        static let hourLabelOffset = 10
        static let temperatureLabelOffset = 105
        static let humidityLabelOffset = 60
        static let windLabelOffset = 50
        static let reuseIdentifier = "forecastCell"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    let hourLabel = Label(font: FontProvider.bigBoldFont)
    let temperatureLabel = Label(textColor: .systemCyan, font: FontProvider.bigBoldFont)
    let humidityLabel = Label(textColor: .systemGray2, font: FontProvider.defaultBoldFont)
    let windLabel = Label(textColor: .systemGray2, font: FontProvider.defaultBoldFont)
    let skyImageView = UIImageView()

    func setupWith(hour: String, temperature: String, humidity: String, wind: String, skyImage: UIImage?) {
        hourLabel.text = hour
        temperatureLabel.text = temperature
        humidityLabel.text = humidity
        windLabel.text = wind
        skyImageView.image = skyImage
    }

    private func setupView() {
        backgroundColor = .systemGray5
        addSubview(hourLabel)
        addSubview(temperatureLabel)
        addSubview(humidityLabel)
        addSubview(windLabel)
        addSubview(skyImageView)
    }

    private func setupConstraints() {
        hourLabel.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().offset(Constants.hourLabelOffset)
            make.centerY.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(hourLabel).offset(Constants.temperatureLabelOffset)
            make.centerY.equalToSuperview()
        }

        humidityLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(temperatureLabel).offset(Constants.humidityLabelOffset)
            make.centerY.equalToSuperview()
        }

        windLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(humidityLabel).offset(Constants.windLabelOffset)
            make.centerY.equalToSuperview()
        }

        skyImageView.snp.makeConstraints { make -> Void in
            make.right.equalToSuperview()
            make.left.greaterThanOrEqualTo(windLabel.snp.right)
            make.centerY.equalToSuperview()
        }
    }

}
