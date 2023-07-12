import UIKit
import SnapKit

class WelcomeView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
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
        
        proceedButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.layoutMarginsGuide)
            make.centerY.equalTo(titleLabel).offset(Constants.proceedButtonToTitleLabelDistance)
            make.size.equalTo(CGSize(width: Constants.proceedButtonWidth, height: Constants.proceedButtonHeight))
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.layoutMarginsGuide)
            make.centerY.equalTo(self.layoutMarginsGuide).offset(Constants.titleLabelYOffset)
        }
        
        iconImageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.layoutMarginsGuide)
            make.bottom.equalTo(titleLabel.snp.top).offset(Constants.iconImageViewToTitleLabelDistance)
            make.width.height.equalTo(Constants.iconImageSize)
        }
    }
}
