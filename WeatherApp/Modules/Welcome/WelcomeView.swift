import SnapKit
import UIKit

class WelcomeView: UIView {

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
    }

    unowned var viewController: WelcomeViewController?

    private enum Constants {
        static let imageCornerRadius = 65
        static let buttonCornerRadius = 20
        static let buttonToLabelDistance = 260
        static let buttonSize = CGSize(width: 150, height: 50)
        static let titleLabelYOffset = 50
        static let imageToLabelDistance = 10
        static let imageSize = 300
    }

    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: R.image.logo() )
        iconImageView.layer.cornerRadius = CGFloat(Constants.imageCornerRadius)
        iconImageView.backgroundColor = .white

        return iconImageView
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = R.string.localizable.app_name()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.textAlignment = .center

        return titleLabel
    }()

    private lazy var proceedButton: UIButton = {
        let proceedButton = UIButton(type: .system)
        proceedButton.backgroundColor = .systemGray5
        proceedButton.layer.cornerRadius = CGFloat(Constants.buttonCornerRadius)
        proceedButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        proceedButton.setTitle(R.string.localizable.button_text(), for: .normal)
        proceedButton.addTarget(self, action: #selector(proceedButtonTap), for: .touchUpInside)

        return proceedButton
    }()

    private func setup() {
        setupView()
        setupConstraints()
    }

    private func setupView() {
        backgroundColor = .systemGray3
        addSubview(proceedButton)
        addSubview(titleLabel)
        addSubview(iconImageView)
    }

    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(titleLabel.snp.top).offset(-Constants.imageToLabelDistance)
            make.width.height.equalTo(Constants.imageSize)
        }

        titleLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide).offset(-Constants.titleLabelYOffset)
        }

        proceedButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.buttonToLabelDistance)
            make.size.equalTo(Constants.buttonSize)
        }
    }

    @objc
    private func proceedButtonTap() {
        viewController?.proceedButtonTap()
    }
    
}
