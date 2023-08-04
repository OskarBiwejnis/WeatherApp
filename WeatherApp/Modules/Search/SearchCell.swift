import UIKit

class SearchCell: UITableViewCell {

    static let reuseIdentifier = "searchCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private enum Constants {
        static let fontSize: CGFloat = 24
        static let labelLeftMargin = 20
    }

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Constants.fontSize)

        return label
    }()
    
    private func setupConstraints() {
        label.snp.makeConstraints { make -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.labelLeftMargin)
        }
    }
    
}
