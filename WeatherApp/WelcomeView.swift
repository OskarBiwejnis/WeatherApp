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
        static let labelName = "WeatherApp"
        static let iconName = "sun.haze"
        static let buttonName = "Proceed"
    }
    
    private enum Constants {
        static let imageCornerRadius = 40
        static let buttonCornerRadius = 20
        static let buttonToLabelDistance = 300
        static let buttonSize = CGSize(width: 150, height: 50)
        static let titleLabelYOffset = 50
        static let imageToLabelDistance = 10
        static let imageSize = 300
    }
    
    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: UIImage(systemName: Strings.iconName) )
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.cornerRadius = CGFloat(Constants.imageCornerRadius)
        iconImageView.tintColor = .systemCyan
        iconImageView.backgroundColor = .systemGray3
        return iconImageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Strings.labelName
        titleLabel.textColor = .white
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    private let proceedButton: UIButton = {
        let proceedButton = UIButton(type: .system)
        proceedButton.backgroundColor = .systemGray2
        proceedButton.layer.cornerRadius = CGFloat(Constants.buttonCornerRadius)
        proceedButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        proceedButton.setTitle(Strings.buttonName, for: .normal)
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
        iconImageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(titleLabel)
            make.bottom.equalTo(titleLabel.snp.top).offset(-Constants.imageToLabelDistance)
            make.width.height.equalTo(Constants.imageSize)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide).offset(-Constants.titleLabelYOffset)
        }
        
        proceedButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(titleLabel)
            make.centerY.equalTo(titleLabel).offset(Constants.buttonToLabelDistance)
            make.size.equalTo(Constants.buttonSize)
        }
    }
}
