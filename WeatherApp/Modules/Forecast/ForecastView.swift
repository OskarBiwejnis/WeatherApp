import SnapKit
import UIKit

class ForecastView: UIView {

    private enum Constants {
        static let forecastReuseIdentifier = "forecastCell"
        static let forecastRowHeight: CGFloat = 75
    }

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = Constants.forecastRowHeight
        tableView.register(ForecastCell.self, forCellReuseIdentifier: Constants.forecastReuseIdentifier)

        return tableView
    }()

    private func setupView() {
        backgroundColor = .systemGray6
        addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.left.right.equalToSuperview()
        }
    }

}
