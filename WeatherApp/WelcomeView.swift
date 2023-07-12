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
    
    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: UIImage(systemName: Strings.systemIconName) )
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.cornerRadius = 40
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
        proceedButton.layer.cornerRadius = 20
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
            proceedButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 300),
            proceedButton.widthAnchor.constraint(equalToConstant: 150),
            proceedButton.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor, constant: -50),
            
            iconImageView.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            iconImageView.widthAnchor.constraint(equalToConstant: 300),
            iconImageView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
}
