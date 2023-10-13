import Combine
import SnapKit
import UIKit

class LoginTextField: UIView {

    enum State {
        case normal
        case caution(message: String)
    }

    private let tapGestureRecognizer = UITapGestureRecognizer()
    private var subscriptions: [AnyCancellable] = []

    let textField: UITextField = {
        let textField = UITextField()
        textField.font = FontProvider.bigBoldFont
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()

    let cautionLabel: UILabel = {
        let label = UILabel()
        label.font = FontProvider.defaultFont
        label.textColor = .red
        label.textAlignment = .left
        label.text = "There will be displayed caution"
        return label
    }()

    init(placeholder: String) {
        self.textField.placeholder = placeholder
        super.init(frame: .zero)
        self.backgroundColor = .blue
        self.textField.delegate = self
        addSubview(textField)
        addSubview(cautionLabel)
        setupConstraints()
        setupGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        textField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        cautionLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(textField.snp.bottom)
            make.left.equalTo(textField)
        }
    }


        private func setupGestureRecognizer() {
            addGestureRecognizer(tapGestureRecognizer)

            tapGestureRecognizer.tapPublisher
                .sink { [weak self] _ in
                    self?.textField.becomeFirstResponder()
                }
                .store(in: &subscriptions)
        }

}

extension LoginTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let endPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }

}
