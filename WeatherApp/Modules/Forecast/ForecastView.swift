import UIKit

class ForecastView: UIView {

    private enum Constants {
        static let forecastReuseIdentifier = "forecastCell"
        
    }

    let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.register(ForecastCell.self, forCellReuseIdentifier: Constants.forecastReuseIdentifier)

        return tableView
    }

}
