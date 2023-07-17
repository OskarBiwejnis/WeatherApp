import SnapKit
import UIKit

class SearchView: UIView {

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    unowned var viewController: SearchViewController?

    private enum Constants {
        static let textFieldFontSize = 32
        static let textFieldMargin = 20
    }

    let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 50
        tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        return tableView
    }()

    let searchTextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = R.string.localizable.searchPlaceholder()
        searchTextField.borderStyle = .roundedRect
        searchTextField.textAlignment = .left
        searchTextField.textColor = .black
        searchTextField.font = .systemFont(ofSize: CGFloat(Constants.textFieldFontSize))

        return searchTextField
    }()

    private func setup() {
        setupView()
        setupConstraints()
    }

    private func setupView() {
        backgroundColor = .systemGray6
        addSubview(searchTextField)
        addSubview(tableView)
    }

    private func setupConstraints() {
        searchTextField.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.textFieldMargin)
            make.left.right.equalToSuperview().inset(Constants.textFieldMargin)
        }

        tableView.snp.makeConstraints { make -> Void in
            make.top.equalTo(searchTextField.snp.bottom).offset(Constants.textFieldMargin)
            make.bottom.left.right.equalToSuperview()
        }
    }
}
