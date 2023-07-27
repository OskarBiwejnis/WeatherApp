import SnapKit
import UIKit

class ForecastView: UIView {

    private enum Constants {
        static let forecastReuseIdentifier = "forecastCell"
    }

    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: Constants.forecastReuseIdentifier)

        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    private func setupView() {
        backgroundColor = .systemGray6
        addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make -> Void in
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.left.right.equalToSuperview()
        }
    }

}


