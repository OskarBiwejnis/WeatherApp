import Combine
import CombineDataSources
import CombineCocoa
import SnapKit
import UIKit

class WelcomeView: UIView {

    // MARK: - Constants -
    
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
        static let tableViewWidth = 250
        static let tableViewHeight = 150
        static let tableViewRowHeight: CGFloat = 50
        static let tableViewCornerRadius: CGFloat = 40
    }

    // MARK: - Variables -

    private var subscriptions: [AnyCancellable] = []

    private let tableViewDataSubject = PassthroughSubject<[City], Never>()

    private let tableViewDidSelectRowSubject = PassthroughSubject<Int, Never>()

    private let itemsController = TableViewItemsController<[[City]]>(cellFactory: { _, tableView, indexPath, model -> UITableViewCell in
        guard let cell: RecentCityCell = tableView.dequeueReusableCell(withIdentifier: RecentCityCell.reuseIdentifier, for: indexPath) as? RecentCityCell
        else { return UITableViewCell() }
        cell.label.text = model.name
        return cell
    })

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

    private let recentLabel = Label(text: R.string.localizable.recent_label_text(), textColor: .systemGray5, font: FontProvider.defaultFont)

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = Constants.tableViewRowHeight
        tableView.register(RecentCityCell.self, forCellReuseIdentifier: RecentCityCell.reuseIdentifier)
        tableView.layer.cornerRadius = Constants.tableViewCornerRadius
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .systemGray4
        return tableView
    }()

     let proceedButton: UIButton = {
        let proceedButton = UIButton(type: .system)
        proceedButton.backgroundColor = .systemGray5
        proceedButton.layer.cornerRadius = Constants.proceedButtonCornerRadius
        proceedButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        proceedButton.setTitle(R.string.localizable.button_text(), for: .normal)

        return proceedButton
    }()

    // MARK: - Initialization -

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
    }

    // MARK: - Public -

    func changeState(_ viewState: WelcomeViewState) {
        switch viewState {
        case .cities(let cities):
            tableViewDataSubject.send(cities)
        }
    }

    lazy var didSelectRowPublisher: AnyPublisher<Int, Never> = tableViewDidSelectRowSubject.eraseToAnyPublisher()

    // MARK: - Private -
    
    private func setupView() {
        backgroundColor = .systemGray3
        addSubview(proceedButton)
        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(tableView)
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

        tableView.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(recentLabel.snp.bottom)
            make.width.equalTo(Constants.tableViewWidth)
            make.height.equalTo(Constants.tableViewHeight)
        }

        recentLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.recentLabelOffset)
        }
    }

    private func bindActions() {
        tableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                self?.tableViewDidSelectRowSubject.send(indexPath.row)
                self?.tableView.deselectRow(at: indexPath, animated: false)
            }
            .store(in: &subscriptions)

        tableViewDataSubject
            .receive(on: DispatchQueue.main)
            .bind(subscriber: tableView.rowsSubscriber(itemsController))
            .store(in: &subscriptions)
    }

}
