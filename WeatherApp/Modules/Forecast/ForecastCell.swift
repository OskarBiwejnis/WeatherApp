import SnapKit
import UIKit

class ForecastCell: UITableViewCell {

    private enum Constants {
        static let forecastReuseIdentifier = "forecastCell"
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
        temperatureLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        temperatureLabel.text = "22°"

        return temperatureLabel
    }()

    let humidityLabel = {
        let humidityLabel = UILabel()
        humidityLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        humidityLabel.text = "57%"

        return humidityLabel
    }()

    let windLabel = {
        let windLabel = UILabel()
        windLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        windLabel.text = "11 kmh"

        return windLabel
    }()

    let skyImageView = {
        let skyImageView = UIImageView()

        return skyImageView
    }()

    private func setupView() {
        addSubview(hourLabel)
        addSubview(temperatureLabel)
        addSubview(humidityLabel)
        addSubview(windLabel)
        addSubview(skyImageView)
    }

    private func setupConstraints() {
        hourLabel.snp.makeConstraints { make -> Void in

        }

        temperatureLabel.snp.makeConstraints { make -> Void in

        }

        humidityLabel.snp.makeConstraints { make -> Void in

        }

        windLabel.snp.makeConstraints { make -> Void in

        }

        skyImageView.snp.makeConstraints { make -> Void in

        }
    }

}
