import Combine
import SnapKit
import UIKit

class LoginView: UIView {

    private enum Constants {
        static let buttonBottomOffset = 50
        static let usernamePlaceholder = "Username"
        static let passwordPlaceholder = "Password"
        static let loginButtonTitle = "Login"
        static let loginButtonCornerRadius: CGFloat = 10
        static let usernameBottomOffset = 40
        static let loginButtonBottomOffset = 200
        static let loginButtonWidth = 80
        static let loginButtonHeight = 40
        static let loadingText = "Loading..."
    }

    private var subscriptions: [AnyCancellable] = []

    let usernameTextField = {
        let textField = UITextField()
        textField.placeholder = Constants.usernamePlaceholder
        textField.font = FontProvider.bigBoldFont
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()

    private let usernameCautionLabel: UILabel = {
        let label = Label(text: "", textColor: .red, font: FontProvider.smallFont)
        label.isHidden = true
        return label
    }()

    let passwordTextField = {
        let textField = UITextField()
        textField.placeholder = Constants.passwordPlaceholder
        textField.font = FontProvider.bigBoldFont
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
        return textField
    }()

    private let passwordCautionLabel: UILabel = {
        let label = Label(text: "", textColor: .red, font: FontProvider.smallFont)
        label.isHidden = true
        return label
    }()

    let loginButton = {
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = .systemGray5
        loginButton.setTitle(Constants.loginButtonTitle, for: .normal)
        loginButton.layer.cornerRadius = Constants.loginButtonCornerRadius
        return loginButton
    }()

    private let stateLabel: UILabel = {
        let label = Label(text: Constants.loadingText, textColor: .cyan, font: FontProvider.defaultBoldFont)
        label.isHidden = true
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        bindActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeState(_ viewState: LoginViewState) {
        DispatchQueue.main.async { [weak self] in
            switch viewState {
            case .normal, .error:
                self?.stateLabel.isHidden = true
            case .loading:
                self?.stateLabel.textColor = .cyan
                self?.stateLabel.text = "Loading..."
                self?.stateLabel.isHidden = false
            case let .issue(message):
                self?.stateLabel.textColor = .red
                self?.stateLabel.text = message
                self?.stateLabel.isHidden = false
            }
        }
    }

    private func setupView() {
        backgroundColor = .white
        addSubview(usernameTextField)
        addSubview(usernameCautionLabel)
        addSubview(passwordTextField)
        addSubview(passwordCautionLabel)
        addSubview(loginButton)
        addSubview(stateLabel)
    }

    private func setupConstraints() {
        usernameTextField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(passwordTextField.snp.top).offset(-Constants.usernameBottomOffset)
        }
        usernameCautionLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(usernameTextField.snp.bottom)
            make.left.equalTo(usernameTextField)
        }
        passwordTextField.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        passwordCautionLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.left.equalTo(passwordTextField)
        }
        loginButton.snp.makeConstraints { make -> Void in
            make.bottom.equalToSuperview().offset(-Constants.loginButtonBottomOffset)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.loginButtonWidth)
            make.height.equalTo(Constants.loginButtonHeight)
        }
        stateLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(loginButton.snp.bottom)
            make.left.equalTo(loginButton)
        }
    }

    private func bindActions() {
        usernameTextField.textPublisher
            .sink { [weak self] username in
                if let username {
                    if username != "", let errorMessage = ValidationService.validateUsername(username) {
                        DispatchQueue.main.async { [weak self] in
                            self?.usernameTextField.backgroundColor = .red
                            self?.usernameCautionLabel.text = errorMessage
                            self?.usernameCautionLabel.isHidden = false
                        }
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            self?.usernameTextField.backgroundColor = .white
                            self?.usernameCautionLabel.isHidden = true
                        }
                    }
                }
            }
            .store(in: &subscriptions)

        passwordTextField.textPublisher
            .sink { password in
                if let password {
                    if password != "", let errorMessage = ValidationService.validatePassword(password) {
                        DispatchQueue.main.async { [weak self] in
                            self?.passwordTextField.backgroundColor = .red
                            self?.passwordCautionLabel.text = errorMessage
                            self?.passwordCautionLabel.isHidden = false
                        }
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            self?.passwordTextField.backgroundColor = .white
                            self?.passwordCautionLabel.isHidden = true
                        }
                    }
                }
            }
            .store(in: &subscriptions)
    }

}
