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
        static let textFieldMarginTop = 25
        static let textFieldMarginSides = 20
    }

    private let searchTextField = {
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
    }

    private func setupConstraints() {
        searchTextField.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.textFieldMarginTop)
            make.left.right.equalToSuperview().inset(Constants.textFieldMarginSides)
        }
    }
}
