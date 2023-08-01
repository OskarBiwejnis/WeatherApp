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

    unowned var delegate: WelcomeViewDelegate?

    private enum Constants {
        static let imageCornerRadius: CGFloat = 30
        static let proceedButtonCornerRadius: CGFloat = 20
        static let proceedButtonToLabelDistance = 260
        static let proceedButtonSize = CGSize(width: 150, height: 50)
        static let titleLabelYOffset = 50
        static let imageToLabelDistance = 10
        static let imageSizeMultipier = 0.3
        static let imageMargin = 0
        static let proceedButtonMargin = 50
        static let numberOfButtons = 3
        static let stackViewCornerRadius: CGFloat = 40
        static let stackViewSpacing: CGFloat = 6
        static let recentButtonCornerRadius: CGFloat = 10
        static let stackViewWidth = 250
        static let stackViewHeight = 160
        static let recentLabelOffset = 40
    }

    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: R.image.logo())
        iconImageView.layer.cornerRadius = Constants.imageCornerRadius
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
        proceedButton.layer.cornerRadius = Constants.proceedButtonCornerRadius
        proceedButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        proceedButton.setTitle(R.string.localizable.button_text(), for: .normal)
        proceedButton.addTarget(self, action: #selector(proceedButtonTap), for: .touchUpInside)

        return proceedButton
    }()

    private let recentLabel = Label(text: R.string.localizable.recent_label_text(), textColor: .systemGray5, font: FontProvider.defaultFont)

    private var stackView = UIStackView()
    private var recentButtons: [UIButton] = []

    private func setup() {
        setupStackView()
        setupView()
        setupConstraints()
    }

    private func setupStackView() {
        stackView = UIStackView()
        stackView.layer.cornerRadius = Constants.stackViewCornerRadius
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.distribution = .fillEqually
        for index in 0 ..< Constants.numberOfButtons {
            let button = UIButton()
            button.setTitle("", for: .normal)
            button.backgroundColor = .systemGray2
            button.layer.cornerRadius = Constants.recentButtonCornerRadius
            button.tag = index
            button.addTarget(self, action: #selector(recentButtonTap), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            recentButtons.append(button)
        }
    }

    private func setupView() {
        backgroundColor = .systemGray3
        addSubview(proceedButton)
        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(stackView)
        addSubview(recentLabel)
    }

    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide).offset(Constants.imageMargin)
            make.width.equalToSuperview().multipliedBy(Constants.imageSizeMultipier)
            make.height.equalTo(iconImageView.snp.width)
        }

        titleLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(iconImageView.snp.bottom).offset(Constants.imageToLabelDistance)
        }

        proceedButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-Constants.proceedButtonMargin)
            make.size.equalTo(Constants.proceedButtonSize)
        }

        stackView.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(recentLabel.snp.bottom)
            make.width.equalTo(Constants.stackViewWidth)
            make.height.equalTo(Constants.stackViewHeight)
        }

        recentLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.recentLabelOffset)
        }
    }

    func reloadRecentsWith(_ cities: [City]) {
        for index in 0 ..< cities.count {
            recentButtons[index].setTitle(cities[index].name, for: .normal)
        }
    }

    @objc
    private func proceedButtonTap() {
        delegate?.proceedButtonTap()
    }

    @objc
    private func recentButtonTap(_ sender: UIButton) {
        delegate?.recentButtonTap(tag: sender.tag)
    }

}

protocol WelcomeViewDelegate: AnyObject {

    func proceedButtonTap()
    func recentButtonTap(tag: Int)

}
