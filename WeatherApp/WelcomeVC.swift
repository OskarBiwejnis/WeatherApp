//
//  WelcomeVC.swift
//  WeatherApp
//
//  Created by Oskar Biwejnis on 11/07/2023.
//

import UIKit
import SnapKit

class WelcomeVC: UIViewController {
    
    private enum Strings {
        static let labelName = "WeatherApp"
        static let systemIconName = "sun.haze"
        static let buttonName = "Proceed"
    }
    
    private let icon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: Strings.systemIconName) )
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.layer.cornerRadius = 40
        icon.tintColor = .systemCyan
        icon.backgroundColor = .systemGray3
        return icon
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = Strings.labelName
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.setTitle(Strings.buttonName, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        
        view.backgroundColor = .systemGray
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(icon)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 300),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            label.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: -50),
            
            icon.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            icon.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -10),
            icon.widthAnchor.constraint(equalToConstant: 300),
            icon.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}
