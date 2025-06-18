//
//  CardsView.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 20.06.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let mainTitle: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Soundy"
        label.font = R.Fonts.avenirBook(with: 72)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = R.Colors.textPrimary
        label.textAlignment = .center
        label.layer.masksToBounds = true
        
        // Add gradient text effect
        label.layer.shadowColor = R.Colors.primary.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 4
        label.layer.shadowOpacity = 0.3
        
        return label
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.backgroundPrimary
        view.layer.cornerRadius = R.Layout.CornerRadius.xxl
        
        // Modern shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowRadius = 24
        view.layer.shadowOpacity = 0.25
        
        return view
    }()
    
    private let lofiImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.backgroundSecondary
        view.layer.cornerRadius = R.Layout.CornerRadius.xl
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "bg2")
        
        // Add modern overlay gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            R.Colors.primary.withAlphaComponent(0.3).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        view.layer.addSublayer(gradientLayer)
        
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
        view.backgroundColor = R.Colors.backgroundSecondary
        view.layer.cornerRadius = R.Layout.CornerRadius.xl
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "bg4")
        
        // Add modern overlay gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            R.Colors.accent.withAlphaComponent(0.3).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        view.layer.addSublayer(gradientLayer)
        
        return view
    }()
    
    private let lofiTitle: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lo-Fi"
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = R.Fonts.system(.title, weight: .bold)
        label.textColor = R.Colors.textPrimary
        
        // Add text shadow for better readability
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 4
        label.layer.shadowOpacity = 0.5
        
        return label
    }()
    
    private let soundsTitle: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sounds".localized()
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = R.Fonts.system(.title, weight: .bold)
        label.textColor = R.Colors.textPrimary
        
        // Add text shadow for better readability
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 4
        label.layer.shadowOpacity = 0.5
        
        return label
    }()
    
        private let soundsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = R.Layout.CornerRadius.xl
        button.layer.masksToBounds = false
        
        // Add modern interaction
        button.addTarget(button, action: #selector(UIButton.handleButtonPress), for: .touchDown)
        button.addTarget(button, action: #selector(UIButton.handleButtonRelease), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()

    private let lofiButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.layer.cornerRadius = R.Layout.CornerRadius.xl
        button.layer.masksToBounds = false
        
        // Add modern interaction
        button.addTarget(button, action: #selector(UIButton.handleButtonPress), for: .touchDown)
        button.addTarget(button, action: #selector(UIButton.handleButtonRelease), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupInteractions()
        setupAccessibility()
        
        // Add entrance animations
        animateViewsOnLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = R.Colors.backgroundPrimary
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            R.Colors.backgroundPrimary.cgColor,
            R.Colors.backgroundSecondary.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(backgroundView)
        view.addSubview(container)
        view.addSubview(lofiImageView)
        view.addSubview(soundsImageView)
        view.addSubview(lofiButton)
        view.addSubview(soundsButton)
        view.addSubview(lofiTitle)
        view.addSubview(soundsTitle)
        view.addSubview(mainTitle)
    }
    
    private func setupConstraints() {
        constraints()
    }
    
    private func setupInteractions() {
        lofiButton.addTarget(self, action: #selector(loFiController), for: .touchUpInside)
        soundsButton.addTarget(self, action: #selector(natureController), for: .touchUpInside)
        
        // Add haptic feedback
        let haptic = UIImpactFeedbackGenerator(style: .medium)
        haptic.prepare()
    }
    
    private func setupAccessibility() {
        mainTitle.setupAccessibility(
            label: "Soundy app",
            hint: "Music and nature sounds application"
        )
        
        lofiButton.setupAccessibility(
            label: "Lo-Fi music section",
            hint: "Double tap to browse Lo-Fi music tracks",
            traits: .button
        )
        
        soundsButton.setupAccessibility(
            label: "Nature sounds section", 
            hint: "Double tap to browse nature and ambient sounds",
            traits: .button
        )
        
        view.accessibilityElements = [mainTitle, soundsButton, lofiButton]
    }
    
    private func animateViewsOnLoad() {
        // Initial state - hidden
        mainTitle.alpha = 0
        mainTitle.transform = CGAffineTransform(translationX: 0, y: -50)
        
        container.alpha = 0
        container.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        soundsImageView.alpha = 0
        soundsImageView.transform = CGAffineTransform(translationX: -100, y: 0)
        
        lofiImageView.alpha = 0
        lofiImageView.transform = CGAffineTransform(translationX: 100, y: 0)
        
        // Animate entrance
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.mainTitle.alpha = 1
            self.mainTitle.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3) {
            self.container.alpha = 1
            self.container.transform = .identity
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2) {
            self.soundsImageView.alpha = 1
            self.soundsImageView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.7, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2) {
            self.lofiImageView.alpha = 1
            self.lofiImageView.transform = .identity
        }
    }
    
    @objc
    func loFiController() {
        navigationController?.pushViewController(LofiController(), animated: true)
        
    }
    
    @objc
    func natureController() {
        navigationController?.pushViewController(SoundsController(), animated: true)
        
    }
    
    func playMusic() {
            // Реализация логики для воспроизведения музыки
            print("Playing music!")
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
