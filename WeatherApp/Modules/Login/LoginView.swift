import SnapKit
import UIKit

class LoginView: UIView {

    private enum Constants {
        static let buttonBottomOffset = 50
    }

    let usernameTextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.font = FontProvider.bigBoldFont
        textField.textColor = .cyan
        return textField
    }()

    let passwordTextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = FontProvider.defaultFont
        textField.textColor = .cyan
        return textField
    }()

    let loginButton = {
        let button = UIButton()
        return button
    }()


    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)

    }

    private func setupConstraints() {
        loginButton.snp.makeConstraints { make -> Void in
            make.bottom.equalToSuperview().offset(Constants.buttonBottomOffset)
        }
    }

}
