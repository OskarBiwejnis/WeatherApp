import Combine
import CombineCocoa
import SnapKit
import UIKit

class LoginTextFieldView: UIView {

    private enum Constants {
        static let textFieldWidth = 350
        static let textFieldHeight = 50
        static let stackViewSpacing: CGFloat = 5
    }

    enum State {
        case normal
        case caution(_ message: String)
    }

    private lazy var stackView = {
        let stackView = UIStackView(arrangedSubviews: [self.textField, self.cautionLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.stackViewSpacing
        return stackView
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.font = FontProvider.bigBoldFont
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let cautionLabel: UILabel = {
        let label = UILabel()
        label.font = FontProvider.smallFont
        label.textColor = .red
        label.textAlignment = .left
        label.text = ""
        label.numberOfLines = 1
        return label
    }()

    init(placeholder: String, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        self.textField.placeholder = placeholder
        self.textField.isSecureTextEntry = isSecureTextEntry
        setupView()
        setupConstraints()
        changeState(.normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeState(_ state: State) {
        switch state {
        case .normal:
            cautionLabel.isHidden = true
            textField.backgroundColor = .white
        case let .caution(message):
            cautionLabel.text = message
            cautionLabel.isHidden = false
            textField.backgroundColor = .red
        }
    }

    private func setupView() {
        addSubview(stackView)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make -> Void in
            make.edges.equalToSuperview()
        }
        textField.snp.makeConstraints { make -> Void in
            make.width.equalTo(Constants.textFieldWidth)
            make.height.equalTo(Constants.textFieldHeight)
        }
    }

}
