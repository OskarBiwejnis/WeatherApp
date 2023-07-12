import UIKit

class WelcomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        setup()
    }

    private enum Strings {
        static let titleLabelName = "WeatherApp"
        static let systemIconName = "sun.haze"
        static let proceedButtonName = "Proceed"
    }
    
    private enum Constants {
        static let iconImageViewCornerRadius = 40
        static let proceedButtonCornerRadius = 20
        static let proceedButtonToTitleLabelDistance = 300
        static let proceedButtonWidth = 150
        static let proceedButtonHeight = 50
        static let titleLabelYOffset = -50
        static let iconImageViewToTitleLabelDistance = -10
        static let iconImageSize = 300
    }
    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: UIImage(systemName: Strings.systemIconName) )
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.cornerRadius = CGFloat(Constants.iconImageViewCornerRadius)
        iconImageView.tintColor = .systemCyan
        iconImageView.backgroundColor = .systemGray3
        return iconImageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Strings.titleLabelName
        titleLabel.textColor = .white
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    private let proceedButton: UIButton = {
        let proceedButton = UIButton(type: .system)
        proceedButton.backgroundColor = .systemGray2
        proceedButton.layer.cornerRadius = CGFloat(Constants.proceedButtonCornerRadius)
        proceedButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        proceedButton.setTitle(Strings.proceedButtonName, for: .normal)
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        
        return proceedButton
    }()

    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        backgroundColor = .systemGray
        addSubview(proceedButton)
        addSubview(titleLabel)
        addSubview(iconImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            proceedButton.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            proceedButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: CGFloat(Constants.proceedButtonToTitleLabelDistance)),
            proceedButton.widthAnchor.constraint(equalToConstant: CGFloat(Constants.proceedButtonWidth)),
            proceedButton.heightAnchor.constraint(equalToConstant: CGFloat(Constants.proceedButtonHeight)),
            
            titleLabel.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor, constant: CGFloat(Constants.titleLabelYOffset)),
            
            iconImageView.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: CGFloat(Constants.iconImageViewToTitleLabelDistance)),
            iconImageView.widthAnchor.constraint(equalToConstant: CGFloat(Constants.iconImageSize)),
            iconImageView.heightAnchor.constraint(equalToConstant: CGFloat(Constants.iconImageSize)),
        ])
    }
}
