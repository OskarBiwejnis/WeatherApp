import SnapKit
import UIKit

class ForecastCell: UITableViewCell {

    private enum Constants {
        static let spacingBetweenElements = 15
        static let bigFontSize: CGFloat = 32
        static let smallFontSize: CGFloat = 18
        static let degreeSign = "°"
        static let percentSign = "%"
        static let speedUnit = " kmh"
        static let hourFormatWithoutSeconds = 5
        static let space = " "
        static let secondPartOfDateFormat = 1
        static let kelvinUnitOffset = 273.15
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    let hourLabel = {
        let hourLabel = UILabel()
        hourLabel.font = UIFont.systemFont(ofSize: Constants.bigFontSize, weight: .bold)

        return hourLabel
    }()

    let temperatureLabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.textColor = .systemCyan
        temperatureLabel.font = UIFont.systemFont(ofSize: Constants.bigFontSize, weight: .bold)

        return temperatureLabel
    }()

    let humidityLabel = {
        let humidityLabel = UILabel()
        humidityLabel.textColor = .systemGray2
        humidityLabel.font = UIFont.systemFont(ofSize: Constants.smallFontSize, weight: .bold)

        return humidityLabel
    }()

    let windLabel = {
        let windLabel = UILabel()
        windLabel.textColor = .systemGray2
        windLabel.font = UIFont.systemFont(ofSize: Constants.smallFontSize, weight: .bold)

        return windLabel
    }()

    let skyImageView = {
        let skyImageView = UIImageView()

        return skyImageView
    }()

    func setupWith(hour: String, temperature: Double, humidity: Int, wind: Double, sky: WeatherType) {
        hourLabel.text = String(String(hour.split(separator: Constants.space)[Constants.secondPartOfDateFormat]).prefix(Constants.hourFormatWithoutSeconds))
        temperatureLabel.text = String(Int(temperature - Constants.kelvinUnitOffset)) + Constants.degreeSign
        humidityLabel.text = String(humidity) + Constants.percentSign
        windLabel.text = String(Int(wind)) + Constants.speedUnit

        switch sky {
        case .thunderstorm:
            skyImageView.image = R.image.thunderstorm()
        case .drizzle:
            skyImageView.image = R.image.drizzle()
        case .rain:
            skyImageView.image = R.image.rain()
        case .snow:
            skyImageView.image = R.image.snow()
        case .atmosphere:
            skyImageView.image = R.image.atmosphere()
        case .clear:
            skyImageView.image = R.image.clear()
        case .clouds:
            skyImageView.image = R.image.clouds()
        }
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
            make.left.equalToSuperview().offset(Constants.spacingBetweenElements)
            make.centerY.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(hourLabel.snp.right).offset(Constants.spacingBetweenElements)
            make.centerY.equalToSuperview()
        }

        humidityLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(temperatureLabel.snp.right).offset(Constants.spacingBetweenElements)
            make.centerY.equalToSuperview()
        }

        windLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(humidityLabel.snp.right).offset(Constants.spacingBetweenElements)
            make.centerY.equalToSuperview()
        }

        skyImageView.snp.makeConstraints { make -> Void in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

}
