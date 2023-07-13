import SnapKit
import UIKit

class MainView: UIView {

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    unowned var viewController: MainViewController?

    private enum Constants {
        static let textFieldFontSize = 32
        static let textFieldMarginTop = 25
    }

    private let searchTextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = "Search"
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
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.left.equalTo(safeAreaLayoutGuide).offset(20)
            make.right.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
}
