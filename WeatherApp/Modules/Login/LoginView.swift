import Combine
import SnapKit
import UIKit

class LoginView: UIView {

    private enum Constants {
        static let usernamePlaceholder = "Username"
        static let passwordPlaceholder = "Password"
        static let loginButtonTitle = "Login"
        static let loginButtonCornerRadius: CGFloat = 10
        static let loginButtonBottomOffset = 200
        static let loginButtonWidth = 80
        static let loginButtonHeight = 40
        static let loadingText = "Loading..."
        static let passwordTextFieldOffset = 30
        static let textFieldsOffset = 100
    }

    private var subscriptions: [AnyCancellable] = []

    let usernameTextFieldView = LoginTextFieldView(placeholder: Constants.usernamePlaceholder)

    let passwordTextFieldView = LoginTextFieldView(placeholder: Constants.passwordPlaceholder, isSecureTextEntry: true)

    let loginButton = {
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = .systemGray5
        loginButton.setTitle(Constants.loginButtonTitle, for: .normal)
        loginButton.layer.cornerRadius = Constants.loginButtonCornerRadius
        return loginButton
    }()

    private let stateLabel: UILabel = {
        let label = Label(text: Constants.loadingText, textColor: .cyan, font: FontProvider.defaultBoldFont)
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        changeState(.normal)
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
                self?.stateLabel.text = Constants.loadingText
                self?.stateLabel.isHidden = false
            case let .issue(message):
                self?.stateLabel.textColor = .red
                self?.stateLabel.text = message
                self?.stateLabel.isHidden = false
            case .usernameCorrect:
                self?.usernameTextFieldView.changeState(.normal)
            case let .usernameValidationError(message):
                self?.usernameTextFieldView.changeState(.caution(message))
            case .passwordCorrect:
                self?.passwordTextFieldView.changeState(.normal)
            case let .passwordValidationError(message):
                self?.passwordTextFieldView.changeState(.caution(message))
            }
        }
    }

    private func setupView() {
        backgroundColor = .white
        addSubview(usernameTextFieldView)
        addSubview(passwordTextFieldView)
        addSubview(loginButton)
        addSubview(stateLabel)
    }

    private func setupConstraints() {
        usernameTextFieldView.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextFieldView).offset(-Constants.textFieldsOffset)
        }
        passwordTextFieldView.snp.makeConstraints {make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.centerY).offset(-Constants.passwordTextFieldOffset)
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

}
