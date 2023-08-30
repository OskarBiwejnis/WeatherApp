import UIKit

class RecentCityCell: UITableViewCell {

    // MARK: - Constants -

    static let reuseIdentifier = "recentCityCell"

    // MARK: - Variables -

    let label = Label(textColor: .black, font: FontProvider.defaultFont)

    // MARK: - Initialization -

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        backgroundColor = .systemGray5
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private -

    private func setupConstraints() {
        label.snp.makeConstraints { make -> Void in
            make.center.equalToSuperview()
        }
    }

}
