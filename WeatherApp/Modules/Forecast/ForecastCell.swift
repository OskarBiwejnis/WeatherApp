import SnapKit
import UIKit

class ForecastCell: UICollectionViewCell {

    static let reuseIdentifier = Constants.reuseIdentifier

    private enum Constants {
        static let hourLabelOffset = 10
        static let hourLabelWidth = 105
        static let temperatureLabelWidth = 60
        static let humidityLabelWidth = 50
        static let windLabelWidth = 60
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
            make.width.equalTo(Constants.hourLabelWidth)
            make.centerY.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(hourLabel.snp.right)
            make.width.equalTo(Constants.temperatureLabelWidth)
            make.centerY.equalToSuperview()
        }

        humidityLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(temperatureLabel.snp.right)
            make.width.equalTo(Constants.humidityLabelWidth)
            make.centerY.equalToSuperview()
        }

        windLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(humidityLabel.snp.right)
            make.width.equalTo(Constants.windLabelWidth)
            make.centerY.equalToSuperview()
        }

        skyImageView.snp.makeConstraints { make -> Void in
            make.right.equalToSuperview()
            make.left.greaterThanOrEqualTo(windLabel.snp.right)
            make.centerY.equalToSuperview()
        }
    }

}
