import UIKit

class RecentCityCell: UITableViewCell {

    static let reuseIdentifier = "recentCityCell"

    let label = Label(textColor: .black, font: FontProvider.defaultFont)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        backgroundColor = .systemGray5
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make -> Void in
            make.center.equalToSuperview()
        }
    }
}
