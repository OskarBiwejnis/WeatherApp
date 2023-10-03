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
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = .systemGray5
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius = 10

        return loginButton
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
        backgroundColor = .white
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)

    }

    private func setupConstraints() {
        usernameTextField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        passwordTextField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(60)
        }

        loginButton.snp.makeConstraints { make -> Void in
            make.bottom.equalToSuperview().offset(-200)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }

}
