import Combine
import CombineDataSources
import CombineCocoa
import SnapKit
import UIKit

class SearchView: UIView {

    // MARK: - Constants -

    private enum Constants {
        static let textFieldFontSize = 32
        static let textFieldMargin = 20
        static let rowHeight: CGFloat = 50
        
    }

    // MARK: - Variables -

    @Published private var cities: [City] = []

    private var subscriptions: [AnyCancellable] = []

    private let tableViewDidSelectRowSubject = PassthroughSubject<Int, Never>()

    private let itemsController = TableViewItemsController<[[City]]>(cellFactory: { _, tableView, indexPath, model -> UITableViewCell in
        guard let cell: SearchCell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseIdentifier, for: indexPath) as? SearchCell
        else { return UITableViewCell() }
        cell.label.text = model.name
        return cell
    })

    let searchTextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = R.string.localizable.search_placeholder()
        searchTextField.borderStyle = .roundedRect
        searchTextField.textAlignment = .left
        searchTextField.textColor = .black
        searchTextField.font = .systemFont(ofSize: CGFloat(Constants.textFieldFontSize))

        return searchTextField
    }()

    let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = Constants.rowHeight
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.reuseIdentifier)

        return tableView
    }()

    // MARK: - Initialization -

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        setupTableView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public -

    func changeState(_ viewState: SearchViewState) {
        if case .cities(let cities) = viewState {
            self.cities = cities
        }
    }

    lazy var didSelectRowPublisher: AnyPublisher<Int, Never> = tableViewDidSelectRowSubject.eraseToAnyPublisher()

    // MARK: - Private -

    private func setupView() {
        backgroundColor = .systemGray6
        addSubview(searchTextField)
        addSubview(tableView)
    }

    private func setupConstraints() {
        searchTextField.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.textFieldMargin)
            make.left.right.equalToSuperview().inset(Constants.textFieldMargin)
        }

        tableView.snp.makeConstraints { make -> Void in
            make.top.equalTo(searchTextField.snp.bottom).offset(Constants.textFieldMargin)
            make.bottom.left.right.equalToSuperview()
        }
    }

    private func setupTableView() {
        $cities
            .receive(on: DispatchQueue.main)
            .bind(subscriber: tableView.rowsSubscriber(itemsController))
            .store(in: &subscriptions)

        tableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                self?.tableViewDidSelectRowSubject.send(indexPath.row)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            .store(in: &subscriptions)
    }

}
