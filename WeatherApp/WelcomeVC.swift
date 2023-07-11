//
//  WelcomeVC.swift
//  WeatherApp
//
//  Created by Oskar Biwejnis on 11/07/2023.
//

import UIKit

class WelcomeVC: UIViewController {

    private let icon: UIImage = {
        let icon = UIImage()
        
        return icon
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "WeatherApp"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setTitle("Proceed", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    



}
