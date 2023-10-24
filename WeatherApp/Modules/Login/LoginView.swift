import Combine
import SnapKit
import UIKit

class LoginView: UIView {

    // MARK: - Constants -
    
    private enum Constants {
        static let loginButtonCornerRadius: CGFloat = 10
        static let loginButtonBottomOffset = 200
        static let loginButtonWidth = 80
        static let loginButtonHeight = 40
        static let passwordTextFieldOffset = 30
        static let textFieldsOffset = 100
    }

    // MARK: - Variables -
    
    private var subscriptions: [AnyCancellable] = []

    let usernameTextFieldView = LoginTextFieldView(placeholder: R.string.localizable.username_textfield_placeholder())

    let passwordTextFieldView = LoginTextFieldView(placeholder: R.string.localizable.password_textfield_placeholder(), isSecureTextEntry: true)

    let loginButton = {
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = .systemGray5
        loginButton.setTitle(R.string.localizable.login_button_title(), for: .normal)
        loginButton.layer.cornerRadius = Constants.loginButtonCornerRadius
        return loginButton
    }()

    private let stateLabel = Label(text: R.string.localizable.loading_state_message(), textColor: .cyan, font: FontProvider.defaultBoldFont)

    // MARK: - Initialization -

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        changeState(.normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public -

    func changeState(_ viewState: LoginViewState) {
        DispatchQueue.main.async { [weak self] in
            switch viewState {
            case .normal, .error:
                self?.stateLabel.isHidden = true
            case .loading:
                self?.stateLabel.textColor = .cyan
                self?.stateLabel.text = R.string.localizable.loading_state_message()
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

    // MARK: - Private -

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
