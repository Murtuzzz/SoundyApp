//
//  CardsView.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 20.06.2023.
//

import UIKit

final class MainView: UIViewController {
    
    private let mainTitle: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mind Focus"
        label.font = R.Fonts.Italic(with: 72)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.textAlignment = .center
        label.layer.masksToBounds = true
        return label
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 40
        return view
    }()
    
    private let lofiImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "bg2")
//        view.layer.shadowColor = (UIColor(ciColor: .black)).cgColor
//        view.layer.shadowOpacity = 1.0;
//        view.layer.shadowRadius = 1.0;
//        view.layer.shadowOffset = CGSizeMake(8, 8);
        return view
    }()
    
    private let backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bg2")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let soundsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "bg4")
//        view.layer.shadowColor = (UIColor(ciColor: .black)).cgColor
//        view.layer.shadowOpacity = 1.0;
//        view.layer.shadowRadius = 1.0;
//        view.layer.shadowOffset = CGSizeMake(8, 8);
        return view
    }()
    
    private let lofiTitle: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lo-Fi"
        label.font = R.Fonts.Italic(with: 52)
        label.textColor = R.Colors.background
        return label
    }()
    
    private let soundsTitle: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sounds".localized()
        label.textAlignment = .center
        label.font = R.Fonts.Italic(with: 48)
        label.textColor = R.Colors.background
        return label
    }()
    
    private let soundsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    
    private let lofiButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.alpha = 0.4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        view.addSubview(container)
        view.addSubview(lofiImageView)
        view.addSubview(soundsImageView)
        view.addSubview(lofiButton)
        view.addSubview(soundsButton)
        view.addSubview(lofiTitle)
        view.addSubview(soundsTitle)
        view.addSubview(mainTitle)
        
        constraints()
        view.backgroundColor = R.Colors.greenBg
        lofiButton.addTarget(self, action: #selector(loFiController), for: .touchUpInside)
        soundsButton.addTarget(self, action: #selector(natureController), for: .touchUpInside)
    }
    
    @objc
    func loFiController() {
        navigationController?.pushViewController(MusicController(), animated: true)
        
    }
    
    @objc
    func natureController() {
        navigationController?.pushViewController(SoundsController(), animated: true)
        
    }
    
    
    func constraints() {
        
        
        NSLayoutConstraint.activate([
            
          
            
            
            mainTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30),
            mainTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -30),
            mainTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),
            mainTitle.bottomAnchor.constraint(equalTo: soundsButton.topAnchor, constant: -10),
            
            
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            //container.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -50),
            
            lofiButton.heightAnchor.constraint(equalToConstant: 150),
            lofiButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            lofiButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            lofiButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            lofiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lofiImageView.heightAnchor.constraint(equalToConstant: 150),
            lofiImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            lofiImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            lofiImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            lofiImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lofiTitle.centerYAnchor.constraint(equalTo: lofiButton.centerYAnchor),
            lofiTitle.centerXAnchor.constraint(equalTo: lofiButton.centerXAnchor),
            lofiTitle.heightAnchor.constraint(equalToConstant: 52),
            lofiTitle.widthAnchor.constraint(equalToConstant: 105),
            
            soundsButton.heightAnchor.constraint(equalToConstant: 150),
            soundsButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            soundsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            soundsButton.bottomAnchor.constraint(equalTo: lofiButton.topAnchor, constant: -20),
            soundsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            soundsImageView.heightAnchor.constraint(equalToConstant: 150),
            soundsImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            soundsImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            soundsImageView.bottomAnchor.constraint(equalTo: lofiButton.topAnchor, constant: -20),
            soundsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            soundsTitle.centerYAnchor.constraint(equalTo: soundsButton.centerYAnchor),
            soundsTitle.centerXAnchor.constraint(equalTo: soundsButton.centerXAnchor),
            soundsTitle.heightAnchor.constraint(equalToConstant: 52),
            soundsTitle.widthAnchor.constraint(equalToConstant: 150),
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
        ])
    }
}
