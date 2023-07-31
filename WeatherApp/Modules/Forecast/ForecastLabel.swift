//
//  ForecastLabel.swift
//  WeatherApp
//
//  Created by Oskar Biwejnis on 31/07/2023.
//

import UIKit

class ForecastLabel: UILabel {

    enum Constants {
        static let emptyString = ""
        static let defaultFontSize: CGFloat = 17
    }

    init(text: String = Constants.emptyString, textColor: UIColor = .black, fontSize: CGFloat = Constants.defaultFontSize, weight: UIFont.Weight = .regular) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
