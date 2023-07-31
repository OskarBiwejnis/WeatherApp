import UIKit

class Label: UILabel {

    init(text: String = "", textColor: UIColor = .black, font: UIFont = FontProvider.defaultFont) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = font
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
