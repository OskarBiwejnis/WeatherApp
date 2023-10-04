import SnapKit
import UIKit

class LoginView: UIView {

    private enum Constants {
        static let buttonBottomOffset = 50
        static let usernamePlaceholder = "Username"
        static let passwordPlaceholder = "Password"
        static let loginButtonTitle = "Login"
        static let loginButtonCornerRadius: CGFloat = 10
        static let passwordCenterYOffset = 60
        static let loginButtonBottomOffset = 200
        static let loginButtonWidth = 80
        static let loginButtonHeight = 40
        static let deadline: DispatchTime = .now() + 2
    }

    let usernameTextField = {
        let textField = UITextField()
        textField.placeholder = Constants.usernamePlaceholder
        textField.font = FontProvider.bigBoldFont
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.textAlignment = .center
        return textField
    }()

    let passwordTextField = {
        let textField = UITextField()
        textField.placeholder = Constants.passwordPlaceholder
        textField.font = FontProvider.defaultFont
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.textAlignment = .center
        return textField
    }()

    let loginButton = {
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = .systemGray5
        loginButton.setTitle(Constants.loginButtonTitle, for: .normal)
        loginButton.layer.cornerRadius = Constants.loginButtonCornerRadius

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

    func changeState(_ viewState: LoginViewState) {
        if case .invalidCredentials = viewState {
            showThatCredentialsAreInvalid()
        }
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
            make.centerY.equalToSuperview().offset(Constants.passwordCenterYOffset)
        }

        loginButton.snp.makeConstraints { make -> Void in
            make.bottom.equalToSuperview().offset(-Constants.loginButtonBottomOffset)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.loginButtonWidth)
            make.height.equalTo(Constants.loginButtonHeight)
        }
    }

    private func showThatCredentialsAreInvalid() {
        usernameTextField.textColor = .red
        passwordTextField.textColor = .red

        DispatchQueue.main.asyncAfter(deadline: Constants.deadline) { [weak self] in
            self?.usernameTextField.textColor = .black
            self?.passwordTextField.textColor = .black
        }
    }

}
