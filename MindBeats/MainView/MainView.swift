//
//  CardsView.swift
//  MindBeats
//
//  Created by Мурат Кудухов on 20.06.2023.
//

import UIKit

final class MainView: UIViewController {
    
    private let shade: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 40
        view.layer.shadowColor = (UIColor(ciColor: .gray)).cgColor
        view.layer.shadowOpacity = 1.0;
        view.layer.shadowRadius = 1.0;
        view.layer.shadowOffset = CGSizeMake(8, 8);
        return view
    }()
    
    private let backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bg2")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shade2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 40
        view.layer.shadowColor = (UIColor(ciColor: .gray)).cgColor
        view.layer.shadowOpacity = 1.0;
        view.layer.shadowRadius = 1.0;
        view.layer.shadowOffset = CGSizeMake(8, 8);
        return view
    }()
    
    private let loFi: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lo-Fi"
        label.font = R.Fonts.Italic(with: 52)
        label.textColor = R.Colors.background
        return label
    }()
    
    private let sounds: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sounds"
        label.font = R.Fonts.Italic(with: 48)
        label.textColor = R.Colors.background
        return label
    }()
    
    private let soundsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = R.Colors.inactive
        button.setBackgroundImage(UIImage(named: "album2"), for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.alpha = 0.7
        return button
    }()
    
    private let lofiButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = R.Colors.inactive
        button.setBackgroundImage(UIImage(named: "Lo-FiCover"), for: .normal)
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.alpha = 0.6
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(backgroundView)
        view.addSubview(shade)
        view.addSubview(shade2)
        view.addSubview(lofiButton)
        view.addSubview(soundsButton)
        view.addSubview(loFi)
        view.addSubview(sounds)
        view.backgroundColor = .white
        
        constraints()
        view.backgroundColor = R.Colors.background
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
        lofiButton.translatesAutoresizingMaskIntoConstraints = false
        soundsButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            lofiButton.heightAnchor.constraint(equalToConstant: 250),
            lofiButton.widthAnchor.constraint(equalToConstant: 250),
            lofiButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            lofiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            shade.heightAnchor.constraint(equalToConstant: 250),
            shade.widthAnchor.constraint(equalToConstant: 250),
            shade.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            shade.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loFi.centerYAnchor.constraint(equalTo: lofiButton.centerYAnchor),
            loFi.centerXAnchor.constraint(equalTo: lofiButton.centerXAnchor),
            loFi.heightAnchor.constraint(equalToConstant: 52),
            loFi.widthAnchor.constraint(equalToConstant: 105),
            
            soundsButton.heightAnchor.constraint(equalToConstant: 250),
            soundsButton.widthAnchor.constraint(equalToConstant: 250),
            soundsButton.bottomAnchor.constraint(equalTo: lofiButton.topAnchor, constant: -60),
            soundsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            shade2.heightAnchor.constraint(equalToConstant: 250),
            shade2.widthAnchor.constraint(equalToConstant: 250),
            shade2.bottomAnchor.constraint(equalTo: lofiButton.topAnchor, constant: -60),
            shade2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            sounds.centerYAnchor.constraint(equalTo: soundsButton.centerYAnchor),
            sounds.centerXAnchor.constraint(equalTo: soundsButton.centerXAnchor),
            sounds.heightAnchor.constraint(equalToConstant: 52),
            sounds.widthAnchor.constraint(equalToConstant: 150),
            
//            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
        ])
    }
}
