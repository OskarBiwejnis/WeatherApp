import SnapKit
import UIKit

class ForecastCell: UITableViewCell {

    private enum Constants {
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
        hourLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        hourLabel.text = "15:00"

        return hourLabel
    }()

    let temperatureLabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.textColor = .systemCyan
        temperatureLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        temperatureLabel.text = "22°"

        return temperatureLabel
    }()

    let humidityLabel = {
        let humidityLabel = UILabel()
        humidityLabel.textColor = .systemGray2
        humidityLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        humidityLabel.text = "57%"

        return humidityLabel
    }()

    let windLabel = {
        let windLabel = UILabel()
        windLabel.textColor = .systemGray2
        windLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        windLabel.text = "11 kmh"

        return windLabel
    }()

    let skyImageView = {
        let skyImageView = UIImageView()

        return skyImageView
    }()

    func setupValues(hour: String, temperature: Double, humidity: Int, wind: Double, sky: WeatherType) {
        hourLabel.text = String(String(hour.split(separator: " ")[1]).prefix(5))
        temperatureLabel.text = String(Int(temperature-273)) + "°"
        humidityLabel.text = String(humidity) + "%"
        windLabel.text = String(Int(wind)) + " kmh"

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
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(hourLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }

        humidityLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(temperatureLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }

        windLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(humidityLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }

        skyImageView.snp.makeConstraints { make -> Void in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

}
